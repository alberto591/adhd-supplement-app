import 'package:flutter/foundation.dart';
import '../../domain/entities/daily_log.dart';
import '../../domain/repositories/log_repository.dart';

/// View model for the History Log screen
/// Manages historical logs and filtering by date/status
class HistoryLogViewModel extends ChangeNotifier {
  final LogRepository _logRepository;
  final String _userId;

  // State
  List<DailyLog> _logs = [];
  String _selectedFilter = 'All'; // All, Missed, Taken, Dismissed
  bool _isLoading = false;
  String? _error;

  // Getters
  List<DailyLog> get logs => _logs;
  String get selectedFilter => _selectedFilter;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Group logs by date sections (Today, Yesterday, This Week, etc.)
  Map<String, List<DailyLog>> get groupedLogs {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    final groups = <String, List<DailyLog>>{};

    for (final log in _logs) {
      final logDate = DateTime(log.date.year, log.date.month, log.date.day);

      String groupKey;
      if (logDate == today) {
        groupKey = 'Earlier Today';
      } else if (logDate == yesterday) {
        groupKey = 'Yesterday';
      } else if (logDate.isAfter(today.subtract(const Duration(days: 7)))) {
        groupKey = 'This Week';
      } else {
        groupKey = 'Earlier';
      }

      groups.putIfAbsent(groupKey, () => []);
      groups[groupKey]!.add(log);
    }

    return groups;
  }

  /// Calculate completion stats
  Map<String, dynamic> get stats {
    int totalEntries = 0;
    int takenCount = 0;
    int missedCount = 0;

    for (final log in _logs) {
      for (final entry in log.entries) {
        totalEntries++;
        if (entry.status == LogStatus.taken) {
          takenCount++;
        } else {
          missedCount++;
        }
      }
    }

    final completionRate =
        totalEntries > 0 ? (takenCount / totalEntries * 100).round() : 0;

    return {
      'total': totalEntries,
      'taken': takenCount,
      'missed': missedCount,
      'completionRate': completionRate,
    };
  }

  HistoryLogViewModel({
    required LogRepository logRepository,
    required String userId,
  })  : _logRepository = logRepository,
        _userId = userId;

  /// Initialize - load recent logs
  Future<void> initialize({int days = 30}) async {
    _setLoading(true);
    _error = null;

    try {
      _logs = await _logRepository.getRecentLogs(_userId, days);
      _logs.sort((a, b) => b.date.compareTo(a.date)); // Most recent first
    } catch (e) {
      _error = 'Failed to load history: $e';
      debugPrint(_error);
    } finally {
      _setLoading(false);
    }
  }

  /// Load logs for a specific date range
  Future<void> loadDateRange(DateTime start, DateTime end) async {
    _setLoading(true);
    _error = null;

    try {
      _logs = await _logRepository.getLogsByDateRange(_userId, start, end);
      _logs.sort((a, b) => b.date.compareTo(a.date));
    } catch (e) {
      _error = 'Failed to load history: $e';
    } finally {
      _setLoading(false);
    }
  }

  /// Filter by status (All, Missed, Taken, Dismissed)
  void setFilter(String filter) {
    _selectedFilter = filter;
    notifyListeners();
  }

  /// Get filtered entries based on selected filter
  List<LogEntry> getFilteredEntries(DailyLog log) {
    if (_selectedFilter == 'All') {
      return log.entries;
    }

    return log.entries.where((entry) {
      switch (_selectedFilter) {
        case 'Taken':
          return entry.status == LogStatus.taken;
        case 'Missed':
          return entry.status == LogStatus.skipped &&
              entry.skippedReason == null;
        case 'Dismissed':
          return entry.status == LogStatus.skipped &&
              entry.skippedReason != null;
        default:
          return true;
      }
    }).toList();
  }

  // Private helpers

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
}
