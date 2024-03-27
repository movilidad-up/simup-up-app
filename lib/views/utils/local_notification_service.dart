import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:timezone/timezone.dart' as tz;

class LocalNotificationService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_notification');

    const InitializationSettings initializationSettings =
    InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );
  }

  Future<void> showNotification(String title, String description) async {
    const AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails(
      'channel_callout',
      'SIMUP Callout Channel',
      channelDescription: 'Channel Description',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );

    int notificationId = DateTime.now().millisecondsSinceEpoch ~/ 1000;

    const NotificationDetails notificationDetails =
    NotificationDetails(android: androidNotificationDetails);

    await flutterLocalNotificationsPlugin.show(
      notificationId,
      title,
      description,
      notificationDetails,
      payload: 'Not present',
    );
  }

  Future<int> scheduleNotification({
    String numberOfTasks = "",
    String description = "",
    int reminderId = 0,
    required String title,
    required int scheduledHours,
    required int scheduledMinutes,
    required List<int> repeatDays, // List of days to repeat (e.g., DateTime.monday, DateTime.tuesday, etc.)
  }) async {
    int notificationId = DateTime.now().millisecondsSinceEpoch ~/ 1000;

    tz.Location local = tz.local;
    tz.TZDateTime now = tz.TZDateTime.now(local);
    tz.TZDateTime scheduledTime = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      scheduledHours,
      scheduledMinutes,
    );

    // If it's already past the scheduled time today, schedule for tomorrow
    if (DateTime.now().hour >= scheduledHours) {
      scheduledTime = scheduledTime.add(const Duration(days: 1));
    }

    // Ensure the scheduled time is in the future
    if (scheduledTime.isBefore(now)) {
      scheduledTime = scheduledTime.add(const Duration(days: 1));
    }

    // Create a Set containing the days of the week to repeat
    Set<int> daysOfWeek = {};
    repeatDays.forEach((day) {
      daysOfWeek.add(day % 7); // Ensure the day is within 0-6 (Sunday-Saturday)
    });

    await flutterLocalNotificationsPlugin.zonedSchedule(
      notificationId,
      title,
      description,
      scheduledTime,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'channel-daily-summary',
          'Daily Summary Channel',
          channelDescription: 'Channel for Daily Task Summary',
          icon: "@mipmap/ic_notification",
          playSound: true,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
      payload: 'custom data'
    );

    return notificationId;
  }

  Future<void> cancelNotification(int reminderId) async {
    await flutterLocalNotificationsPlugin.cancel(reminderId);
  }
}
