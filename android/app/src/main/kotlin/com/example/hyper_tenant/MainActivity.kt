package com.example.hyper_tenant

import android.Manifest
import android.content.Intent
import android.content.pm.PackageManager
import android.os.Build
import android.view.WindowManager
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel
import java.io.File

class MainActivity : FlutterActivity() {

    private val securityChannel = "com.hypertenant/security"
    private val paymentChannel = "com.hypertenant/payment_service"
    private val screenRecordingChannel = "com.hypertenant/screen_recording"

    companion object {
        private const val REQ_POST_NOTIFICATIONS = 9001
    }

    // UPDATED: hold the pending channel result until the permission dialog returns
    private var pendingPermissionResult: MethodChannel.Result? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        val messenger = flutterEngine.dartExecutor.binaryMessenger

        MethodChannel(messenger, securityChannel).setMethodCallHandler { call, result ->
            when (call.method) {
                "isRooted" -> result.success(isDeviceRooted())
                "enableSecure" -> {
                    runOnUiThread {
                        window.addFlags(WindowManager.LayoutParams.FLAG_SECURE)
                    }
                    result.success(null)
                }
                "disableSecure" -> {
                    runOnUiThread {
                        window.clearFlags(WindowManager.LayoutParams.FLAG_SECURE)
                    }
                    result.success(null)
                }
                else -> result.notImplemented()
            }
        }

        MethodChannel(messenger, paymentChannel).setMethodCallHandler { call, result ->
            when (call.method) {
                // UPDATED: reply asynchronously after the user answers the dialog
                "requestNotificationPermission" -> requestNotificationPermission(result)
                "start" -> {
                    val intent = Intent(this, PaymentForegroundService::class.java)
                        .setAction(PaymentForegroundService.ACTION_START)
                    ContextCompat.startForegroundService(this, intent)
                    result.success(null)
                }
                "stop" -> {
                    val intent = Intent(this, PaymentForegroundService::class.java)
                        .setAction(PaymentForegroundService.ACTION_STOP)
                    startService(intent)
                    result.success(null)
                }
                else -> result.notImplemented()
            }
        }

        EventChannel(messenger, screenRecordingChannel).setStreamHandler(
            object : EventChannel.StreamHandler {
                private var callback: java.util.function.Consumer<Int>? = null

                override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                    // addScreenRecordingCallback exists only on Android 15 (API 35).
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.VANILLA_ICE_CREAM) {
                        val cb = java.util.function.Consumer<Int> { state ->
                            events?.success(state == WindowManager.SCREEN_RECORDING_STATE_VISIBLE)
                        }
                        callback = cb
                        // returns the current state immediately, then fires on changes
                        val current = windowManager.addScreenRecordingCallback(mainExecutor, cb)
                        events?.success(current == WindowManager.SCREEN_RECORDING_STATE_VISIBLE)
                    } else {
                        events?.success(false) // detection unavailable below API 35
                    }
                }

                override fun onCancel(arguments: Any?) {
                    val cb = callback ?: return
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.VANILLA_ICE_CREAM) {
                        windowManager.removeScreenRecordingCallback(cb)
                    }
                    callback = null
                }
            }
        )

    }




    private fun requestNotificationPermission(result: MethodChannel.Result) {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.TIRAMISU) {
            result.success(true)
            return
        }
        val granted = ContextCompat.checkSelfPermission(
            this, Manifest.permission.POST_NOTIFICATIONS
        ) == PackageManager.PERMISSION_GRANTED
        if (granted) {
            result.success(true)
            return
        }
        pendingPermissionResult = result
        ActivityCompat.requestPermissions(
            this,
            arrayOf(Manifest.permission.POST_NOTIFICATIONS),
            REQ_POST_NOTIFICATIONS
        )
    }

    // UPDATED: deliver the permission outcome back to the waiting Flutter call
    override fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<out String>,
        grantResults: IntArray
    ) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
        if (requestCode == REQ_POST_NOTIFICATIONS) {
            val granted = grantResults.isNotEmpty() &&
                    grantResults[0] == PackageManager.PERMISSION_GRANTED
            pendingPermissionResult?.success(granted)
            pendingPermissionResult = null
        }
    }

    private fun isDeviceRooted(): Boolean =
        hasTestKeys() || hasSuBinary() || hasRootApps() || canExecuteWhichSu()

    private fun hasTestKeys(): Boolean =
        Build.TAGS?.contains("test-keys") == true

    private fun hasSuBinary(): Boolean {
        val paths = listOf(
            "/system/bin/su", "/system/xbin/su", "/sbin/su", "/system/su",
            "/system/bin/.ext/.su", "/system/usr/we-need-root/su-backup",
            "/data/local/xbin/su", "/data/local/bin/su", "/data/local/su",
            "/su/bin/su", "/system/app/Superuser.apk", "/cache/su", "/dev/su"
        )
        return paths.any { File(it).exists() }
    }

    private fun hasRootApps(): Boolean {
        val packages = listOf(
            "com.topjohnwu.magisk",
            "eu.chainfire.supersu",
            "com.noshufou.android.su",
            "com.koushikdutta.superuser",
            "com.thirdparty.superuser"
        )
        return packages.any { pkg ->
            try {
                packageManager.getPackageInfo(pkg, 0); true
            } catch (e: Exception) {
                false
            }
        }
    }

    private fun canExecuteWhichSu(): Boolean = try {
        val process = Runtime.getRuntime().exec(arrayOf("which", "su"))
        val found = process.inputStream.bufferedReader().readLine() != null
        process.destroy()
        found
    } catch (e: Exception) {
        false
    }
}