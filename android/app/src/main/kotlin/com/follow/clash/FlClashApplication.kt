package com.follow.clash;

import android.app.Application
import android.content.Context

class FlowvyApplication : Application() {
    companion object {
        private lateinit var instance: FlowvyApplication
        fun getAppContext(): Context {
            return instance.applicationContext
        }
    }

    override fun onCreate() {
        super.onCreate()
        instance = this
    }
}
