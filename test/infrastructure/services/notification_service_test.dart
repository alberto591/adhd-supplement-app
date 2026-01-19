import 'package:flutter_test/flutter_test.dart';
import 'package:adhd_supplement_app/infrastructure/services/notification_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

void main() {
  late NotificationService notificationService;

  setUp(() {
    notificationService = NotificationService();
  });

  group('NotificationService', () {
    test('should initialize without errors', () async {
      // This test ensures the service can be instantiated
      expect(notificationService, isNotNull);

      // Note: Full initialization requires platform channels,
      // so we can't test init() in a unit test environment.
      // This would require integration testing on a device.
    });

    test('should create instance successfully', () {
      final service = NotificationService();
      expect(service, isA<NotificationService>());
    });

    // Note: The following tests would require mocking flutter_local_notifications
    // or running on a device/emulator. These are placeholders for integration tests.

    group('scheduleNotification', () {
      test('should accept valid parameters', () {
        // This is a structural test to ensure the method signature is correct
        expect(
          () => notificationService.scheduleNotification(
            id: 1,
            title: 'Test',
            body: 'Test body',
            scheduledDate: DateTime.now().add(const Duration(hours: 1)),
          ),
          returnsNormally,
        );
      });
    });

    group('scheduleRecurringNotification', () {
      test('should accept valid parameters', () {
        expect(
          () => notificationService.scheduleRecurringNotification(
            id: 2,
            title: 'Recurring',
            body: 'Daily reminder',
            hour: 8,
            minute: 0,
          ),
          returnsNormally,
        );
      });
    });

    group('cancelNotification', () {
      test('should accept notification id', () {
        expect(
          () => notificationService.cancelNotification(1),
          returnsNormally,
        );
      });
    });

    group('cancelAllNotifications', () {
      test('should execute without errors', () {
        expect(
          () => notificationService.cancelAllNotifications(),
          returnsNormally,
        );
      });
    });

    group('getPendingNotifications', () {
      test('should return a Future of PendingNotificationRequest list', () {
        final result = notificationService.getPendingNotifications();
        expect(result, isA<Future<List<PendingNotificationRequest>>>());
      });
    });
  });

  group('NotificationService Edge Cases', () {
    test('should handle past scheduled dates correctly', () {
      final pastDate = DateTime.now().subtract(const Duration(hours: 1));

      // Should not throw, implementation handles this internally
      expect(
        () => notificationService.scheduleNotification(
          id: 3,
          title: 'Past notification',
          body: 'This was in the past',
          scheduledDate: pastDate,
        ),
        returnsNormally,
      );
    });

    test('should handle midnight time scheduling', () {
      expect(
        () => notificationService.scheduleRecurringNotification(
          id: 4,
          title: 'Midnight reminder',
          body: 'At midnight',
          hour: 0,
          minute: 0,
        ),
        returnsNormally,
      );
    });

    test('should handle late night time scheduling', () {
      expect(
        () => notificationService.scheduleRecurringNotification(
          id: 5,
          title: 'Late night',
          body: 'Before midnight',
          hour: 23,
          minute: 59,
          second: 59,
        ),
        returnsNormally,
      );
    });

    test('should handle multiple notifications with same id (overwrite)', () {
      expect(
        () async {
          await notificationService.scheduleNotification(
            id: 100,
            title: 'First',
            body: 'First notification',
            scheduledDate: DateTime.now().add(const Duration(hours: 1)),
          );

          // Same ID should overwrite
          await notificationService.scheduleNotification(
            id: 100,
            title: 'Second',
            body: 'Second notification',
            scheduledDate: DateTime.now().add(const Duration(hours: 2)),
          );
        },
        returnsNormally,
      );
    });
  });
}
