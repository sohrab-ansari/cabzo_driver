package com.nzcu_driver

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.os.Build
import android.os.Bundle
import android.util.Log
import android.view.WindowManager
import android.widget.Button
import android.widget.ImageView
import android.widget.TextView
import androidx.appcompat.app.AppCompatActivity
import org.json.JSONObject

class RideRequestActivity : AppCompatActivity() {

    private var rideData: JSONObject? = null
    private val TAG = "RideRequestActivity"

    private val cancellationReceiver = object : BroadcastReceiver() {
        override fun onReceive(context: Context?, intent: Intent?) {
            if (intent?.action == "RIDE_CANCELLED") {
                Log.d(TAG, "Ride cancelled by user, closing activity")
                finish()
            }
        }
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        Log.d(TAG, "🚀 onCreate - RideRequestActivity")
        
        try {
            setupWindow()
            setContentView(R.layout.activity_ride_request)
            Log.d(TAG, "✅ Layout inflated successfully")
        } catch (e: Exception) {
            Log.e(TAG, "❌ Error during layout inflation: ${e.message}")
            e.printStackTrace()
            finish()
            return
        }

        val rideDataStr = intent.getStringExtra("rideData")
        Log.d(TAG, "📦 Received rideData: ${rideDataStr?.take(100)}...")
        
        if (rideDataStr != null) {
            try {
                rideData = JSONObject(rideDataStr)
                setupUI()
                Log.d(TAG, "✅ UI Setup complete")
            } catch (e: Exception) {
                Log.e(TAG, "❌ Error parsing ride data: ${e.message}")
                finish()
            }
        } else {
            Log.w(TAG, "⚠️ No rideData in intent, finishing")
            finish()
        }

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            registerReceiver(cancellationReceiver, IntentFilter("RIDE_CANCELLED"), Context.RECEIVER_NOT_EXPORTED)
        } else {
            @Suppress("UnspecifiedRegisterReceiverFlag")
            registerReceiver(cancellationReceiver, IntentFilter("RIDE_CANCELLED"))
        }
    }

    override fun onStart() {
        super.onStart()
        Log.d(TAG, "🏁 onStart")
    }

    override fun onResume() {
        super.onResume()
        Log.d(TAG, "▶️ onResume")
    }

    override fun onPause() {
        super.onPause()
        Log.d(TAG, "⏸️ onPause")
    }

    override fun onStop() {
        super.onStop()
        Log.d(TAG, "⏹️ onStop")
    }

    private fun setupWindow() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O_MR1) {
            setShowWhenLocked(true)
            setTurnScreenOn(true)
        } else {
            @Suppress("DEPRECATION")
            window.addFlags(
                WindowManager.LayoutParams.FLAG_SHOW_WHEN_LOCKED or
                        WindowManager.LayoutParams.FLAG_DISMISS_KEYGUARD or
                        WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON or
                        WindowManager.LayoutParams.FLAG_TURN_SCREEN_ON
            )
        }
        
        // Ensure the activity fills the screen but background is transparent
        window.setLayout(WindowManager.LayoutParams.MATCH_PARENT, WindowManager.LayoutParams.MATCH_PARENT)
    }

    private fun setupUI() {
        val riderNameTxt = findViewById<TextView>(R.id.riderName)
        val pickupAddressTxt = findViewById<TextView>(R.id.pickupAddress)
        val dropoffAddressTxt = findViewById<TextView>(R.id.dropoffAddress)
        val rideFareTxt = findViewById<TextView>(R.id.rideFare)
        val rideTypeTxt = findViewById<TextView>(R.id.rideType)
        val btnAccept = findViewById<Button>(R.id.btnAccept)
        val btnDecline = findViewById<Button>(R.id.btnDecline)

        rideData?.let { data ->
            val userId = data.optJSONObject("userId")
            riderNameTxt.text = userId?.optString("name", "New Rider") ?: data.optString("riderName", "New Rider")
            
            val startLocation = data.optJSONObject("startLocation")
            pickupAddressTxt.text = startLocation?.optString("address", "Pickup Location") ?: data.optString("pickupLocation", "Pickup Location")
            
            val endLocation = data.optJSONObject("endLocation")
            dropoffAddressTxt.text = endLocation?.optString("address", "Drop Location") ?: data.optString("dropLocation", "Drop Location")
            
            val fare = data.optString("totalFare", data.optString("amount", "0.0"))
            rideFareTxt.text = "₹ $fare"
            
            rideTypeTxt.text = data.optString("vehicleType", "Standard")
        }

        btnAccept.setOnClickListener { handleAccept() }
        btnDecline.setOnClickListener { handleDecline() }
        
        findViewById<android.view.View>(R.id.rideRequestParent).setOnClickListener {
            // Senior tip: Don't dismiss if they click background, force a choice
        }
    }

    private fun handleAccept() {
        Log.d(TAG, "✅ User clicked ACCEPT button")
        val serviceIntent = Intent(this, LocationService::class.java).apply {
            action = "ACCEPT_RIDE"
            putExtra("rideData", rideData.toString())
        }
        startService(serviceIntent)

        // Bring the app to the foreground
        val mainIntent = Intent(this, MainActivity::class.java).apply {
            putExtra("rideData", rideData.toString())
            action = "OPEN_RIDE_DETAILS"
            addFlags(Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP)
        }
        startActivity(mainIntent)

        finish()
    }

    private fun handleDecline() {
        Log.d(TAG, "❌ User clicked DECLINE button")
        val serviceIntent = Intent(this, LocationService::class.java).apply {
            action = "DECLINE_RIDE"
            putExtra("rideData", rideData.toString())
        }
        startService(serviceIntent)
        finish()
    }

    override fun finish() {
        super.finish()
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.UPSIDE_DOWN_CAKE) {
            overrideActivityTransition(OVERRIDE_TRANSITION_CLOSE, 0, R.anim.fade_out)
        } else {
            @Suppress("DEPRECATION")
            overridePendingTransition(0, R.anim.fade_out)
        }
    }

    override fun onDestroy() {
        super.onDestroy()
        try {
            unregisterReceiver(cancellationReceiver)
        } catch (e: Exception) {
            // Already unregistered or not registered
        }
    }
}
