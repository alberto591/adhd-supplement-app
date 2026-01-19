import 'package:flutter/foundation.dart';
import '../../domain/entities/supplement_stack.dart';
import '../../domain/entities/daily_log.dart';
import '../../domain/entities/supplement.dart';
import '../../domain/repositories/stack_repository.dart';
import '../../domain/repositories/log_repository.dart';
import '../../domain/repositories/supplement_repository.dart';

/// View model for the Daily Stack screen
/// Manages today's stacks, intake status, and progress tracking
class DailyStackViewModel extends ChangeNotifier {
  final StackRepository _stackRepository;
  final LogRepository _logRepository;
  final SupplementRepository _supplementRepository;
  final String _userId;

  // State
  List<SupplementStack> _stacks = [];
  DailyLog? _todayLog;
  final Map<String, Supplement> _supplementCache = {};
  int _streakCount = 0;
  bool _isLoading = false;
  String? _error;

  // Getters
  List<SupplementStack> get stacks => _stacks;
  DailyLog? get todayLog => _todayLog;
  int get streakCount => _streakCount;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Calculate today's progress as a percentage (0.0 - 1.0)
  double get todayProgress {
    if (_stacks.isEmpty) return 0.0;
    
    int totalItems = 0;
    int completedItems = 0;
    
    for (final stack in _stacks) {
      totalItems += stack.items.length;
    }
    
    if (_todayLog != null) {
      for (final entry in _todayLog!.entries) {
        if (entry.taken) completedItems++;
      }
    }
    
    if (totalItems == 0) return 0.0;
    return completedItems / totalItems;
  }

  /// Get count of completed stacks vs total
  String get progressText {
    if (_stacks.isEmpty) return 'No stacks configured';
    
    int completedStacks = 0;
    for (final stack in _stacks) {
      final allTaken = stack.items.every((item) {
        if (_todayLog == null) return false;
        return _todayLog!.entries.any(
          (e) => e.supplementId == item.supplementId && e.taken,
        );
      });
      if (allTaken && stack.items.isNotEmpty) completedStacks++;
    }
    
    return '$completedStacks of ${_stacks.length} stacks completed';
  }

  DailyStackViewModel({
    required StackRepository stackRepository,
    required LogRepository logRepository,
    required SupplementRepository supplementRepository,
    required String userId,
  })  : _stackRepository = stackRepository,
        _logRepository = logRepository,
        _supplementRepository = supplementRepository,
        _userId = userId;

  /// Initialize the view model - load stacks, today's log, and streak
  Future<void> initialize() async {
    _setLoading(true);
    _error = null;
    
    try {
      // Load in parallel
      final results = await Future.wait([
        _stackRepository.getUserStacks(_userId),
        _logRepository.getLogForDate(_userId, DateTime.now()),
        _logRepository.getStreakCount(_userId),
      ]);
      
      _stacks = results[0] as List<SupplementStack>;
      _todayLog = results[1] as DailyLog?;
      _streakCount = results[2] as int;
      
      // Cache supplements for display
      await _cacheSupplements();
      
    } catch (e) {
      _error = 'Failed to load daily stack: $e';
      debugPrint(_error);
    } finally {
      _setLoading(false);
    }
  }

  /// Mark a supplement as taken
  Future<void> markSupplementTaken(String supplementId) async {
    final now = DateTime.now();
    final entry = LogEntry(
      supplementId: supplementId,
      takenAt: now,
      taken: true,
    );
    
    await _updateTodayLog(entry);
  }

  /// Mark a supplement as skipped
  Future<void> markSupplementSkipped(String supplementId, {String? reason}) async {
    final now = DateTime.now();
    final entry = LogEntry(
      supplementId: supplementId,
      takenAt: now,
      taken: false,
      skippedReason: reason,
    );
    
    await _updateTodayLog(entry);
  }

  /// Toggle a supplement's taken status
  Future<void> toggleSupplement(String supplementId) async {
    final isTaken = isSupplementTaken(supplementId);
    if (isTaken) {
      // Remove the entry (undo)
      if (_todayLog != null) {
        final updatedEntries = _todayLog!.entries
            .where((e) => e.supplementId != supplementId)
            .toList();
        
        final updatedLog = _todayLog!.copyWith(entries: updatedEntries);
        await _logRepository.saveLog(updatedLog);
        _todayLog = updatedLog;
        notifyListeners();
      }
    } else {
      await markSupplementTaken(supplementId);
    }
  }

  /// Check if a supplement has been taken today
  bool isSupplementTaken(String supplementId) {
    if (_todayLog == null) return false;
    return _todayLog!.entries.any(
      (e) => e.supplementId == supplementId && e.taken,
    );
  }

  /// Get supplement details from cache
  Supplement? getSupplement(String supplementId) {
    return _supplementCache[supplementId];
  }

  /// Save symptom ratings for today
  Future<void> saveSymptomRatings(Map<String, int> ratings) async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    
    final log = _todayLog ?? DailyLog(
      id: '${_userId}_${today.toIso8601String()}',
      userId: _userId,
      date: today,
      entries: [],
      createdAt: now,
    );
    
    final updatedLog = log.copyWith(symptomRatings: ratings);
    await _logRepository.saveLog(updatedLog);
    _todayLog = updatedLog;
    notifyListeners();
  }

  // Private helpers

  Future<void> _updateTodayLog(LogEntry entry) async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    
    List<LogEntry> entries;
    if (_todayLog != null) {
      // Replace existing entry for same supplement, or add new
      entries = _todayLog!.entries
          .where((e) => e.supplementId != entry.supplementId)
          .toList();
      entries.add(entry);
    } else {
      entries = [entry];
    }
    
    final log = _todayLog?.copyWith(entries: entries) ?? DailyLog(
      id: '${_userId}_${today.toIso8601String()}',
      userId: _userId,
      date: today,
      entries: entries,
      createdAt: now,
    );
    
    try {
      await _logRepository.saveLog(log);
      _todayLog = log;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to save log: $e';
      notifyListeners();
    }
  }

  Future<void> _cacheSupplements() async {
    final supplementIds = <String>{};
    for (final stack in _stacks) {
      for (final item in stack.items) {
        supplementIds.add(item.supplementId);
      }
    }
    
    for (final id in supplementIds) {
      try {
        final supplement = await _supplementRepository.getSupplement(id);
        if (supplement != null) {
          _supplementCache[id] = supplement;
        }
      } catch (e) {
        debugPrint('Failed to load supplement $id: $e');
      }
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
}
