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
}
