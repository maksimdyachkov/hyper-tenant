package com.example.hyper_tenant

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.Service
import android.content.Context
import android.content.Intent
import android.content.pm.ServiceInfo
import android.os.Build
import android.os.Handler
import android.os.IBinder
import android.os.Looper
import androidx.core.app.NotificationCompat
import androidx.core.app.ServiceCompat // UPDATED: backward-compatible stopForeground

class PaymentForegroundService : Service() {

    companion object {
        const val ACTION_START = "com.hypertenant.payment.START"
        const val ACTION_STOP = "com.hypertenant.payment.STOP"

        private const val CHANNEL_ID = "payment_processing_channel"
        private const val NOTIFICATION_ID = 1001
        private const val DONE_NOTIFICATION_ID = 1002 // UPDATED: standalone "Done" notification id
        private const val MAX_PROGRESS = 100
        private const val STEP = 4
        private const val TICK_MS = 500L
    }

    private val handler = Handler(Looper.getMainLooper())
    private var progress = 0

    private val tick = object : Runnable {
        override fun run() {
            if (progress <= MAX_PROGRESS) {
                updateNotification(progress)
                progress += STEP
                handler.postDelayed(this, TICK_MS)
            } else {
                showCompleted()
                stopSelf()
            }
        }
    }

    override fun onBind(intent: Intent?): IBinder? = null

    override fun onCreate() {
        super.onCreate()
        createNotificationChannel()
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        when (intent?.action) {
            ACTION_STOP -> stopProcessing()
            else -> startProcessing()
        }
        return START_NOT_STICKY
    }

    private fun startProcessing() {
        val notification = buildNotification(0)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.UPSIDE_DOWN_CAKE) {
            startForeground(
                NOTIFICATION_ID,
                notification,
                ServiceInfo.FOREGROUND_SERVICE_TYPE_SHORT_SERVICE
            )
        } else {
            startForeground(NOTIFICATION_ID, notification)
        }
        handler.removeCallbacks(tick)
        progress = 0
        handler.post(tick)
    }

    private fun stopProcessing() {
        handler.removeCallbacks(tick)
        ServiceCompat.stopForeground(this, ServiceCompat.STOP_FOREGROUND_REMOVE) // UPDATED
        stopSelf()
    }

    private fun createNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel(
                CHANNEL_ID,
                "Payment processing",
                NotificationManager.IMPORTANCE_LOW
            ).apply {
                description = "Shows payment processing progress"
                setSound(null, null)
            }
            getSystemService(NotificationManager::class.java)
                .createNotificationChannel(channel)
        }
    }

    private fun buildNotification(value: Int): Notification =
        NotificationCompat.Builder(this, CHANNEL_ID)
            .setContentTitle("Processing payment")
            .setContentText("$value%")
            .setSmallIcon(android.R.drawable.stat_sys_upload)
            .setOngoing(true)
            .setOnlyAlertOnce(true)
            .setProgress(MAX_PROGRESS, value, false)
            .setPriority(NotificationCompat.PRIORITY_MAX)
            .setForegroundServiceBehavior(NotificationCompat.FOREGROUND_SERVICE_IMMEDIATE)
            .build()

    private fun updateNotification(value: Int) {
        val manager = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        manager.notify(NOTIFICATION_ID, buildNotification(value))
    }

    private fun showCompleted() {
        val manager = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        val done = NotificationCompat.Builder(this, CHANNEL_ID)
            .setContentTitle("Payment processed")
            .setContentText("Done")
            .setSmallIcon(android.R.drawable.stat_sys_upload_done)
            .setOngoing(false)
            .setAutoCancel(true)
            .setProgress(0, 0, false)
            .build()

        ServiceCompat.stopForeground(this, ServiceCompat.STOP_FOREGROUND_REMOVE)
        manager.notify(DONE_NOTIFICATION_ID, done)
    }

    override fun onDestroy() {
        handler.removeCallbacks(tick)
        super.onDestroy()
    }
}