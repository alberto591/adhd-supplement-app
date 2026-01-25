import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:adhd_supplement_app/infrastructure/services/notification_service.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

@GenerateNiceMocks([
  MockSpec<FlutterLocalNotificationsPlugin>(),
  MockSpec<AndroidFlutterLocalNotificationsPlugin>(),
  MockSpec<AndroidNotificationDetails>(),
  MockSpec<NotificationDetails>(),
])
import 'notification_service_slots_test.mocks.dart';

void main() {
  late NotificationService notificationService;
  late MockFlutterLocalNotificationsPlugin mockNotificationsPlugin;

  setUp(() {
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('UTC'));
    mockNotificationsPlugin = MockFlutterLocalNotificationsPlugin();
    notificationService = NotificationService(plugin: mockNotificationsPlugin);
  });

  group('NotificationSlot', () {
    test('baseIds are correct', () {
      expect(NotificationSlot.morning.baseId, 1000);
      expect(NotificationSlot.afternoon.baseId, 2000);
      expect(NotificationSlot.evening.baseId, 3000);
      expect(NotificationSlot.night.baseId, 4000);
    });
  });

  group('scheduleRecurringNudgeSequence', () {
    test('schedules correct IDs for Morning slot', () async {
      when(mockNotificationsPlugin.zonedSchedule(
        any,
        any,
        any,
        any,
        any,
        androidScheduleMode: anyNamed('androidScheduleMode'),
        uiLocalNotificationDateInterpretation:
            anyNamed('uiLocalNotificationDateInterpretation'),
        matchDateTimeComponents: anyNamed('matchDateTimeComponents'),
      )).thenAnswer((_) async {});

      await notificationService.scheduleRecurringNudgeSequence(
        slot: NotificationSlot.morning,
        title: 'Morning Nudge',
        body: 'Body',
        hour: 8,
        minute: 0,
        mode: NotificationMode.gentle,
      );

      // Verify gentle: 0, 15, 30 mins
      // Base ID 1000
      verify(mockNotificationsPlugin.zonedSchedule(
        1000,
        any,
        any,
        any,
        any,
        androidScheduleMode: anyNamed('androidScheduleMode'),
        uiLocalNotificationDateInterpretation:
            anyNamed('uiLocalNotificationDateInterpretation'),
        matchDateTimeComponents: anyNamed('matchDateTimeComponents'),
      )).called(1);

      verify(mockNotificationsPlugin.zonedSchedule(
        1001,
        any,
        any,
        any,
        any,
        androidScheduleMode: anyNamed('androidScheduleMode'),
        uiLocalNotificationDateInterpretation:
            anyNamed('uiLocalNotificationDateInterpretation'),
        matchDateTimeComponents: anyNamed('matchDateTimeComponents'),
      )).called(1);

      verify(mockNotificationsPlugin.zonedSchedule(
        1002,
        any,
        any,
        any,
        any,
        androidScheduleMode: anyNamed('androidScheduleMode'),
        uiLocalNotificationDateInterpretation:
            anyNamed('uiLocalNotificationDateInterpretation'),
        matchDateTimeComponents: anyNamed('matchDateTimeComponents'),
      )).called(1);
    });

    test('schedules correct IDs for Evening slot', () async {
      when(mockNotificationsPlugin.zonedSchedule(
        any,
        any,
        any,
        any,
        any,
        androidScheduleMode: anyNamed('androidScheduleMode'),
        uiLocalNotificationDateInterpretation:
            anyNamed('uiLocalNotificationDateInterpretation'),
        matchDateTimeComponents: anyNamed('matchDateTimeComponents'),
      )).thenAnswer((_) async {});

      await notificationService.scheduleRecurringNudgeSequence(
        slot: NotificationSlot.evening,
        title: 'Evening Nudge',
        body: 'Body',
        hour: 18,
        minute: 0,
        mode: NotificationMode.gentle,
      );

      // Base ID 3000
      verify(mockNotificationsPlugin.zonedSchedule(
        3000,
        any,
        any,
        any,
        any,
        androidScheduleMode: anyNamed('androidScheduleMode'),
        uiLocalNotificationDateInterpretation:
            anyNamed('uiLocalNotificationDateInterpretation'),
        matchDateTimeComponents: anyNamed('matchDateTimeComponents'),
      )).called(1);
    });
  });
}
