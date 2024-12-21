package com.kasun.cookie_clicker

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.Intent
import android.widget.RemoteViews

/**
 * Implementation of App Widget functionality.
 */
class CookieEmpireWidget : AppWidgetProvider() {

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        // Loop through all widget instances and update them
        for (appWidgetId in appWidgetIds) {
            appWidgetId.updateAppWidget(context, appWidgetManager)
        }
    }

    override fun onEnabled(context: Context) {
        // First widget created - enter relevant functionality
    }

    override fun onDisabled(context: Context) {
        // Last widget destroyed - clean up functionality
    }

    private fun Int.updateAppWidget(
        context: Context,
        appWidgetManager: AppWidgetManager
    ) {
        // Get the cookie count and production rate (You can get these from shared preferences or a database)
        val cookies = 1234 // Example cookie count
        val productionRate = 5.6 // Example production rate (cookies per second)

        // Construct the RemoteViews object to update the widget's UI
        val views = RemoteViews(context.packageName, R.layout.cookie_empire_widget)

        // Set the cookie count and production rate
        views.setTextViewText(R.id.cookie_count, cookies.toString())
        views.setTextViewText(R.id.production_rate, "$productionRate/s")

        // Set a click action for the "Tap" button
        val intent = Intent(context, MainActivity::class.java) // This would open your app
        val pendingIntent = PendingIntent.getActivity(context, 0, intent, PendingIntent.FLAG_UPDATE_CURRENT)
        views.setOnClickPendingIntent(R.id.action_button, pendingIntent)

        // Instruct the widget manager to update the widget
        appWidgetManager.updateAppWidget(this, views)

        // Optionally, update Home Widget plugin
        appWidgetManager.updateAppWidget(this, views)
    }
}
