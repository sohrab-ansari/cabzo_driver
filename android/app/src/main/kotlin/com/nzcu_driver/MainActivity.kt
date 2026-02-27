package com.nzcu_driver

import android.content.Intent
import android.os.Build
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.nzcu_driver/background_service"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "startService") {
                 val intent = Intent(this, ForegroundService::class.java)
                 if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                     startForegroundService(intent)
                 } else {
                     startService(intent)
                 }
                 result.success("Service Started")
            } else if (call.method == "stopService") {
                 val intent = Intent(this, ForegroundService::class.java)
                 intent.putExtra("action", "stop")
                 startService(intent)
                 result.success("Service Stopped")
            } else if (call.method == "updateNotification") {
                 val title = call.argument<String>("title")
                 val body = call.argument<String>("body")
                 val intent = Intent(this, ForegroundService::class.java)
                 intent.putExtra("action", "update")
                 if (title != null) intent.putExtra("title", title)
                 if (body != null) intent.putExtra("body", body)
                 startService(intent)
                 result.success("Notification Updated")
            } else {
                result.notImplemented()
            }
        }
    }
}
