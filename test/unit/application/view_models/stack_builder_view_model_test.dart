import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:neurostack_app/presentation/view_models/stack_builder_view_model.dart';
import 'package:neurostack_app/application/view_models/routine_safety_view_model.dart';
import 'package:neurostack_app/domain/entities/supplement.dart';
import 'package:neurostack_app/domain/entities/supplement_stack.dart';
import 'package:neurostack_app/domain/repositories/stack_repository.dart';
import 'package:neurostack_app/domain/repositories/supplement_repository.dart';

import 'stack_builder_view_model_test.mocks.dart';

@GenerateMocks([
  StackRepository,
  SupplementRepository,
  RoutineSafetyViewModel,
])
void main() {
  late StackBuilderViewModel viewModel;
  late MockStackRepository mockStackRepository;
  late MockSupplementRepository mockSupplementRepository;
  late MockRoutineSafetyViewModel mockSafetyViewModel;

  setUp(() {
    mockStackRepository = MockStackRepository();
    mockSupplementRepository = MockSupplementRepository();
    mockSafetyViewModel = MockRoutineSafetyViewModel();

    viewModel = StackBuilderViewModel(
      stackRepository: mockStackRepository,
      supplementRepository: mockSupplementRepository,
      safetyViewModel: mockSafetyViewModel,
      userId: 'test_user',
    );
  });

  group('StackBuilderViewModel Tests', () {
    final testStack = SupplementStack(
      id: 'test_stack',
      userId: 'test_user',
      name: 'Test Stack',
      items: [],
      timeOfDay: 'morning',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    test('applyPreset steady_focus adds correct items', () async {
      // Arrange
      when(mockSupplementRepository.getAllSupplements(userId: 'test_user'))
          .thenAnswer((_) async => []);
      when(mockStackRepository.getUserStacks('test_user'))
          .thenAnswer((_) async => [testStack]);

      // Initialize to load currentStack
      await viewModel.initialize();

      // Act
      viewModel.applyPreset('steady_focus');

      // Assert
      final stack = viewModel.currentStack;
      expect(stack, isNotNull);
      expect(stack!.items.length, 3);

      // Verify Specific Items for Steady Focus
      final ids = stack.items.map((i) => i.supplementId).toList();
      expect(ids, contains('l-theanine'));
      expect(ids, contains('omega-3'));
      expect(ids, contains('zinc'));

      // Verify save was called
      verify(mockStackRepository.saveStack(any, any)).called(1);
    });

    test('stackInsight detects l-theanine + caffeine synergy', () async {
      // Arrange
      when(mockSupplementRepository.getAllSupplements(userId: 'test_user'))
          .thenAnswer((_) async => []);
      when(mockStackRepository.getUserStacks('test_user'))
          .thenAnswer((_) async => [testStack]);

      await viewModel.initialize();

      // Add items manually mimicking the behavior
      final lTheanine = Supplement(
          id: 'l-theanine',
          name: 'L-Theanine',
          category: 'Nootropic',
          defaultDosage: '200mg',
          benefits: []);
      final caffeine = Supplement(
          id: 'caffeine',
          name: 'Caffeine',
          category: 'Stimulant',
          defaultDosage: '100mg',
          benefits: []);

      viewModel.addItem(lTheanine);
      viewModel.addItem(caffeine);

      // Act
      final insight = viewModel.stackInsight;

      // Assert
      expect(insight, contains('Synergy Detected'));
      expect(insight, contains('L-Theanine'));
    });
  });
}
