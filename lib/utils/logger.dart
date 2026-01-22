import 'package:flutter/foundation.dart';

/// Centralized logger for the application.
/// Wraps debugPrint to ensure logs are only shown in debug mode
/// and provides a consistent structure for logging.
class AppLogger {
  // Prevent instantiation
  AppLogger._();

  /// Logs a debug message.
  static void d(String message, [dynamic error, StackTrace? stackTrace]) {
    if (kDebugMode) {
      debugPrint('🐛 [DEBUG] $message');
      if (error != null) debugPrint('   Error: $error');
      if (stackTrace != null) debugPrint('   Stack: $stackTrace');
    }
  }

  /// Logs an info message.
  static void i(String message) {
    if (kDebugMode) {
      debugPrint('ℹ️ [INFO] $message');
    }
  }

  /// Logs a warning message.
  static void w(String message, [dynamic error]) {
    if (kDebugMode) {
      debugPrint('⚠️ [WARN] $message');
      if (error != null) debugPrint('   Error: $error');
    }
  }

  /// Logs an error message.
  static void e(String message, [dynamic error, StackTrace? stackTrace]) {
    // Always print errors, even in release mode (or consider sending to Crashlytics)
    debugPrint('❌ [ERROR] $message');
    if (error != null) debugPrint('   Error: $error');
    if (stackTrace != null) debugPrint('   Stack: $stackTrace');
  }
}
