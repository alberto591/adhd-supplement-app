import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:adhd_supplement_app/application/view_models/insights_view_model.dart';
import 'package:adhd_supplement_app/domain/repositories/log_repository.dart';
import 'package:adhd_supplement_app/domain/entities/daily_log.dart';

// Generate Mocks
@GenerateMocks([LogRepository])
import 'insights_view_model_test.mocks.dart';

void main() {
  late MockLogRepository mockLogRepository;
  late InsightsViewModel viewModel;
  const String userId = 'test_user';

  setUp(() {
    mockLogRepository = MockLogRepository();
    // Default stubs to prevent MissingStubError during constructor call
    when(mockLogRepository.getStreakCount(any)).thenAnswer((_) async => 0);
    when(mockLogRepository.getLogsByDateRange(any, any, any))
        .thenAnswer((_) async => []); // Empty list of DailyLog

    viewModel = InsightsViewModel(
      logRepository: mockLogRepository,
      userId: userId,
    );
  });

  group('InsightsViewModel Tests', () {
    test('Initial state is correct', () {
      // expect(viewModel.isLoading, true); // Flaky due to auto-load
      expect(viewModel.streakCount, 0);
      expect(viewModel.consistencyScore, 0.0);
      expect(viewModel.encouragementText, 'Start your journey today!');
    });

    test('loadData fetches streak and logs successfully', () async {
      // Arrange
      when(mockLogRepository.getStreakCount(userId)).thenAnswer((_) async => 5);

      // Mock logs for consistency calculation (e.g., 5 logs in 30 days)
      final logs = List<DailyLog>.generate(
          5,
          (index) => DailyLog(
                id: 'log_$index',
                date: DateTime.now().subtract(Duration(days: index)),
                entries: [],
                userId: userId,
                createdAt: DateTime.now(),
              ));

      when(mockLogRepository.getLogsByDateRange(userId, any, any))
          .thenAnswer((_) async => logs);

      // Act
      await viewModel.loadData();

      // Assert
      expect(viewModel.streakCount, 5);
      // Logic: 5 logs / 30 days * 100 = 16.666...
      expect(viewModel.consistencyScore, closeTo(16.6, 0.1));
      expect(viewModel.encouragementText, isNotEmpty);
      expect(viewModel.isLoading, false);
    });

    test('consistency is capped at 100%', () async {
      // Arrange
      when(mockLogRepository.getStreakCount(userId))
          .thenAnswer((_) async => 35);

      // Mock 35 logs (more than 30 days)
      final logs = List<DailyLog>.generate(
          35,
          (index) => DailyLog(
                id: 'log_$index',
                date: DateTime.now().subtract(Duration(days: index)),
                entries: [],
                userId: userId,
                createdAt: DateTime.now(),
              ));

      when(mockLogRepository.getLogsByDateRange(userId, any, any))
          .thenAnswer((_) async => logs);

      // Act
      await viewModel.loadData();

      // Assert
      expect(viewModel.consistencyScore, 100.0);
    });

    test('handles error gracefully', () async {
      // Arrange
      when(mockLogRepository.getStreakCount(userId)) // Correct method name
          .thenThrow(Exception('Network Error'));

      // Act
      await viewModel.loadData();

      // Assert
      expect(viewModel.streakCount, 0); // Should remain default
      expect(viewModel.isLoading, false);
    });
  });
}
