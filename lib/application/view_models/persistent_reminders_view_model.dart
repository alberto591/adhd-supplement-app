import 'package:flutter/material.dart';
import '../../domain/repositories/settings_repository.dart';
import '../../infrastructure/services/notification_service.dart';

class PersistentRemindersViewModel extends ChangeNotifier {
  final SettingsRepository _settingsRepository;
  final NotificationService _notificationService;

  PersistentRemindersViewModel(
    this._settingsRepository,
    this._notificationService,
  ) {
    _loadSettings();
  }

  bool _nudgeModeEnabled = true;
  TimeOfDay _nudgeTime = const TimeOfDay(hour: 8, minute: 0);
  String _warningNudgeOption = '15m'; // '15m' or 'followup'
  bool _extendedRemindersEnabled = true;

  bool get nudgeModeEnabled => _nudgeModeEnabled;
  TimeOfDay get nudgeTime => _nudgeTime;
  String get warningNudgeOption => _warningNudgeOption;
  bool get extendedRemindersEnabled => _extendedRemindersEnabled;

  void _loadSettings() {
    _nudgeModeEnabled = _settingsRepository.getNudgeModeEnabled();
    _nudgeTime = _settingsRepository.getNudgeTime();
    _warningNudgeOption = _settingsRepository.getWarningNudgeOption();
    _extendedRemindersEnabled =
        _settingsRepository.getExtendedRemindersEnabled();
    notifyListeners();
  }

  Future<void> setNudgeModeEnabled(bool value) async {
    _nudgeModeEnabled = value;
    await _settingsRepository.setNudgeModeEnabled(value);
    _scheduleOrCancelNotifications();
    notifyListeners();
  }

  Future<void> setNudgeTime(TimeOfDay time) async {
    _nudgeTime = time;
    await _settingsRepository.setNudgeTime(time);
    _scheduleOrCancelNotifications();
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

  Future<void> _scheduleOrCancelNotifications() async {
    // 1000 is the ID for the daily reminder
    // 1001 is the ID for the warning/follow-up nudge
    if (_nudgeModeEnabled) {
      await _notificationService.scheduleRecurringNotification(
        id: 1000,
        title: 'Time for your daily stack!',
        body: 'Keep your streak alive. Take your supplements now.',
        hour: _nudgeTime.hour,
        minute: _nudgeTime.minute,
      );

      // Warning Nudge (15m before or after - assume after for "missed")
      if (_warningNudgeOption == '15m' || _warningNudgeOption == 'followup') {
        int warningHour = _nudgeTime.hour;
        int warningMinute = _nudgeTime.minute + 15;
        if (warningMinute >= 60) {
          warningHour = (warningHour + 1) % 24;
          warningMinute = warningMinute - 60;
        }

        await _notificationService.scheduleRecurringNotification(
          id: 1001,
          title: 'Missed your stack?',
          body: 'Just a friendly nudge to log your supplements!',
          hour: warningHour,
          minute: warningMinute,
        );
      } else {
        await _notificationService.cancelNotification(1001);
      }

      // Follow-up / Extended Logic (Scheduling additional nudges)
      if (_warningNudgeOption == 'followup' || _extendedRemindersEnabled) {
        // Schedule a second nudge +30m
        int secondHour = _nudgeTime.hour;
        int secondMinute = _nudgeTime.minute + 30;
        if (secondMinute >= 60) {
          secondHour = (secondHour + 1) % 24;
          secondMinute = secondMinute - 60;
        }

        await _notificationService.scheduleRecurringNotification(
          id: 1002,
          title: 'Still haven\'t logged?',
          body: 'Consistency is key! tracking helps your doctor help you.',
          hour: secondHour,
          minute: secondMinute,
        );
      } else {
        await _notificationService.cancelNotification(1002);
      }
    } else {
      await _notificationService.cancelNotification(1000);
      await _notificationService.cancelNotification(1001);
      await _notificationService.cancelNotification(1002);
    }
  }

  Future<void> testNotification() async {
    await _notificationService.showNotification(
      id: 999, // Test ID
      title: 'Test Reminder',
      body: 'This is how your daily nudge will look and sound.',
    );
  }
}
