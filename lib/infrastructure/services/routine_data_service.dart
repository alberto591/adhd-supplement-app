import 'package:neurostack_app/domain/entities/supplement.dart';
import 'package:neurostack_app/domain/entities/routine_element.dart';
import 'package:neurostack_app/domain/services/compatibility_service.dart';
import 'package:neurostack_app/domain/services/routine_compatibility_service.dart';
import 'package:neurostack_app/domain/services/routine_optimization_guard.dart';

class RoutineDataService implements CompatibilityService {
  @override
  Future<List<CompatibilityGuidance>> checkRoutineOptimization({
    required Supplement supplement,
    required List<RoutineElement> userElements,
  }) async {
    // Initial implementation uses the local RoutineCompatibilityService logic
    final guard = RoutineCompatibilityService(userElements);
    final guidances = guard.checkSupplement(supplement);

    // Additionally check against RoutineOptimizationGuard rules
    for (final element in userElements) {
      final routineStatus = RoutineOptimizationGuard.checkCompatibility(
          element.name, supplement.name);
      if (routineStatus['impact'] != 'Low') {
        // Map simplified check to CompatibilityGuidance
        final exists = guidances.any((w) =>
            w.elementName == element.name &&
            w.supplementName == supplement.name);
        if (!exists) {
          guidances.add(CompatibilityGuidance(
            supplementName: supplement.name,
            elementName: element.name,
            severity: _mapImpactToGuidance(routineStatus['impact'] as String),
            title: (routineStatus['warning'] as String?) ??
                'Routine Consideration',
            description: routineStatus['message'] as String,
            recommendation: routineStatus['recommendation'] as String,
          ));
        }
      }
    }

    return guidances;
  }

  @override
  Future<List<CompatibilityGuidance>> checkStackOptimization({
    required List<Supplement> supplements,
    required List<RoutineElement> userElements,
  }) async {
    final allGuidances = <CompatibilityGuidance>[];
    for (final supplement in supplements) {
      final guidances = await checkRoutineOptimization(
        supplement: supplement,
        userElements: userElements,
      );
      allGuidances.addAll(guidances);
    }
    return allGuidances;
  }

  GuidanceLevel _mapImpactToGuidance(String impact) {
    switch (impact.toLowerCase()) {
      case 'high':
      case 'danger':
        return GuidanceLevel.danger;
      case 'moderate':
      case 'warning':
        return GuidanceLevel.warning;
      case 'caution':
        return GuidanceLevel.caution;
      default:
        return GuidanceLevel.info;
    }
  }
}
