package com.modelcost.modelcost_monitor

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent

class ProxyServiceReceiver : BroadcastReceiver() {
    
    override fun onReceive(context: Context?, intent: Intent?) {
        when (intent?.action) {
            ProxyForegroundService.ACTION_STOP -> {
                val stopIntent = Intent(context, ProxyForegroundService::class.java).apply {
                    action = ProxyForegroundService.ACTION_STOP
                }
                context?.startService(stopIntent)
            }
        }
    }
}
