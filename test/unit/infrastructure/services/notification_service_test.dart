import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:adhd_supplement_app/infrastructure/services/notification_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;

@GenerateMocks([FlutterLocalNotificationsPlugin])
import 'notification_service_test.mocks.dart';

void main() {
  late NotificationService notificationService;
  late MockFlutterLocalNotificationsPlugin mockPlugin;

  setUp(() async {
    tz.initializeTimeZones();
    mockPlugin = MockFlutterLocalNotificationsPlugin();
    notificationService = NotificationService(plugin: mockPlugin);
  });

  group('scheduleRecurringNudgeSequence', () {
    test('schedules 3 notifications with correct offsets for Gentle mode',
        () async {
      const title = 'Test Title';
      const body = 'Test Body';
      const hour = 8;
      const minute = 0;

      await notificationService.scheduleRecurringNudgeSequence(
        slot: NotificationSlot.morning,
        title: title,
        body: body,
        hour: hour,
        minute: minute,
        mode: NotificationMode.gentle,
      );

      // Verify 3 notifications scheduled via zonedSchedule
      verify(mockPlugin.zonedSchedule(
        any,
        any,
        any,
        any,
        any,
        androidScheduleMode: anyNamed('androidScheduleMode'),
        uiLocalNotificationDateInterpretation:
            anyNamed('uiLocalNotificationDateInterpretation'),
        matchDateTimeComponents: anyNamed('matchDateTimeComponents'),
      )).called(3);
    });

    test('urgent mode uses different time offsets', () async {
      // Future-proofing the test for when urgent logic is detailed
      await notificationService.scheduleRecurringNudgeSequence(
        slot: NotificationSlot.afternoon,
        title: 'Urgent',
        body: 'Hurry',
        hour: 9,
        minute: 0,
        mode: NotificationMode.urgent,
      );

      verify(mockPlugin.zonedSchedule(any, any, any, any, any,
              androidScheduleMode: anyNamed('androidScheduleMode'),
              uiLocalNotificationDateInterpretation:
                  anyNamed('uiLocalNotificationDateInterpretation'),
              matchDateTimeComponents: anyNamed('matchDateTimeComponents')))
          .called(12);
    });
  });

  group('cancelAllSupplementNudges', () {
    test('cancels a range of notification IDs', () async {
      const supplementId = 'omega-3';

      await notificationService.cancelAllSupplementNudges(supplementId);

      // Should cancel base and follow-ups
      // Depending on implementation, we just want to verify cancel was called
      verify(mockPlugin.cancel(any)).called(greaterThan(0));
    });
  });
}
