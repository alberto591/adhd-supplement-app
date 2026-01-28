enum CompatibilityLevel {
  critical, // Major risk, should not be combined
  caution, // Moderate risk, monitor closely or consult advisor
  stable // Known status but usually safe with monitoring
}

class SupplementCompatibility {
  final String id;
  final String supplementAId;
  final String supplementBId;
  final CompatibilityLevel severity;
  final String description;
  final String recommendation;
  final List<String> scientificReferences;

  const SupplementCompatibility({
    required this.id,
    required this.supplementAId,
    required this.supplementBId,
    required this.severity,
    required this.description,
    required this.recommendation,
    this.scientificReferences = const [],
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'supplementAId': supplementAId,
      'supplementBId': supplementBId,
      'severity': severity.name,
      'description': description,
      'recommendation': recommendation,
      'scientificReferences': scientificReferences,
    };
  }

  factory SupplementCompatibility.fromJson(Map<String, dynamic> json) {
    return SupplementCompatibility(
      id: json['id'] as String,
      supplementAId: json['supplementAId'] as String,
      supplementBId: json['supplementBId'] as String,
      severity: CompatibilityLevel.values.byName(json['severity'] as String),
      description: json['description'] as String,
      recommendation: json['recommendation'] as String,
      scientificReferences: (json['scientificReferences'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );
  }
}
