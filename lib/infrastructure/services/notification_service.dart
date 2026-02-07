import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' show Platform;

enum NotificationMode {
  persistent, // Aggressive: Every 5 mins for an hour
  gentle, // Inattentive-friendly: Every 15 mins (3 times)
  urgent, // New: Immediate feedback loop
}

enum NotificationSlot {
  morning,
  afternoon,
  evening,
  night;

  int get baseId {
    switch (this) {
      case NotificationSlot.morning:
        return 1000;
      case NotificationSlot.afternoon:
        return 2000;
      case NotificationSlot.evening:
        return 3000;
      case NotificationSlot.night:
        return 4000;
    }
  }
}

class NotificationService {
  final FlutterLocalNotificationsPlugin _notificationsPlugin;

  NotificationService({FlutterLocalNotificationsPlugin? plugin})
      : _notificationsPlugin = plugin ?? FlutterLocalNotificationsPlugin();

  Future<bool> checkExactAlarmPermission() async {
    if (kIsWeb || !Platform.isAndroid) return true;

    final androidImplementation =
        _notificationsPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    if (androidImplementation == null) return false;

    final bool? granted =
        await androidImplementation.canScheduleExactNotifications();
    return granted ?? false;
  }

  Future<bool> requestExactAlarmPermission() async {
    if (kIsWeb || !Platform.isAndroid) return true;

    final androidImplementation =
        _notificationsPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    if (androidImplementation == null) return false;

    // This typically opens the system "Alarms & Reminders" settings page for the app
    final bool? granted =
        await androidImplementation.requestExactAlarmsPermission();
    return granted ?? false;
  }

  Future<void> init() async {
    // Initialize timezone data
    tz_data.initializeTimeZones();
    await configureLocalTimezone();

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await _notificationsPlugin.initialize(initializationSettings);

    // Request permissions for Android 13+
    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'focus_channel',
      'Focus Notifications',
      channelDescription: 'Supplement reminders and notifications',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: DarwinNotificationDetails(),
    );

    await _notificationsPlugin.show(id, title, body, details);
  }

  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
  }) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'focus_channel',
      'Focus Notifications',
      channelDescription: 'Supplement reminders and notifications',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: DarwinNotificationDetails(),
    );

    await _notificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledDate, tz.local),
      details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  Future<void> scheduleRecurringNotification({
    required int id,
    required String title,
    required String body,
    required int hour,
    required int minute,
    int second = 0,
    bool startFromTomorrow = false,
  }) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'focus_channel',
      'Focus Notifications',
      channelDescription: 'Supplement reminders and notifications',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: DarwinNotificationDetails(),
    );

    // Schedule daily notification at specified time
    final now = tz.TZDateTime.now(tz.local);
    var scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
      second,
    );

    // If startFromTomorrow is true OR the scheduled time is in the past, schedule for tomorrow
    if (startFromTomorrow || scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    await _notificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      scheduledDate,
      details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  /// Schedules a sequence of recurring notifications based on the mode.
  /// [slot] determines the ID range (Morning=1000+, Afternoon=2000+, etc.)
  /// [hour] and [minute] define the start time.
  Future<void> scheduleRecurringNudgeSequence({
    required NotificationSlot slot,
    required String title,
    required String body,
    required int hour,
    required int minute,
    required NotificationMode mode,
  }) async {
    List<int> offsets;
    if (mode == NotificationMode.gentle) {
      // Gentle: 0, 15, 30 mins
      offsets = [0, 15, 30];
    } else {
      // Persistent: 0, 5, 10, ... 55 mins (12 times)
      offsets = List.generate(12, (index) => index * 5);
    }

    final baseId = slot.baseId;

    for (int i = 0; i < offsets.length; i++) {
      int offset = offsets[i];
      int nudgeHour = hour;
      int nudgeMinute = minute + offset;

      // Handle hour rollover
      if (nudgeMinute >= 60) {
        nudgeHour = (nudgeHour + (nudgeMinute ~/ 60)) % 24;
        nudgeMinute = nudgeMinute % 60;
      }

      String nudgeTitle = title;
      String nudgeBody = body;

      // Customize messages for sequence
      if (i > 0) {
        if (mode == NotificationMode.gentle) {
          nudgeTitle = 'Gentle Reminder: $title';
          nudgeBody = 'Have you had a chance to start? $body';
        } else {
          nudgeTitle = 'URGENT: $title';
          nudgeBody = 'Action Required! $body';
        }
      }

      await scheduleRecurringNotification(
        id: baseId + i,
        title: nudgeTitle,
        body: nudgeBody,
        hour: nudgeHour,
        minute: nudgeMinute,
      );
    }
  }

  Future<void> cancelNotification(int id) async {
    try {
      await _notificationsPlugin.cancel(id);
    } catch (e) {
      // Silent catch for platform-level cancellation errors
    }
  }

  Future<void> cancelAllNotifications() async {
    try {
      await _notificationsPlugin.cancelAll();
    } catch (e) {
      // Silent catch
    }
  }

  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    return await _notificationsPlugin.pendingNotificationRequests();
  }

  /// Internal helper to generate a safe 32-bit unique ID for a supplement's nudge sequence
  /// We use an offset of 5000 to avoid collisions with global reminders (1000-2999)
  int _getNudgeId(String supplementId, int index) {
    // Generate a stable base integer from the supplement ID string
    // Using a simple hash that fits in safe signed 32-bit integer range
    int hash = 0;
    for (int i = 0; i < supplementId.length; i++) {
      hash = 31 * hash + supplementId.codeUnitAt(i);
      hash = hash & 0x7FFFFFFF; // Maintain positive 31-bit range
    }

    // Final ID = RangeBase (5000) + (SuppHash MOD 1000000) * 20 (Max nudges space) + Index
    // This gives us space for ~100,000 unique supplements with 20 nudges each
    // while staying well under the 2.1B max for 32-bit ints.
    return 5000 + ((hash % 100000) * 20) + index;
  }

  /// Schedule a sequence of 5-minute nudges for a specific supplement
  Future<void> schedulePersistentNudge({
    required String supplementId,
    required String title,
    required String body,
    required DateTime initialTime,
    int maxNudges = 12, // 1 hour total (12 * 5m)
  }) async {
    for (int i = 0; i < maxNudges; i++) {
      final nudgeTime = initialTime.add(Duration(minutes: i * 5));
      if (nudgeTime.isBefore(DateTime.now())) continue;

      await scheduleNotification(
        id: _getNudgeId(supplementId, i),
        title: i == 0 ? title : '$title (Reminder $i)',
        body: body,
        scheduledDate: nudgeTime,
      );
    }
  }

  /// Snooze a persistent nudge by canceling current ones and rescheduling starting in 5m
  Future<void> snoozePersistentNudge({
    required String supplementId,
    required String title,
    required String body,
    int maxNudges = 12,
  }) async {
    await cancelAllSupplementNudges(supplementId, maxNudges);
    await schedulePersistentNudge(
      supplementId: supplementId,
      title: title,
      body: body,
      initialTime: DateTime.now().add(const Duration(minutes: 5)),
      maxNudges: maxNudges,
    );
  }

  /// Cancel all notifications in a nudge sequence for a specific supplement
  Future<void> cancelAllSupplementNudges(String supplementId,
      [int maxNudges = 12]) async {
    try {
      for (int i = 0; i < maxNudges; i++) {
        await _notificationsPlugin.cancel(_getNudgeId(supplementId, i));
      }
    } catch (e) {
      // Silent catch
    }
  }

  Future<void> configureLocalTimezone() async {
    try {
      // Dynamic handling to support different versions of flutter_timezone
      // Some versions return String, others return TimezoneInfo
      final dynamic result = await FlutterTimezone.getLocalTimezone();
      final String timeZoneName = result.toString();
      tz.setLocalLocation(tz.getLocation(timeZoneName));
    } catch (e) {
      // Fallback or log error
      try {
        tz.setLocalLocation(tz.getLocation('UTC'));
      } catch (_) {}
    }
  }
}
