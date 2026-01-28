/// RoutineElement Entity
///
/// Represents an element of the user's routine for optimization checks.
library;

class RoutineElement {
  final String id;
  final String name;
  final ElementCategory type;
  final double dosage;

  const RoutineElement({
    required this.id,
    required this.name,
    required this.type,
    required this.dosage,
  });

  /// Helper to create from string name (useful for onboarding/profile data)
  factory RoutineElement.fromName(String name, {double dosage = 0.0}) {
    final lower = name.toLowerCase();
    ElementCategory type = ElementCategory.typeD;

    if (lower.contains('type a') || lower.contains('fast-acting')) {
      type = ElementCategory.typeA;
    } else if (lower.contains('type b') || lower.contains('steady')) {
      type = ElementCategory.typeB;
    } else if (lower.contains('type c') || lower.contains('mood')) {
      type = ElementCategory.typeC;
    }

    return RoutineElement(
      id: name.replaceAll(' ', '_').toLowerCase(),
      name: name,
      type: type,
      dosage: dosage,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type.name,
      'dosage': dosage,
    };
  }

  factory RoutineElement.fromJson(Map<String, dynamic> json) {
    return RoutineElement(
      id: json['id'] as String,
      name: json['name'] as String,
      type: ElementCategory.values.byName(json['type'] as String),
      dosage: (json['dosage'] as num).toDouble(),
    );
  }
}

enum ElementCategory {
  typeA, // Fast-acting routine elements
  typeB, // Steady routine elements
  typeC, // Mood-support routine elements
  typeD, // Other elements
}

/// Guidance level for routine compatibility
enum GuidanceLevel {
  info, // Educational, no action needed
  caution, // Consider timing separation
  warning, // Consult advisor recommended
  danger, // Do not combine without supervision
}

/// Represents a compatibility guidance
class CompatibilityGuidance {
  final String supplementName;
  final String elementName;
  final GuidanceLevel severity;
  final String title;
  final String description;
  final String recommendation;

  final List<String> scientificReferences;

  const CompatibilityGuidance({
    required this.supplementName,
    required this.elementName,
    required this.severity,
    required this.title,
    required this.description,
    required this.recommendation,
    this.scientificReferences = const [],
  });
}
