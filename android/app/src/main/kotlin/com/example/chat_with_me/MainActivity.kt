package com.example.chat_with_me

import android.content.Context
import android.os.Build
import android.os.VibrationEffect
import android.os.Vibrator
import android.os.VibratorManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.example.chat_with_me/native"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "isPowerSaveMode" -> {
                    val powerManager = getSystemService(Context.POWER_SERVICE) as? android.os.PowerManager
                    val isSaving = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
                        powerManager?.isPowerSaveMode ?: false
                    } else {
                        false
                    }
                    result.success(isSaving)
                }
                
                "vibrate" -> {
                    val duration = call.argument<Int>("duration") ?: 200
                    triggerVibration(duration)
                    result.success(null)
                }
                
                "getPlatformVersion" -> {
                    result.success("Android ${Build.VERSION.RELEASE}")
                }
                
                else -> {
                    result.notImplemented()
                }
            }
        }
    }

    private fun triggerVibration(duration: Int) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            // Android 12+ использует VibratorManager
            val vibratorManager = getSystemService(Context.VIBRATOR_SERVICE) as? VibratorManager
            vibratorManager?.defaultVibrator?.vibrate(
                VibrationEffect.createOneShot(duration.toLong(), VibrationEffect.DEFAULT_AMPLITUDE)
            )
        } else {
            // Android 11 и ниже
            @Suppress("DEPRECATION")
            val vibrator = getSystemService(Context.VIBRATOR_SERVICE) as? Vibrator
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                vibrator?.vibrate(VibrationEffect.createOneShot(duration.toLong(), VibrationEffect.DEFAULT_AMPLITUDE))
            } else {
                @Suppress("DEPRECATION")
                vibrator?.vibrate(duration.toLong())
            }
        }
    }
}