import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/repositories/settings_repository.dart';

class SharedPrefsSettingsRepository implements SettingsRepository {
  late SharedPreferences _prefs;

  // Keys
  static const String _keyNudgeEnabled = 'nudge_enabled';
  static const String _keyNudgeHour = 'nudge_hour';
  static const String _keyNudgeMinute = 'nudge_minute';
  static const String _keyWarningOption =
      'warning_option'; // '15m' or 'followup'
  static const String _keyExtendedEnabled = 'extended_enabled';

  @override
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  @override
  bool getNudgeModeEnabled() {
    return _prefs.getBool(_keyNudgeEnabled) ?? true; // Default true
  }

  @override
  Future<void> setNudgeModeEnabled(bool enabled) async {
    await _prefs.setBool(_keyNudgeEnabled, enabled);
  }

  @override
  TimeOfDay getNudgeTime() {
    final hour = _prefs.getInt(_keyNudgeHour) ?? 8; // Default 8:00 AM
    final minute = _prefs.getInt(_keyNudgeMinute) ?? 0;
    return TimeOfDay(hour: hour, minute: minute);
  }

  @override
  Future<void> setNudgeTime(TimeOfDay time) async {
    await _prefs.setInt(_keyNudgeHour, time.hour);
    await _prefs.setInt(_keyNudgeMinute, time.minute);
  }

  @override
  String getWarningNudgeOption() {
    return _prefs.getString(_keyWarningOption) ?? '15m';
  }

  @override
  Future<void> setWarningNudgeOption(String option) async {
    await _prefs.setString(_keyWarningOption, option);
  }

  @override
  bool getExtendedRemindersEnabled() {
    return _prefs.getBool(_keyExtendedEnabled) ?? true;
  }

  @override
  Future<void> setExtendedRemindersEnabled(bool enabled) async {
    await _prefs.setBool(_keyExtendedEnabled, enabled);
  }
}
