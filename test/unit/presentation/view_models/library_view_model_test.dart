import 'package:flutter_test/flutter_test.dart';
import 'package:adhd_supplement_app/presentation/view_models/library_view_model.dart';
import 'package:adhd_supplement_app/domain/entities/supplement.dart';
import 'package:adhd_supplement_app/domain/entities/supplement_stack.dart';
import 'package:adhd_supplement_app/domain/repositories/supplement_repository.dart';
import 'package:adhd_supplement_app/domain/repositories/stack_repository.dart';

// Fakes for cleaner testing
class FakeSupplementRepository implements SupplementRepository {
  List<Supplement> supplements = [];

  @override
  Future<List<Supplement>> getAllSupplements() async => supplements;

  @override
  Future<Supplement?> getSupplement(String id) async =>
      supplements.firstWhere((s) => s.id == id);

  @override
  Future<List<Supplement>> searchSupplements(String query) async => [];
  @override
  Future<List<Supplement>> getSupplementsByCategory(String category) async =>
      [];
  @override
  Stream<List<Supplement>> watchSupplements() => Stream.value([]);
  @override
  Future<void> trackReferralClick(String supplementId) async {}
}

class FakeStackRepository implements StackRepository {
  List<SupplementStack> stacks = [];
  SupplementStack? lastSavedStack;

  @override
  Future<List<SupplementStack>> getUserStacks(String userId) async => stacks;

  @override
  Future<void> saveStack(String userId, SupplementStack stack) async {
    lastSavedStack = stack;
    final index = stacks.indexWhere((s) => s.id == stack.id);
    if (index >= 0) {
      stacks[index] = stack;
    } else {
      stacks.add(stack);
    }
  }

  @override
  Future<SupplementStack?> getStack(String userId) async => null;
}

void main() {
  late LibraryViewModel viewModel;
  late FakeSupplementRepository fakeSupplementRepo;
  late FakeStackRepository fakeStackRepo;
  const String userId = 'test-user';

  const beneficialSupp = Supplement(
    id: 'supp1',
    name: 'Magnesium',
    category: 'Mineral',
    dosage: '200mg',
    benefits: ['Sleep'],
    description: 'Relaxation',
    status: 'beneficial',
  );

  const avoidSupp = Supplement(
    id: 'avoid1',
    name: 'Red Dye 40',
    category: 'Additive',
    dosage: 'None',
    benefits: ['None'],
    description: 'Harmful',
    status: 'avoid',
  );

  setUp(() {
    fakeSupplementRepo = FakeSupplementRepository();
    fakeStackRepo = FakeStackRepository();
    viewModel = LibraryViewModel(
      supplementRepository: fakeSupplementRepo,
      stackRepository: fakeStackRepo,
      userId: userId,
    );
  });

  group('LibraryViewModel Tests', () {
    test('initializes with beneficial supplements by default', () async {
      fakeSupplementRepo.supplements = [beneficialSupp, avoidSupp];

      await viewModel.initialize();

      expect(viewModel.supplements.length, 1);
      expect(viewModel.supplements.first.status, 'beneficial');
      expect(viewModel.currentStatus, 'beneficial');
    });

    test('filterByStatus switches between beneficial and avoid', () async {
      fakeSupplementRepo.supplements = [beneficialSupp, avoidSupp];
      await viewModel.initialize();

      viewModel.filterByStatus('avoid');

      expect(viewModel.supplements.length, 1);
      expect(viewModel.supplements.first.status, 'avoid');
      expect(viewModel.supplements.first.id, 'avoid1');
    });

    test('search filters within current status', () async {
      fakeSupplementRepo.supplements = [
        beneficialSupp,
        beneficialSupp.copyWith(id: 'supp2', name: 'Zinc'),
        avoidSupp,
      ];
      await viewModel.initialize();

      // Search for Magnesium in beneficial
      await viewModel.search('Mag');
      expect(viewModel.supplements.length, 1);
      expect(viewModel.supplements.first.name, 'Magnesium');

      // Search for Red Dye (not in beneficial)
      await viewModel.search('Red');
      expect(viewModel.supplements.isEmpty, true);

      // Switch to avoid and search
      viewModel.filterByStatus('avoid');
      await viewModel.search('Red');
      expect(viewModel.supplements.length, 1);
      expect(viewModel.supplements.first.name, 'Red Dye 40');
    });

    test('filterByCategory works with status', () async {
      fakeSupplementRepo.supplements = [beneficialSupp, avoidSupp];
      await viewModel.initialize();

      // Beneficial + Mineral
      viewModel.filterByCategory('Mineral');
      expect(viewModel.supplements.length, 1);

      // Beneficial + Additive (Magnesium is Mineral)
      viewModel.filterByCategory('Additive');
      expect(viewModel.supplements.isEmpty, true);

      // Avoid + Additive
      viewModel.filterByStatus('avoid');
      viewModel.filterByCategory('Additive');
      expect(viewModel.supplements.length, 1);
    });

    test('clearFilters resets to beneficial', () async {
      fakeSupplementRepo.supplements = [beneficialSupp, avoidSupp];
      await viewModel.initialize();

      viewModel.filterByStatus('avoid');
      expect(viewModel.supplements.first.status, 'avoid');

      viewModel.clearFilters();
      expect(viewModel.currentStatus, 'beneficial');
      expect(viewModel.supplements.first.status, 'beneficial');
    });
  });
}
