import 'package:flutter_test/flutter_test.dart';
import 'package:adhd_supplement_app/presentation/view_models/library_view_model.dart';
import 'package:adhd_supplement_app/domain/entities/supplement.dart';
import 'package:adhd_supplement_app/domain/entities/supplement_stack.dart';
import 'package:adhd_supplement_app/domain/repositories/supplement_repository.dart';
import 'package:adhd_supplement_app/domain/repositories/stack_repository.dart';
import 'package:adhd_supplement_app/domain/repositories/settings_repository.dart';
import 'package:flutter/material.dart';

// Fakes for cleaner testing
class FakeSupplementRepository implements SupplementRepository {
  List<Supplement> supplements = [];
  List<Supplement> savedCustomSupplements = [];

  @override
  Future<List<Supplement>> getAllSupplements({String? userId}) async {
    return [...supplements, ...savedCustomSupplements];
  }

  @override
  Future<Supplement?> getSupplement(String id, {String? userId}) async {
    try {
      return [...supplements, ...savedCustomSupplements]
          .firstWhere((s) => s.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<List<Supplement>> searchSupplements(String query,
      {String? userId}) async {
    final all = await getAllSupplements(userId: userId);
    return all
        .where((s) => s.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  @override
  Future<List<Supplement>> getSupplementsByCategory(String category,
          {String? userId}) async =>
      [];

  @override
  Stream<List<Supplement>> watchSupplements({String? userId}) =>
      Stream.value([]);

  @override
  Future<void> saveCustomSupplement(Supplement supplement) async {
    savedCustomSupplements.add(supplement);
  }

  @override
  Future<void> deleteCustomSupplement(String id, String userId) async {
    savedCustomSupplements.removeWhere((s) => s.id == id);
  }

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

  @override
  Stream<List<SupplementStack>> watchUserStacks(String userId) =>
      Stream.value(stacks);
}

class FakeSettingsRepository implements SettingsRepository {
  @override
  Future<void> init() async {}

  @override
  bool getNudgeModeEnabled() => true;
  @override
  Future<void> setNudgeModeEnabled(bool enabled) async {}

  @override
  TimeOfDay getNudgeTime() => const TimeOfDay(hour: 8, minute: 0);
  @override
  Future<void> setNudgeTime(TimeOfDay time) async {}

  @override
  TimeOfDay getSlotTime(String slot) {
    switch (slot.toLowerCase()) {
      case 'morning':
        return const TimeOfDay(hour: 8, minute: 0);
      case 'afternoon':
        return const TimeOfDay(hour: 13, minute: 0);
      case 'evening':
        return const TimeOfDay(hour: 18, minute: 0);
      case 'night':
        return const TimeOfDay(hour: 21, minute: 0);
      default:
        return const TimeOfDay(hour: 8, minute: 0);
    }
  }

  @override
  Future<void> setSlotTime(String slot, TimeOfDay time) async {}

  @override
  String getWarningNudgeOption() => '15m';
  @override
  Future<void> setWarningNudgeOption(String option) async {}

  @override
  bool getExtendedRemindersEnabled() => true;
  @override
  Future<void> setExtendedRemindersEnabled(bool enabled) async {}

  @override
  bool getBiometricLockEnabled() => false;
  @override
  Future<void> setBiometricLockEnabled(bool enabled) async {}

  @override
  bool getLocalStorageOnly() => true;
  @override
  Future<void> setLocalStorageOnly(bool enabled) async {}

  @override
  bool getAnalyticsEnabled() => false;
  @override
  Future<void> setAnalyticsEnabled(bool enabled) async {}

  @override
  bool getCrashReportingEnabled() => false;
  @override
  Future<void> setCrashReportingEnabled(bool enabled) async {}

  @override
  ThemeMode getThemeMode() => ThemeMode.system;
  @override
  Future<void> setThemeMode(ThemeMode mode) async {}

  @override
  bool getReducedMotionEnabled() => false;
  @override
  Future<void> setReducedMotionEnabled(bool enabled) async {}

  @override
  bool getHapticFeedbackEnabled() => true;
  @override
  Future<void> setHapticFeedbackEnabled(bool enabled) async {}

  @override
  double getFontSizeScale() => 1.0;
  @override
  Future<void> setFontSizeScale(double scale) async {}

  @override
  bool hasAcceptedDisclaimer() => true;
  @override
  Future<void> setAcceptedDisclaimer(bool accepted) async {}
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
      settingsRepository: FakeSettingsRepository(),
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

      // Deselect Mineral, then select Additive
      viewModel.filterByCategory('Mineral'); // Deselect
      viewModel.filterByCategory('Additive');
      expect(viewModel.supplements.isEmpty, true);

      // Avoid + Additive
      viewModel.filterByStatus('avoid');
      // Additive is already selected from previous step
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

    test('createCustomSupplement adds to list and maintains status', () async {
      fakeSupplementRepo.supplements = [beneficialSupp];
      await viewModel.initialize();
      expect(viewModel.supplements.length, 1);

      await viewModel.createCustomSupplement(
        name: 'My Tea',
        category: 'Herbal',
        dosage: '1 cup',
      );

      // Should have 2 now
      expect(viewModel.supplements.length, 2);
      expect(viewModel.supplements.any((s) => s.name == 'My Tea'), true);
      expect(
          viewModel.supplements.firstWhere((s) => s.name == 'My Tea').isCustom,
          true);
    });

    test('deleteCustomSupplement removes from list', () async {
      final custom = beneficialSupp.copyWith(id: 'custom1', isCustom: true);
      fakeSupplementRepo.savedCustomSupplements = [custom];
      await viewModel.initialize();
      expect(viewModel.supplements.length, 1);

      await viewModel.deleteCustomSupplement('custom1');

      expect(viewModel.supplements.isEmpty, true);
    });

    test('filterByForm works correctly', () async {
      fakeSupplementRepo.supplements = [
        beneficialSupp.copyWith(id: 'supp1', form: 'Capsule'),
        beneficialSupp.copyWith(id: 'supp2', form: 'Tablet'),
      ];
      await viewModel.initialize();

      viewModel.filterByForm('Capsule');
      expect(viewModel.supplements.length, 1);
      expect(viewModel.supplements.first.form, 'Capsule');

      viewModel.filterByForm('Tablet');
      expect(viewModel.supplements.length, 1);
      expect(viewModel.supplements.first.form, 'Tablet');

      viewModel.filterByForm(null);
      expect(viewModel.supplements.length, 2);
    });
  });
}
