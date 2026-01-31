import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../utils/logger.dart';
import '../../domain/entities/supplement_stack.dart';
import '../../domain/entities/daily_log.dart';
import '../../domain/entities/supplement.dart';
import '../../domain/repositories/stack_repository.dart';
import '../../domain/repositories/log_repository.dart';
import '../../domain/repositories/supplement_repository.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/repositories/settings_repository.dart';
import '../../infrastructure/services/notification_service.dart';
import '../../infrastructure/services/sound_service.dart';
import '../../domain/services/analytics_service.dart';
import 'dart:async';

/// View model for the Daily Stack screen
/// Manages today's stacks, intake status, and progress tracking
class DailyStackViewModel extends ChangeNotifier {
  final StackRepository _stackRepository;
  final LogRepository _logRepository;
  final SupplementRepository _supplementRepository;
  final SettingsRepository _settingsRepository;
  final NotificationService _notificationService;
  final AuthRepository _authRepository;
  final AnalyticsService _analyticsService;
  final SoundService _soundService;
  final String _userId;

  // State
  List<SupplementStack> _stacks = [];
  DailyLog? _todayLog;
  final Map<String, Supplement> _supplementCache = {};
  int _streakCount = 0;
  bool _isLoading = false;
  String? _error;
  bool _isDisposed = false;
  final Set<String> _snoozedSupplements = {};
  final Set<String> _collapsedStackIds = {};
  bool _allCollapsed = false;
  StreamSubscription<List<SupplementStack>>? _stackSubscription;

  // Time-based slots
  List<StackItem> get morningItems => _getItemsForSlot('morning');
  List<StackItem> get afternoonItems => _getItemsForSlot('afternoon');
  List<StackItem> get eveningItems => _getItemsForSlot('evening');
  List<StackItem> get nightItems => _getItemsForSlot('night');

  /// Get the data for the "Up Next" routine card
  Map<String, dynamic>? get upcomingStack {
    final slot = _getCurrentRoutineSlot();
    if (slot == null) return null;

    final items = _getItemsForSlot(slot);
    if (items.isEmpty) return null;

    return {
      'slot': slot,
      'title': _getSlotTitle(slot),
      'subtitle': getSlotSubtitle(slot),
      'imagePath': getSlotImagePath(slot),
      'timeLabel': getSlotTimeLabel(slot),
      'items': items,
    };
  }

  String? _getCurrentRoutineSlot() {
    final now = DateTime.now();
    final nowMinutes = now.hour * 60 + now.minute;

    // Get configured times (defaulting if necessary)
    // final morningTime = _timeToMinutes(_settingsRepository.getSlotTime('morning'));
    final afternoonTime =
        _timeToMinutes(_settingsRepository.getSlotTime('afternoon'));
    final eveningTime =
        _timeToMinutes(_settingsRepository.getSlotTime('evening'));
    final nightTime = _timeToMinutes(_settingsRepository.getSlotTime('night'));

    // Determine current phase
    // Default order: Morning < Afternoon < Evening < Night
    // We check ranges.

    // Check Active Phase first
    if (nowMinutes < afternoonTime) {
      // In Morning Phase (before Afternoon starts)
      if (morningItems.isNotEmpty) return 'morning';
      // If Morning done, check Afternoon (Upcoming)
      if (afternoonItems.isNotEmpty) return 'afternoon';
      if (eveningItems.isNotEmpty) return 'evening';
      if (nightItems.isNotEmpty) return 'night';
    } else if (nowMinutes < eveningTime) {
      // In Afternoon Phase
      if (afternoonItems.isNotEmpty) return 'afternoon';
      // If Afternoon done, check Evening
      if (eveningItems.isNotEmpty) return 'evening';
      if (nightItems.isNotEmpty) return 'night';
      // Fallback: Check if Morning was missed?
      if (morningItems.isNotEmpty) return 'morning';
    } else if (nowMinutes < nightTime) {
      // In Evening Phase
      if (eveningItems.isNotEmpty) return 'evening';
      if (nightItems.isNotEmpty) return 'night';
      // Fallback: Missed previous?
      if (afternoonItems.isNotEmpty) return 'afternoon';
      if (morningItems.isNotEmpty) return 'morning';
    } else {
      // In Night Phase
      if (nightItems.isNotEmpty) return 'night';
      // Fallback: Missed previous?
      if (eveningItems.isNotEmpty) return 'evening';
      if (afternoonItems.isNotEmpty) return 'afternoon';
      if (morningItems.isNotEmpty) return 'morning';
    }

    return null;
  }

  int _timeToMinutes(TimeOfDay time) {
    return time.hour * 60 + time.minute;
  }

  String _getSlotTitle(String slot) {
    switch (slot.toLowerCase()) {
      case 'morning':
        return 'Morning';
      case 'afternoon':
        return 'Afternoon';
      case 'evening':
        return 'Evening';
      case 'night':
        return 'Night';
      default:
        // Capitalize default
        if (slot.isEmpty) return slot;
        return slot[0].toUpperCase() + slot.substring(1).toLowerCase();
    }
  }

  String getSlotSubtitle(String slot) {
    return slot.toLowerCase() == 'morning' ? 'Start your day' : 'Stay on track';
  }

  String getSlotImagePath(String slot) {
    switch (slot.toLowerCase()) {
      case 'morning':
        return 'assets/images/morning_slot.png';
      case 'afternoon':
        return 'assets/images/afternoon_slot.png';
      case 'evening':
        return 'assets/images/evening_slot.png';
      case 'night':
        return 'assets/images/night_slot.png';
      default:
        return 'assets/images/morning_slot.png';
    }
  }

  String getSlotTimeLabel(String slot) {
    if (slot.toLowerCase() == 'night') return 'Before Bed';

    try {
      final time = _settingsRepository.getSlotTime(slot.toLowerCase());
      final hour =
          time.hour == 0 ? 12 : (time.hour > 12 ? time.hour - 12 : time.hour);
      final amPm = time.hour >= 12 ? 'PM' : 'AM';
      final minute = time.minute.toString().padLeft(2, '0');
      return 'Before $hour:$minute $amPm';
    } catch (_) {
      return '';
    }
  }

  /// Helper to get slot from stack name (internal consistency)
  String _getSlotFromName(String name) {
    final lower = name.toLowerCase();
    if (lower.contains('morning') || lower.contains('startup')) {
      return 'morning';
    }
    if (lower.contains('afternoon') || lower.contains('boost')) {
      return 'afternoon';
    }
    if (lower.contains('evening')) return 'evening';
    if (lower.contains('night') || lower.contains('recovery')) return 'night';
    return lower;
  }

  /// Get all items that were skipped today
  List<StackItem> get skippedItems {
    final List<StackItem> result = [];
    for (final stack in _stacks) {
      final slot = _getSlotFromName(stack.name);
      result.addAll(stack.items
          .where((item) => isSupplementSkipped(item.supplementId, slot: slot)));
    }
    return result;
  }

  // Getters
  List<SupplementStack> get stacks => _stacks;
  DailyLog? get todayLog => _todayLog;
  int get streakCount => _streakCount;
  bool get isLoading => _isLoading;
  String? get error => _error;
  Set<String> get snoozedSupplements => _snoozedSupplements;
  Set<String> get collapsedStackIds => _collapsedStackIds;
  bool get allCollapsed => _allCollapsed;

  /// Get all items that are pending (neither taken nor skipped)
  List<StackItem> get pendingItems {
    final List<StackItem> result = [];
    for (final stack in _stacks) {
      final slot = _getSlotFromName(stack.name);
      result.addAll(stack.items.where((item) =>
          !isSupplementTaken(item.supplementId, slot: slot) &&
          !isSupplementSkipped(item.supplementId, slot: slot)));
    }
    return result;
  }

  /// Whether there are any skipped items today
  bool get hasSkippedItems {
    return _stacks
        .any((s) => s.items.any((i) => isSupplementSkipped(i.supplementId)));
  }

  /// Calculate today's progress as a percentage (0.0 - 1.0)
  /// Calculate today's progress as a percentage (0.0 - 1.0)
  double get todayProgress {
    if (_stacks.isEmpty) return 0.0;

    int totalScheduledItems = 0;
    int completedItems = 0;

    for (final stack in _stacks) {
      final stackSlot = _getSlotFromName(stack.name);

      for (final item in stack.items) {
        totalScheduledItems++;

        if (isSupplementTaken(item.supplementId, slot: stackSlot) ||
            isSupplementSkipped(item.supplementId, slot: stackSlot)) {
          completedItems++;
        }
      }
    }

    if (totalScheduledItems == 0) return 0.0;
    // Cap at 1.0 just in case
    return (completedItems / totalScheduledItems).clamp(0.0, 1.0);
  }

  /// Get count of completed stacks vs total
  String get progressText {
    if (_stacks.isEmpty) return 'No stacks configured';

    int completedStacks = 0;
    for (final stack in _stacks) {
      if (stack.items.isEmpty) continue;

      final stackSlot = _getSlotFromName(stack.name);

      final allHandled = stack.items.every((item) {
        return isSupplementTaken(item.supplementId, slot: stackSlot) ||
            isSupplementSkipped(item.supplementId, slot: stackSlot);
      });

      if (allHandled) {
        completedStacks++;
      }
    }

    return '$completedStacks/${_stacks.length} Stacks Completed';
  }

  /// Get the target time for a specific slot
  TimeOfDay getSlotTime(String slot) {
    return _settingsRepository.getSlotTime(slot);
  }

  DailyStackViewModel({
    required StackRepository stackRepository,
    required LogRepository logRepository,
    required SupplementRepository supplementRepository,
    required SettingsRepository settingsRepository,
    required NotificationService notificationService,
    required AuthRepository authRepository,
    required AnalyticsService analyticsService,
    required SoundService soundService,
    required String userId,
  })  : _stackRepository = stackRepository,
        _logRepository = logRepository,
        _supplementRepository = supplementRepository,
        _settingsRepository = settingsRepository,
        _notificationService = notificationService,
        _authRepository = authRepository,
        _analyticsService = analyticsService,
        _soundService = soundService,
        _userId = userId;

  /// Initialize the view model - load stacks, today's log, and streak
  Future<void> initialize() async {
    _setLoading(true);
    _error = null;

    if (_userId.isEmpty) {
      _error = 'User not authenticated';
      _setLoading(false);
      return;
    }

    try {
      AppLogger.i('Initializing DailyStackViewModel for user: $_userId');
      AppLogger.d('Initialize StackTrace: ${StackTrace.current}'); // DEBUG LOOP
      final logicalToday = _getLogicalToday();
      AppLogger.d('Logical today determined as: $logicalToday');

      // Load in parallel with timeouts
      AppLogger.d('Starting parallel data load (Stacks, Log, Streak)...');
      final results = await Future.wait([
        _stackRepository.getUserStacks(_userId),
        _logRepository.getLogForDate(_userId, logicalToday),
        _logRepository.getStreakCount(_userId),
      ]);
      AppLogger.d('Parallel data load complete.');

      _stacks = results[0] as List<SupplementStack>;
      _todayLog = results[1] as DailyLog?;
      _streakCount = results[2] as int;

      // Notify immediately so UI shows structure (with "Loading..." for missing supplements)
      notifyListeners();

      // Cache supplements for display
      await _cacheSupplements();
      await _processEmergencyCleanup(); // Cleanup stale references
      notifyListeners();

      // Listen for future updates
      _stackSubscription?.cancel();
      _stackSubscription =
          _stackRepository.watchUserStacks(_userId).listen((updatedStacks) {
        AppLogger.i(
            'REACTIVE UPDATE: Received ${updatedStacks.length} stacks for user $_userId');
        // DEBUG LOG
        for (var s in updatedStacks) {
          AppLogger.d(
              'Stack: ${s.name} (${s.timeOfDay}) - ${s.items.length} items');
        }
        _stacks = List.from(updatedStacks);
        notifyListeners(); // Notify immediately so UI shows new cards (even if loading supps)
        _cacheSupplements().then((_) {
          notifyListeners();
        });
      });

      _snoozedSupplements.clear();

      // Check for achievements on load
      final currentUser = await _authRepository.getCurrentUser();

      // Streak Bagdes
      if (_streakCount >= 3) {
        await unlockAchievement('consistency_champion');
      }
      if (_streakCount >= 7) {
        await unlockAchievement('7_day_warrior');
      }
      if (_streakCount >= 30) {
        await unlockAchievement('30_day_legend');
      }

      // Level Badges
      // Level Badges
      if ((currentUser?.level ?? 1) >= 10) {
        await unlockAchievement('focus_adept');
      }
    } catch (e) {
      _error = 'Failed to load daily stack: $e';
      AppLogger.e(_error!);
    } finally {
      _setLoading(false);
    }
  }

  /// Mark a supplement as taken
  /// Mark a supplement as taken
  Future<void> markSupplementTaken(String supplementId, {String? slot}) async {
    _snoozedSupplements.remove(supplementId);
    AppLogger.d('Marking supplement as taken: $supplementId (Slot: $slot)');
    HapticFeedback.heavyImpact();
    _soundService.playTriumphant();
    final now = DateTime.now();
    final entry = LogEntry(
      supplementId: supplementId,
      takenAt: now,
      status: LogStatus.taken,
      confidenceScore: 5, // Default to high certainty for manual logs
      slot: slot?.toLowerCase(),
    );

    await _updateTodayLog(entry);

    await _analyticsService.logEvent('dose_logged', parameters: {
      'supplement_id': supplementId,
      'status': 'taken',
      'slot': slot?.toLowerCase() ?? 'unknown',
    });

    AppLogger.d('Today log updated for $supplementId');

    // Give 10 XP per supplement taken
    await _incrementUserXP(10);

    // Cancel any active nudges for this supplement
    try {
      await _notificationService.cancelAllSupplementNudges(supplementId);
      await _checkAndCancelGlobalNudges();
    } catch (e) {
      AppLogger.e('Failed to cancel nudges', e);
    }
  }

  /// Mark multiple supplements as taken efficiently
  Future<void> markBatchTaken(List<String> supplementIds,
      {String? slot}) async {
    if (supplementIds.isEmpty) return;

    AppLogger.d(
        'Batch marking ${supplementIds.length} supplements as taken (Slot: $slot)');
    HapticFeedback.heavyImpact();
    _soundService.playTriumphant();

    final now = DateTime.now();
    final newEntries = supplementIds.map((id) {
      _snoozedSupplements.remove(id);
      return LogEntry(
        supplementId: id,
        takenAt: now,
        status: LogStatus.taken,
        confidenceScore: 5,
        slot: slot?.toLowerCase(),
      );
    }).toList();

    await _updateTodayLogBatch(newEntries);

    // Batch analytics logging
    for (final id in supplementIds) {
      await _analyticsService.logEvent('dose_logged', parameters: {
        'supplement_id': id,
        'status': 'taken',
        'slot': slot?.toLowerCase() ?? 'unknown',
        'is_batch': true,
      });
    }

    // Give XP per supplement (10 XP each)
    await _incrementUserXP(10 * supplementIds.length);

    // Cancel nudges
    try {
      await Future.wait(supplementIds
          .map((id) => _notificationService.cancelAllSupplementNudges(id)));
      await _checkAndCancelGlobalNudges();
    } catch (e) {
      AppLogger.e('Failed to cancel nudges in batch', e);
    }
  }

  Future<void> _incrementUserXP(int amount) async {
    try {
      final user = await _authRepository.getCurrentUser();
      if (user != null) {
        final updatedUser = user.copyWith(xp: user.xp + amount);
        await _authRepository.updateUserProfile(updatedUser);
        AppLogger.d('XP Added: $amount. Total: ${updatedUser.xp}');
      }
    } catch (e) {
      AppLogger.e('Failed to update user XP', e);
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

          await _analyticsService.logEvent('achievement_unlocked', parameters: {
            'achievement_id': achievementId,
          });

          AppLogger.d('Achievement Unlocked: $achievementId');
        }
      }
    } catch (e) {
      AppLogger.e('Failed to unlock achievement', e);
    }
  }

  /// Mark a supplement as skipped
  /// Mark a supplement as skipped
  Future<void> markSupplementSkipped(String supplementId,
      {String? reason, String? slot}) async {
    _snoozedSupplements.remove(supplementId);
    HapticFeedback.lightImpact();
    final now = DateTime.now();
    final entry = LogEntry(
      supplementId: supplementId,
      takenAt: now,
      status: LogStatus.skipped,
      skippedReason: reason,
      slot: slot?.toLowerCase(),
    );

    await _updateTodayLog(entry);

    // Cancel any active nudges for this supplement
    try {
      await _notificationService.cancelAllSupplementNudges(supplementId);
      await _checkAndCancelGlobalNudges();
    } catch (e) {
      AppLogger.e('Failed to cancel nudges', e);
    }
  }

  Future<void> toggleSupplement(String supplementId, {String? slot}) async {
    final normalizedSlot = slot?.toLowerCase();
    final isTaken = isSupplementTaken(supplementId, slot: normalizedSlot);
    final isSkipped = isSupplementSkipped(supplementId, slot: normalizedSlot);

    if (isTaken || isSkipped) {
      // Remove the entry (undo / unskip)
      // Note: _deleteFromTodayLog needs to be slot-aware or we might delete the wrong entry if multiple exist
      // For now, simpler approach: find entry matching ID and Status (and slot) and remove it.
      await _deleteFromTodayLog(supplementId, slot: normalizedSlot);
    } else {
      await markSupplementTaken(supplementId, slot: normalizedSlot);
    }
  }

  /// Toggle expansion state of a stack
  void toggleStackExpansion(String stackId) {
    if (_collapsedStackIds.contains(stackId)) {
      _collapsedStackIds.remove(stackId);
    } else {
      _collapsedStackIds.add(stackId);
    }

    // Update allCollapsed state
    if (_collapsedStackIds.length == _stacks.length) {
      _allCollapsed = true;
    } else if (_collapsedStackIds.isEmpty) {
      _allCollapsed = false;
    }

    notifyListeners();
  }

  /// Toggle expansion for ALL stacks
  void toggleAllExpansion() {
    if (_allCollapsed) {
      _collapsedStackIds.clear();
      _allCollapsed = false;
    } else {
      // Add all dynamic stack IDs
      for (final stack in _stacks) {
        _collapsedStackIds.add(stack.id);
      }
      // Also add standard dashboard slot IDs to ensure Dashboard collapses too
      _collapsedStackIds.addAll(['morning', 'afternoon', 'evening', 'night']);
      _allCollapsed = true;
    }
    notifyListeners();
  }

  /// Snooze a persistent nudge for a supplement
  Future<void> snoozeSupplement(String supplementId) async {
    final supplement = _supplementCache[supplementId];
    if (supplement == null) return;

    await _notificationService.snoozePersistentNudge(
      supplementId: supplementId,
      title: 'Time for ${supplement.name}',
      body: 'Snoozed for 5 minutes. Don\'t forget your focus stack!',
    );
    _snoozedSupplements.add(supplementId);
    notifyListeners();
  }

  bool isSupplementSnoozed(String supplementId) {
    return _snoozedSupplements.contains(supplementId);
  }

  /// Check if a supplement has been taken today (optionally in a specific slot)
  bool isSupplementTaken(String supplementId, {String? slot}) {
    if (_todayLog == null) return false;
    return _todayLog!.entries.any(
      (e) {
        final idMatch = e.supplementId == supplementId;
        final statusMatch = e.status == LogStatus.taken;
        // If slot is provided, match it. If log has no slot (legacy), assume global match (or ignore slot? Let's assume strict if slot provided)
        // Better logic: If we are checking for a specific slot, we only care if it was taken IN THAT SLOT.
        // If the log entry has NO slot, it might be a legacy global take.
        // Let's decide: New system requires slot matching if provided.
        final slotMatch =
            slot == null || e.slot?.toLowerCase() == slot.toLowerCase();
        return idMatch && statusMatch && slotMatch;
      },
    );
  }

  /// Check if a supplement has been skipped today
  bool isSupplementSkipped(String supplementId, {String? slot}) {
    if (_todayLog == null) return false;
    return _todayLog!.entries.any(
      (e) {
        final idMatch = e.supplementId == supplementId;
        final statusMatch = e.status == LogStatus.skipped;
        final slotMatch =
            slot == null || e.slot?.toLowerCase() == slot.toLowerCase();
        return idMatch && statusMatch && slotMatch;
      },
    );
  }

  /// Get supplement details from cache
  Supplement? getSupplement(String id) {
    final cached = _supplementCache[id];
    if (cached != null) return cached;

    // Trigger an async load but return null for now to avoid blocking
    // The UI will rebuild when the cache is populated
    _loadSupplementSilently(id);
    return null;
  }

  Future<void> _loadSupplementSilently(String id) async {
    try {
      final s = await _supplementRepository.getSupplement(id, userId: _userId);
      if (s != null) {
        _supplementCache[id] = s;
        notifyListeners();
      }
    } catch (e) {
      AppLogger.e('Error loading supplement $id silently', e);
    }
  }

  /// Save state ratings for today
  Future<void> saveStateRatings(Map<String, int> ratings) async {
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

    final updatedLog = log.copyWith(stateRatings: ratings);
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

  /// Get formatted time status string for a given item
  String? getItemTimeStatus(StackItem item) {
    final supplement = _supplementCache[item.supplementId];
    String? timeStr = item.scheduledTime;

    // If no specific scheduled time, use the slot default
    if (timeStr == null && supplement?.timeOfDay != null) {
      final slot = supplement!.timeOfDay!.toLowerCase();
      String? normalizedSlot;
      if (slot.contains('morning')) {
        normalizedSlot = 'morning';
      } else if (slot.contains('afternoon')) {
        normalizedSlot = 'afternoon';
      } else if (slot.contains('evening')) {
        normalizedSlot = 'evening';
      } else if (slot.contains('night')) {
        normalizedSlot = 'night';
      }

      if (normalizedSlot != null) {
        final time = _settingsRepository.getSlotTime(normalizedSlot);
        timeStr =
            '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
      }
    }

    if (timeStr == null) return null;

    try {
      final now = DateTime.now();
      final parts = timeStr.split(':');
      final target = DateTime(now.year, now.month, now.day, int.parse(parts[0]),
          int.parse(parts[1]));
      final diff = target.difference(now);

      if (diff.isNegative) {
        if (diff.abs().inHours > 4) {
          return 'Overdue';
        }
        return 'Overdue by ${diff.abs().inMinutes}m';
      } else {
        if (diff.inHours > 0) {
          return 'in ${diff.inHours}h ${diff.inMinutes % 60}m';
        }
        return 'in ${diff.inMinutes}m';
      }
    } catch (_) {
      return null;
    }
  }

  /// Get formatted time status string for a given time slots
  String? getTimeStatus(String? timeOfDay) {
    if (timeOfDay == null) return null;

    // Normalize string
    final slot = timeOfDay.toLowerCase();
    if (!['morning', 'afternoon', 'evening', 'night'].contains(slot)) {
      return null;
    }
    final targetTime = _settingsRepository.getSlotTime(slot);

    final now = DateTime.now();
    final target = DateTime(
        now.year, now.month, now.day, targetTime.hour, targetTime.minute);
    final diff = target.difference(now);

    if (diff.isNegative) {
      // If overdue by more than 4 hours, just say "Today" or simplified status
      // But user requested "Time Urgency", so "Overdue" is good.
      if (diff.abs().inHours > 4) {
        return 'Overdue';
      }
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
    // Note: _checkForDayRollover() removed to prevent infinite build loops.
    // Rollover checks should be handled via Lifecycle/Timer events.

    final List<StackItem> items = [];

    for (final stack in _stacks) {
      final stackSlot = _getSlotFromName(stack.name);
      final isMatch = stackSlot == slot.toLowerCase() ||
          stack.timeOfDay?.toLowerCase() == slot.toLowerCase();

      AppLogger.d(
          'Checking stack ${stack.name} for slot $slot. Match: $isMatch');

      if (isMatch) {
        for (final item in stack.items) {
          // Filter out already taken or skipped items (as per user preference)
          // Pass the calculated stackSlot to allow multi-dose tracking
          final taken = isSupplementTaken(item.supplementId, slot: stackSlot);
          final skipped =
              isSupplementSkipped(item.supplementId, slot: stackSlot);

          if (taken || skipped) {
            AppLogger.d(
                'Skipping item ${item.supplementId} (Taken: $taken, Skipped: $skipped)');
            continue;
          }

          final exists = items.any((i) => i.supplementId == item.supplementId);
          if (!exists) {
            items.add(item);
          }
        }
      }
    }
    return items;
  }

  void checkForDayRollover() {
    AppLogger.i('checkForDayRollover called from: ${StackTrace.current}');
    if (_todayLog == null) return;

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    // If the log date is not today, we need to re-initialize
    if (!_isSameDay(_todayLog!.date, today)) {
      AppLogger.i('Day rollover detected. Refreshing Daily Log...');
      initialize();
    }
  }

  bool _isSameDay(DateTime d1, DateTime d2) {
    return d1.year == d2.year && d1.month == d2.month && d1.day == d2.day;
  }

  Future<void> _updateTodayLogBatch(List<LogEntry> newEntries) async {
    final now = DateTime.now();
    final logicalToday = _getLogicalToday();

    List<LogEntry> currentEntries = _todayLog?.entries.toList() ?? [];

    // Remove existing entries that conflict with new ones (same ID and slot)
    for (final newEntry in newEntries) {
      currentEntries.removeWhere((e) =>
          e.supplementId == newEntry.supplementId && e.slot == newEntry.slot);
    }

    // Add new entries
    currentEntries.addAll(newEntries);

    final log = _todayLog?.copyWith(entries: currentEntries) ??
        DailyLog(
          id: '${_userId}_${logicalToday.toIso8601String().split('T').first}',
          userId: _userId,
          date: logicalToday,
          entries: currentEntries,
          createdAt: now,
        );

    try {
      _todayLog = log;
      notifyListeners();
      await _logRepository.saveLog(log);
    } catch (e) {
      _error = 'Failed to save batch log: $e';
      notifyListeners();
    }
  }

  Future<void> _updateTodayLog(LogEntry entry) async {
    final now = DateTime.now();
    final logicalToday = _getLogicalToday();

    List<LogEntry> entries;
    if (_todayLog != null) {
      // Replace existing entry for same supplement AND slot, or add new
      // This allows multi-dose supplements (e.g. Morning vs Afternoon) to coexist in the log
      entries = _todayLog!.entries.where((e) {
        final sameSupp = e.supplementId == entry.supplementId;
        final sameSlot = e.slot == entry.slot;
        return !(sameSupp && sameSlot);
      }).toList();
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

  /// Remove an entry from today's log for a specific supplement
  Future<void> _deleteFromTodayLog(String supplementId, {String? slot}) async {
    if (_todayLog == null) return;

    final updatedEntries = _todayLog!.entries.where((e) {
      if (e.supplementId != supplementId) return true;
      // If matching supplement, check slot
      if (slot != null && e.slot?.toLowerCase() != slot.toLowerCase()) {
        return true;
      }
      // If we are deleting a specific slot but the entry has no slot (legacy),
      // we might want to keep it or delete it?
      // Strict matching: If slot requested, only delete if slot matches.
      // If slot NOT requested (shouldn't happen with new logic), delete all for ID?
      // Let's assume strict:
      if (slot == null && e.slot != null) return true;

      return false; // Delete this one
    }).toList();

    final updatedLog = _todayLog!.copyWith(entries: updatedEntries);

    try {
      _todayLog = updatedLog;
      notifyListeners();
      await _logRepository.saveLog(updatedLog);
    } catch (e) {
      _error = 'Failed to update log: $e';
      notifyListeners();
    }
  }

  /// Automatically cancel global reminders if everything is done for the day
  Future<void> _checkAndCancelGlobalNudges() async {
    if (_stacks.isEmpty) return;

    // Check if ALL items in ALL stacks are handled (taken or skipped)
    final allHandled = _stacks.every((stack) {
      final slot = _getSlotFromName(stack.name);
      return stack.items.every((item) {
        return isSupplementTaken(item.supplementId, slot: slot) ||
            isSupplementSkipped(item.supplementId, slot: slot);
      });
    });

    if (allHandled) {
      AppLogger.d(
          'Smart Nudge: All items handled. Canceling all remaining nudges for today.');

      // Cancel all global nudge notifications for today
      await _notificationService.cancelNotification(1000);
      await _notificationService.cancelNotification(1001);
      await _notificationService.cancelNotification(1002);
    }
  }

  DateTime _getLogicalToday() {
    // Centralized 4 AM rollover logic from date_utils.dart
    final now = DateTime.now();
    if (now.hour < 4) {
      return DateTime(now.year, now.month, now.day)
          .subtract(const Duration(days: 1));
    }
    return DateTime(now.year, now.month, now.day);
  }

  Future<void> _cacheSupplements() async {
    AppLogger.d('Caching supplements...');
    final supplementIds = <String>{};
    for (final stack in _stacks) {
      for (final item in stack.items) {
        if (!_supplementCache.containsKey(item.supplementId) &&
            item.supplementId.isNotEmpty) {
          supplementIds.add(item.supplementId);
        }
      }
    }

    if (supplementIds.isEmpty) return;

    AppLogger.d('Parallel fetching ${supplementIds.length} supplements...');

    await Future.wait(supplementIds.map((id) async {
      try {
        final supplement =
            await _supplementRepository.getSupplement(id, userId: _userId);
        if (supplement != null) {
          _supplementCache[id] = supplement;
        } else {
          AppLogger.w('Supplement $id not found in repository.');
        }
      } catch (e) {
        AppLogger.e('Failed to load supplement $id', e);
      }
    }));

    notifyListeners(); // Ensure UI redraws after cache update
  }

  /// Emergency cleanup for stale supplement references (Requested by user)
  Future<void> _processEmergencyCleanup() async {
    const targetId = 'mtWLM7ov7flnmZEflZgw';
    bool cleanupPerformed = false;

    // We work on a copy to avoid concurrent modification issues
    final updatedStacks = List<SupplementStack>.from(_stacks);

    for (int i = 0; i < updatedStacks.length; i++) {
      final stack = updatedStacks[i];
      final originalItemCount = stack.items.length;
      final newItems =
          stack.items.where((it) => it.supplementId != targetId).toList();

      if (newItems.length != originalItemCount) {
        // This stack had the bad ID
        AppLogger.i(
            'CLEANUP: Removing stale supplement $targetId from stack ${stack.name}');
        final updatedStack = stack.copyWith(
          items: newItems,
          updatedAt: DateTime.now(),
        );
        await _stackRepository.saveStack(_userId, updatedStack);
        updatedStacks[i] = updatedStack;
        cleanupPerformed = true;
      }
    }

    if (cleanupPerformed) {
      _stacks = updatedStacks;
      AppLogger.i('Emergency cleanup for $targetId completed successfully.');
      notifyListeners();
    }
  }

  /// Remove a supplement from a specific stack (slot)
  Future<void> removeSupplementFromStack(
      String supplementId, String slot) async {
    final normalizedSlot = slot.toLowerCase();
    AppLogger.i(
        'Removing supplement $supplementId from stack: $normalizedSlot');

    // Find the matching stack
    final stackIndex = _stacks.indexWhere((s) {
      final stackSlot = _getSlotFromName(s.name);
      return stackSlot == normalizedSlot ||
          s.timeOfDay?.toLowerCase() == normalizedSlot;
    });

    if (stackIndex == -1) {
      AppLogger.w('No stack found for slot: $normalizedSlot');
      return;
    }

    final stack = _stacks[stackIndex];
    final updatedItems =
        stack.items.where((item) => item.supplementId != supplementId).toList();

    if (updatedItems.length == stack.items.length) {
      AppLogger.w('Supplement $supplementId not found in stack: ${stack.name}');
      return;
    }

    final updatedStack = stack.copyWith(
      items: updatedItems,
      updatedAt: DateTime.now(),
    );

    try {
      // Update local state for immediate feedback
      _stacks[stackIndex] = updatedStack;

      // Also remove from today's log if it was taken/skipped to clear it from dashboard
      await _deleteFromTodayLog(supplementId, slot: normalizedSlot);

      notifyListeners();

      // Persist to repository
      await _stackRepository.saveStack(_userId, updatedStack);

      await _analyticsService
          .logEvent('supplement_removed_from_stack', parameters: {
        'supplement_id': supplementId,
        'slot': normalizedSlot,
      });

      AppLogger.i('Successfully removed $supplementId from ${stack.name}');
    } catch (e) {
      _error = 'Failed to remove supplement: $e';
      AppLogger.e(_error!);
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    _stackSubscription?.cancel();
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
