import 'package:flutter_test/flutter_test.dart';
import 'package:adhd_supplement_app/presentation/view_models/daily_stack_view_model.dart';
import 'package:adhd_supplement_app/domain/repositories/stack_repository.dart';
import 'package:adhd_supplement_app/domain/repositories/log_repository.dart';
import 'package:adhd_supplement_app/domain/repositories/supplement_repository.dart';
import 'package:adhd_supplement_app/domain/entities/supplement_stack.dart';
import 'package:adhd_supplement_app/domain/entities/daily_log.dart';
import 'package:adhd_supplement_app/domain/entities/supplement.dart';

// Fakes for cleaner manual testing without mockito's "when" null-safety issues
class FakeStackRepository implements StackRepository {
  List<SupplementStack> stacks = [];
  String? lastUserId;

  @override
  Future<List<SupplementStack>> getUserStacks(String userId) async {
    lastUserId = userId;
    return stacks;
  }

  @override
  Future<SupplementStack?> getStack(String userId) async => null;

  @override
  Future<void> saveStack(String userId, SupplementStack stack) async {}
}

class FakeLogRepository implements LogRepository {
  DailyLog? todayLog;
  int streakCount = 0;
  DailyLog? lastSavedLog;

  @override
  Future<DailyLog?> getLogForDate(String userId, DateTime date) async =>
      todayLog;
  @override
  Future<int> getStreakCount(String userId) async => streakCount;
  @override
  Future<void> saveLog(DailyLog log) async {
    lastSavedLog = log;
    todayLog = log;
  }

  @override
  Future<List<DailyLog>> getLogsByDateRange(
          String userId, DateTime start, DateTime end) async =>
      [];
  @override
  Future<List<DailyLog>> getRecentLogs(String userId, int days) async => [];
  @override
  Stream<DailyLog?> watchTodayLog(String userId) => Stream.value(todayLog);
}

class FakeSupplementRepository implements SupplementRepository {
  final Map<String, Supplement> supplements = {};

  @override
  Future<Supplement?> getSupplement(String id) async => supplements[id];

  @override
  Future<List<Supplement>> searchSupplements(String query) async => [];
  @override
  Future<List<Supplement>> getSupplementsByCategory(String category) async =>
      [];
  @override
  Stream<List<Supplement>> watchSupplements() => Stream.value([]);
  @override
  Future<List<Supplement>> getAllSupplements() async =>
      supplements.values.toList();
  @override
  Future<void> trackReferralClick(String supplementId) async {}
}

void main() {
  late DailyStackViewModel viewModel;
  late FakeStackRepository fakeStackRepo;
  late FakeLogRepository fakeLogRepo;
  late FakeSupplementRepository fakeSupplementRepo;
  const String userId = 'test-user';

  const testSupplement = Supplement(
    id: 'supp1',
    name: 'Magnesium',
    category: 'Mineral',
    dosage: '200mg',
    timeOfDay: 'evening',
    benefits: ['Sleep'],
    description: 'Relaxation',
    referralUrl: '',
    sideEffects: [],
    interactions: [],
    focusLevel: 3,
  );

  final testStack = SupplementStack(
    id: 'stack1',
    userId: userId,
    name: 'Evening Routine',
    items: [
      const StackItem(supplementId: 'supp1', order: 1, scheduledTime: '20:00'),
      const StackItem(supplementId: 'supp2', order: 2, scheduledTime: '08:00'),
    ],
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  );

  setUp(() {
    fakeStackRepo = FakeStackRepository();
    fakeLogRepo = FakeLogRepository();
    fakeSupplementRepo = FakeSupplementRepository();
    viewModel = DailyStackViewModel(
      stackRepository: fakeStackRepo,
      logRepository: fakeLogRepo,
      supplementRepository: fakeSupplementRepo,
      userId: userId,
    );
  });

  group('DailyStackViewModel Tests (with Fakes)', () {
    test('initialize loads data and caches supplements', () async {
      fakeStackRepo.stacks = [testStack];
      fakeLogRepo.streakCount = 5;
      fakeSupplementRepo.supplements['supp1'] = testSupplement;
      fakeSupplementRepo.supplements['supp2'] =
          testSupplement.copyWith(id: 'supp2', timeOfDay: 'morning');

      await viewModel.initialize();

      expect(viewModel.stacks.length, 1);
      expect(viewModel.streakCount, 5);
      expect(viewModel.getSupplement('supp1'), isNotNull);
      expect(viewModel.morningItems.length, 1);
      expect(viewModel.eveningItems.length, 1);
    });

    test('todayProgress calculates correctly', () async {
      fakeStackRepo.stacks = [testStack];
      fakeLogRepo.todayLog = DailyLog(
        id: 'log1',
        userId: userId,
        date: DateTime.now(),
        entries: [
          LogEntry(supplementId: 'supp1', takenAt: DateTime.now(), taken: true),
        ],
        createdAt: DateTime.now(),
      );

      await viewModel.initialize();

      // total items = 2, completed = 1
      expect(viewModel.todayProgress, 0.5);
    });

    test('toggleSupplement marks as taken and updates log', () async {
      fakeStackRepo.stacks = [testStack];
      fakeSupplementRepo.supplements['supp1'] = testSupplement;
      fakeSupplementRepo.supplements['supp2'] = testSupplement;

      await viewModel.initialize();
      expect(viewModel.isSupplementTaken('supp1'), false);

      await viewModel.toggleSupplement('supp1');

      expect(viewModel.isSupplementTaken('supp1'), true);
      expect(fakeLogRepo.lastSavedLog, isNotNull);
      expect(
          fakeLogRepo.lastSavedLog!.entries
              .any((e) => e.supplementId == 'supp1' && e.taken),
          true);
    });

    test('greeting is one of the valid options', () {
      final validGreetings = [
        'Good Morning',
        'Good Afternoon',
        'Good Evening',
        'Good Night'
      ];
      expect(validGreetings.contains(viewModel.greeting), true);
    });
  });
}
