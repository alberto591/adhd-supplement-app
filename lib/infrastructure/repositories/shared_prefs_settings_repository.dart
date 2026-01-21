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
  static const String _keyThemeMode = 'theme_mode';

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

  // Privacy Settings
  static const String _keyBiometricEnabled = 'biometric_enabled';
  static const String _keyLocalStorageOnly = 'local_storage_only';
  static const String _keyAnalyticsEnabled = 'analytics_enabled';
  static const String _keyCrashReportingEnabled = 'crash_reporting_enabled';

  @override
  bool getBiometricLockEnabled() {
    return _prefs.getBool(_keyBiometricEnabled) ?? false;
  }

  @override
  Future<void> setBiometricLockEnabled(bool enabled) async {
    await _prefs.setBool(_keyBiometricEnabled, enabled);
  }

  @override
  bool getLocalStorageOnly() {
    return _prefs.getBool(_keyLocalStorageOnly) ?? true;
  }

  @override
  Future<void> setLocalStorageOnly(bool enabled) async {
    await _prefs.setBool(_keyLocalStorageOnly, enabled);
  }

  @override
  bool getAnalyticsEnabled() {
    return _prefs.getBool(_keyAnalyticsEnabled) ?? false;
  }

  @override
  Future<void> setAnalyticsEnabled(bool enabled) async {
    await _prefs.setBool(_keyAnalyticsEnabled, enabled);
  }

  @override
  bool getCrashReportingEnabled() {
    return _prefs.getBool(_keyCrashReportingEnabled) ?? false;
  }

  @override
  Future<void> setCrashReportingEnabled(bool enabled) async {
    await _prefs.setBool(_keyCrashReportingEnabled, enabled);
  }

  @override
  ThemeMode getThemeMode() {
    final index = _prefs.getInt(_keyThemeMode) ?? ThemeMode.system.index;
    return ThemeMode.values[index];
  }

  @override
  Future<void> setThemeMode(ThemeMode mode) async {
    await _prefs.setInt(_keyThemeMode, mode.index);
  }
}
