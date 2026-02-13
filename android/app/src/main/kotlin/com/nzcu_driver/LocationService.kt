package com.nzcu_driver

import android.app.*
import android.content.Context
import android.content.Intent
import android.content.SharedPreferences
import android.location.Location
import android.os.Build
import android.os.IBinder
import android.os.Looper
import android.util.Log
import androidx.core.app.NotificationCompat
import com.google.android.gms.location.*
import io.socket.client.IO
import io.socket.client.Socket
import org.json.JSONObject
import java.util.concurrent.TimeUnit
import java.util.Random
import android.view.WindowManager
import android.graphics.Color

class LocationService : Service() {

    private var socket: Socket? = null
    private lateinit var fusedLocationClient: FusedLocationProviderClient
    private lateinit var locationCallback: LocationCallback
    private var lastLat = 0.0
    private var lastLng = 0.0
    private val handler = android.os.Handler(android.os.Looper.getMainLooper())
    private var locationRunnable: Runnable? = null

    private val CHANNEL_ID = "NativeLocationChannel"
    private val RIDE_CHANNEL_ID = "high_importance_channel"
    private val NOTIFICATION_ID = 1001
    private val RIDE_NOTIFICATION_ID = 888
    private var activeAlertDialog: AlertDialog? = null

    companion object {
        var isAppInForeground = false
    }

    override fun onCreate() {
        super.onCreate()
        Log.d("NativeLocation", "Service Created")
        fusedLocationClient = LocationServices.getFusedLocationProviderClient(this)
        createNotificationChannels()
        setupLocationTracking()
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        val action = intent?.action
        Log.d("NativeLocation", "onStartCommand Action: $action")

        if (action == "START") {
            startForegroundService()
            connectSocket()
            startLocationUpdates()
        } else if (action == "STOP") {
            stopForeground(STOP_FOREGROUND_REMOVE)
            stopSelf()
        } else if (action == "ACCEPT_RIDE") {
            Log.d("NativeLocation", "✅ onStartCommand RECEIVED ACCEPT_RIDE action")
            val rideDataStr = intent?.getStringExtra("rideData")
            if (rideDataStr != null) {
                acceptRide(JSONObject(rideDataStr))
            }
            val manager = getSystemService(NotificationManager::class.java)
            manager.cancel(RIDE_NOTIFICATION_ID)
        } else if (action == "DECLINE_RIDE") {
            Log.d("NativeLocation", "❌ onStartCommand RECEIVED DECLINE_RIDE action")
            val rideDataStr = intent?.getStringExtra("rideData")
            if (rideDataStr != null) {
                declineRide(JSONObject(rideDataStr))
            }
            val manager = getSystemService(NotificationManager::class.java)
            manager.cancel(RIDE_NOTIFICATION_ID)
        } else if (action == "CLEAR_RIDE_STATE") {
            Log.d("NativeLocation", "🧹 onStartCommand RECEIVED CLEAR_RIDE_STATE action")
            clearRideState()
        }

        startEmissionTimer()
        return START_STICKY
    }

    private fun startEmissionTimer() {
        if (locationRunnable != null) return
        
        locationRunnable = object : Runnable {
            override fun run() {
                if (socket?.connected() == true && lastLat != 0.0 && lastLng != 0.0) {
                    sendLocationUpdate()
                }
                handler.postDelayed(this, 3000)
            }
        }
        handler.post(locationRunnable!!)
    }

    private fun createNotificationChannels() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val manager = getSystemService(NotificationManager::class.java)
            
            val serviceChannel = NotificationChannel(
                CHANNEL_ID,
                "NZCU Native Location Service",
                NotificationManager.IMPORTANCE_LOW
            )
            
            val rideChannel = NotificationChannel(
                RIDE_CHANNEL_ID,
                "New Ride Requests",
                NotificationManager.IMPORTANCE_HIGH
            ).apply {
                description = "This channel is used for important ride alerts"
                enableVibration(true)
                lockscreenVisibility = Notification.VISIBILITY_PUBLIC
                setBypassDnd(true) // Wake up the driver even in DND
                setShowBadge(true)
            }

            manager.createNotificationChannel(serviceChannel)
            manager.createNotificationChannel(rideChannel)
        }
    }

    private fun startForegroundService() {
        val notificationIntent = Intent(this, MainActivity::class.java)
        val pendingIntent = PendingIntent.getActivity(
            this, 0, notificationIntent,
            PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_UPDATE_CURRENT
        )

        val notification = NotificationCompat.Builder(this, CHANNEL_ID)
            .setContentTitle("NZCU Driver")
            .setContentText("Background location service is active")
            .setSmallIcon(android.R.drawable.ic_menu_mylocation)
            .setContentIntent(pendingIntent)
            .setOngoing(true)
            .build()

        startForeground(NOTIFICATION_ID, notification)
    }

    private fun connectSocket() {
        if (socket?.connected() == true) return

        val prefs = getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE)
        val token = prefs.getString("flutter.auth_token", null)
        val driverId = prefs.getString("flutter.driver_userid", null)

        if (token == null || driverId == null) {
            Log.e("NativeLocation", "Missing auth data in SharedPreferences")
            return
        }

        try {
            val opts = IO.Options()
            opts.auth = mapOf("token" to token)
            opts.query = "userRole=Driver&platform=flutter&driverId=$driverId&isBackground=true"
            opts.transports = arrayOf("websocket", "polling")

            
            socket = IO.socket("https://corezap.smarttechbros.com", opts)
            socket?.on(Socket.EVENT_CONNECT) {
                Log.d("NativeLocation", "Socket Connected!")
                emitOnlineStatus()
            }

            socket?.on("ride:newRide") { args ->
                if (args.isNotEmpty()) {
                    val data = args[0] as JSONObject
                    Log.d("NativeLocation", "🚕 NEW RIDE RECEIVED: $data")
                    // Use the optimized notification which handles both Lock Screen and Banner cases
                    showRideNotification(data)
                }
            }

            socket?.on("ride:status") { args ->
                if (args.isNotEmpty()) {
                    val data = args[0] as JSONObject
                    val status = data.optString("status", "").lowercase()
                    if (status == "completed" || status == "finished" || status == "ended" || status == "cancelled") {
                        clearRideState()
                    }
                }
            }

            socket?.on("ride:orderCancelled") {
                Log.d("NativeLocation", "Ride Cancelled by User")
                val cancelIntent = Intent("RIDE_CANCELLED")
                sendBroadcast(cancelIntent)
                val manager = getSystemService(NotificationManager::class.java)
                manager.cancel(RIDE_NOTIFICATION_ID)
                clearRideState()
            }

            socket?.on(Socket.EVENT_DISCONNECT) {
                Log.d("NativeLocation", "Socket Disconnected")
            }

            socket?.connect()
        } catch (e: Exception) {
            Log.e("NativeLocation", "Socket Connection Error: ${e.message}")
        }
    }


    // Generic System Alert removed because it requires manual permission on modern Android. 
    // We now use RideRequestActivity via FullScreenIntent for better "No Permission" support.

    private fun dismissActiveAlertDialog() {
        try {
            if (activeAlertDialog?.isShowing == true) {
                activeAlertDialog?.dismiss()
                activeAlertDialog = null
                Log.d("NativeLocation", "AlertDialog dismissed")
            }
        } catch (e: Exception) {
            Log.e("NativeLocation", "Error dismissing dialog: ${e.message}")
        }
    }

    private fun showRideNotification(rideData: JSONObject) {
        // We always try to show the notification and launch the activity for maximum visibility.
        // Android will decide if it shows a banner or a full-screen dialog based on the screen state.
        
        val orderId = rideData.optString("orderId", rideData.optString("rideId", rideData.optString("_id", "unknown")))
        val riderName = rideData.optJSONObject("userId")?.optString("name", "Customer") 
            ?: rideData.optString("riderName", "New Rider")
        val pickup = rideData.optJSONObject("startLocation")?.optString("address", "Pickup Location") 
            ?: rideData.optString("pickupLocation", "Pickup Location")

        // Launch Native Bottom Sheet Activity
        val rideIntent = Intent(this, RideRequestActivity::class.java).apply {
            putExtra("rideData", rideData.toString())
            addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
            addFlags(Intent.FLAG_ACTIVITY_SINGLE_TOP)
            addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP)
            addFlags(Intent.FLAG_ACTIVITY_REORDER_TO_FRONT)
        }
        
        // This is crucial for showing the activity from background on modern Android
        val fullScreenPendingIntent = PendingIntent.getActivity(
            this, Random().nextInt(), rideIntent,
            PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_UPDATE_CURRENT
        )

        val notificationIntent = Intent(this, MainActivity::class.java).apply {
            putExtra("rideData", rideData.toString())
            putExtra("orderId", orderId)
            action = "OPEN_RIDE_DETAILS"
        }

        val pendingIntent = PendingIntent.getActivity(
            this, Random().nextInt(), notificationIntent,
            PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_UPDATE_CURRENT
        )

        // Save last ride request to SharedPreferences so Flutter can see it on launch
        val prefs = getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE)
        prefs.edit().putString("flutter.last_ride_request", rideData.toString()).apply()

        val acceptIntent = Intent(this, LocationService::class.java).apply {
            action = "ACCEPT_RIDE"
            putExtra("rideData", rideData.toString())
        }
        val acceptPendingIntent = PendingIntent.getService(
            this, Random().nextInt(), acceptIntent,
            PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_UPDATE_CURRENT
        )

        val declineIntent = Intent(this, LocationService::class.java).apply {
            action = "DECLINE_RIDE"
            putExtra("rideData", rideData.toString())
        }
        val declinePendingIntent = PendingIntent.getService(
            this, Random().nextInt(), declineIntent,
            PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_UPDATE_CURRENT
        )

        val notification = NotificationCompat.Builder(this, RIDE_CHANNEL_ID)
            .setContentTitle("🚗 NEW RIDE REQUEST")
            .setContentText("Tap to open centered dialog")
            .setSubText("Rider: $riderName")
            .setSmallIcon(android.R.drawable.ic_dialog_info)
            .setPriority(NotificationCompat.PRIORITY_MAX)
            .setCategory(NotificationCompat.CATEGORY_ALARM) // More aggressive than CATEGORY_CALL
            .setFullScreenIntent(fullScreenPendingIntent, true)
            .setContentIntent(pendingIntent)
            .addAction(android.R.drawable.ic_input_add, "ACCEPT", acceptPendingIntent)
            .addAction(android.R.drawable.ic_menu_close_clear_cancel, "DECLINE", declinePendingIntent)
            .setAutoCancel(true)
            .setOngoing(true) // Keeps it visible
            .setVibrate(longArrayOf(0, 1000, 500, 1000, 500, 1000))
            .setSound(android.provider.Settings.System.DEFAULT_RINGTONE_URI)
            .setVisibility(NotificationCompat.VISIBILITY_PUBLIC)
            .setLocalOnly(true)
            .setDefaults(Notification.DEFAULT_ALL)
            .build()

        val manager = getSystemService(NotificationManager::class.java)
        Log.d("NativeLocation", "Showing Ride Notification for: $orderId")
        
        // Log if we have overlay permission
        val canDraw = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            android.provider.Settings.canDrawOverlays(this)
        } else {
            true
        }
        Log.d("NativeLocation", "Can draw overlays: $canDraw")

        manager.notify(RIDE_NOTIFICATION_ID, notification)

        // Try to launch activity directly if we have permission or on older Android
        try {
            Log.d("NativeLocation", "Attempting direct activity launch from service")
            startActivity(rideIntent)
        } catch (e: Exception) {
            Log.e("NativeLocation", "Direct launch failed: ${e.message}")
        }
    }

    private fun acceptRide(rideData: JSONObject) {
        if (socket?.connected() != true) connectSocket()
        
        val orderId = rideData.optString("orderId", rideData.optString("rideId", rideData.optString("_id", "unknown")))
        val prefs = getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE)
        val driverId = prefs.getString("flutter.driver_userid", "")
        val driverName = prefs.getString("flutter.driver_name", "")
        val driverPhone = prefs.getString("flutter.driver_mobile", "")
        val vehicleType = prefs.getString("flutter.vehicle_type_id", "")
        val vehicleNumber = prefs.getString("flutter.vehicle_id", "")
        val vehicleImage = prefs.getString("flutter.vehicle_image", "")

        val payload = JSONObject()
        payload.put("orderId", orderId)
        payload.put("driverId", driverId)
        payload.put("driverName", driverName)
        payload.put("driverPhone", driverPhone)
        payload.put("acceptedAt", if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) java.time.Instant.now().toString() else System.currentTimeMillis().toString())
        
        val loc = JSONObject()
        loc.put("latitude", lastLat)
        loc.put("longitude", lastLng)
        payload.put("location", loc)
        
        payload.put("vehicleType", vehicleType)
        payload.put("vehicleNumber", vehicleNumber)
        payload.put("vehicleImage", vehicleImage)

        Log.d("NativeLocation", "📤 EMITTING ride:accept for orderId: $orderId")
        socket?.emit("ride:accept", payload)
        
        // Mark as active in prefs so background emitter switches to ride:location:update
        prefs.edit().putBoolean("flutter.is_ride_in_progress", true).apply()
        prefs.edit().putString("flutter.active_ride_id", orderId).apply()
        
        Log.d("NativeLocation", "Accepted Ride: $orderId")
    }

    private fun declineRide(rideData: JSONObject) {
        if (socket?.connected() != true) connectSocket()
        val orderId = rideData.optString("orderId", rideData.optString("rideId", rideData.optString("_id", "unknown")))
        val prefs = getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE)
        val driverId = prefs.getString("flutter.driver_userid", "")

        val payload = JSONObject()
        payload.put("orderId", orderId)
        payload.put("driverId", driverId)
        payload.put("reason", "Declined from native UI")
        payload.put("declinedAt", if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) java.time.Instant.now().toString() else System.currentTimeMillis().toString())

        Log.d("NativeLocation", "📤 EMITTING ride:decline for orderId: $orderId")
        socket?.emit("ride:decline", payload)
        Log.d("NativeLocation", "Declined Ride: $orderId")
        clearRideState()
    }

    private fun clearRideState() {
        val prefs = getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE)
        prefs.edit().putBoolean("flutter.is_ride_in_progress", false).apply()
        prefs.edit().putString("flutter.active_ride_id", "").apply()
        Log.d("NativeLocation", "Ride State Cleared")
    }

    private fun emitOnlineStatus() {
        val prefs = getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE)
        val vehicleType = prefs.getString("flutter.vehicle_type_id", "")
        val vehicleType2 = prefs.getString("flutter.vehicle_SubType", "")
        val vehicleNumber = prefs.getString("flutter.vehicle_id", "")
        val vehicleImage = prefs.getString("flutter.vehicle_image", "")
        val fleetId = prefs.getString("flutter.fleet_id", "")

        val data = JSONObject()
        data.put("latitude", lastLat)
        data.put("longitude", lastLng)
        data.put("vehicleType", vehicleType)
        data.put("vehicleSubType", vehicleType2)
        data.put("vehicleId", vehicleNumber)
        data.put("vehicleImage", vehicleImage)
        data.put("fleetId", fleetId)

        socket?.emit("user:online", data)
    }

    private fun setupLocationTracking() {
        locationCallback = object : LocationCallback() {
            override fun onLocationResult(locationResult: LocationResult) {
                for (location in locationResult.locations) {
                    lastLat = location.latitude
                    lastLng = location.longitude
                }
            }
        }
    }

    private fun startLocationUpdates() {
        val locationRequest = LocationRequest.Builder(Priority.PRIORITY_HIGH_ACCURACY, 3000)
            .setMinUpdateIntervalMillis(2000)
            .build()

        try {
            fusedLocationClient.requestLocationUpdates(
                locationRequest,
                locationCallback,
                Looper.getMainLooper()
            )
        } catch (e: SecurityException) {
            Log.e("NativeLocation", "Location permission missing: ${e.message}")
        }
    }

    private fun sendLocationUpdate() {
        if (socket?.connected() != true) return

        val prefs = getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE)
        val vehicleType = prefs.getString("flutter.vehicle_type_id", "")
        val vehicleType2 = prefs.getString("flutter.vehicle_SubType", "")
        val vehicleNumber = prefs.getString("flutter.vehicle_id", "")
        val vehicleImage = prefs.getString("flutter.vehicle_image", "")
        val fleetId = prefs.getString("flutter.fleet_id", "")
        val isRideActive = prefs.getBoolean("flutter.is_ride_in_progress", false)
        val activeRideId = prefs.getString("flutter.active_ride_id", "")

        Log.v("NativeLocation", "State check: isRideActive=$isRideActive, activeRideId=$activeRideId")

        val data = JSONObject()
        if (isRideActive && !activeRideId.isNullOrEmpty() && activeRideId != "unknown" && activeRideId != "") {
            data.put("rideId", activeRideId)
            val locData = JSONObject()
            locData.put("latitude", lastLat)
            locData.put("longitude", lastLng)
            locData.put("lat", lastLat)
            locData.put("lng", lastLng)
            locData.put("accuracy", 0.0)
            locData.put("speed", 0.0)
            
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                locData.put("timestamp", java.time.Instant.now().toString())
            } else {
                locData.put("timestamp", System.currentTimeMillis().toString())
            }
            data.put("location", locData)
            socket?.emit("ride:location:update", data)
            Log.d("NativeLocation", "Emitted Ride Loc: $activeRideId")
        } else {
            data.put("latitude", lastLat)
            data.put("longitude", lastLng)
            data.put("role", "Driver")
            data.put("vehicleType", vehicleType)
            data.put("vehicleSubType", vehicleType2)
            data.put("vehicleId", vehicleNumber)
            data.put("vehicleImage", vehicleImage)
            data.put("fleetId", fleetId)
            
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                data.put("timestamp", java.time.Instant.now().toString())
            } else {
                data.put("timestamp", System.currentTimeMillis().toString())
            }
            socket?.emit("driver:location:update", data)
            Log.d("NativeLocation", "Emitted Driver Loc: $lastLat, $lastLng")
        }
    }

    override fun onDestroy() {
        super.onDestroy()
        Log.d("NativeLocation", "Service Destroyed")
        fusedLocationClient.removeLocationUpdates(locationCallback)
        locationRunnable?.let { handler.removeCallbacks(it) }
        socket?.disconnect()
    }

    override fun onBind(intent: Intent?): IBinder? = null
}
