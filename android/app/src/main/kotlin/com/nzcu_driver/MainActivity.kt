package com.nzcu_driver

import android.content.Intent
import android.os.Build
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.nzcu_driver/background_service"

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
                else -> result.notImplemented()
            }
        }
    }
}
