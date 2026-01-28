/// Routine Optimization Guard - Simplified Quick-Check System
///
/// This provides quick validation for routine optimization.
/// Works alongside the main RoutineCompatibilityService.
library;

class RoutineOptimizationGuard {
  // List of elements affected by routine triggers
  // No longer hardcoding brand names to comply with Individual Account requirements.
  static const List<String> typeAMeds = [
    'Fast-Acting Protocol',
    'Morning Routine Type A',
  ];

  static const List<String> typeBMeds = [
    'Steady-Release Protocol',
    'Daily Routine Type B',
  ];

  static const List<String> typeCMeds = [
    'Mood Support Protocol',
    'Evening Routine Type C',
  ];

  // List of supplements that are optimization triggers
  static const List<String> optimizationTriggers = [
    'Vitamin C',
    'Ascorbic Acid',
    'Multivitamin (with Vit C)',
    'Multivitamin', // Most contain Vitamin C
    'Orange Extract',
    'Citrus Bioflavonoids',
    'Lemon Extract',
    'Acerola Cherry',
    'Rose Hips',
    'Camu Camu',
  ];

  /// Quick check for routine optimization
  /// Returns a detailed status map
  static Map<String, dynamic> checkCompatibility(
      String element, String supplement) {
    final elementLower = element.toLowerCase();
    final suppLower = supplement.toLowerCase();

    bool isTypeA = typeAMeds
        .any((trigger) => elementLower.contains(trigger.toLowerCase()));

    bool hasTrigger = optimizationTriggers
        .any((trigger) => suppLower.contains(trigger.toLowerCase()));

    if (isTypeA && hasTrigger) {
      return {
        'impact': 'Moderate',
        'warning': 'Routine Consideration',
        'message': 'Vitamin C can reduce the efficiency of your routine '
            'protocol by impacting how elements are cleared from your system. '
            'This happens because certain routine elements are sensitive to '
            'optimizations in your environment.',
        'recommendation': 'Wait at least 1-2 hours before or after your '
            'scheduled time to take this supplement.',
        'mechanism': 'Optimization overlap detected',
      };
    }

    return {
      'impact': 'Low',
      'warning': null,
      'message': 'No known timing considerations found.',
      'recommendation': 'Follow your standard routine.',
      'mechanism': null,
    };
  }

  /// Check if an element is Type A
  static bool isTypeAElement(String element) {
    final elementLower = element.toLowerCase();
    return typeAMeds
        .any((trigger) => elementLower.contains(trigger.toLowerCase()));
  }

  /// Check if a supplement is an optimization trigger
  static bool isOptimizationTrigger(String supplement) {
    final suppLower = supplement.toLowerCase();
    return optimizationTriggers
        .any((trigger) => suppLower.contains(trigger.toLowerCase()));
  }

  /// Get potential optimizations for a supplement
  static List<String> getPotentialOptimizationsFor(String supplement) {
    if (isOptimizationTrigger(supplement)) {
      return List.from(typeAMeds);
    }
    return [];
  }
}
