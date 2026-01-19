class Supplement {
  final String id;
  final String name;
  final String category;
  final String? dosage;
  final String? defaultDosage; // For backward compatibility/consistency
  final String? timeOfDay; // morning, afternoon, evening, bedtime
  final List<String> benefits;
  final String? evidenceLevel; // high, moderate, low
  final String? notes;
  final String? imageUrl;
  final bool isPrescription;

  // From models/supplement.dart
  final String description;
  final String referralUrl;
  final List<String> sideEffects;
  final List<String> interactions;
  final int focusLevel; // 1-5 scale for ADHD focus improvement

  const Supplement({
    required this.id,
    required this.name,
    required this.category,
    this.dosage,
    this.defaultDosage,
    this.timeOfDay,
    this.benefits = const [],
    this.evidenceLevel,
    this.notes,
    this.imageUrl,
    this.isPrescription = false,
    this.description = '',
    this.referralUrl = '',
    this.sideEffects = const [],
    this.interactions = const [],
    this.focusLevel = 3,
  });

  Supplement copyWith({
    String? id,
    String? name,
    String? category,
    String? dosage,
    String? defaultDosage,
    String? timeOfDay,
    List<String>? benefits,
    String? evidenceLevel,
    String? notes,
    String? imageUrl,
    bool? isPrescription,
    String? description,
    String? referralUrl,
    List<String>? sideEffects,
    List<String>? interactions,
    int? focusLevel,
  }) {
    return Supplement(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      dosage: dosage ?? this.dosage,
      defaultDosage: defaultDosage ?? this.defaultDosage,
      timeOfDay: timeOfDay ?? this.timeOfDay,
      benefits: benefits ?? this.benefits,
      evidenceLevel: evidenceLevel ?? this.evidenceLevel,
      notes: notes ?? this.notes,
      imageUrl: imageUrl ?? this.imageUrl,
      isPrescription: isPrescription ?? this.isPrescription,
      description: description ?? this.description,
      referralUrl: referralUrl ?? this.referralUrl,
      sideEffects: sideEffects ?? this.sideEffects,
      interactions: interactions ?? this.interactions,
      focusLevel: focusLevel ?? this.focusLevel,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'dosage': dosage,
      'defaultDosage': defaultDosage,
      'timeOfDay': timeOfDay,
      'benefits': benefits,
      'evidenceLevel': evidenceLevel,
      'notes': notes,
      'imageUrl': imageUrl,
      'isPrescription': isPrescription,
      'description': description,
      'referralUrl': referralUrl,
      'sideEffects': sideEffects,
      'interactions': interactions,
      'focusLevel': focusLevel,
    };
  }

  factory Supplement.fromJson(Map<String, dynamic> json) {
    return Supplement(
      id: json['id'] as String,
      name: json['name'] as String,
      category: json['category'] as String? ?? 'general',
      dosage: json['dosage'] as String? ?? json['dosageInstruction'] as String?,
      defaultDosage: json['defaultDosage'] as String? ??
          json['dosageInstruction'] as String?,
      timeOfDay: json['timeOfDay'] as String?,
      benefits: (json['benefits'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      evidenceLevel: json['evidenceLevel'] as String?,
      notes: json['notes'] as String?,
      imageUrl: json['imageUrl'] as String?,
      isPrescription: json['isPrescription'] as bool? ?? false,
      description: json['description'] as String? ?? '',
      referralUrl: json['referralUrl'] as String? ?? '',
      sideEffects: (json['sideEffects'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      interactions: (json['interactions'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      focusLevel: json['focusLevel'] as int? ?? 3,
    );
  }
}
