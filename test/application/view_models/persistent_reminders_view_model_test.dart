import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:adhd_supplement_app/application/view_models/persistent_reminders_view_model.dart';
import 'package:adhd_supplement_app/domain/repositories/settings_repository.dart';
import 'package:adhd_supplement_app/infrastructure/services/notification_service.dart';

class _FakeSettingsRepository implements SettingsRepository {
  bool nudgeModeEnabled;
  TimeOfDay nudgeTime;
  String warningNudgeOption;
  bool extendedRemindersEnabled;

  _FakeSettingsRepository({
    this.nudgeModeEnabled = true,
    TimeOfDay? nudgeTime,
    this.warningNudgeOption = '15m',
    this.extendedRemindersEnabled = true,
  }) : nudgeTime = nudgeTime ?? const TimeOfDay(hour: 8, minute: 0);

  @override
  Future<void> init() async {}

  @override
  bool getNudgeModeEnabled() => nudgeModeEnabled;

  @override
  Future<void> setNudgeModeEnabled(bool enabled) async {
    nudgeModeEnabled = enabled;
  }

  @override
  TimeOfDay getNudgeTime() => nudgeTime;

  @override
  Future<void> setNudgeTime(TimeOfDay time) async {
    nudgeTime = time;
  }

  @override
  String getWarningNudgeOption() => warningNudgeOption;

  @override
  Future<void> setWarningNudgeOption(String option) async {
    warningNudgeOption = option;
  }

  @override
  bool getExtendedRemindersEnabled() => extendedRemindersEnabled;

  @override
  Future<void> setExtendedRemindersEnabled(bool enabled) async {
    extendedRemindersEnabled = enabled;
  }

  @override
  bool getBiometricLockEnabled() {
    return false;
  }

  @override
  Future<void> setBiometricLockEnabled(bool enabled) async {}

  @override
  bool getLocalStorageOnly() => false;

  @override
  Future<void> setLocalStorageOnly(bool enabled) async {}

  @override
  bool getAnalyticsEnabled() => false;

  @override
  Future<void> setAnalyticsEnabled(bool enabled) async {}

  @override
  bool getCrashReportingEnabled() => false;

  @override
  Future<void> setCrashReportingEnabled(bool enabled) async {}
}

class _FakeNotificationService extends NotificationService {
  int? lastScheduledId;
  int? lastScheduledHour;
  int? lastScheduledMinute;
  int scheduleCallCount = 0;

  int? lastCancelledId;
  int cancelCallCount = 0;

  int? lastShownId;
  String? lastShownTitle;
  String? lastShownBody;

  @override
  Future<void> scheduleRecurringNotification({
    required int id,
    required String title,
    required String body,
    required int hour,
    required int minute,
    int second = 0,
  }) async {
    lastScheduledId = id;
    lastScheduledHour = hour;
    lastScheduledMinute = minute;
    scheduleCallCount++;
  }

  @override
  Future<void> cancelNotification(int id) async {
    lastCancelledId = id;
    cancelCallCount++;
  }

  @override
  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    lastShownId = id;
    lastShownTitle = title;
    lastShownBody = body;
  }
}

void main() {
  group('PersistentRemindersViewModel', () {
    late _FakeSettingsRepository settingsRepository;
    late _FakeNotificationService notificationService;
    late PersistentRemindersViewModel viewModel;

    setUp(() {
      settingsRepository = _FakeSettingsRepository(
        nudgeModeEnabled: true,
        nudgeTime: const TimeOfDay(hour: 9, minute: 30),
        warningNudgeOption: 'followup',
        extendedRemindersEnabled: false,
      );
      notificationService = _FakeNotificationService();
      viewModel =
          PersistentRemindersViewModel(settingsRepository, notificationService);
    });

    test('loads initial settings from repository', () {
      expect(viewModel.nudgeModeEnabled, isTrue);
      expect(viewModel.nudgeTime.hour, 9);
      expect(viewModel.nudgeTime.minute, 30);
      expect(viewModel.warningNudgeOption, 'followup');
      expect(viewModel.extendedRemindersEnabled, isFalse);
    });

    test('setNudgeModeEnabled true schedules recurring notification', () async {
      await viewModel.setNudgeModeEnabled(true);

      expect(settingsRepository.nudgeModeEnabled, isTrue);
      expect(notificationService.scheduleCallCount, 1);
      expect(notificationService.lastScheduledId, 1000);
      expect(notificationService.lastCancelledId, isNull);
    });

    test('setNudgeModeEnabled false cancels notification', () async {
      await viewModel.setNudgeModeEnabled(false);

      expect(settingsRepository.nudgeModeEnabled, isFalse);
      expect(notificationService.cancelCallCount, 1);
      expect(notificationService.lastCancelledId, 1000);
      // No new schedule calls when disabling
      expect(notificationService.scheduleCallCount, 0);
    });

    test('setNudgeTime updates time and reschedules notification', () async {
      const newTime = TimeOfDay(hour: 7, minute: 15);

      await viewModel.setNudgeTime(newTime);

      expect(viewModel.nudgeTime, newTime);
      expect(settingsRepository.nudgeTime, newTime);
      expect(notificationService.scheduleCallCount, 1);
      expect(notificationService.lastScheduledHour, 7);
      expect(notificationService.lastScheduledMinute, 15);
    });

    test('setWarningNudgeOption updates setting only', () async {
      await viewModel.setWarningNudgeOption('15m');

      expect(viewModel.warningNudgeOption, '15m');
      expect(settingsRepository.warningNudgeOption, '15m');
      // Should not touch notifications
      expect(notificationService.scheduleCallCount, 0);
      expect(notificationService.cancelCallCount, 0);
    });

    test('setExtendedRemindersEnabled updates setting only', () async {
      await viewModel.setExtendedRemindersEnabled(true);

      expect(viewModel.extendedRemindersEnabled, isTrue);
      expect(settingsRepository.extendedRemindersEnabled, isTrue);
      // Should not touch notifications
      expect(notificationService.scheduleCallCount, 0);
      expect(notificationService.cancelCallCount, 0);
    });

    test('testNotification triggers a one-time notification', () async {
      await viewModel.testNotification();

      expect(notificationService.lastShownId, 999);
      expect(notificationService.lastShownTitle, isNotEmpty);
      expect(notificationService.lastShownBody, isNotEmpty);
    });
  });
}
