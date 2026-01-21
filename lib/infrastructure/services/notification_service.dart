import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    // Initialize timezone data
    tz.initializeTimeZones();

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
      'adhd_channel',
      'ADHD Notifications',
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
      'adhd_channel',
      'ADHD Notifications',
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
      'adhd_channel',
      'ADHD Notifications',
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

  Future<void> cancelNotification(int id) async {
    await _notificationsPlugin.cancel(id);
  }

  Future<void> cancelAllNotifications() async {
    await _notificationsPlugin.cancelAll();
  }

  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    return await _notificationsPlugin.pendingNotificationRequests();
  }

  /// Schedule a sequence of 5-minute nudges for a specific stack/event
  /// [baseId] is used to generate a unique sequence (e.g., baseId, baseId+1, ...)
  Future<void> schedulePersistentNudge({
    required int baseId,
    required String title,
    required String body,
    required DateTime initialTime,
    int maxNudges = 12, // 1 hour total (12 * 5m)
  }) async {
    for (int i = 0; i < maxNudges; i++) {
      final nudgeTime = initialTime.add(Duration(minutes: i * 5));
      if (nudgeTime.isBefore(DateTime.now())) continue;

      await scheduleNotification(
        id: baseId + i,
        title: i == 0 ? title : '$title (Reminder $i)',
        body: body,
        scheduledDate: nudgeTime,
      );
    }
  }

  /// Snooze a persistent nudge by canceling current ones and rescheduling starting in 5m
  Future<void> snoozePersistentNudge({
    required int baseId,
    required String title,
    required String body,
    int maxNudges = 12,
  }) async {
    await cancelNudgeSequence(baseId, maxNudges);
    await schedulePersistentNudge(
      baseId: baseId,
      title: title,
      body: body,
      initialTime: DateTime.now().add(const Duration(minutes: 5)),
      maxNudges: maxNudges,
    );
  }

  /// Cancel all notifications in a nudge sequence
  Future<void> cancelNudgeSequence(int baseId, int count) async {
    for (int i = 0; i < count; i++) {
      await _notificationsPlugin.cancel(baseId + i);
    }
  }
}
