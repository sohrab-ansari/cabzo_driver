package com.nzcu_driver

import android.app.NotificationManager
import android.content.Intent
import android.os.Build
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.os.Bundle
import android.view.WindowManager

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.nzcu_driver/background_service"

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
                    val intent = Intent(this, SocketForegroundService::class.java)
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                        startForegroundService(intent)
                    } else {
                        startService(intent)
                    }
                    result.success("Service Started")
                }
                "stopService" -> {
                    val intent = Intent(this, SocketForegroundService::class.java)
                    intent.putExtra(SocketForegroundService.EXTRA_ACTION, SocketForegroundService.ACTION_STOP)
                    startService(intent)
                    result.success("Service Stopped")
                }
                "updateNotification" -> {
                    val title = call.argument<String>("title")
                    val body = call.argument<String>("body")
                    val intent = Intent(this, SocketForegroundService::class.java)
                    intent.putExtra(SocketForegroundService.EXTRA_ACTION, SocketForegroundService.ACTION_UPDATE)
                    if (title != null) intent.putExtra(SocketForegroundService.EXTRA_TITLE, title)
                    if (body != null) intent.putExtra(SocketForegroundService.EXTRA_BODY, body)
                    startService(intent)
                    result.success("Notification Updated")
                }
                "setAppState" -> {
                    val state = call.argument<String>("state") ?: "Foreground"
                    val intent = Intent(this, SocketForegroundService::class.java)
                    intent.putExtra(SocketForegroundService.EXTRA_ACTION, SocketForegroundService.ACTION_SET_APP_STATE)
                    intent.putExtra(SocketForegroundService.EXTRA_APP_STATE, state)
                    startService(intent)
                    result.success("App state updated")
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
