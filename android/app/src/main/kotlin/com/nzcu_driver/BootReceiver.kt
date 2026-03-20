package com.nzcu_driver

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.os.Build
import android.util.Log

/**
 * Restarts the SocketForegroundService after device reboot if the driver
 * was online when the device shut down. Critical for OPPO/Realme/OnePlus
 * devices that kill all services on reboot.
 */
class BootReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        if (intent.action != Intent.ACTION_BOOT_COMPLETED) return

        val prefs = context.getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE)
        val wasOnline = prefs.getBoolean("flutter.driver_is_online", false)

        Log.i("BootReceiver", "Device booted. Driver was online: $wasOnline")

        if (wasOnline) {
            val serviceIntent = Intent(context, SocketForegroundService::class.java)
            try {
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                    context.startForegroundService(serviceIntent)
                } else {
                    context.startService(serviceIntent)
                }
                Log.i("BootReceiver", "SocketForegroundService restarted after boot")
            } catch (e: Exception) {
                Log.e("BootReceiver", "Failed to restart service: ${e.message}")
            }
        }
    }
}
