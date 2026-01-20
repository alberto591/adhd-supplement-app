import 'package:flutter/foundation.dart';
import '../../domain/entities/supplement_stack.dart';
import '../../domain/entities/daily_log.dart';
import '../../domain/entities/supplement.dart';
import '../../domain/repositories/stack_repository.dart';
import '../../domain/repositories/log_repository.dart';
import '../../domain/repositories/supplement_repository.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../infrastructure/services/notification_service.dart';

/// View model for the Daily Stack screen
/// Manages today's stacks, intake status, and progress tracking
class DailyStackViewModel extends ChangeNotifier {
  final StackRepository _stackRepository;
  final LogRepository _logRepository;
  final SupplementRepository _supplementRepository;
  final NotificationService _notificationService;
  final AuthRepository _authRepository;
  final String _userId;

  // State
  List<SupplementStack> _stacks = [];
  DailyLog? _todayLog;
  final Map<String, Supplement> _supplementCache = {};
  int _streakCount = 0;
  bool _isLoading = false;
  String? _error;

  // Time-based slots
  List<StackItem> get morningItems => _getItemsForSlot('morning');
  List<StackItem> get afternoonItems => _getItemsForSlot('afternoon');
  List<StackItem> get eveningItems => _getItemsForSlot('evening');

  // Getters
  List<SupplementStack> get stacks => _stacks;
  DailyLog? get todayLog => _todayLog;
  int get streakCount => _streakCount;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Get dynamic greeting based on time of day
  String get greeting {
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 12) return 'Good Morning';
    if (hour >= 12 && hour < 17) return 'Good Afternoon';
    if (hour >= 17 && hour < 21) return 'Good Evening';
    return 'Good Night';
  }

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
        if (entry.status == LogStatus.taken) completedItems++;
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
          (e) =>
              e.supplementId == item.supplementId &&
              e.status == LogStatus.taken,
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
    required NotificationService notificationService,
    required AuthRepository authRepository,
    required String userId,
  })  : _stackRepository = stackRepository,
        _logRepository = logRepository,
        _supplementRepository = supplementRepository,
        _notificationService = notificationService,
        _authRepository = authRepository,
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
      status: LogStatus.taken,
    );

    await _updateTodayLog(entry);

    // Give 10 XP per supplement taken
    await _incrementUserXP(10);

    // Cancel any active nudges for this supplement
    await _notificationService.cancelNudgeSequence(supplementId.hashCode, 12);
  }

  Future<void> _incrementUserXP(int amount) async {
    try {
      final user = await _authRepository.getCurrentUser();
      if (user != null) {
        final updatedUser = user.copyWith(xp: user.xp + amount);
        await _authRepository.updateUserProfile(updatedUser);
        debugPrint('XP Added: $amount. Total: ${updatedUser.xp}');
      }
    } catch (e) {
      debugPrint('Failed to update user XP: $e');
    }
  }

  /// Mark a supplement as skipped
  Future<void> markSupplementSkipped(String supplementId,
      {String? reason}) async {
    final now = DateTime.now();
    final entry = LogEntry(
      supplementId: supplementId,
      takenAt: now,
      status: LogStatus.skipped,
      skippedReason: reason,
    );

    await _updateTodayLog(entry);

    // Cancel any active nudges for this supplement
    await _notificationService.cancelNudgeSequence(supplementId.hashCode, 12);
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

  /// Snooze a persistent nudge for a supplement
  Future<void> snoozeSupplement(String supplementId) async {
    final supplement = _supplementCache[supplementId];
    if (supplement == null) return;

    await _notificationService.snoozePersistentNudge(
      baseId: supplementId.hashCode,
      title: 'Time for ${supplement.name}',
      body: 'Snoozed for 5 minutes. Don\'t forget your focus stack!',
    );
    notifyListeners();
  }

  /// Check if a supplement has been taken today
  bool isSupplementTaken(String supplementId) {
    if (_todayLog == null) return false;
    return _todayLog!.entries.any(
      (e) => e.supplementId == supplementId && e.status == LogStatus.taken,
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

    final log = _todayLog ??
        DailyLog(
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

  /// Save mood and focus scores for today
  Future<void> saveScores({int? mood, int? focus}) async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final log = _todayLog ??
        DailyLog(
          id: '${_userId}_${today.toIso8601String()}',
          userId: _userId,
          date: today,
          entries: [],
          createdAt: now,
        );

    final updatedLog = log.copyWith(
      moodScore: mood ?? log.moodScore,
      focusScore: focus ?? log.focusScore,
    );
    await _logRepository.saveLog(updatedLog);
    _todayLog = updatedLog;
    notifyListeners();
  }

  // Private helpers

  List<StackItem> _getItemsForSlot(String slot) {
    // 1. Flatten all stack items
    final allItems = _stacks.expand((s) => s.items).toList();

    // 2. Filter by slot
    return allItems.where((item) {
      final scheduledTime = item.scheduledTime;
      if (scheduledTime != null) {
        // Parse time: "HH:mm"
        try {
          final parts = scheduledTime.split(':');
          final hour = int.parse(parts[0]);
          if (slot == 'morning') return hour < 12;
          if (slot == 'afternoon') return hour >= 12 && hour < 18;
          if (slot == 'evening') return hour >= 18;
        } catch (_) {}
      }

      // Fallback to supplement's default timeOfDay (if cached) or stack's timeOfDay
      // Currently using stack's timeOfDay as proxy or just all in 'morning' for now if undefined
      // But prompt logic suggests "Morning Focus" and "Evening Stack" groups.

      // Let's assume for now, if no time is set:
      // - First stack is morning
      // - Or rely on `Supplement.timeOfDay`

      final supplement = _supplementCache[item.supplementId];
      final timeOfDay = supplement?.timeOfDay?.toLowerCase() ?? 'morning';

      if (slot == 'morning') return timeOfDay.contains('morning');
      if (slot == 'afternoon') return timeOfDay.contains('afternoon');
      if (slot == 'evening') {
        return timeOfDay.contains('evening') || timeOfDay.contains('bed');
      }

      return false;
    }).toList();
  }

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

    final log = _todayLog?.copyWith(entries: entries) ??
        DailyLog(
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
