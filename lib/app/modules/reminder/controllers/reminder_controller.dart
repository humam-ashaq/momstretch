// reminder_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class ReminderController extends GetxController {
  final time = TimeOfDay(hour: 8, minute: 45).obs;
  final isEnabled = false.obs;
  final notifications = FlutterLocalNotificationsPlugin();

  @override
  void onInit() {
    super.onInit();
    _initializeNotification();
  }

  Future<void> _initializeNotification() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidSettings);
    await notifications.initialize(initSettings);
  }

  Future<void> scheduleDailyNotification() async {
    final selectedTime = time.value;
    final now = DateTime.now();
    final scheduledTime = DateTime(now.year, now.month, now.day, selectedTime.hour, selectedTime.minute);

    await notifications.zonedSchedule(
      0,
      'Jangan Lupa Stretching!',
      'Luangkan waktu sebentar untuk stretching hari ini.',
      _nextInstanceOfTime(selectedTime),
      const NotificationDetails(
        android: AndroidNotificationDetails('daily_notif', 'Daily Notification',
            importance: Importance.max, priority: Priority.high),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  tz.TZDateTime _nextInstanceOfTime(TimeOfDay tod) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(tz.local, now.year, now.month, now.day, tod.hour, tod.minute);
    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(Duration(days: 1));
    }
    return scheduled;
  }

  void updateTime(TimeOfDay newTime) {
    time.value = newTime;
    if (isEnabled.value) scheduleDailyNotification();
  }

  void toggleReminder(bool value) {
    isEnabled.value = value;
    if (value) {
      scheduleDailyNotification();
    } else {
      notifications.cancelAll();
    }
  }
}
