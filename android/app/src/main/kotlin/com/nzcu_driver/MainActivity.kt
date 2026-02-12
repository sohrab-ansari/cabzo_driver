package com.nzcu_driver

import android.content.Intent
import android.net.Uri
import android.provider.Settings
import android.util.Log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.nzcu_driver/native_location"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        handleIntent(intent, flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "startService" -> {
                    val intent = Intent(this, LocationService::class.java)
                    intent.action = "START"
                    if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.O) {
                        startForegroundService(intent)
                    } else {
                        startService(intent)
                    }
                    result.success(true)
                }
                "stopService" -> {
                    val intent = Intent(this, LocationService::class.java)
                    intent.action = "STOP"
                    startService(intent)
                    result.success(true)
                }
                "getInitialRide" -> {
                    val rideData = intent.getStringExtra("rideData")
                    result.success(rideData)
                }
                "checkOverlayPermission" -> {
                    result.success(if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.M) {
                        Settings.canDrawOverlays(this)
                    } else {
                        true
                    })
                }
                "requestOverlayPermission" -> {
                    if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.M) {
                        val intent = Intent(
                            Settings.ACTION_MANAGE_OVERLAY_PERMISSION,
                            Uri.parse("package:$packageName")
                        )
                        startActivityForResult(intent, 1234)
                        result.success(true)
                    } else {
                        result.success(true)
                    }
                }
                "updateForegroundState" -> {
                    val isOpen = call.argument<Boolean>("isOpen") ?: false
                    LocationService.isAppInForeground = isOpen
                    Log.d("NativeLocation", "Explicit foreground state update: $isOpen")
                    result.success(true)
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }

    override fun onResume() {
        super.onResume()
        LocationService.isAppInForeground = true
        Log.d("NativeLocation", "MainActivity Resumed - App in foreground")
    }

    override fun onPause() {
        super.onPause()
        LocationService.isAppInForeground = false
        Log.d("NativeLocation", "MainActivity Paused - App in background")
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        setIntent(intent)
        val flutterEngine = flutterEngine
        if (flutterEngine != null) {
            handleIntent(intent, flutterEngine)
        }
    }

    private fun handleIntent(intent: Intent, flutterEngine: FlutterEngine) {
        if ("OPEN_RIDE_DETAILS" == intent.action) {
            val rideData = intent.getStringExtra("rideData")
            if (rideData != null) {
                MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
                    .invokeMethod("onRideRequestFromNotification", rideData)
            }
        }
    }
}
