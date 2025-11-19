package com.example.koma_app

import android.util.Log
import io.flutter.app.FlutterApplication
import com.wonderpush.sdk.WonderPush

class KomaApplication : FlutterApplication() {

    override fun onCreate() {
        super.onCreate()

        if (BuildConfig.DEBUG) {
            WonderPush.setLogging(true)
        }

        val clientId = BuildConfig.WONDERPUSH_CLIENT_ID
        val clientSecret = BuildConfig.WONDERPUSH_CLIENT_SECRET

        if (clientId.isBlank() || clientSecret.isBlank()) {
            Log.w("KomaApplication", "WonderPush credentials missing - push notifications disabled")
            return
        }

        WonderPush.initialize(this, clientId, clientSecret)
        WonderPush.subscribeToNotifications()
    }
}

