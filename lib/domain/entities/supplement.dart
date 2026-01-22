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
  final String? form; // e.g., "Tablet", "Capsule", "Liquid"
  final String? benefitTag; // From Backend Spec v1.0
  final String? shapeIcon; // e.g., "pill", "capsule"
  final String? colorHex; // e.g., "#135BEC"
  final String status; // 'beneficial', 'avoid', 'neutral'
  final String? mechanismOfAction;
  final List<String> detailedBenefits;
  final String? timingRationale;
  final int? scientificEvidenceRank; // 1-100 score
  final Map<String, String> studyLinks; // title: url

  // Backward compatibility
  String? get iconType => shapeIcon;
  String? get iconColor => colorHex;

  // From models/supplement.dart
  final String description;
  final String referralUrl;
  final List<String> sideEffects;
  final List<String> interactions;
  final int focusLevel; // 1-5 scale for ADHD focus improvement

  String get formattedReferralUrl {
    if (referralUrl.isEmpty) return '';
    final uri = Uri.parse(referralUrl);
    final params = Map<String, String>.from(uri.queryParameters);

    if (uri.host.contains('amazon.com')) {
      params['tag'] = 'adhdsupps-20';
    } else if (uri.host.contains('iherb.com')) {
      params['rcode'] = 'ADHDSUPPS';
    }

    return uri.replace(queryParameters: params).toString();
  }

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
    this.form,
    this.benefitTag,
    this.shapeIcon,
    this.colorHex,
    this.description = '',
    this.referralUrl = '',
    this.sideEffects = const [],
    this.interactions = const [],
    this.focusLevel = 3,
    this.status = 'beneficial',
    this.mechanismOfAction,
    this.detailedBenefits = const [],
    this.timingRationale,
    this.scientificEvidenceRank,
    this.studyLinks = const {},
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
    String? form,
    String? benefitTag,
    String? shapeIcon,
    String? colorHex,
    String? description,
    String? referralUrl,
    List<String>? sideEffects,
    List<String>? interactions,
    int? focusLevel,
    String? status,
    String? mechanismOfAction,
    List<String>? detailedBenefits,
    String? timingRationale,
    int? scientificEvidenceRank,
    Map<String, String>? studyLinks,
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
      form: form ?? this.form,
      benefitTag: benefitTag ?? this.benefitTag,
      shapeIcon: shapeIcon ?? this.shapeIcon,
      colorHex: colorHex ?? this.colorHex,
      description: description ?? this.description,
      referralUrl: referralUrl ?? this.referralUrl,
      sideEffects: sideEffects ?? this.sideEffects,
      interactions: interactions ?? this.interactions,
      focusLevel: focusLevel ?? this.focusLevel,
      status: status ?? this.status,
      mechanismOfAction: mechanismOfAction ?? this.mechanismOfAction,
      detailedBenefits: detailedBenefits ?? this.detailedBenefits,
      timingRationale: timingRationale ?? this.timingRationale,
      scientificEvidenceRank:
          scientificEvidenceRank ?? this.scientificEvidenceRank,
      studyLinks: studyLinks ?? this.studyLinks,
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
      'form': form,
      'benefitTag': benefitTag,
      'shapeIcon': shapeIcon,
      'colorHex': colorHex,
      'description': description,
      'referralUrl': referralUrl,
      'sideEffects': sideEffects,
      'interactions': interactions,
      'focusLevel': focusLevel,
      'status': status,
      'mechanismOfAction': mechanismOfAction,
      'detailedBenefits': detailedBenefits,
      'timingRationale': timingRationale,
      'scientificEvidenceRank': scientificEvidenceRank,
      'studyLinks': studyLinks,
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
      form: json['form'] as String?,
      benefitTag:
          json['benefitTag'] as String? ?? json['benefit_tag'] as String?,
      shapeIcon: json['shapeIcon'] as String? ??
          json['shape_icon'] as String? ??
          json['iconType'] as String?,
      colorHex: json['colorHex'] as String? ??
          json['color_hex'] as String? ??
          json['iconColor'] as String?,
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
      status: json['status'] as String? ?? 'beneficial',
      mechanismOfAction: json['mechanismOfAction'] as String?,
      detailedBenefits: (json['detailedBenefits'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      timingRationale: json['timingRationale'] as String?,
      scientificEvidenceRank: json['scientificEvidenceRank'] as int?,
      studyLinks: (json['studyLinks'] as Map<String, dynamic>?)?.map(
            (k, v) => MapEntry(k, v as String),
          ) ??
          {},
    );
  }
}
