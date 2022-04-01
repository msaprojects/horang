package com.cvdtc.horang

import io.flutter.app.FlutterApplication
import io.flutter.plugin.common.PluginRegistry
import io.flutter.plugin.common.PluginRegistry.PluginRegistrantCallback
import io.flutter.view.FlutterMain
import io.flutter.plugins.firebase.messaging.FlutterFirebaseMessagingBackgroundService;

class Application : FlutterApplication(), PluginRegistrantCallback {

    override fun onCreate() {
        super.onCreate()
        FlutterMain.startInitialization(this)
    }

    override fun registerWith(registry: PluginRegistry?) {
    }
}

