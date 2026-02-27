package com.nzcu_driver

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.Service
import android.content.Context
import android.content.Intent
import android.os.Build
import android.os.IBinder
import android.os.PowerManager
import android.net.wifi.WifiManager
import androidx.core.app.NotificationCompat

class ForegroundService : Service() {
    private val CHANNEL_ID = "nzcu_driver_foreground_service"
    private var wakeLock: PowerManager.WakeLock? = null
    private var wifiLock: WifiManager.WifiLock? = null

    override fun onCreate() {
        super.onCreate()
        createNotificationChannel()
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        val action = intent?.getStringExtra("action")

        if (action == "stop") {
            stopForegroundService()
            return START_NOT_STICKY
        }

        val title = intent?.getStringExtra("title") ?: "NZCU Driver — Online"
        val body = intent?.getStringExtra("body") ?: "You are online and ready for ride requests."

        if (action == "update") {
             updateNotification(title, body)
             return START_STICKY
        }

        startForeground(1, createNotification(title, body))
        acquireLocks()

        return START_STICKY
    }

    private fun acquireLocks() {
        if (wakeLock == null) {
            val powerManager = getSystemService(Context.POWER_SERVICE) as PowerManager
            wakeLock = powerManager.newWakeLock(PowerManager.PARTIAL_WAKE_LOCK, "NZCUDriver::WakeLock")
            wakeLock?.acquire()
        }
        
        if (wifiLock == null) {
             val wifiManager = applicationContext.getSystemService(Context.WIFI_SERVICE) as WifiManager
             wifiLock = wifiManager.createWifiLock(WifiManager.WIFI_MODE_FULL_HIGH_PERF, "NZCUDriver::WifiLock")
             wifiLock?.acquire()
        }
    }

    private fun releaseLocks() {
        try {
            wakeLock?.let {
                if (it.isHeld) it.release()
            }
            wakeLock = null
            
            wifiLock?.let {
                 if (it.isHeld) it.release()
            }
            wifiLock = null
        } catch (e: Exception) {
            // Ignore errors releasing locks
        }
    }

    private fun stopForegroundService() {
        releaseLocks()
        stopForeground(true)
        stopSelf()
    }

    override fun onDestroy() {
        super.onDestroy()
        releaseLocks()
    }

    override fun onBind(intent: Intent?): IBinder? {
        return null
    }

    private fun createNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val serviceChannel = NotificationChannel(
                CHANNEL_ID,
                "NZCU Driver Background Service",
                NotificationManager.IMPORTANCE_LOW
            )
            val manager = getSystemService(NotificationManager::class.java)
            manager.createNotificationChannel(serviceChannel)
        }
    }

    private fun createNotification(title: String, body: String): Notification {
        return NotificationCompat.Builder(this, CHANNEL_ID)
            .setContentTitle(title)
            .setContentText(body)
            .setSmallIcon(R.mipmap.ic_launcher) 
            .setOngoing(true)
            .build()
    }
    
    private fun updateNotification(title: String, body: String) {
        val notification = createNotification(title, body)
        val mNotificationManager = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        mNotificationManager.notify(1, notification)
    }
    override fun onTaskRemoved(rootIntent: Intent?) {
        super.onTaskRemoved(rootIntent)
        println("❌ Task Removed (App Swiped Away)")

        val restartIntent = Intent(applicationContext, MainActivity::class.java)
        restartIntent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)

        val notification = NotificationCompat.Builder(this, CHANNEL_ID)
            .setContentTitle("NZCU Driver — App Killed")
            .setContentText("Tap to restart app and reconnect.")
            .setSmallIcon(R.mipmap.ic_launcher)
            .setOngoing(true)
            .setContentIntent(android.app.PendingIntent.getActivity(
                this, 0, restartIntent, android.app.PendingIntent.FLAG_IMMUTABLE or android.app.PendingIntent.FLAG_UPDATE_CURRENT
            ))
            .build()
        
        val manager = getSystemService(NotificationManager::class.java)
        manager.notify(1, notification)
    }
}
