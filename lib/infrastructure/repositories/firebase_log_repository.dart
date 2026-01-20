import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/daily_log.dart';
import '../../domain/repositories/log_repository.dart';

class FirebaseLogRepository implements LogRepository {
  final FirebaseFirestore _firestore;

  FirebaseLogRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<List<DailyLog>> getLogsByDateRange(
      String userId, DateTime start, DateTime end) async {
    try {
      final snapshot = await _firestore
          .collection('logs')
          .where('userId', isEqualTo: userId)
          .where('date', isGreaterThanOrEqualTo: start.toIso8601String())
          .where('date', isLessThanOrEqualTo: end.toIso8601String())
          .orderBy('date', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => DailyLog.fromJson({...doc.data(), 'id': doc.id}))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch logs by date range: $e');
    }
  }

  @override
  Future<DailyLog?> getLogForDate(String userId, DateTime date) async {
    try {
      final dateStr = _dateOnlyString(date);
      final snapshot = await _firestore
          .collection('logs')
          .where('userId', isEqualTo: userId)
          .where('date', isEqualTo: dateStr)
          .limit(1)
          .get();

      if (snapshot.docs.isEmpty) return null;
      return DailyLog.fromJson(
          {...snapshot.docs.first.data(), 'id': snapshot.docs.first.id});
    } catch (e) {
      throw Exception('Failed to fetch log for date: $e');
    }
  }

  @override
  Future<void> saveLog(DailyLog log) async {
    try {
      if (log.id.isEmpty) {
        // Create new log
        await _firestore.collection('logs').add(log.toJson());
      } else {
        // Update existing log
        await _firestore.collection('logs').doc(log.id).set(log.toJson());
      }
    } catch (e) {
      throw Exception('Failed to save log: $e');
    }
  }

  @override
  Future<int> getStreakCount(String userId) async {
    try {
      // Get recent logs ordered by date descending
      final logs = await getRecentLogs(userId, 90); // Check last 90 days

      if (logs.isEmpty) return 0;

      int streak = 0;
      DateTime checkDate = DateTime.now();

      for (final log in logs) {
        final logDate = log.date;
        final daysDiff = checkDate.difference(logDate).inDays;

        // Check if this log is for yesterday or the current streak date
        if (daysDiff == streak || (streak == 0 && daysDiff == 0)) {
          // Check if at least one supplement was taken
          final hasTaken =
              log.entries.any((entry) => entry.status == LogStatus.taken);
          if (hasTaken) {
            streak++;
            checkDate = logDate.subtract(const Duration(days: 1));
          } else {
            break; // Streak broken
          }
        } else {
          break; // Gap in dates
        }
      }

      return streak;
    } catch (e) {
      throw Exception('Failed to calculate streak: $e');
    }
  }

  @override
  Future<List<DailyLog>> getRecentLogs(String userId, int days) async {
    try {
      final startDate = DateTime.now().subtract(Duration(days: days));
      return getLogsByDateRange(userId, startDate, DateTime.now());
    } catch (e) {
      throw Exception('Failed to fetch recent logs: $e');
    }
  }

  @override
  Stream<DailyLog?> watchTodayLog(String userId) {
    final today = _dateOnlyString(DateTime.now());

    return _firestore
        .collection('logs')
        .where('userId', isEqualTo: userId)
        .where('date', isEqualTo: today)
        .limit(1)
        .snapshots()
        .map((snapshot) {
      if (snapshot.docs.isEmpty) return null;
      return DailyLog.fromJson(
          {...snapshot.docs.first.data(), 'id': snapshot.docs.first.id});
    });
  }

  @override
  Future<void> clearAllLogs(String userId) async {
    try {
      final batch = _firestore.batch();
      final snapshots = await _firestore
          .collection('logs')
          .where('userId', isEqualTo: userId)
          .get();

      for (var doc in snapshots.docs) {
        batch.delete(doc.reference);
      }

      await batch.commit();
    } catch (e) {
      throw Exception('Failed to clear logs: $e');
    }
  }

  String _dateOnlyString(DateTime date) {
    return DateTime(date.year, date.month, date.day)
        .toIso8601String()
        .split('T')
        .first;
  }
}
