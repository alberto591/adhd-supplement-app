import 'package:flutter/foundation.dart';
import '../../domain/repositories/log_repository.dart';
import '../../domain/repositories/stack_repository.dart';
import '../../domain/entities/daily_log.dart';
// import '../../domain/entities/supplement_stack.dart';
import '../../config/locator.dart';

class HistoryLogViewModel extends ChangeNotifier {
  final LogRepository _logRepository;
  final StackRepository _stackRepository;
  final String _userId;

  List<DailyLog> _recentLogs = [];
  bool _isLoading = false;
  String? _error;

  List<DailyLog> get recentLogs => _recentLogs;
  bool get isLoading => _isLoading;
  String? get error => _error;

  HistoryLogViewModel({
    required LogRepository logRepository,
    required StackRepository stackRepository,
    required String userId,
  })  : _logRepository = logRepository,
        _stackRepository = stackRepository,
        _userId = userId;

  factory HistoryLogViewModel.withParams(String userId) {
    return HistoryLogViewModel(
      logRepository: locator<LogRepository>(),
      stackRepository: locator<StackRepository>(),
      userId: userId,
    );
  }

  Future<void> fetchHistory() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _recentLogs = await _logRepository.getRecentLogs(_userId, 7);
    } catch (e) {
      _error = 'Failed to load history: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> resolveAllMissed() async {
    _isLoading = true;
    notifyListeners();

    try {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);

      // 1. Get today's log or create a new one
      var log = await _logRepository.getLogForDate(_userId, today) ??
          DailyLog(
            id: '${_userId}_${today.toIso8601String()}',
            userId: _userId,
            date: today,
            entries: [],
            createdAt: now,
          );

      // 2. Get user stacks to find what SHOULD have been taken
      final stacks = await _stackRepository.getUserStacks(_userId);
      final allScheduledItems = stacks.expand((s) => s.items).toList();

      // 3. Identify missed items (scheduled but no entry)
      bool changed = false;
      final existingIds = log.entries.map((e) => e.supplementId).toSet();

      final newEntries = List<LogEntry>.from(log.entries);

      for (final item in allScheduledItems) {
        if (!existingIds.contains(item.supplementId)) {
          // Check if scheduled time has passed
          if (_isTimePassed(item.scheduledTime)) {
            newEntries.add(LogEntry(
              supplementId: item.supplementId,
              takenAt: now,
              status: LogStatus.late,
              skippedReason: 'Acknowledged missed reminder',
            ));
            changed = true;
          }
        }
      }

      if (changed) {
        await _logRepository.saveLog(log.copyWith(entries: newEntries));
        await fetchHistory();
      }
    } catch (e) {
      _error = 'Failed to resolve items: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  bool _isTimePassed(String? scheduledTime) {
    if (scheduledTime == null) return false;
    try {
      final parts = scheduledTime.split(':');
      final hour = int.parse(parts[0]);
      final minute = int.parse(parts[1]);
      final now = DateTime.now();

      if (now.hour > hour) return true;
      if (now.hour == hour && now.minute >= minute) return true;
    } catch (_) {}
    return false;
  }
}
