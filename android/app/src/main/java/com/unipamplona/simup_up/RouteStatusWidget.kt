package com.unipamplona.simup_up

import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetPlugin

/**
 * Implementation of App Widget functionality.
 */
class RouteStatusWidget : AppWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        for (appWidgetId in appWidgetIds) {
            val widgetData = HomeWidgetPlugin.getData(context)
            val views = RemoteViews(context.packageName, R.layout.route_status_widget)
            val icon = widgetData.getString("icon", "")
            val label = widgetData.getString("label", "")
            val title = widgetData.getString("title", "")
            views.setImageViewResource(R.id.status_icon, R.drawable.bus_icon)
            views.setTextViewText(R.id.status_label, label)
            views.setTextViewText(R.id.status_title, title)
            appWidgetManager.updateAppWidget(appWidgetId, views)
        }
    }

    override fun onEnabled(context: Context) {
        // Enter relevant functionality for when the first widget is created
    }

    override fun onDisabled(context: Context) {
        // Enter relevant functionality for when the last widget is disabled
    }
}

//internal fun updateAppWidget(
//    context: Context,
//    appWidgetManager: AppWidgetManager,
//    appWidgetId: Int
//) {
//    val widgetText = context.getString(R.string.status_label)
//    // Construct the RemoteViews object
//    val views = RemoteViews(context.packageName, R.layout.route_status_widget)
//    views.setTextViewText(R.id.status_label, widgetText)
//
//    // Instruct the widget manager to update the widget
//    appWidgetManager.updateAppWidget(appWidgetId, views)
//}