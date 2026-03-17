package com.nzcu_driver

import android.Manifest
import android.app.AlarmManager
import android.app.Notification
import android.app.NotificationManager
import android.app.PendingIntent
import android.app.Service
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.SharedPreferences
import android.content.pm.PackageManager
import android.location.Location
import android.os.Build
import android.os.IBinder
import android.os.Looper
import android.os.PowerManager
import android.os.SystemClock
import android.net.wifi.WifiManager
import android.util.Log
import androidx.core.app.ActivityCompat
import androidx.core.app.NotificationCompat
import com.google.android.gms.location.*
import io.socket.client.IO
import io.socket.client.Socket
import org.json.JSONObject
import java.net.URI
import java.util.*

/**
 * Native Android Foreground Service that maintains a Socket.IO connection
 * to the ride server even when the Flutter app is killed.
 *
 * This service:
 *  1. Connects to the Socket.IO server with the driver's auth token
 *  2. Listens for ride:newRide events and shows Accept/Decline notifications
 *  3. Sends periodic location updates via socket
 *  4. Survives app kills via START_STICKY + AlarmManager restart
 *  5. Acquires WakeLock + WifiLock to maintain connectivity
 */
class SocketForegroundService : Service() {

    companion object {
        private const val TAG = "SocketFGService"
        private const val SOCKET_URL = "https://api.nzcu.framekarts.com"

        // Notification IDs & channels (channels created in NZCUApplication.kt)
        const val STATUS_NOTIFICATION_ID = 1
        const val RIDE_NOTIFICATION_ID = 900
        const val CHAT_NOTIFICATION_ID = 950
        const val STATUS_CHANNEL_ID = "nzcu_driver_foreground_service"
        const val RIDE_CHANNEL_ID = "ride_request_channel_v9"
        const val CHAT_CHANNEL_ID = "general_notifications_channel"

        // Location update interval (ms)
        private const val LOCATION_INTERVAL_MS = 5000L
        private const val LOCATION_FASTEST_MS = 3000L

        // Pref keys — MUST match Flutter's SharedPreferences keys exactly
        // Flutter shared_preferences plugin uses file: FlutterSharedPreferences
        // and prefixes all keys with "flutter."
        private const val PREFS_NAME = "FlutterSharedPreferences"
        private const val PREF_AUTH_TOKEN = "flutter.auth_token"
        private const val PREF_DRIVER_ID = "flutter.driver_userid"       // Flutter: prefs.getString("driver_userid")
        private const val PREF_DRIVER_NAME = "flutter.driver_name"       // Flutter: prefs.getString("driver_name")
        private const val PREF_VEHICLE_TYPE = "flutter.vehicle_type_id"  // Flutter: prefs.getString("vehicle_type_id")
        private const val PREF_VEHICLE_SUB_TYPE = "flutter.vehicle_SubType" // Flutter: prefs.getString("vehicle_SubType")
        private const val PREF_VEHICLE_NUMBER = "flutter.vehicle_id"     // Flutter: prefs.getString("vehicle_id")
        private const val PREF_VEHICLE_IMAGE = "flutter.driver_image"    // Flutter: prefs.getString("driver_image")
        private const val PREF_FLEET_ID = "flutter.fleet_id"
        private const val PREF_IS_RIDE_IN_PROGRESS = "flutter.is_ride_in_progress"
        private const val PREF_ACTIVE_RIDE_ID = "flutter.active_ride_id"
        private const val PREF_LAST_RIDE_REQUEST = "flutter.last_ride_request"
        private const val PREF_PENDING_ACCEPT_ORDER_ID = "flutter.pending_accept_order_id"
        private const val PREF_PENDING_DECLINE_ORDER_ID = "flutter.pending_decline_order_id"

        // Extra keys for intent
        const val EXTRA_ACTION = "action"
        const val ACTION_STOP = "stop"
        const val ACTION_UPDATE = "update"
        const val ACTION_SET_APP_STATE = "set_app_state"
        const val ACTION_ACCEPT_RIDE = "accept_ride"
        const val ACTION_DECLINE_RIDE = "decline_ride"
        const val EXTRA_APP_STATE = "app_state"
        const val EXTRA_TITLE = "title"
        const val EXTRA_BODY = "body"
        const val EXTRA_ORDER_ID = "order_id"
    }

    // Socket
    private var socket: Socket? = null
    private var isSocketConnected = false

    // Location
    private var fusedLocationClient: FusedLocationProviderClient? = null
    private var locationCallback: LocationCallback? = null
    private var currentLat = 0.0
    private var currentLng = 0.0

    // Locks
    private var wakeLock: PowerManager.WakeLock? = null
    private var wifiLock: WifiManager.WifiLock? = null

    // State
    private var isOnDuty = false
    private var appState = "Foreground" // Foreground | Background | Killed

    // Timer for periodic online emit
    private var onlineTimer: Timer? = null

    // Timer for location socket emit
    private var locationEmitTimer: Timer? = null

    // ──────────────────────────────────────────────────────────
    //  Lifecycle
    // ──────────────────────────────────────────────────────────

    override fun onCreate() {
        super.onCreate()
        Log.i(TAG, "[LIFECYCLE] onCreate() - Service created")
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        val action = intent?.getStringExtra(EXTRA_ACTION)
        Log.i(TAG, "[LIFECYCLE] onStartCommand() - action: $action, flags: $flags, startId: $startId")

        when (action) {
            ACTION_STOP -> {
                Log.i(TAG, "[LIFECYCLE] onStartCommand - Stopping service via ACTION_STOP")
                stopSelf()
                return START_NOT_STICKY
            }
            ACTION_UPDATE -> {
                val title = intent.getStringExtra(EXTRA_TITLE) ?: "NZCU Driver — Online"
                val body = intent.getStringExtra(EXTRA_BODY) ?: "Waiting for rides..."
                updateStatusNotification(title, body)
                return START_STICKY
            }
            ACTION_SET_APP_STATE -> {
                val state = intent.getStringExtra(EXTRA_APP_STATE) ?: "Foreground"
                setAppState(state)
                // Only keep the service alive (START_STICKY) if driver is actually online.
                // When offline, don't persist the service just for state tracking.
                val driverOnline = getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
                    .getBoolean("flutter.driver_is_online", false)
                return if (driverOnline) START_STICKY else START_NOT_STICKY
            }
            ACTION_ACCEPT_RIDE -> {
                val orderId = intent.getStringExtra(EXTRA_ORDER_ID) ?: ""
                handleAcceptRide(orderId)
                return START_STICKY
            }
            ACTION_DECLINE_RIDE -> {
                val orderId = intent.getStringExtra(EXTRA_ORDER_ID) ?: ""
                handleDeclineRide(orderId)
                return START_STICKY
            }
        }

        // Default: start the service.
        // IMPORTANT: When the service restarts via START_STICKY after being killed by the OS,
        // onStartCommand() is called with intent=null, so action=null and we land here.
        // We must NOT assume the driver is online — check the persisted pref first.
        val prefs = getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
        val driverIsOnline = prefs.getBoolean("flutter.driver_is_online", false)

        if (!driverIsOnline) {
            // Android rule: when started via startForegroundService(), the service MUST call
            // startForeground() within 5 seconds or the system throws a fatal exception.
            // We satisfy this rule with a silent placeholder, then immediately remove it and stop.
            Log.i(TAG, "Service started but driver is offline — starting foreground briefly then stopping.")
            try {
                val notification = buildStatusNotification("NZCU Driver", "Starting...")
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                    startForeground(
                        STATUS_NOTIFICATION_ID, 
                        notification, 
                        android.content.pm.ServiceInfo.FOREGROUND_SERVICE_TYPE_LOCATION or 
                        android.content.pm.ServiceInfo.FOREGROUND_SERVICE_TYPE_DATA_SYNC
                    )
                } else {
                    startForeground(STATUS_NOTIFICATION_ID, notification)
                }
                stopForeground(STOP_FOREGROUND_REMOVE) // removes the notification immediately
            } catch (e: Exception) {
                Log.e(TAG, "startForeground failed while stopping: ${e.message}")
            }
            stopSelf()
            return START_NOT_STICKY
        }

        Log.i(TAG, "Starting foreground service")
        isOnDuty = true
        appState = "Foreground"

        try {
            // Start as foreground immediately (MUST happen within 5s)
            val notification = buildStatusNotification(
                "NZCU Driver — Online",
                "\uD83D\uDFE2 App Active — Foreground • Waiting for rides..."
            )
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                startForeground(
                    STATUS_NOTIFICATION_ID, 
                    notification, 
                    android.content.pm.ServiceInfo.FOREGROUND_SERVICE_TYPE_LOCATION or 
                    android.content.pm.ServiceInfo.FOREGROUND_SERVICE_TYPE_DATA_SYNC
                )
            } else {
                startForeground(STATUS_NOTIFICATION_ID, notification)
            }
        } catch (e: Exception) {
            Log.e(TAG, "FATAL: startForeground failed: ${e.message}", e)
            stopSelf()
            return START_NOT_STICKY
        }

        // Defer heavy operations to background thread to avoid ANR
        Thread {
            try {
                acquireLocks()
            } catch (e: Exception) {
                Log.e(TAG, "Error acquiring locks: ${e.message}", e)
            }

            // NOTE: Do NOT connect socket here!
            // Flutter's socket handles rides when app is alive (Foreground/Background).
            // The Kotlin socket only connects when the app is killed (see onTaskRemoved).
            // Connecting both simultaneously causes the server to deliver rides
            // only to the Kotlin socket, breaking Flutter's RideRequestScreen navigation.

            locationEmitTimer?.cancel()
            locationEmitTimer = Timer().also {
                it.scheduleAtFixedRate(object : TimerTask() {
                    override fun run() {
                        try { emitLocation() } catch (e: Exception) {
                            Log.e(TAG, "Error in emitLocation: ${e.message}")
                        }
                    }
                }, 3000, 5000)
            }
        }.start()

        // Start location updates on main thread (requires Looper)
        try {
            startLocationUpdates()
        } catch (e: Exception) {
            Log.e(TAG, "Error starting location: ${e.message}", e)
        }

        return START_STICKY
    }

    override fun onDestroy() {
        Log.i(TAG, "[LIFECYCLE] onDestroy() - Service destroyed")
        onlineTimer?.cancel()
        locationEmitTimer?.cancel()
        stopLocationUpdates()
        disconnectSocket()
        releaseLocks()
        super.onDestroy()
    }

    override fun onBind(intent: Intent?): IBinder? {
        Log.i(TAG, "[LIFECYCLE] onBind() - action: ${intent?.action}")
        return null
    }

    override fun onTaskRemoved(rootIntent: Intent?) {
        super.onTaskRemoved(rootIntent)
        Log.w(TAG, "[LIFECYCLE] onTaskRemoved() - ⚠️ App killed (onTaskRemoved) — connecting Kotlin socket as takeover")
        appState = "Killed"

        // Update notification to show killed state
        updateStatusNotification(
            "NZCU Driver — Online",
            "🔴 App Killed — Running in Background • Waiting for rides..."
        )

        // NOW connect the Kotlin socket — Flutter's socket is dead, we take over
        Thread {
            try {
                connectSocket()
                Log.i(TAG, "✅ Kotlin socket connected (app killed, taking over from Flutter)")
            } catch (e: Exception) {
                Log.e(TAG, "Error connecting socket after kill: ${e.message}", e)
            }

            // Start online emit timer (only needed in killed state)
            onlineTimer?.cancel()
            onlineTimer = Timer().also {
                it.scheduleAtFixedRate(object : TimerTask() {
                    override fun run() {
                        try { emitOnline() } catch (e: Exception) {
                            Log.e(TAG, "Error in emitOnline: ${e.message}")
                        }
                    }
                }, 5000, 30000)
            }
        }.start()

        // Schedule restart via AlarmManager (1 second)
        val restartIntent = Intent(applicationContext, SocketForegroundService::class.java)
        val pendingIntent = PendingIntent.getService(
            applicationContext, 1, restartIntent,
            PendingIntent.FLAG_ONE_SHOT or PendingIntent.FLAG_IMMUTABLE
        )
        val alarmManager = getSystemService(Context.ALARM_SERVICE) as AlarmManager
        alarmManager.set(
            AlarmManager.ELAPSED_REALTIME,
            SystemClock.elapsedRealtime() + 1000,
            pendingIntent
        )
    }

    // ──────────────────────────────────────────────────────────
    //  App State (called from Flutter via MethodChannel)
    // ──────────────────────────────────────────────────────────

    fun setAppState(state: String) {
        Log.i(TAG, "[STATE] App state changed: $appState -> $state")
        val oldState = appState
        appState = state
        // Only update the notification if we are actually running as foreground (driver is online).
        // Do NOT show any notification when the service is invoked for state tracking while offline.
        if (isOnDuty) {
            val body = buildNotificationBody()
            updateStatusNotification("NZCU Driver — Online", body)
        }

        // When Flutter comes back alive, disconnect Kotlin socket
        // to let Flutter's socket handle rides (avoid duplicate connections)
        if (oldState == "Killed" && (state == "Foreground" || state == "Background")) {
            Log.i(TAG, "🔄 Flutter is back — disconnecting Kotlin socket (Flutter takes over)")
            Thread {
                disconnectSocket()
                onlineTimer?.cancel()
                onlineTimer = null
            }.start()
        }
    }

    // ──────────────────────────────────────────────────────────
    //  Socket.IO
    // ──────────────────────────────────────────────────────────

    private fun connectSocket() {
        try {
            val prefs = getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
            val token = prefs.getString(PREF_AUTH_TOKEN, null)
            val driverId = prefs.getString(PREF_DRIVER_ID, null)

            Log.i(TAG, "🔑 Auth token: ${if (token.isNullOrEmpty()) "MISSING!" else "found (${token.length} chars)"}")
            Log.i(TAG, "🆔 Driver ID: ${if (driverId.isNullOrEmpty()) "MISSING!" else driverId}")

            if (token.isNullOrEmpty() || driverId.isNullOrEmpty()) {
                Log.e(TAG, "❌ Missing auth token or driverId — cannot connect socket")
                // Log all prefs keys for debugging
                val allKeys = prefs.all.keys
                Log.e(TAG, "📋 Available prefs keys: ${allKeys.take(20)}")
                return
            }

            Log.i(TAG, "🔌 Connecting socket to $SOCKET_URL (driverId=$driverId)")

            // Disconnect existing
            disconnectSocket()

            val options = IO.Options().apply {
                transports = arrayOf("websocket", "polling")
                reconnection = true
                reconnectionAttempts = Int.MAX_VALUE
                reconnectionDelay = 1000
                reconnectionDelayMax = 5000
                timeout = 10000
                auth = mapOf("token" to token)
                query = "userRole=Driver&platform=android_native&driverId=$driverId"
            }

            socket = IO.socket(URI.create(SOCKET_URL), options)

            socket?.on(Socket.EVENT_CONNECT) {
                Log.i(TAG, "[SOCKET] ✅ Socket connected (id=${socket?.id()})")
                isSocketConnected = true
                emitOnline()
            }

            socket?.on(Socket.EVENT_DISCONNECT) { args ->
                val reason = if (args.isNotEmpty()) args[0].toString() else "unknown"
                Log.w(TAG, "❌ Socket disconnected: $reason")
                isSocketConnected = false
            }

            socket?.on(Socket.EVENT_CONNECT_ERROR) { args ->
                val err = if (args.isNotEmpty()) args[0].toString() else "unknown"
                Log.e(TAG, "❌ Socket connect error: $err")
            }

            // ── Ride Events ────────────────────────────────────

            socket?.on("ride:newRide") { args ->
                Log.i(TAG, "🚕 NEW RIDE REQUEST received")
                if (args.isNotEmpty()) {
                    try {
                        val data = args[0] as JSONObject
                        handleNewRideRequest(data)
                    } catch (e: Exception) {
                        Log.e(TAG, "Error parsing ride request: ${e.message}")
                    }
                }
            }

            socket?.on("ride:confirmed") { args ->
                Log.i(TAG, "✅ Ride confirmed")
                if (args.isNotEmpty()) {
                    try {
                        val data = args[0] as JSONObject
                        val orderId = data.optString("orderId", data.optString("_id", ""))

                        // Store ride data in SharedPreferences for Flutter
                        val prefs2 = getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
                        prefs2.edit()
                            .putString("flutter.active_ride_full_data", data.toString())
                            .putString("flutter.active_order_id", orderId)
                            .putBoolean("flutter.is_ride_in_progress", true)
                            .apply()

                        // Dismiss ride notification
                        val nm = getSystemService(NotificationManager::class.java)
                        nm.cancel(RIDE_NOTIFICATION_ID)

                        // Update status notification
                        updateStatusNotification(
                            "NZCU Driver — Ride in Progress",
                            buildNotificationBody()
                        )
                    } catch (e: Exception) {
                        Log.e(TAG, "Error handling ride:confirmed: ${e.message}")
                    }
                }
            }

            socket?.on("ride:orderCancelled") { args ->
                Log.i(TAG, "❌ Ride cancelled by user")
                val nm = getSystemService(NotificationManager::class.java)
                nm.cancel(RIDE_NOTIFICATION_ID)
                // Clear ride state so we emit driver:location:update again (waiting for ride)
                try {
                    getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE).edit()
                        .putBoolean(PREF_IS_RIDE_IN_PROGRESS, false)
                        .putString(PREF_ACTIVE_RIDE_ID, "")
                        .apply()
                } catch (e: Exception) {
                    Log.e(TAG, "Error clearing ride state: ${e.message}")
                }
            }

            socket?.on("ride:status") { args ->
                if (args.isEmpty()) return@on
                try {
                    val data = args[0] as? JSONObject ?: return@on
                    val status = data.optString("status", "").lowercase()
                    if (status in listOf("completed", "finished", "ended", "cancelled")) {
                        Log.i(TAG, "✅ Ride ended (status=$status) — clearing ride state")
                        getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE).edit()
                            .putBoolean(PREF_IS_RIDE_IN_PROGRESS, false)
                            .putString(PREF_ACTIVE_RIDE_ID, "")
                            .apply()
                    }
                } catch (e: Exception) {
                    Log.e(TAG, "Error handling ride:status: ${e.message}")
                }
            }

            socket?.on("driver:online_success") { args ->
                // Log.v(TAG, "✅ Driver online confirmed by server") // Commented out, runs every 5s with emitOnline
            }

            // ── Chat Events ────────────────────────────────────
            // These fire when a rider sends a chat message while the app is killed.
            // The Flutter Dart runtime is dead in this state, so we must show the
            // notification from here using the native NotificationManager.

            socket?.on("chat:receiveMessage") { args ->
                Log.i(TAG, "💬 Chat message received (chat:receiveMessage)")
                if (args.isNotEmpty()) {
                    try {
                        val data = args[0] as? JSONObject ?: return@on
                        showChatNotification(data)
                    } catch (e: Exception) {
                        Log.e(TAG, "Error handling chat:receiveMessage: ${e.message}")
                    }
                }
            }

            socket?.on("chat:message") { args ->
                Log.i(TAG, "💬 Chat message received (chat:message)")
                if (args.isNotEmpty()) {
                    try {
                        val data = args[0] as? JSONObject ?: return@on
                        showChatNotification(data)
                    } catch (e: Exception) {
                        Log.e(TAG, "Error handling chat:message: ${e.message}")
                    }
                }
            }

            socket?.connect()

        } catch (e: Exception) {
            Log.e(TAG, "Fatal socket error: ${e.message}", e)
        }
    }

    private fun disconnectSocket() {
        try {
            socket?.off()
            socket?.disconnect()
            socket?.close()
            socket = null
            isSocketConnected = false
        } catch (e: Exception) {
            Log.e(TAG, "Error disconnecting socket: ${e.message}")
        }
    }

    // ──────────────────────────────────────────────────────────
    //  Socket Emits
    // ──────────────────────────────────────────────────────────

    private fun emitOnline() {
        if (!isOnDuty || socket == null || !isSocketConnected) return

        val prefs = getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
        val vehicleType = prefs.getString(PREF_VEHICLE_TYPE, "") ?: ""
        val vehicleSubType = prefs.getString(PREF_VEHICLE_SUB_TYPE, null)
        val vehicleId = prefs.getString(PREF_VEHICLE_NUMBER, "") ?: ""
        val vehicleImage = prefs.getString(PREF_VEHICLE_IMAGE, null)
        val fleetId = prefs.getString(PREF_FLEET_ID, null)

        val payload = JSONObject().apply {
            put("latitude", currentLat)
            put("longitude", currentLng)
            put("vehicleType", vehicleType)
            if (vehicleSubType != null) put("vehicleSubType", vehicleSubType)
            put("vehicleId", vehicleId)
            if (vehicleImage != null) put("vehicleImage", vehicleImage)
            if (fleetId != null) put("fleetId", fleetId)
            put("timestamp", System.currentTimeMillis())
        }

        try {
            socket?.emit("user:online", payload)
            // Log.d(TAG, "📡 Emitted user:online (${currentLat}, ${currentLng})") // Commented out to reduce spam
        } catch (e: Exception) {
            Log.e(TAG, "Error emitting user:online: ${e.message}")
        }
    }

    private fun emitLocation() {
        if (!isOnDuty || socket == null || !isSocketConnected) return
        if (currentLat == 0.0 && currentLng == 0.0) return

        val prefs = getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
        val isRide = prefs.getBoolean(PREF_IS_RIDE_IN_PROGRESS, false)
        val activeRideId = prefs.getString(PREF_ACTIVE_RIDE_ID, "") ?: ""
        val vehicleType = prefs.getString(PREF_VEHICLE_TYPE, "") ?: ""

        try {
            if (isRide && activeRideId.isNotEmpty()) {
                val payload = JSONObject().apply {
                    put("rideId", activeRideId)
                    put("location", JSONObject().apply {
                        put("latitude", currentLat)
                        put("longitude", currentLng)
                        put("lat", currentLat)
                        put("lng", currentLng)
                        put("timestamp", Date().toInstant().toString())
                        put("accuracy", 0.0)
                        put("speed", 0.0)
                    })
                }
                socket?.emit("ride:location:update", payload)
            } else {
                val payload = JSONObject().apply {
                    put("latitude", currentLat)
                    put("longitude", currentLng)
                    put("role", "Driver")
                    put("vehicleType", vehicleType)
                    put("timestamp", Date().toInstant().toString())
                }
                socket?.emit("driver:location:update", payload)
            }
        } catch (e: Exception) {
            Log.e(TAG, "Error emitting location: ${e.message}")
        }
    }

    // ──────────────────────────────────────────────────────────
    //  Ride Request Handling
    // ──────────────────────────────────────────────────────────

    private fun handleNewRideRequest(data: JSONObject) {
        Log.i(TAG, "Processing ride request: ${data.toString().take(200)}")

        // Store ride data for Flutter.
        // IMPORTANT: Always set pending_ride_from_killed=true here.
        // The Kotlin socket ONLY connects when the app is killed (called from onTaskRemoved()).
        // Even though onStartCommand() resets appState="Foreground" after each AlarmManager restart,
        // the Kotlin socket connection itself is proof that Flutter is not alive.
        // Do NOT gate this on appState — that check was the root cause of the bug.
        val prefs = getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
        val editor = prefs.edit()
            .putString(PREF_LAST_RIDE_REQUEST, data.toString())
            // Store timestamp so Flutter can discard stale rides (>30s old)
            .putLong("flutter.last_ride_request_ts", System.currentTimeMillis())
            // Always set this flag — Flutter reads it on cold-start to show RideRequestScreen
            .putBoolean("flutter.pending_ride_from_killed", true)
        editor.apply()
        Log.i(TAG, "✅ pending_ride_from_killed=true stored for Flutter (appState=$appState)")

        // Extract orderId — the backend uses different keys on different events.
        // Try all known variants: "orderId", "_id", "rideId", "id"
        val orderId = data.optString("orderId").ifEmpty {
            data.optString("_id").ifEmpty {
                data.optString("rideId").ifEmpty {
                    data.optString("id", "")
                }
            }
        }
        Log.i(TAG, "Extracted orderId='$orderId' from ride data")

        val pickupLocation = data.optString("pickupLocation",
            data.optJSONObject("pickup")?.optString("address", "Pickup") ?: "Pickup"
        )
        val dropLocation = data.optString("dropLocation",
            data.optJSONObject("dropoff")?.optString("address", "Drop") ?: "Drop"
        )
        val fare = data.optString("fare",
            data.optString("estimatedFare", "")
        )
        val distance = data.optString("distance", "")

        // Build notification body
        val body = buildString {
            append("$pickupLocation")
            append(" → $dropLocation")
            if (fare.isNotEmpty()) append(" • ₹$fare")
            if (distance.isNotEmpty()) append(" • $distance km")
        }

        // Show ride notification with Accept / Decline actions.
        // Tapping the notification body will open the app via its contentIntent PendingIntent.
        // For the killed-state, Flutter reads pending_ride_from_killed on startup and pushes
        // RideRequestScreen — no explicit startActivity() call needed here.
        showRideNotification(orderId, "New Ride Request!", body)
    }


    private fun showChatNotification(data: JSONObject) {
        try {
            // Extract message content — mirrors ChatNotificationController._showLocalNotification() in Flutter
            val messageObj = data.optJSONObject("message")
            val senderName = messageObj
                ?.optJSONObject("senderId")
                ?.optString("name", "New Message")
                ?: "New Message"
            val messageText = messageObj?.optString("message", "") ?: ""

            // Open app on tap
            val openAppIntent = packageManager.getLaunchIntentForPackage(packageName)?.apply {
                addFlags(Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_SINGLE_TOP)
            }
            val pendingIntent = PendingIntent.getActivity(
                this, 4000, openAppIntent,
                PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_UPDATE_CURRENT
            )

            val notification = NotificationCompat.Builder(this, CHAT_CHANNEL_ID)
                .setSmallIcon(R.drawable.ic_bg_service_small)
                .setContentTitle("Chat: $senderName")
                .setContentText(messageText)
                .setStyle(NotificationCompat.BigTextStyle().bigText(messageText))
                .setPriority(NotificationCompat.PRIORITY_HIGH)
                .setCategory(NotificationCompat.CATEGORY_MESSAGE)
                .setAutoCancel(true)
                .setContentIntent(pendingIntent)
                .setDefaults(NotificationCompat.DEFAULT_ALL)
                .build()

            val nm = getSystemService(NotificationManager::class.java)
            // Use a unique ID per chat message (epoch seconds keeps them distinct but prevents flood)
            val notifId = CHAT_NOTIFICATION_ID + (System.currentTimeMillis() / 1000 % 1000).toInt()
            nm.notify(notifId, notification)

            Log.i(TAG, "✅ Chat notification shown: \"Chat: $senderName\"")
        } catch (e: Exception) {
            Log.e(TAG, "Error showing chat notification: ${e.message}")
        }
    }

    private fun showRideNotification(orderId: String, title: String, body: String) {
        // Use orderId-based unique request codes + FLAG_CANCEL_CURRENT so each new ride
        // always gets a fresh PendingIntent with the correct orderId (fixes empty orderId bug).
        val rideHash = orderId.hashCode() and 0xFFFF  // keep it positive & within int range

        // Accept action (Directly opens the app instead of routing through a BroadcastReceiver)
        // Android 10+ is notoriously strict about background activity launches.
        // A direct PendingIntent.getActivity attached to a notification action button
        // is guaranteed to be allowed to launch the app.
        val acceptAppIntent = packageManager.getLaunchIntentForPackage(packageName)?.apply {
            addFlags(
                Intent.FLAG_ACTIVITY_NEW_TASK or
                Intent.FLAG_ACTIVITY_SINGLE_TOP or
                Intent.FLAG_ACTIVITY_CLEAR_TOP
            )
            putExtra("from_notification", true)
            putExtra("from_ride_notification", true)
            putExtra("accepted_ride", true)
            putExtra(EXTRA_ORDER_ID, orderId)
            action = "com.nzcu_driver.ACCEPT_RIDE"
        }
        val acceptPendingIntent = PendingIntent.getActivity(
            this, 1000 + rideHash, acceptAppIntent,
            PendingIntent.FLAG_CANCEL_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )

        // Decline action (Still routes through BroadcastReceiver since it doesn't open the app)
        val declineIntent = Intent(this, RideActionReceiver::class.java).apply {
            action = "com.nzcu_driver.DECLINE_RIDE"
            putExtra(EXTRA_ORDER_ID, orderId)
        }
        val declinePendingIntent = PendingIntent.getBroadcast(
            this, 2000 + rideHash, declineIntent,
            PendingIntent.FLAG_CANCEL_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )

        // Tap notification body to open app
        val openAppIntent = packageManager.getLaunchIntentForPackage(packageName)?.apply {
            addFlags(
                Intent.FLAG_ACTIVITY_NEW_TASK or
                Intent.FLAG_ACTIVITY_SINGLE_TOP or
                Intent.FLAG_ACTIVITY_CLEAR_TOP
            )
            putExtra("from_notification", true)
            putExtra("from_ride_notification", true)
            putExtra(EXTRA_ORDER_ID, orderId)
        }
        val openPendingIntent = PendingIntent.getActivity(
            this, 3000 + rideHash, openAppIntent,
            PendingIntent.FLAG_CANCEL_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )

        val notification = NotificationCompat.Builder(this, RIDE_CHANNEL_ID)
            .setSmallIcon(R.drawable.ic_bg_service_small)
            .setContentTitle(title)
            .setContentText(body)
            .setStyle(NotificationCompat.BigTextStyle().bigText(body))
            .setPriority(NotificationCompat.PRIORITY_HIGH)
            .setCategory(NotificationCompat.CATEGORY_CALL)
            .setAutoCancel(false)
            .setOngoing(true)
            .setContentIntent(openPendingIntent)
            .addAction(0, "✅ Accept", acceptPendingIntent)
            .addAction(0, "❌ Decline", declinePendingIntent)
            .setDefaults(NotificationCompat.DEFAULT_ALL)
            .setFullScreenIntent(openPendingIntent, true)
            .build()
            
        // 🚨 CRITICAL: Make the notification ring infinitely until cancelled
        notification.flags = notification.flags or Notification.FLAG_INSISTENT

        val nm = getSystemService(NotificationManager::class.java)
        nm.notify(RIDE_NOTIFICATION_ID, notification)
    }

    private fun handleAcceptRide(orderId: String) {
        Log.i(TAG, "✅ Accepting ride: $orderId")

        // Persist user's decision so Flutter can reconcile if needed.
        // Also store a timestamp so Flutter can detect freshness and ignore stale actions.
        try {
            val prefs = getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
            prefs.edit()
                .putString(PREF_PENDING_ACCEPT_ORDER_ID, orderId)
                .putLong("flutter.pending_accept_timestamp", System.currentTimeMillis())
                .remove(PREF_PENDING_DECLINE_ORDER_ID)
                .apply()
        } catch (e: Exception) {
            Log.e(TAG, "Error persisting pending accept: ${e.message}")
        }

        // NOTE: We DO NOT emit 'ride:accept' from the native service anymore.
        // Reason: If we emit here, the server replies with 'ride:confirmed' to the native socket
        // BEFORE Flutter starts. Flutter then never sees 'ride:confirmed' and gets stuck.
        // Instead, Flutter will read "pending_accept_order_id" and emit 'ride:accept' with
        // the full driver payload.

        // Dismiss ride notification
        val nm = getSystemService(NotificationManager::class.java)
        nm.cancel(RIDE_NOTIFICATION_ID)

        // NOTE: App-open is handled by RideActionReceiver.onReceive() directly —
        // BroadcastReceivers responding to user-initiated notification taps are exempt
        // from Android 10+ background activity launch restrictions.
        Log.i(TAG, "✅ handleAcceptRide complete — app-open delegated to RideActionReceiver")
    }


    private fun handleDeclineRide(orderId: String) {
        Log.i(TAG, "❌ Declining ride: $orderId")

        // Persist user's decision so Flutter can reconcile if needed
        try {
            val prefs = getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
            prefs.edit()
                .putString(PREF_PENDING_DECLINE_ORDER_ID, orderId)
                .remove(PREF_PENDING_ACCEPT_ORDER_ID)
                .apply()
        } catch (e: Exception) {
            Log.e(TAG, "Error persisting pending decline: ${e.message}")
        }

        // NOTE: We DO NOT emit 'ride:decline' from the native service anymore.
        // Reason: Better to let Flutter handle it consistently so that local state is synchronized.
        // Flutter reads "pending_decline_order_id" and emits 'ride:decline'.

        // Dismiss ride notification
        val nm = getSystemService(NotificationManager::class.java)
        nm.cancel(RIDE_NOTIFICATION_ID)
    }

    // ──────────────────────────────────────────────────────────
    //  Location (native, using FusedLocationProvider)
    // ──────────────────────────────────────────────────────────

    private fun startLocationUpdates() {
        if (ActivityCompat.checkSelfPermission(this, Manifest.permission.ACCESS_FINE_LOCATION)
            != PackageManager.PERMISSION_GRANTED
        ) {
            Log.w(TAG, "Location permission not granted")
            return
        }

        fusedLocationClient = LocationServices.getFusedLocationProviderClient(this)

        val locationRequest = LocationRequest.Builder(
            Priority.PRIORITY_HIGH_ACCURACY, LOCATION_INTERVAL_MS
        ).apply {
            setMinUpdateIntervalMillis(LOCATION_FASTEST_MS)
            setWaitForAccurateLocation(false)
        }.build()

        locationCallback = object : LocationCallback() {
            override fun onLocationResult(result: LocationResult) {
                result.lastLocation?.let { location ->
                    currentLat = location.latitude
                    currentLng = location.longitude
                    // Log.v(TAG, "📍 Location: ($currentLat, $currentLng)") // Commented out to reduce spam
                }
            }
        }

        fusedLocationClient?.requestLocationUpdates(
            locationRequest, locationCallback!!, Looper.getMainLooper()
        )

        // Also get last known location immediately
        fusedLocationClient?.lastLocation?.addOnSuccessListener { location: Location? ->
            location?.let {
                currentLat = it.latitude
                currentLng = it.longitude
                Log.i(TAG, "📍 Initial location: ($currentLat, $currentLng)")
            }
        }
    }

    private fun stopLocationUpdates() {
        locationCallback?.let {
            fusedLocationClient?.removeLocationUpdates(it)
        }
        locationCallback = null
        fusedLocationClient = null
    }

    // ──────────────────────────────────────────────────────────
    //  Notifications
    // ──────────────────────────────────────────────────────────

    private fun buildNotificationBody(): String {
        val prefs = getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
        val isRide = prefs.getBoolean(PREF_IS_RIDE_IN_PROGRESS, false)

        val sb = StringBuilder()

        when (appState) {
            "Killed" -> sb.append("🔴 App Killed — Running in Background")
            "Background" -> sb.append("🟡 App Minimised — Running in Background")
            else -> sb.append("🟢 App Active — Foreground")
        }

        if (isRide) {
            sb.append(" • 🚗 Ride in Progress")
        } else if (isOnDuty) {
            sb.append(" • Waiting for rides...")
        }

        return sb.toString()
    }

    private fun buildStatusNotification(title: String, body: String): Notification {
        val openAppIntent = packageManager.getLaunchIntentForPackage(packageName)?.apply {
            addFlags(Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_SINGLE_TOP)
        }
        val pendingIntent = PendingIntent.getActivity(
            this, 0, openAppIntent,
            PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_UPDATE_CURRENT
        )

        return NotificationCompat.Builder(this, STATUS_CHANNEL_ID)
            .setContentTitle(title)
            .setContentText(body)
            .setSmallIcon(R.drawable.ic_bg_service_small)
            .setOngoing(true)
            .setContentIntent(pendingIntent)
            .setSilent(true)
            .setPriority(NotificationCompat.PRIORITY_LOW)
            .build()
    }

    private fun updateStatusNotification(title: String, body: String) {
        val notification = buildStatusNotification(title, body)
        val nm = getSystemService(NotificationManager::class.java)
        nm.notify(STATUS_NOTIFICATION_ID, notification)
    }

    // ──────────────────────────────────────────────────────────
    //  Locks (WakeLock + WifiLock)
    // ──────────────────────────────────────────────────────────

    private fun acquireLocks() {
        if (wakeLock == null) {
            val pm = getSystemService(Context.POWER_SERVICE) as PowerManager
            wakeLock = pm.newWakeLock(PowerManager.PARTIAL_WAKE_LOCK, "NZCUDriver::SocketWakeLock")
            wakeLock?.acquire()
        }
        if (wifiLock == null) {
            val wm = applicationContext.getSystemService(Context.WIFI_SERVICE) as WifiManager
            @Suppress("DEPRECATION")
            wifiLock = wm.createWifiLock(WifiManager.WIFI_MODE_FULL_HIGH_PERF, "NZCUDriver::SocketWifiLock")
            wifiLock?.acquire()
        }
        Log.i(TAG, "🔒 Locks acquired")
    }

    private fun releaseLocks() {
        try {
            wakeLock?.let { if (it.isHeld) it.release() }
            wakeLock = null
            wifiLock?.let { if (it.isHeld) it.release() }
            wifiLock = null
            Log.i(TAG, "🔓 Locks released")
        } catch (e: Exception) {
            Log.e(TAG, "Error releasing locks: ${e.message}")
        }
    }
}

// ──────────────────────────────────────────────────────────────────
//  BroadcastReceiver for notification Accept / Decline buttons
// ──────────────────────────────────────────────────────────────────

class RideActionReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        val orderId = intent.getStringExtra(SocketForegroundService.EXTRA_ORDER_ID) ?: ""
        Log.i("RideActionReceiver", "Action: ${intent.action}, orderId: $orderId")

        val serviceIntent = Intent(context, SocketForegroundService::class.java).apply {
            when (intent.action) {
                "com.nzcu_driver.ACCEPT_RIDE" -> {
                    putExtra(SocketForegroundService.EXTRA_ACTION, SocketForegroundService.ACTION_ACCEPT_RIDE)
                    putExtra(SocketForegroundService.EXTRA_ORDER_ID, orderId)
                }
                "com.nzcu_driver.DECLINE_RIDE" -> {
                    putExtra(SocketForegroundService.EXTRA_ACTION, SocketForegroundService.ACTION_DECLINE_RIDE)
                    putExtra(SocketForegroundService.EXTRA_ORDER_ID, orderId)
                }
            }
        }

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            context.startForegroundService(serviceIntent)
        } else {
            context.startService(serviceIntent)
        }

        // ── For ACCEPT only: open the app directly from here ────────────────
        // A BroadcastReceiver handling a user-initiated notification button tap is
        // explicitly exempt from Android 10-12+ background activity launch restrictions.
        // Context.startActivity() works here even when the app is fully killed.
        // Do NOT do this from inside the Service (PendingIntent.send() is still restricted).
        if (intent.action == "com.nzcu_driver.ACCEPT_RIDE") {
            // Proactively clear the pending_ride_from_killed flag so that when
            // checkPendingRideFromKilledState() runs in splash it finds nothing and skips
            // RideRequestScreen. The accepted state is handled by _processPendingNativeNotificationActions.
            try {
                val prefs = context.getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE)
                prefs.edit()
                    .putBoolean("flutter.pending_ride_from_killed", false)
                    .apply()
                Log.i("RideActionReceiver", "✅ Cleared pending_ride_from_killed to prevent ghost RideRequestScreen")
            } catch (e: Exception) {
                Log.e("RideActionReceiver", "Error clearing pending flag: ${e.message}")
            }

            try {
                // Collapse the notification panel so the activity can come to the foreground
                context.sendBroadcast(Intent(Intent.ACTION_CLOSE_SYSTEM_DIALOGS))

                val pm = context.packageManager
                val launchIntent = pm.getLaunchIntentForPackage(context.packageName)?.apply {
                    addFlags(
                        Intent.FLAG_ACTIVITY_NEW_TASK or
                        Intent.FLAG_ACTIVITY_CLEAR_TOP or
                        Intent.FLAG_ACTIVITY_SINGLE_TOP or
                        Intent.FLAG_ACTIVITY_REORDER_TO_FRONT
                    )
                    putExtra("from_notification", true)
                    putExtra("from_ride_notification", true)
                    putExtra("accepted_ride", true)
                    putExtra(SocketForegroundService.EXTRA_ORDER_ID, orderId)
                }
                
                if (launchIntent != null) {
                    context.startActivity(launchIntent)
                    Log.i("RideActionReceiver", "✅ App launched from BroadcastReceiver via startActivity (notification panel collapsed)")
                } else {
                    Log.e("RideActionReceiver", "❌ getLaunchIntentForPackage returned null")
                }
            } catch (e: Exception) {
                Log.e("RideActionReceiver", "Could not open app from receiver: ${e.message}")
            }
        }
    }
}

