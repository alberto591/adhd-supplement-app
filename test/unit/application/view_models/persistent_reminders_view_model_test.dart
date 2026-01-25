import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:adhd_supplement_app/application/view_models/persistent_reminders_view_model.dart';
import 'package:adhd_supplement_app/domain/repositories/settings_repository.dart';
import 'package:adhd_supplement_app/infrastructure/services/notification_service.dart';

@GenerateMocks([SettingsRepository, NotificationService])
import 'persistent_reminders_view_model_test.mocks.dart';

void main() {
  late PersistentRemindersViewModel viewModel;
  late MockSettingsRepository mockSettingsRepository;
  late MockNotificationService mockNotificationService;

  setUp(() async {
    mockSettingsRepository = MockSettingsRepository();
    mockNotificationService = MockNotificationService();

    // Default mock behavior for initialization (stub everything BEFORE creating VM)
    when(mockSettingsRepository.getNudgeModeEnabled()).thenReturn(true);
    when(mockSettingsRepository.getNudgeTime())
        .thenReturn(const TimeOfDay(hour: 8, minute: 0));
    when(mockSettingsRepository.getWarningNudgeOption()).thenReturn('15m');
    when(mockSettingsRepository.getExtendedRemindersEnabled()).thenReturn(true);
    when(mockSettingsRepository.getSlotTime(any))
        .thenReturn(const TimeOfDay(hour: 8, minute: 0));
    when(mockSettingsRepository.getNotificationMode())
        .thenReturn(NotificationMode.gentle);
    when(mockNotificationService.checkExactAlarmPermission())
        .thenAnswer((_) async => true);

    // Stub missing members
    when(mockSettingsRepository.hasAcceptedDisclaimer()).thenReturn(true);
    when(mockSettingsRepository.getSoundsEnabled()).thenReturn(true);
  });

  group('PersistentRemindersViewModel', () {
    test('initialization loads settings correctly', () async {
      viewModel = PersistentRemindersViewModel(
          mockSettingsRepository, mockNotificationService);
      await viewModel.initializationFuture;

      expect(viewModel.nudgeModeEnabled, isTrue);
      expect(viewModel.nudgeTime.hour, 8);
      expect(viewModel.warningNudgeOption, '15m');
      expect(viewModel.extendedRemindersEnabled, isTrue);
      verify(mockSettingsRepository.getNudgeModeEnabled()).called(1);
    });

    test('setNudgeModeEnabled updates settings and schedules/cancels',
        () async {
      viewModel = PersistentRemindersViewModel(
          mockSettingsRepository, mockNotificationService);
      await viewModel.initializationFuture;

      when(mockSettingsRepository.setNudgeModeEnabled(any))
          .thenAnswer((_) async => true);
      when(mockNotificationService.cancelNotification(any))
          .thenAnswer((_) async => true);
      when(mockNotificationService.scheduleRecurringNotification(
        id: anyNamed('id'),
        title: anyNamed('title'),
        body: anyNamed('body'),
        hour: anyNamed('hour'),
        minute: anyNamed('minute'),
      )).thenAnswer((_) async => true);

      await viewModel.setNudgeModeEnabled(false);

      expect(viewModel.nudgeModeEnabled, isFalse);
      verify(mockSettingsRepository.setNudgeModeEnabled(false)).called(1);
      verify(mockNotificationService.cancelNotification(1000)).called(1);
    });

    test('setNudgeTime updates time and reschedules', () async {
      viewModel = PersistentRemindersViewModel(
          mockSettingsRepository, mockNotificationService);
      await viewModel.initializationFuture;
      const newTime = TimeOfDay(hour: 9, minute: 30);

      when(mockSettingsRepository.setNudgeTime(newTime))
          .thenAnswer((_) async => true);
      when(mockNotificationService.scheduleRecurringNotification(
        id: anyNamed('id'),
        title: anyNamed('title'),
        body: anyNamed('body'),
        hour: anyNamed('hour'),
        minute: anyNamed('minute'),
      )).thenAnswer((_) async => true);

      await viewModel.setNudgeTime(newTime);

      expect(viewModel.nudgeTime, newTime);
      verify(mockSettingsRepository.setNudgeTime(newTime)).called(1);
      verify(mockNotificationService.scheduleRecurringNudgeSequence(
        slot: NotificationSlot.morning,
        title: anyNamed('title'),
        body: anyNamed('body'),
        hour: 9,
        minute: 30,
        mode: anyNamed('mode'),
      )).called(1);
    });

    test('schedule notifications correctly maps nudge offsets', () async {
      viewModel = PersistentRemindersViewModel(
          mockSettingsRepository, mockNotificationService);
      await viewModel.initializationFuture;

      when(mockSettingsRepository.setNudgeModeEnabled(any))
          .thenAnswer((_) async => true);
      when(mockNotificationService.scheduleRecurringNotification(
        id: anyNamed('id'),
        title: anyNamed('title'),
        body: anyNamed('body'),
        hour: anyNamed('hour'),
        minute: anyNamed('minute'),
      )).thenAnswer((_) async => true);

      // Default nudge is 15m after 08:00 -> sequence handles offsets
      await viewModel.setNudgeModeEnabled(true);

      verify(mockSettingsRepository.setNudgeModeEnabled(true)).called(1);
      verify(mockNotificationService.scheduleRecurringNudgeSequence(
        slot: NotificationSlot.morning,
        title: anyNamed('title'),
        body: anyNamed('body'),
        hour: 8,
        minute: 0,
        mode: anyNamed('mode'),
      )).called(1);
    });

    test('testNotification triggers service call', () async {
      viewModel = PersistentRemindersViewModel(
          mockSettingsRepository, mockNotificationService);
      await viewModel.initializationFuture;

      when(mockNotificationService.showNotification(
        id: anyNamed('id'),
        title: anyNamed('title'),
        body: anyNamed('body'),
      )).thenAnswer((_) async => true);

      await viewModel.testNotification();

      verify(mockNotificationService.showNotification(
        id: 999,
        title: anyNamed('title'),
        body: anyNamed('body'),
      )).called(1);
    });
  });
}
