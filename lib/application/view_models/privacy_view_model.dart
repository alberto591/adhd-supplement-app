import 'package:flutter/foundation.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/repositories/log_repository.dart';
import '../../config/locator.dart';

class PrivacyViewModel extends ChangeNotifier {
  final AuthRepository _authRepository = locator<AuthRepository>();
  // ignore: unused_field
  final LogRepository _logRepository = locator<LogRepository>();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  Future<void> downloadData() async {
    _setLoading(true);
    _error = null;
    try {
      // Simulate data generation time
      await Future<void>.delayed(const Duration(seconds: 2));
      // In a real app, this would generate a CSV/PDF and share it
    } catch (e) {
      _error = 'Failed to generate data export.';
    } finally {
      _setLoading(false);
    }
  }

  Future<void> deleteAccount() async {
    _setLoading(true);
    _error = null;
    try {
      await _authRepository.deleteUser();
      // App should navigate to login/onboarding after this
    } catch (e) {
      _error = 'Failed to delete account. Please try again.';
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
