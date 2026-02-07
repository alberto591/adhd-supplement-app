import 'package:flutter_test/flutter_test.dart';
import 'package:neurostack_app/infrastructure/services/seeding_service.dart';

void main() {
  test('Verify all supplements have valid localized study links', () {
    // Access the static list directly
    final supplements = SeedingService.defaultSupplements;
    final List<String> issues = [];
    int checkedCount = 0;

    for (var supplement in supplements) {
      final String id = supplement['id'] as String;
      final Map<String, dynamic>? studyLinksEn =
          supplement['studyLinks'] as Map<String, dynamic>?;

      if (studyLinksEn != null && studyLinksEn.isNotEmpty) {
        checkedCount++;
        final Map<String, dynamic>? translations =
            supplement['translations'] as Map<String, dynamic>?;

        if (translations == null) {
          issues.add('Supplement $id has studyLinks but no translations');
          continue;
        }

        // Check Italian
        final Map<String, dynamic>? itData =
            translations['it'] as Map<String, dynamic>?;
        if (itData == null) {
          issues.add('Supplement $id missing IT translations');
        } else {
          final Map<String, dynamic>? itStudyLinks =
              itData['studyLinks'] as Map<String, dynamic>?;
          if (itStudyLinks == null || itStudyLinks.isEmpty) {
            issues.add('Supplement $id missing IT studyLinks');
          } else {
            itStudyLinks.forEach((key, value) {
              if (!value.toString().startsWith('http')) {
                issues.add(
                    'Supplement $id (IT): Value for "$key" is not a URL: "$value"');
              }
            });
          }
        }

        // Check Spanish
        final Map<String, dynamic>? esData =
            translations['es'] as Map<String, dynamic>?;
        if (esData == null) {
          issues.add('Supplement $id missing ES translations');
        } else {
          final Map<String, dynamic>? esStudyLinks =
              esData['studyLinks'] as Map<String, dynamic>?;
          if (esStudyLinks == null || esStudyLinks.isEmpty) {
            issues.add('Supplement $id missing ES studyLinks');
          } else {
            esStudyLinks.forEach((key, value) {
              if (!value.toString().startsWith('http')) {
                issues.add(
                    'Supplement $id (ES): Value for "$key" is not a URL: "$value"');
              }
            });
          }
        }
      }
    }

    print('Checked $checkedCount supplements with study links.');

    if (issues.isNotEmpty) {
      fail('Found ${issues.length} issues:\n${issues.join('\n')}');
    }
  });
}
