import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:neurostack_app/infrastructure/services/seeding_service.dart';

void main() {
  group('SeedingService Localization Tests', () {
    test(
        'defaultSupplements should contain trilingual translations for all items',
        () {
      const supplements = SeedingService.defaultSupplements;
      final errors = <String>[];

      final requiredLanguages = ['it', 'es'];
      final requiredFields = [
        'name',
        'description',
        'mechanismOfAction',
        'detailedBenefits',
        'timingRationale',
        'dosageFrequency',
        'dosageWarnings',
        'tldr',
      ];

      for (var supplement in supplements) {
        final id = supplement['id'];
        final translations =
            supplement['translations'] as Map<String, dynamic>?;

        if (translations == null) {
          errors.add('Supplement $id is missing translations map');
          continue;
        }

        for (var lang in requiredLanguages) {
          final langData = translations[lang] as Map<String, dynamic>?;
          if (langData == null) {
            errors.add('Supplement $id is missing $lang translation');
            continue;
          }

          for (var field in requiredFields) {
            if (!langData.containsKey(field)) {
              errors.add('Supplement $id ($lang) is missing field: $field');
            }
          }
        }
      }

      if (errors.isNotEmpty) {
        debugPrint('Localization Errors found:\n${errors.join('\n')}');
      }
      expect(errors.isEmpty, isTrue,
          reason: 'Found ${errors.length} localization errors');
    });

    test('Special precautions for 5-HTP should be present in all languages',
        () {
      final htp = SeedingService.defaultSupplements
          .firstWhere((s) => s['id'] == '5-htp');
      final itWarnings = htp['translations']['it']['dosageWarnings'] as List;
      final esWarnings = htp['translations']['es']['dosageWarnings'] as List;

      expect(itWarnings.any((w) => w.toString().contains('Serotoninergica')),
          isTrue);
      expect(esWarnings.any((w) => w.toString().contains('Serotoninérgico')),
          isTrue);
    });

    test('Food additives should be marked as "avoid"', () {
      final red3 = SeedingService.defaultSupplements
          .firstWhere((s) => s['id'] == 'red-3');
      expect(red3['status'], 'avoid');

      final itFreq = red3['translations']['it']['dosageFrequency'].toString();
      final esFreq = red3['translations']['es']['dosageFrequency'].toString();

      expect(itFreq, contains('Eliminare'));
      expect(esFreq, contains('Eliminar'));
    });
  });
}
