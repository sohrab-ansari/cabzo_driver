package com.nzcu_driver

import android.app.NotificationChannel
import android.app.NotificationManager
import android.os.Build
import io.flutter.app.FlutterApplication

/**
 * Custom Application class — creates all notification channels in onCreate()
 * so they exist before any Service calls startForeground().
 */
class NZCUApplication : FlutterApplication() {
    override fun onCreate() {
        super.onCreate()
        createNotificationChannels()
    }

    private fun createNotificationChannels() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val manager = getSystemService(NotificationManager::class.java)

            // 1. Status channel — low priority, ongoing notification
            val statusChannel = NotificationChannel(
                SocketForegroundService.STATUS_CHANNEL_ID,
                "NZCU Driver Service",
                NotificationManager.IMPORTANCE_LOW
            ).apply {
                description = "Shows when driver is online"
                setShowBadge(false)
                enableVibration(false)
                setSound(null, null)
            }
            manager.createNotificationChannel(statusChannel)

            // 2. Ride request channel — high priority, heads-up notification
            val rideChannel = NotificationChannel(
                SocketForegroundService.RIDE_CHANNEL_ID,
                "Ride Requests",
                NotificationManager.IMPORTANCE_HIGH
            ).apply {
                description = "New ride request alerts"
                setShowBadge(true)
                enableVibration(true)
                enableLights(true)
                lockscreenVisibility = android.app.Notification.VISIBILITY_PUBLIC
            }
            manager.createNotificationChannel(rideChannel)

            // 3. Background service channel (kept for flutter_background_service compatibility)
            val bgChannel = NotificationChannel(
                "nzcu_bg_service_channel",
                "Background Service",
                NotificationManager.IMPORTANCE_LOW
            ).apply {
                description = "Background service notification"
                setShowBadge(false)
                enableVibration(false)
                setSound(null, null)
            }
            manager.createNotificationChannel(bgChannel)
        }
    }
}
