package com.modelcost.modelcost_monitor

import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetPlugin

class ModelCostWidgetReceiver : AppWidgetProvider() {
    
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        for (appWidgetId in appWidgetIds) {
            val widgetData = HomeWidgetPlugin.getData(context)
            val views = RemoteViews(context.packageName, R.layout.widget_modelcost_monitor)
            
            val todayCost = widgetData.getString("today_cost", "$0.0000")
            val monthCost = widgetData.getString("month_cost", "$0.0000")
            val proxyState = widgetData.getString("proxy_state", "Stopped")
            val proxyUrl = widgetData.getString("proxy_url", "http://127.0.0.1:8787")
            
            views.setTextViewText(R.id.widget_today_cost, todayCost)
            views.setTextViewText(R.id.widget_month_cost, monthCost)
            views.setTextViewText(R.id.widget_status, proxyState)
            views.setTextViewText(R.id.widget_proxy_url, proxyUrl)
            
            val statusColor = when (proxyState) {
                "Running" -> android.graphics.Color.GREEN
                "Degraded" -> android.graphics.Color.YELLOW
                "Crashed" -> android.graphics.Color.RED
                else -> android.graphics.Color.GRAY
            }
            views.setInt(R.id.widget_status_indicator, "setBackgroundColor", statusColor)
            
            appWidgetManager.updateAppWidget(appWidgetId, views)
        }
    }
}
