import '../entities/daily_state_checkin.dart';

abstract class CheckInRepository {
  /// Log a new state check-in
  Future<void> logCheckIn(DailyStateCheckIn checkIn);

  /// Get all check-ins for a user
  Future<List<DailyStateCheckIn>> getCheckIns(String userId);

  /// Get check-ins within a date range
  Future<List<DailyStateCheckIn>> getCheckInsByDateRange(
    String userId,
    DateTime startDate,
    DateTime endDate,
  );

  /// Get the most recent check-in
  Future<DailyStateCheckIn?> getLatestCheckIn(String userId);

  /// Check if user has checked in today
  Future<bool> hasCheckedInToday(String userId);

  /// Delete a check-in
  Future<void> deleteCheckIn(String id);
}
