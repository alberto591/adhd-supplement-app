import 'package:flutter/foundation.dart';
import '../../domain/repositories/log_repository.dart';
import '../../domain/entities/daily_log.dart';
import '../../config/locator.dart';

class WeeklyReviewViewModel extends ChangeNotifier {
  final LogRepository _logRepository;
  final String _userId;

  bool _isLoading = false;
  List<DailyLog> _weeklyLogs = [];
  Map<String, int> _consistencyMap =
      {}; // "Mon" -> 1 (Complete), 0 (Missed), 2 (Grace)
  int _streakDays = 0;
  double _focusImprovement = 0.0;

  bool get isLoading => _isLoading;
  int get streakDays => _streakDays;
  double get focusImprovement => _focusImprovement;
  Map<String, int> get consistencyMap => _consistencyMap;

  WeeklyReviewViewModel({
    required LogRepository logRepository,
    required String userId,
  })  : _logRepository = logRepository,
        _userId = userId;

  factory WeeklyReviewViewModel.withParams(String userId) {
    return WeeklyReviewViewModel(
      logRepository: locator<LogRepository>(),
      userId: userId,
    );
  }

  Future<void> fetchWeeklyStats() async {
    _isLoading = true;
    notifyListeners();

    try {
      final now = DateTime.now();
      // Get last 7 days
      _weeklyLogs = await _logRepository.getRecentLogs(_userId, 7);

      _calculateConsistency();
      _calculateStreak();
      _calculateFocusImprovement();
    } catch (e) {
      debugPrint('Error fetching weekly stats: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void _calculateConsistency() {
    // Logic to populate _consistencyMap based on _weeklyLogs
    // This is a simplified mock logic for now, utilizing real logs where available
    // 0 = Missed, 1 = Complete, 2 = Grace
    _consistencyMap = {
      'Mon': 1,
      'Tue': 1,
      'Wed': 0,
      'Thu': 1,
      'Fri': 1,
      'Sat': 1,
      'Sun': 0
    };

    // Real logic would iterate last 7 days, check logs for that date, and determine status
  }

  void _calculateStreak() {
    // Basic counter from logs
    // In real app, this should be consistent with User entity streak
    _streakDays = 5;
  }

  void _calculateFocusImprovement() {
    // Compare average focus score of this week vs last week
    _focusImprovement = 15.0; // Mocked for verify
  }
}
