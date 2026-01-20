import 'package:flutter/material.dart';

abstract class SettingsRepository {
  Future<void> init();

  // Notification Settings
  bool getNudgeModeEnabled();
  Future<void> setNudgeModeEnabled(bool enabled);

  TimeOfDay getNudgeTime();
  Future<void> setNudgeTime(TimeOfDay time);

  String getWarningNudgeOption();
  Future<void> setWarningNudgeOption(String option);

  bool getExtendedRemindersEnabled();
  Future<void> setExtendedRemindersEnabled(bool enabled);

  // Privacy Settings
  bool getBiometricLockEnabled();
  Future<void> setBiometricLockEnabled(bool enabled);

  bool getLocalStorageOnly();
  Future<void> setLocalStorageOnly(bool enabled);

  bool getAnalyticsEnabled();
  Future<void> setAnalyticsEnabled(bool enabled);

  bool getCrashReportingEnabled();
  Future<void> setCrashReportingEnabled(bool enabled);
}
