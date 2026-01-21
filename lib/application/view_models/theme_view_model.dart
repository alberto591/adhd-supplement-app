import 'package:flutter/material.dart';
import '../../domain/repositories/settings_repository.dart';

class ThemeViewModel extends ChangeNotifier {
  final SettingsRepository _settingsRepository;

  ThemeViewModel(this._settingsRepository);

  ThemeMode get themeMode => _settingsRepository.getThemeMode();

  bool get isDarkMode => themeMode == ThemeMode.dark;

  Future<void> toggleTheme() async {
    final nextMode = isDarkMode ? ThemeMode.light : ThemeMode.dark;
    await _settingsRepository.setThemeMode(nextMode);
    notifyListeners();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    await _settingsRepository.setThemeMode(mode);
    notifyListeners();
  }
}
