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
  final String? userId; // Owner of the supplement (null for global)
  final bool isCustom; // Whether this is a user-created supplement
  final Map<String, Map<String, dynamic>>?
      translations; // locale: { field: value }

  // Phase 1 Enhancements: Dosage Intelligence
  final Map<String, String>?
      dosageByWeight; // weight range: dosage (e.g., "50-70kg": "300mg")
  final String? dosageFrequency; // "Once daily", "Twice daily", etc.
  final String? bestTimeToTake; // "With breakfast", "30 min before bed"
  final List<String>? dosageWarnings; // Special population warnings

// Clinical fields removed for Play Console compliance

  final bool requiresPrescription; // Legal status

  // Phase 1 Enhancements: Evidence & Research
  final String? metaAnalysisSummary; // Summary of research consensus
  final int? participantCount; // Total across all studies
  final String? lastReviewedDate; // When evidence was updated

  // Phase 1 Enhancements: User Experience
  final double? communityRating; // 1-5 stars from app users
  final int? reviewCount;

  // Phase 1 Enhancements: Comparison & FAQs
  final List<String>? similarSupplements; // IDs of alternatives
  final String? comparisonSummary; // Why this vs. alternatives
  final Map<String, String>? faqs; // question: answer
  final String? tldr; // One-sentence summary for skimmers

  // Backward compatibility
  String? get iconType => shapeIcon;
  String? get iconColor => colorHex;

  // From models/supplement.dart
  final String description;
  final String referralUrl;
  final List<String> sideEffects;
  final List<String> compatibilitys;
  final int focusLevel; // 1-5 scale for Neurostack focus improvement

  String get formattedReferralUrl {
    if (referralUrl.isEmpty) return '';
    final uri = Uri.parse(referralUrl);
    final params = Map<String, String>.from(uri.queryParameters);

    if (uri.host.contains('amazon.com')) {
      params['tag'] = 'focussupps-20';
    } else if (uri.host.contains('iherb.com')) {
      params['rcode'] = 'NeurostackSUPPS';
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
    this.compatibilitys = const [],
    this.focusLevel = 3,
    this.status = 'beneficial',
    this.mechanismOfAction,
    this.detailedBenefits = const [],
    this.timingRationale,
    this.scientificEvidenceRank,
    this.studyLinks = const {},
    // Phase 1 fields
    this.dosageByWeight,
    this.dosageFrequency,
    this.bestTimeToTake,
    this.dosageWarnings,
// contraindications, drugCompatibilitys, focusMedCompatibilitys, pregnancyCategory removed
    this.requiresPrescription = false,
    this.metaAnalysisSummary,
    this.participantCount,
    this.lastReviewedDate,
    this.communityRating,
    this.reviewCount,
    this.similarSupplements,
    this.comparisonSummary,
    this.faqs,
    this.tldr,
    this.userId,
    this.isCustom = false,
    this.translations,
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
    List<String>? compatibilitys,
    int? focusLevel,
    String? status,
    String? mechanismOfAction,
    List<String>? detailedBenefits,
    String? timingRationale,
    int? scientificEvidenceRank,
    Map<String, String>? studyLinks,
    // Phase 1 fields
    Map<String, String>? dosageByWeight,
    String? dosageFrequency,
    String? bestTimeToTake,
    List<String>? dosageWarnings,
// compatibilitys removed
    bool? requiresPrescription,
    String? metaAnalysisSummary,
    int? participantCount,
    String? lastReviewedDate,
    double? communityRating,
    int? reviewCount,
    List<String>? similarSupplements,
    String? comparisonSummary,
    Map<String, String>? faqs,
    String? tldr,
    String? userId,
    bool? isCustom,
    Map<String, Map<String, dynamic>>? translations,
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
      compatibilitys: compatibilitys ?? this.compatibilitys,
      focusLevel: focusLevel ?? this.focusLevel,
      status: status ?? this.status,
      mechanismOfAction: mechanismOfAction ?? this.mechanismOfAction,
      detailedBenefits: detailedBenefits ?? this.detailedBenefits,
      timingRationale: timingRationale ?? this.timingRationale,
      scientificEvidenceRank:
          scientificEvidenceRank ?? this.scientificEvidenceRank,
      studyLinks: studyLinks ?? this.studyLinks,
      // Phase 1 fields
      dosageByWeight: dosageByWeight ?? this.dosageByWeight,
      dosageFrequency: dosageFrequency ?? this.dosageFrequency,
      bestTimeToTake: bestTimeToTake ?? this.bestTimeToTake,
      dosageWarnings: dosageWarnings ?? this.dosageWarnings,
// compatibilitys assignments removed
      requiresPrescription: requiresPrescription ?? this.requiresPrescription,
      metaAnalysisSummary: metaAnalysisSummary ?? this.metaAnalysisSummary,
      participantCount: participantCount ?? this.participantCount,
      lastReviewedDate: lastReviewedDate ?? this.lastReviewedDate,
      communityRating: communityRating ?? this.communityRating,
      reviewCount: reviewCount ?? this.reviewCount,
      similarSupplements: similarSupplements ?? this.similarSupplements,
      comparisonSummary: comparisonSummary ?? this.comparisonSummary,
      faqs: faqs ?? this.faqs,
      tldr: tldr ?? this.tldr,
      userId: userId ?? this.userId,
      isCustom: isCustom ?? this.isCustom,
      translations: translations ?? this.translations,
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
      'compatibilitys': compatibilitys,
      'focusLevel': focusLevel,
      'status': status,
      'mechanismOfAction': mechanismOfAction,
      'detailedBenefits': detailedBenefits,
      'timingRationale': timingRationale,
      'scientificEvidenceRank': scientificEvidenceRank,
      'studyLinks': studyLinks,
      // Phase 1 fields
      'dosageByWeight': dosageByWeight,
      'dosageFrequency': dosageFrequency,
      'bestTimeToTake': bestTimeToTake,
      'dosageWarnings': dosageWarnings,
// compatibilitys json removed
      'requiresPrescription': requiresPrescription,
      'metaAnalysisSummary': metaAnalysisSummary,
      'participantCount': participantCount,
      'lastReviewedDate': lastReviewedDate,
      'communityRating': communityRating,
      'reviewCount': reviewCount,
      'similarSupplements': similarSupplements,
      'comparisonSummary': comparisonSummary,
      'faqs': faqs,
      'tldr': tldr,
      'userId': userId,
      'isCustom': isCustom,
      'translations': translations,
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
      compatibilitys: (json['compatibilitys'] as List<dynamic>?)
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
      // Phase 1 fields
      dosageByWeight: (json['dosageByWeight'] as Map<String, dynamic>?)?.map(
        (k, v) => MapEntry(k, v as String),
      ),
      dosageFrequency: json['dosageFrequency'] as String?,
      bestTimeToTake: json['bestTimeToTake'] as String?,
// compatibilitys parsing removed
      requiresPrescription: json['requiresPrescription'] as bool? ?? false,
      metaAnalysisSummary: json['metaAnalysisSummary'] as String?,
      participantCount: json['participantCount'] as int?,
      lastReviewedDate: json['lastReviewedDate'] as String?,
      communityRating: (json['communityRating'] as num?)?.toDouble(),
      reviewCount: json['reviewCount'] as int?,
      similarSupplements: (json['similarSupplements'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      comparisonSummary: json['comparisonSummary'] as String?,
      faqs: (json['faqs'] as Map<String, dynamic>?)?.map(
        (k, v) => MapEntry(k, v as String),
      ),
      tldr: json['tldr'] as String?,
      userId: json['userId'] as String?,
      isCustom: json['isCustom'] as bool? ?? false,
      translations: (json['translations'] as Map<String, dynamic>?)?.map(
        (k, v) => MapEntry(k, Map<String, dynamic>.from(v as Map)),
      ),
    );
  }

  /// Helper to get a localized field or fallback to the default
  String getLocalizedField(
      String fieldName, String defaultValue, String locale) {
    if (translations == null || !translations!.containsKey(locale)) {
      return defaultValue;
    }
    return translations![locale]![fieldName] as String? ?? defaultValue;
  }

  /// Helper for List fields
  List<String> getLocalizedListField(
      String fieldName, List<String> defaultList, String locale) {
    if (translations == null || !translations!.containsKey(locale)) {
      return defaultList;
    }
    final localized = translations![locale]![fieldName] as List<dynamic>?;
    return localized?.map((e) => e as String).toList() ?? defaultList;
  }
}
