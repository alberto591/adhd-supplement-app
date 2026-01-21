import 'package:flutter/foundation.dart';
import '../../domain/entities/supplement_stack.dart';
import '../../domain/entities/daily_log.dart';
import '../../domain/entities/supplement.dart';
import '../../domain/repositories/stack_repository.dart';
import '../../domain/repositories/log_repository.dart';
import '../../domain/repositories/supplement_repository.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/repositories/settings_repository.dart';
import '../../infrastructure/services/notification_service.dart';

/// View model for the Daily Stack screen
/// Manages today's stacks, intake status, and progress tracking
class DailyStackViewModel extends ChangeNotifier {
  final StackRepository _stackRepository;
  final LogRepository _logRepository;
  final SupplementRepository _supplementRepository;
  final SettingsRepository _settingsRepository;
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
  bool _isDisposed = false;

  // Time-based slots
  List<StackItem> get morningItems => _getItemsForSlot('morning');
  List<StackItem> get afternoonItems => _getItemsForSlot('afternoon');
  List<StackItem> get eveningItems => _getItemsForSlot('evening');
  List<StackItem> get nightItems => _getItemsForSlot('night');

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
    required SettingsRepository settingsRepository,
    required NotificationService notificationService,
    required AuthRepository authRepository,
    required String userId,
  })  : _stackRepository = stackRepository,
        _logRepository = logRepository,
        _supplementRepository = supplementRepository,
        _settingsRepository = settingsRepository,
        _notificationService = notificationService,
        _authRepository = authRepository,
        _userId = userId;

  /// Initialize the view model - load stacks, today's log, and streak
  Future<void> initialize() async {
    _setLoading(true);
    _error = null;

    try {
      debugPrint('Initializing DailyStackViewModel for user: $_userId');
      final logicalToday = _getLogicalToday();
      debugPrint('Logical today determined as: $logicalToday');

      // Load in parallel with timeouts
      debugPrint('Starting parallel data load (Stacks, Log, Streak)...');
      final results = await Future.wait([
        _stackRepository.getUserStacks(_userId),
        _logRepository.getLogForDate(_userId, logicalToday),
        _logRepository.getStreakCount(_userId),
      ]);
      debugPrint('Parallel data load complete.');

      _stacks = results[0] as List<SupplementStack>;
      _todayLog = results[1] as DailyLog?;
      _streakCount = results[2] as int;

      // Cache supplements for display
      await _cacheSupplements();

      // Check for achievements on load
      final currentUser = await _authRepository.getCurrentUser();
      if (_streakCount >= 7) {
        await unlockAchievement('7_day_warrior');
      }
      if ((currentUser?.level ?? 1) >= 5) {
        await unlockAchievement('focus_master');
      }
    } catch (e) {
      _error = 'Failed to load daily stack: $e';
      debugPrint(_error);
    } finally {
      _setLoading(false);
    }
  }

  /// Mark a supplement as taken
  Future<void> markSupplementTaken(String supplementId) async {
    debugPrint('Marking supplement as taken: $supplementId');
    final now = DateTime.now();
    final entry = LogEntry(
      supplementId: supplementId,
      takenAt: now,
      status: LogStatus.taken,
    );

    await _updateTodayLog(entry);
    debugPrint('Today log updated for $supplementId');

    // Give 10 XP per supplement taken
    await _incrementUserXP(10);

    // Cancel any active nudges for this supplement
    try {
      await _notificationService.cancelNudgeSequence(supplementId.hashCode, 12);
      await _checkAndCancelGlobalNudges();
    } catch (e) {
      debugPrint('Failed to cancel nudges: $e');
    }
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

  /// Unlock an achievement for the user
  Future<void> unlockAchievement(String achievementId) async {
    try {
      final user = await _authRepository.getCurrentUser();
      if (user != null) {
        if (!user.unlockedAchievements.contains(achievementId)) {
          final updatedAchievements =
              List<String>.from(user.unlockedAchievements)..add(achievementId);
          final updatedUser =
              user.copyWith(unlockedAchievements: updatedAchievements);
          await _authRepository.updateUserProfile(updatedUser);
          debugPrint('Achievement Unlocked: $achievementId');
        }
      }
    } catch (e) {
      debugPrint('Failed to unlock achievement: $e');
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
    try {
      await _notificationService.cancelNudgeSequence(supplementId.hashCode, 12);
      await _checkAndCancelGlobalNudges();
    } catch (e) {
      debugPrint('Failed to cancel nudges: $e');
    }
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

  /// Get formatted time status string for a given time slots
  String? getTimeStatus(String? timeOfDay) {
    if (timeOfDay == null) return null;
    int targetHour;

    // Normalize string
    final slot = timeOfDay.toLowerCase();

    if (slot.contains('morning')) {
      targetHour = 8;
    } else if (slot.contains('afternoon')) {
      targetHour = 13;
    } else if (slot.contains('evening')) {
      targetHour = 18;
    } else if (slot.contains('night')) {
      targetHour = 21;
    } else {
      return null;
    }

    final now = DateTime.now();
    final target = DateTime(now.year, now.month, now.day, targetHour);
    final diff = target.difference(now);

    if (diff.isNegative) {
      // If overdue by more than 4 hours, just say "Today" or simplified status
      // But user requested "Time Urgency", so "Overdue" is good.
      if (diff.abs().inHours > 4) return 'Overdue';
      return 'Overdue by ${diff.abs().inMinutes}m';
    } else {
      if (diff.inHours > 0) {
        return 'in ${diff.inHours}h ${diff.inMinutes % 60}m';
      }
      return 'in ${diff.inMinutes}m';
    }
  }

  // Private helpers

  List<StackItem> _getItemsForSlot(String slot) {
    // 1. Flatten all stack items
    final allItems = _stacks.expand((s) => s.items).toList();

    // 2. Filter by slot AND completion (Hide if taken)
    return allItems.where((item) {
      if (isSupplementTaken(item.supplementId)) return false;

      final scheduledTime = item.scheduledTime;
      if (scheduledTime != null) {
        // Parse time: "HH:mm"
        try {
          final parts = scheduledTime.split(':');
          final hour = int.parse(parts[0]);
          if (slot == 'morning') return hour < 12;
          if (slot == 'afternoon') return hour >= 12 && hour < 18;
          if (slot == 'evening') return hour >= 18 && hour < 21;
          if (slot == 'night') return hour >= 21;
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

      if (slot == 'morning') {
        return timeOfDay.contains('morning');
      }
      if (slot == 'afternoon') {
        return timeOfDay.contains('afternoon');
      }
      if (slot == 'evening') {
        return timeOfDay.contains('evening');
      }
      if (slot == 'night') {
        return timeOfDay.contains('night') || timeOfDay.contains('bed');
      }

      return false;
    }).toList();
  }

  Future<void> _updateTodayLog(LogEntry entry) async {
    final now = DateTime.now();
    final logicalToday = _getLogicalToday();

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
          id: '${_userId}_${logicalToday.toIso8601String().split('T').first}',
          userId: _userId,
          date: logicalToday,
          entries: entries,
          createdAt: now,
        );

    try {
      // Update local state and notify immediately for responsiveness
      _todayLog = log;
      notifyListeners();

      // Persist in background
      await _logRepository.saveLog(log);
    } catch (e) {
      _error = 'Failed to save log: $e';
      notifyListeners();
    }
  }

  /// Automatically cancel global reminders if everything is done for the day
  Future<void> _checkAndCancelGlobalNudges() async {
    if (_stacks.isEmpty) return;

    // Check if ALL items in ALL stacks are handled (taken or skipped)
    final allHandled = _stacks.expand((s) => s.items).every((item) {
      if (_todayLog == null) return false;
      return _todayLog!.entries.any(
        (e) =>
            e.supplementId == item.supplementId &&
            (e.status == LogStatus.taken || e.status == LogStatus.skipped),
      );
    });

    if (allHandled) {
      debugPrint(
          'Smart Nudge: All items handled. Skipping remaining nudges for today.');
      final nudgeTime = _settingsRepository.getNudgeTime();
      final nudgeEnabled = _settingsRepository.getNudgeModeEnabled();
      final warningOption = _settingsRepository.getWarningNudgeOption();

      if (!nudgeEnabled) return;

      // 1000: Primary
      await _notificationService.scheduleRecurringNotification(
        id: 1000,
        title: 'Time for your daily stack!',
        body: 'Keep your streak alive. Take your supplements now.',
        hour: nudgeTime.hour,
        minute: nudgeTime.minute,
        startFromTomorrow: true,
      );

      // 1001: Warning
      if (warningOption == '15m' || warningOption == 'followup') {
        int warningHour = nudgeTime.hour;
        int warningMinute = nudgeTime.minute + 15;
        if (warningMinute >= 60) {
          warningHour = (warningHour + 1) % 24;
          warningMinute = warningMinute - 60;
        }

        await _notificationService.scheduleRecurringNotification(
          id: 1001,
          title: 'Missed your stack?',
          body: 'Just a friendly nudge to log your supplements!',
          hour: warningHour,
          minute: warningMinute,
          startFromTomorrow: true,
        );
      }

      // 1002: Follow-up
      if (warningOption == 'followup' ||
          _settingsRepository.getExtendedRemindersEnabled()) {
        int secondHour = nudgeTime.hour;
        int secondMinute = nudgeTime.minute + 30;
        if (secondMinute >= 60) {
          secondHour = (secondHour + 1) % 24;
          secondMinute = secondMinute - 60;
        }

        await _notificationService.scheduleRecurringNotification(
          id: 1002,
          title: 'Still haven\'t logged?',
          body: 'Consistency is key! tracking helps your doctor help you.',
          hour: secondHour,
          minute: secondMinute,
          startFromTomorrow: true,
        );
      }

      // 2000: Evening summary
      await _notificationService.scheduleRecurringNotification(
        id: 2000,
        title: 'Daily Summary 🌙',
        body: 'Tap to see your progress for today!',
        hour: 20,
        minute: 0,
        startFromTomorrow: true,
      );
    }
  }

  DateTime _getLogicalToday() {
    final now = DateTime.now();
    if (now.hour < 4) {
      return DateTime(now.year, now.month, now.day)
          .subtract(const Duration(days: 1));
    }
    return DateTime(now.year, now.month, now.day);
  }

  Future<void> _cacheSupplements() async {
    debugPrint('Caching supplements...');
    final supplementIds = <String>{};
    for (final stack in _stacks) {
      for (final item in stack.items) {
        if (!_supplementCache.containsKey(item.supplementId)) {
          supplementIds.add(item.supplementId);
        }
      }
    }

    if (supplementIds.isEmpty) return;

    debugPrint('Parallel fetching ${supplementIds.length} supplements...');

    await Future.wait(supplementIds.map((id) async {
      try {
        final supplement = await _supplementRepository.getSupplement(id);
        if (supplement != null) {
          _supplementCache[id] = supplement;
        }
      } catch (e) {
        debugPrint('Failed to load supplement $id: $e');
      }
    }));
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  @override
  void notifyListeners() {
    if (!_isDisposed) {
      super.notifyListeners();
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
}
