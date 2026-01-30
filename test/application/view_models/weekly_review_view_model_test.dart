import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:neurostack_app/application/view_models/weekly_review_view_model.dart';
import 'package:neurostack_app/domain/repositories/log_repository.dart';
import 'package:neurostack_app/domain/entities/daily_log.dart';

// Generate mocks
@GenerateMocks([LogRepository])
import 'weekly_review_view_model_test.mocks.dart';

void main() {
  late MockLogRepository mockRepository;
  late WeeklyReviewViewModel viewModel;

  setUp(() {
    mockRepository = MockLogRepository();
    viewModel = WeeklyReviewViewModel(
      logRepository: mockRepository,
      userId: 'test_user',
    );
  });

  group('WeeklyReviewViewModel', () {
    test('initial state is correct', () {
      expect(viewModel.isLoading, false);
      expect(viewModel.streakDays, 0);
      expect(viewModel.focusImprovement, 0.0);
      expect(viewModel.consistencyMap, isEmpty);
    });

    test('fetchWeeklyStats calculates streak correctly', () async {
      final now = DateTime.now();
      final logs = [
        DailyLog(
          id: '1',
          userId: 'test_user',
          date: now,
          entries: [
            LogEntry(
                supplementId: 's1',
                takenAt: now,
                status: LogStatus.taken,
                slot: 'morning')
          ],
          createdAt: now,
        ),
        DailyLog(
          id: '2',
          userId: 'test_user',
          date: now.subtract(const Duration(days: 1)),
          entries: [
            LogEntry(
                supplementId: 's1',
                takenAt: now,
                status: LogStatus.taken,
                slot: 'morning')
          ],
          createdAt: now,
        ),
        DailyLog(
          id: '3',
          userId: 'test_user',
          date: now.subtract(const Duration(days: 2)),
          entries: [
            LogEntry(
                supplementId: 's1',
                takenAt: now,
                status: LogStatus.skipped,
                slot: 'morning') // Skipped breaks streak in current logic?
            // Actually logic says: hasLog = any(status == taken). So this is false.
          ],
          createdAt: now,
        ),
      ];

      when(mockRepository.getRecentLogs('test_user', 14))
          .thenAnswer((_) async => logs);

      await viewModel.fetchWeeklyStats();

      // Today (Taken) + Yesterday (Taken) = 2.
      // Day before (Skipped != Taken) -> break.
      expect(viewModel.streakDays, 2);
    });

    test('fetchWeeklyStats calculates consistency map', () async {
      final now = DateTime.now();
      // Let's mocking logs for today (Mon) and yesterday (Sun)
      // Assuming today is Mon for stable test mapping is tricky without injecting clock,
      // but logic uses DateTime.now().
      // reliable test: just check that it populates 7 days.

      when(mockRepository.getRecentLogs('test_user', 14))
          .thenAnswer((_) async => []);

      await viewModel.fetchWeeklyStats();

      expect(viewModel.consistencyMap.length, 7);
      // Since no logs, all should be 0 (Missed)
      expect(viewModel.consistencyMap.values.every((v) => v == 0), isTrue);
    });

    test('calculateFocusImprovement handles empty logs', () async {
      when(mockRepository.getRecentLogs('test_user', 14))
          .thenAnswer((_) async => []);

      await viewModel.fetchWeeklyStats();

      expect(viewModel.focusImprovement, 0.0);
    });

    test('calculateFocusImprovement logic', () async {
      final now = DateTime.now();
      // This week: avg 4
      // Last week: avg 2
      // Improvement should be 100%

      final thisWeekLog = DailyLog(
          id: '1',
          userId: 'test_user',
          date: now,
          entries: [],
          createdAt: now,
          focusScore: 4);

      final lastWeekLog = DailyLog(
          id: '2',
          userId: 'test_user',
          date: now.subtract(const Duration(days: 8)),
          entries: [],
          createdAt: now,
          focusScore: 2);

      when(mockRepository.getRecentLogs('test_user', 14))
          .thenAnswer((_) async => [thisWeekLog, lastWeekLog]);

      await viewModel.fetchWeeklyStats();

      expect(viewModel.focusImprovement, 100.0);
    });
  });
}
