import 'package:flutter_test/flutter_test.dart';
import 'package:adhd_supplement_app/presentation/view_models/library_view_model.dart';
import 'package:adhd_supplement_app/domain/entities/supplement.dart';
import 'package:adhd_supplement_app/domain/entities/supplement_stack.dart';
import 'package:adhd_supplement_app/domain/repositories/supplement_repository.dart';
import 'package:adhd_supplement_app/domain/repositories/stack_repository.dart';
import 'package:adhd_supplement_app/domain/repositories/settings_repository.dart';
import 'package:adhd_supplement_app/infrastructure/services/notification_service.dart';
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
  NotificationMode getNotificationMode() => NotificationMode.gentle;

  @override
  Future<void> setNotificationMode(NotificationMode mode) async {}

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
        avoidSupp.copyWith(name: 'Avoid Item'),
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
      await viewModel.search('Avoid');
      expect(viewModel.supplements.length, 1);
      expect(viewModel.supplements.first.name, 'Avoid Item');
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

    test('filterByForm supports multi-select and toggling', () async {
      fakeSupplementRepo.supplements = [
        beneficialSupp.copyWith(id: 'supp1', name: 'Supp 1', form: 'Capsule'),
        beneficialSupp.copyWith(id: 'supp2', name: 'Supp 2', form: 'Tablet'),
        beneficialSupp.copyWith(id: 'supp3', name: 'Supp 3', form: 'Powder'),
      ];
      await viewModel.initialize();

      // Select Capsule
      viewModel.filterByForm('Capsule');
      expect(viewModel.supplements.length, 1);
      expect(viewModel.supplements.first.id, 'supp1');

      // Select Tablet (now both Capsule and Tablet)
      viewModel.filterByForm('Tablet');
      expect(viewModel.supplements.length, 2);
      expect(viewModel.supplements.any((s) => s.id == 'supp1'), true);
      expect(viewModel.supplements.any((s) => s.id == 'supp2'), true);

      // Deselect Capsule (leaving only Tablet)
      viewModel.filterByForm('Capsule');
      expect(viewModel.supplements.length, 1);
      expect(viewModel.supplements.first.id, 'supp2');

      // Select Powder (Tablet and Powder)
      viewModel.filterByForm('Powder');
      expect(viewModel.supplements.length, 2);

      // Clear all
      viewModel.filterByForm(null);
      expect(viewModel.supplements.length, 3);
    });

    test('filterByEvidence supports multi-select', () async {
      fakeSupplementRepo.supplements = [
        beneficialSupp.copyWith(
            id: 'supp1', name: 'Supp 1', evidenceLevel: 'High'),
        beneficialSupp.copyWith(
            id: 'supp2', name: 'Supp 2', evidenceLevel: 'Moderate'),
        beneficialSupp.copyWith(
            id: 'supp3', name: 'Supp 3', evidenceLevel: 'Low'),
      ];
      await viewModel.initialize();

      viewModel.filterByEvidence('High');
      viewModel.filterByEvidence('Low');

      expect(viewModel.supplements.length, 2);
      expect(
          viewModel.supplements
              .any((s) => s.evidenceLevel?.toLowerCase() == 'high'),
          true);
      expect(
          viewModel.supplements
              .any((s) => s.evidenceLevel?.toLowerCase() == 'low'),
          true);
      expect(
          viewModel.supplements
              .any((s) => s.evidenceLevel?.toLowerCase() == 'moderate'),
          false);

      viewModel.filterByEvidence(null);
      expect(viewModel.supplements.length, 3);
    });

    test('filterByStimulant handles Safe and Caution multi-select', () async {
      fakeSupplementRepo.supplements = [
        beneficialSupp.copyWith(
            id: 'safe1',
            name: 'Safe Supp',
            isPrescription: false,
            adhdMedInteractions: {}),
        beneficialSupp.copyWith(
            id: 'caution1', name: 'Caution Supp 1', isPrescription: true),
        beneficialSupp.copyWith(
            id: 'caution2',
            name: 'Caution Supp 2',
            adhdMedInteractions: {'Adderall': 'Interaction'}),
      ];
      await viewModel.initialize();

      // Filter by Safe
      viewModel.filterByStimulant('Safe');
      expect(viewModel.supplements.length, 1);
      expect(viewModel.supplements.first.id, 'safe1');

      // Filter by Caution (now showing both)
      viewModel.filterByStimulant('Caution');
      expect(viewModel.supplements.length, 3);

      // Deselect Safe (showing only Caution)
      viewModel.filterByStimulant('Safe');
      expect(viewModel.supplements.length, 2);
      expect(viewModel.supplements.any((s) => s.id == 'safe1'), false);

      viewModel.filterByStimulant(null);
      expect(viewModel.supplements.length, 3);
    });

    group('De-duplication Logic', () {
      test('initialize removes duplicates by name, preferring detailed entries',
          () async {
        final alcar1 = beneficialSupp.copyWith(
          id: 'alcar-basic',
          name: 'Acetyl-L-Carnitine',
          description: 'Short desc',
          benefits: ['A'],
        );
        final alcar2 = beneficialSupp.copyWith(
          id: 'alcar-detailed',
          name: 'Acetyl-L-Carnitine',
          description: 'Much longer description with more details',
          benefits: ['A', 'B', 'C'],
        );

        fakeSupplementRepo.supplements = [alcar1, alcar2, beneficialSupp];

        await viewModel.initialize();

        // Should have 2 (ALCAR + Magnesium)
        expect(viewModel.allSupplements.length, 2);
        final alcar = viewModel.allSupplements
            .firstWhere((s) => s.name == 'Acetyl-L-Carnitine');
        // Should prefer the detailed one (alcar2)
        expect(alcar.id, 'alcar-detailed');
      });

      test('de-duplication treats names case-insensitively', () async {
        final zinc1 = beneficialSupp.copyWith(id: 'zinc1', name: 'ZINC');
        final zinc2 = beneficialSupp.copyWith(id: 'zinc2', name: 'zinc');

        fakeSupplementRepo.supplements = [zinc1, zinc2];
        await viewModel.initialize();

        expect(viewModel.allSupplements.length, 1);
      });

      test('supplements are sorted alphabetically case-insensitively',
          () async {
        final suppA = beneficialSupp.copyWith(id: 'a', name: 'Alpha');
        final suppB =
            beneficialSupp.copyWith(id: 'b', name: 'beta'); // lowercase
        final suppC = beneficialSupp.copyWith(id: 'c', name: 'Gamma');

        // Mixed order input
        fakeSupplementRepo.supplements = [suppC, suppA, suppB];
        await viewModel.initialize();

        expect(viewModel.supplements.length, 3);
        expect(viewModel.supplements[0].name, 'Alpha');
        // 'beta' should come before 'Gamma' if case-insensitive
        // 'beta' comes AFTER 'Gamma' if case-sensitive (default behavior, which we want to fix/test)
        // With current broken implementation: expecting this to FAIL if we assertion strictly
        // But for reproduction, let's assert the CORRECT behavior and watch it fail.
        expect(viewModel.supplements[1].name, 'beta');
        expect(viewModel.supplements[2].name, 'Gamma');
      });
    });
  });
}
