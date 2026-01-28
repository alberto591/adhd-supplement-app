import 'package:flutter_test/flutter_test.dart';
import 'package:neurostack_app/domain/services/routine_compatibility_service.dart';
import 'package:neurostack_app/domain/entities/supplement.dart';
import 'package:neurostack_app/domain/entities/routine_element.dart';

void main() {
  group('RoutineCompatibilityService', () {
    const typeAElement = RoutineElement(
      id: 'm1',
      name: 'Adderall',
      type: ElementCategory.typeA,
      dosage: 20,
    );

    const typeCElement = RoutineElement(
      id: 'm2',
      name: 'Lexapro',
      type: ElementCategory.typeC,
      dosage: 10,
    );

    group('RoutineElement.fromName', () {
      test('should detect Type A elements', () {
        final element =
            RoutineElement.fromName('Fast-Acting Protocol', dosage: 20);
        expect(element.type, ElementCategory.typeA);
        expect(element.name, 'Fast-Acting Protocol');
        expect(element.dosage, 20);
      });

      test('should detect Type B elements', () {
        final element = RoutineElement.fromName('Steady-Release Protocol');
        expect(element.type, ElementCategory.typeB);
      });

      test('should detect Type C elements', () {
        final element = RoutineElement.fromName('Mood Support Protocol');
        expect(element.type, ElementCategory.typeC);
      });

      test('should default to type D for unknown elements', () {
        final element = RoutineElement.fromName('Melatonin');
        expect(element.type, ElementCategory.typeD);
      });
    });

    test('hasTypeA returns true if user uses Type A', () {
      final guard = RoutineCompatibilityService([typeAElement, typeCElement]);
      expect(guard.hasTypeA, isTrue);
    });

    test('hasTypeA returns false if user does not use Type A', () {
      final guard = RoutineCompatibilityService([typeCElement]);
      expect(guard.hasTypeA, isFalse);
    });

    test('hasTypeC returns true if user uses Type C', () {
      final guard = RoutineCompatibilityService([typeAElement, typeCElement]);
      expect(guard.hasTypeC, isTrue);
    });

    test('checkSupplement flags Vitamin C with Type A', () {
      final guard = RoutineCompatibilityService([typeAElement]);
      const vitaminC = Supplement(
        id: 's1',
        name: 'Vitamin C',
        category: 'Vitamins',
        benefits: ['Immunity'],
        dosage: '1000mg',
        form: 'Tablet',
        defaultDosage: '500mg',
        shapeIcon: 'tablet',
        colorHex: '#FFFFFF',
      );

      final warnings = guard.checkSupplement(vitaminC);

      expect(warnings, isNotEmpty);
      expect(warnings.first.severity, GuidanceLevel.warning);
      expect(warnings.first.title, contains('Routine Consideration'));
      expect(warnings.first.description,
          contains('influence how quickly Type A elements are processed'));
    });

    test('checkSupplement flags 5-HTP with Type C as danger', () {
      final guard = RoutineCompatibilityService([typeCElement]);
      const fiveHtp = Supplement(
        id: 's2',
        name: '5-HTP',
        category: 'Mood',
        benefits: ['Serotonin'],
        dosage: '100mg',
        form: 'Capsule',
        defaultDosage: '100mg',
        shapeIcon: 'capsule',
        colorHex: '#FFFFFF',
      );

      final warnings = guard.checkSupplement(fiveHtp);

      expect(warnings, isNotEmpty);
      expect(warnings.first.severity, GuidanceLevel.danger);
      expect(warnings.first.title, contains('Routine Consideration'));
    });

    test('checkSupplement does not flag safe combinations', () {
      final guard = RoutineCompatibilityService([typeAElement]);
      const magnesium = Supplement(
        id: 's3',
        name: 'Magnesium Glycinate',
        category: 'Minerals',
        benefits: ['Relaxation'],
        dosage: '200mg',
        form: 'Capsule',
        defaultDosage: '200mg',
        shapeIcon: 'capsule',
        colorHex: '#FFFFFF',
      );

      final warnings = guard.checkSupplement(magnesium);

      expect(warnings, isEmpty);
    });

    test('getHighestSeverity prioritizes danger over others', () {
      final warnings = [
        const CompatibilityGuidance(
          supplementName: 'Test 1',
          elementName: 'Item 1',
          severity: GuidanceLevel.caution,
          title: 'T1',
          description: 'D1',
          recommendation: 'R1',
        ),
        const CompatibilityGuidance(
          supplementName: 'Test 2',
          elementName: 'Item 2',
          severity: GuidanceLevel.danger,
          title: 'T2',
          description: 'D2',
          recommendation: 'R2',
        ),
        const CompatibilityGuidance(
          supplementName: 'Test 3',
          elementName: 'Item 3',
          severity: GuidanceLevel.warning,
          title: 'T3',
          description: 'D3',
          recommendation: 'R3',
        ),
      ];

      final result = RoutineCompatibilityService.getHighestSeverity(warnings);
      expect(result, GuidanceLevel.danger);
    });

    test('getHighestSeverity returns null for empty list', () {
      expect(RoutineCompatibilityService.getHighestSeverity([]), isNull);
    });
  });
}
