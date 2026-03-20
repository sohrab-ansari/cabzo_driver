package com.nzcu_driver

import android.app.NotificationManager
import android.content.Intent
import android.os.Build
import androidx.annotation.NonNull
import androidx.core.content.ContextCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.os.Bundle
import android.view.WindowManager

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.nzcu_driver/background_service"

    private fun startSocketServiceCompat(intent: Intent) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            ContextCompat.startForegroundService(this, intent)
        } else {
            startService(intent)
        }
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        
        // Wake up screen and show over lockscreen for ride requests
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O_MR1) {
            setShowWhenLocked(true)
            setTurnScreenOn(true)
        } else {
            window.addFlags(
                WindowManager.LayoutParams.FLAG_SHOW_WHEN_LOCKED or
                WindowManager.LayoutParams.FLAG_TURN_SCREEN_ON or
                WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON
            )
        }

        handleIntentExtras(intent)
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        setIntent(intent)
        handleIntentExtras(intent)
    }

    private fun handleIntentExtras(intent: Intent?) {
        if (intent == null) return
        
        val isFromNotification = intent.getBooleanExtra("from_notification", false)
        val isFromRideNotification = intent.getBooleanExtra("from_ride_notification", false)
        val isAcceptedRide = intent.getBooleanExtra("accepted_ride", false)
        val orderId = intent.getStringExtra(SocketForegroundService.EXTRA_ORDER_ID)

        // Always cancel the native ride notification when the app is opened from it
        if (isFromNotification && isFromRideNotification) {
            cancelNativeRideNotification()
        }
        
        if (isFromNotification && isAcceptedRide && orderId != null) {
            try {
                val prefs = getSharedPreferences("FlutterSharedPreferences", android.content.Context.MODE_PRIVATE)
                prefs.edit()
                    .putString("flutter.pending_accept_order_id", orderId)
                    .putLong("flutter.pending_accept_timestamp", System.currentTimeMillis())
                    .putBoolean("flutter.pending_ride_from_killed", false)
                    .apply()
                android.util.Log.i("MainActivity", "✅ Captured Accept Intent! Wrote orderId=$orderId to SharedPreferences")
            } catch (e: Exception) {
                android.util.Log.e("MainActivity", "Error writing to SharedPreferences: ${e.message}")
            }
        }
    }

    private fun cancelNativeRideNotification() {
        try {
            val nm = getSystemService(NotificationManager::class.java)
            nm.cancel(SocketForegroundService.RIDE_NOTIFICATION_ID)
            android.util.Log.i("MainActivity", "🔇 Cancelled native ride notification (ID=${SocketForegroundService.RIDE_NOTIFICATION_ID})")
        } catch (e: Exception) {
            android.util.Log.e("MainActivity", "Error cancelling ride notification: ${e.message}")
        }
    }

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        val soundTest = R.raw.ride_sound
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "startService" -> {
                    try {
                        val intent = Intent(this, SocketForegroundService::class.java)
                        startSocketServiceCompat(intent)
                        result.success("Service Started")
                    } catch (e: Exception) {
                        android.util.Log.e("MainActivity", "startService failed: ${e.message}", e)
                        result.error("START_FAILED", e.message, null)
                    }
                }
                "stopService" -> {
                    try {
                        val stopped = stopService(Intent(this, SocketForegroundService::class.java))
                        result.success(if (stopped) "Service Stopped" else "Service Not Running")
                    } catch (e: Exception) {
                        android.util.Log.e("MainActivity", "stopService failed: ${e.message}", e)
                        result.error("STOP_FAILED", e.message, null)
                    }
                }
                "updateNotification" -> {
                    try {
                        val title = call.argument<String>("title")
                        val body = call.argument<String>("body")
                        val intent = Intent(this, SocketForegroundService::class.java)
                        intent.putExtra(SocketForegroundService.EXTRA_ACTION, SocketForegroundService.ACTION_UPDATE)
                        if (title != null) intent.putExtra(SocketForegroundService.EXTRA_TITLE, title)
                        if (body != null) intent.putExtra(SocketForegroundService.EXTRA_BODY, body)
                        // Do not start as foreground here: ACTION_UPDATE path is lightweight
                        // and may not call startForeground() immediately if service wasn't running.
                        startService(intent)
                        result.success("Notification Updated")
                    } catch (e: Exception) {
                        android.util.Log.e("MainActivity", "updateNotification failed: ${e.message}", e)
                        result.error("UPDATE_FAILED", e.message, null)
                    }
                }
                "setAppState" -> {
                    try {
                        val state = call.argument<String>("state") ?: "Foreground"
                        val prefs = getSharedPreferences("FlutterSharedPreferences", android.content.Context.MODE_PRIVATE)
                        val isDriverOnline = prefs.getBoolean("flutter.driver_is_online", false)

                        // Avoid unnecessary service starts while offline, which are brittle on OEM ROMs.
                        if (!isDriverOnline) {
                            result.success("App state skipped (driver offline)")
                            return@setMethodCallHandler
                        }

                        val intent = Intent(this, SocketForegroundService::class.java)
                        intent.putExtra(SocketForegroundService.EXTRA_ACTION, SocketForegroundService.ACTION_SET_APP_STATE)
                        intent.putExtra(SocketForegroundService.EXTRA_APP_STATE, state)
                        // Do not force foreground start for state sync actions.
                        // This avoids Android OEM crashes when service is not already active.
                        startService(intent)
                        result.success("App state updated")
                    } catch (e: Exception) {
                        android.util.Log.e("MainActivity", "setAppState failed: ${e.message}", e)
                        result.error("SET_STATE_FAILED", e.message, null)
                    }
                }
                "bringToFront" -> {
                    val appIntent = Intent(this@MainActivity, MainActivity::class.java).apply {
                        flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_REORDER_TO_FRONT
                    }
                    startActivity(appIntent)
                    result.success("Brought to front")
                }
                "cancelRideNotification" -> {
                    cancelNativeRideNotification()
                    result.success("Ride notification cancelled")
                }
                "launchIntent" -> {
                    val pkg = call.argument<String>("package") ?: ""
                    val cls = call.argument<String>("class") ?: ""
                    try {
                        val intent = Intent().apply {
                            component = android.content.ComponentName(pkg, cls)
                            addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                        }
                        startActivity(intent)
                        result.success("Launched")
                    } catch (e: Exception) {
                        result.error("LAUNCH_FAILED", e.message, null)
                    }
                }
                else -> result.notImplemented()
            }
        }
    }
}
