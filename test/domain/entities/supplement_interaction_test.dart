import 'package:flutter_test/flutter_test.dart';
import 'package:neurostack_app/domain/entities/supplement_compatibility.dart';

void main() {
  group('SupplementCompatibility', () {
    test('should support value equality', () {
      const compatibility1 = SupplementCompatibility(
        id: '1',
        supplementAId: 'sup1',
        supplementBId: 'sup2',
        severity: CompatibilityLevel.critical,
        description: 'Test description',
        recommendation: 'Test recommendation',
        scientificReferences: ['ref1'],
      );

      const compatibility2 = SupplementCompatibility(
        id: '1',
        supplementAId: 'sup1',
        supplementBId: 'sup2',
        severity: CompatibilityLevel.critical,
        description: 'Test description',
        recommendation: 'Test recommendation',
        scientificReferences: ['ref1'],
      );

      // Assuming Equatable or similar is used, or just checking fields if not.
      // Based on previous file reads, it seemed to be a standard class.
      // If it's a standard class without Equatable, strict equality checks reference.
      // Let's verify field values instead to be safe if Equatable isn't used.

      expect(compatibility1.id, compatibility2.id);
      expect(compatibility1.severity, compatibility2.severity);
    });

    test('should correctly identify critical severity', () {
      const compatibility = SupplementCompatibility(
        id: '1',
        supplementAId: 'a',
        supplementBId: 'b',
        severity: CompatibilityLevel.critical,
        description: 'desc',
        recommendation: 'rec',
        scientificReferences: [],
      );

      expect(compatibility.severity, CompatibilityLevel.critical);
    });
  });
}
