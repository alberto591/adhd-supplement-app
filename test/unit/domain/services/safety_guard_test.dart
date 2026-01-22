import 'package:flutter_test/flutter_test.dart';
import 'package:adhd_supplement_app/domain/services/safety_guard.dart';
import 'package:adhd_supplement_app/domain/entities/supplement.dart';

void main() {
  group('SafetyGuard', () {
    const stimulantMed = Medication(
      id: 'm1',
      name: 'Adderall',
      type: MedicationType.stimulant,
      dosageMg: 20,
    );

    const antidepressantMed = Medication(
      id: 'm2',
      name: 'Lexapro',
      type: MedicationType.antidepressant,
      dosageMg: 10,
    );

    test('isOnStimulants returns true if user takes stimulants', () {
      final guard = SafetyGuard([stimulantMed, antidepressantMed]);
      expect(guard.isOnStimulants, isTrue);
    });

    test('isOnStimulants returns false if user does not take stimulants', () {
      final guard = SafetyGuard([antidepressantMed]);
      expect(guard.isOnStimulants, isFalse);
    });

    test('isOnAntidepressants returns true if user takes antidepressants', () {
      final guard = SafetyGuard([stimulantMed, antidepressantMed]);
      expect(guard.isOnAntidepressants, isTrue);
    });

    test('checkSupplement flags Vitamin C with stimulants', () {
      final guard = SafetyGuard([stimulantMed]);
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
      expect(warnings.first.severity, WarningSeverity.warning);
      expect(warnings.first.title, contains('Interaction Detected'));
      expect(warnings.first.description,
          contains('effectiveness of your stimulant'));
    });

    test('checkSupplement flags 5-HTP with antidepressants as danger', () {
      final guard = SafetyGuard([antidepressantMed]);
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
      expect(warnings.first.severity, WarningSeverity.danger);
      expect(warnings.first.title, contains('Dangerous Interaction'));
    });

    test('checkSupplement does not flag safe combinations', () {
      final guard = SafetyGuard([stimulantMed]);
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
        const InteractionWarning(
          supplementName: 'Test 1',
          medicationName: 'Med 1',
          severity: WarningSeverity.caution,
          title: 'T1',
          description: 'D1',
          recommendation: 'R1',
        ),
        const InteractionWarning(
          supplementName: 'Test 2',
          medicationName: 'Med 2',
          severity: WarningSeverity.danger,
          title: 'T2',
          description: 'D2',
          recommendation: 'R2',
        ),
        const InteractionWarning(
          supplementName: 'Test 3',
          medicationName: 'Med 3',
          severity: WarningSeverity.warning,
          title: 'T3',
          description: 'D3',
          recommendation: 'R3',
        ),
      ];

      final result = SafetyGuard.getHighestSeverity(warnings);
      expect(result, WarningSeverity.danger);
    });

    test('getHighestSeverity returns null for empty list', () {
      expect(SafetyGuard.getHighestSeverity([]), isNull);
    });
  });
}
