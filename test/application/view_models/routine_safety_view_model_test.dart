import 'package:flutter_test/flutter_test.dart';
import 'package:neurostack_app/application/view_models/routine_safety_view_model.dart';
import 'package:neurostack_app/domain/entities/supplement_compatibility.dart';
import 'package:neurostack_app/domain/entities/routine_override.dart';
import 'package:neurostack_app/domain/repositories/routine_safety_repository.dart';

// Manual Mock
class MockRoutineSafetyRepository implements RoutineSafetyRepository {
  List<SupplementCompatibility> compatibilitysToReturn = [];
  RoutineOverride? lastLoggedOverride;

  @override
  Future<List<SupplementCompatibility>> getCompatibilitysForSupplements(
      List<String> supplementIds) async {
    return compatibilitysToReturn;
  }

  @override
  Future<void> logRoutineOverride(RoutineOverride override) async {
    lastLoggedOverride = override;
  }

  @override
  Future<List<RoutineOverride>> getRoutineOverrides(String userId) async {
    return [];
  }

  @override
  Future<SupplementCompatibility?> getCompatibilityById(String id) async {
    try {
      return compatibilitysToReturn.firstWhere((i) => i.id == id);
    } catch (_) {
      return null;
    }
  }
}

void main() {
  group('RoutineSafetyViewModel', () {
    late RoutineSafetyViewModel viewModel;
    late MockRoutineSafetyRepository mockRepository;

    setUp(() {
      mockRepository = MockRoutineSafetyRepository();
      viewModel = RoutineSafetyViewModel(
        repository: mockRepository,
        userId: 'test_user',
      );
    });

    test('should initialize with empty compatibilitys', () {
      expect(viewModel.currentCompatibilitys, isEmpty);
      expect(viewModel.hasCriticalCompatibilitys, isFalse);
    });

    test(
        'checkCompatibilitys should update currentCompatibilitys when consideration exists',
        () async {
      // Arrange
      const supAId = '1';
      const supBId = '2';

      const compatibility = SupplementCompatibility(
        id: 'i1',
        supplementAId: '1',
        supplementBId: '2',
        severity: CompatibilityLevel.critical,
        description: 'Routine optimization suggested',
        recommendation: 'Adjust timing',
        scientificReferences: [],
      );

      mockRepository.compatibilitysToReturn = [compatibility];

      // Act
      await viewModel.checkCompatibilitys([supAId, supBId]);

      // Assert
      expect(viewModel.currentCompatibilitys, hasLength(1));
      expect(viewModel.currentCompatibilitys.first, compatibility);
      expect(viewModel.hasCriticalCompatibilitys, isTrue);
    });

    test('overrideCompatibility should log override', () async {
      // Arrange

      // Act
      await viewModel.overrideCompatibility('i1', 'I consulted my advisor');

      // Assert
      expect(mockRepository.lastLoggedOverride, isNotNull);
      expect(mockRepository.lastLoggedOverride!.compatibilityId, 'i1');
      expect(mockRepository.lastLoggedOverride!.userReason,
          'I consulted my advisor');
      expect(mockRepository.lastLoggedOverride!.userId, 'test_user');
    });
  });
}
