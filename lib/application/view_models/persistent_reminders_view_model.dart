import 'package:flutter/material.dart';
import '../../domain/repositories/settings_repository.dart';
import '../../infrastructure/services/notification_service.dart';
import '../../utils/logger.dart';

class PersistentRemindersViewModel extends ChangeNotifier {
  final SettingsRepository _settingsRepository;
  final NotificationService _notificationService;

  PersistentRemindersViewModel(
    this._settingsRepository,
    this._notificationService,
  ) {
    _initializationFuture = _loadSettings();
  }

  late Future<void> _initializationFuture;
  Future<void> get initializationFuture => _initializationFuture;

  bool _nudgeModeEnabled = true;
  TimeOfDay _nudgeTime = const TimeOfDay(hour: 8, minute: 0);
  String _warningNudgeOption = '15m'; // '15m' or 'followup'
  bool _extendedRemindersEnabled = true;

  TimeOfDay _morningTime = const TimeOfDay(hour: 8, minute: 0);
  TimeOfDay _afternoonTime = const TimeOfDay(hour: 13, minute: 0);
  TimeOfDay _eveningTime = const TimeOfDay(hour: 18, minute: 0);
  TimeOfDay _nightTime = const TimeOfDay(hour: 21, minute: 0);

  NotificationMode _notificationMode = NotificationMode.gentle;
  bool _exactAlarmPermissionGranted = true;

  bool get nudgeModeEnabled => _nudgeModeEnabled;
  TimeOfDay get nudgeTime => _nudgeTime;
  String get warningNudgeOption => _warningNudgeOption;
  bool get extendedRemindersEnabled => _extendedRemindersEnabled;
  NotificationMode get notificationMode => _notificationMode;
  bool get exactAlarmPermissionGranted => _exactAlarmPermissionGranted;

  TimeOfDay get morningTime => _morningTime;
  TimeOfDay get afternoonTime => _afternoonTime;
  TimeOfDay get eveningTime => _eveningTime;
  TimeOfDay get nightTime => _nightTime;

  Future<void> _loadSettings() async {
    _nudgeModeEnabled = _settingsRepository.getNudgeModeEnabled();
    _nudgeTime = _settingsRepository.getNudgeTime();
    _warningNudgeOption = _settingsRepository.getWarningNudgeOption();
    _extendedRemindersEnabled =
        _settingsRepository.getExtendedRemindersEnabled();
    _notificationMode = _settingsRepository.getNotificationMode();

    _morningTime = _settingsRepository.getSlotTime('morning');
    _afternoonTime = _settingsRepository.getSlotTime('afternoon');
    _eveningTime = _settingsRepository.getSlotTime('evening');
    _nightTime = _settingsRepository.getSlotTime('night');

    _exactAlarmPermissionGranted =
        await _notificationService.checkExactAlarmPermission();

    notifyListeners();
  }

  Future<void> refreshPermissionStatus() async {
    _exactAlarmPermissionGranted =
        await _notificationService.checkExactAlarmPermission();
    notifyListeners();
  }

  Future<void> requestExactAlarmPermission() async {
    final granted = await _notificationService.requestExactAlarmPermission();
    _exactAlarmPermissionGranted = granted;
    notifyListeners();
  }

  Future<void> setNudgeModeEnabled(bool value) async {
    _nudgeModeEnabled = value;
    await _settingsRepository.setNudgeModeEnabled(value);
    await _scheduleOrCancelNotifications();
    notifyListeners();
  }

  Future<void> setNudgeTime(TimeOfDay time) async {
    _nudgeTime = time;
    await _settingsRepository.setNudgeTime(time);
    await _scheduleOrCancelNotifications();
    notifyListeners();
  }

  Future<void> setNotificationMode(NotificationMode mode) async {
    _notificationMode = mode;
    await _settingsRepository.setNotificationMode(mode);
    await _scheduleOrCancelNotifications();
    notifyListeners();
  }

  Future<void> setWarningNudgeOption(String option) async {
    _warningNudgeOption = option;
    await _settingsRepository.setWarningNudgeOption(option);
    notifyListeners();
  }

  Future<void> setExtendedRemindersEnabled(bool value) async {
    _extendedRemindersEnabled = value;
    await _settingsRepository.setExtendedRemindersEnabled(value);
    notifyListeners();
  }

  Future<void> setSlotTime(String slot, TimeOfDay time) async {
    switch (slot.toLowerCase()) {
      case 'morning':
        _morningTime = time;
        break;
      case 'afternoon':
        _afternoonTime = time;
        break;
      case 'evening':
        _eveningTime = time;
        break;
      case 'night':
        _nightTime = time;
        break;
    }
    await _settingsRepository.setSlotTime(slot, time);
    notifyListeners();
  }

  Future<void> _scheduleOrCancelNotifications() async {
    try {
      // 1000 is the ID for the daily reminder sequence (Morning Slot)
      if (_nudgeModeEnabled) {
        await _notificationService.scheduleRecurringNudgeSequence(
          slot: NotificationSlot.morning,
          title: 'Time for your daily stack!',
          body: 'Keep your streak alive. Take your supplements now.',
          hour: _nudgeTime.hour,
          minute: _nudgeTime.minute,
          mode: _notificationMode,
        );

        // Evening Summary (20:00) - Uses Evening Slot Base ID (3000)
        await _notificationService.scheduleRecurringNotification(
          id: NotificationSlot.evening.baseId,
          title: 'Daily Summary 🌙',
          body: 'Tap to see your progress for today!',
          hour: 20,
          minute: 0,
        );
      } else {
        // Cancel sequence range (max 15 for persistent)
        final morningBase = NotificationSlot.morning.baseId;
        for (int i = 0; i < 15; i++) {
          await _notificationService.cancelNotification(morningBase + i);
        }
        await _notificationService
            .cancelNotification(NotificationSlot.evening.baseId);
      }
    } catch (e) {
      AppLogger.e('Failed to update notification schedule', e);
      // We do not rethrow so that the UI can still update its state
    }
  }

  Future<void> testNotification() async {
    await _notificationService.showNotification(
      id: 999, // Test ID
      title: 'Test Reminder',
      body: 'This is how your daily nudge will look and sound.',
    );
  }

  Future<void> clearAllNotifications() async {
    await _notificationService.cancelAllNotifications();
    // Reschedule recurring ones if nudge mode is on
    if (_nudgeModeEnabled) {
      await _scheduleOrCancelNotifications();
    }
  }

  Future<void> refreshSchedules() async {
    // 1. Update the timezone definition (critical step)
    await _notificationService.configureLocalTimezone();

    // 2. Clear and reschedule ensuring new timezone is used
    await _notificationService.cancelAllNotifications();

    if (_nudgeModeEnabled) {
      // Logic re-runs using the (now updated) tz.local
      await _scheduleOrCancelNotifications();
    }
  }
}
