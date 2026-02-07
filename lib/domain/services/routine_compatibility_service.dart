/// Routine Guard - Routine Optimization Checker
///
/// Cross-references user's routine elements with supplements to detect
/// routine considerations and display appropriate guidance.
library;

import 'package:neurostack_app/domain/entities/supplement.dart';
import 'package:neurostack_app/domain/entities/routine_element.dart';

/// Routine Compatibility Service - Routine Optimization Checker
class RoutineCompatibilityService {
  final List<RoutineElement> _userElements;

  RoutineCompatibilityService(this._userElements);

  /// Known optimization rules database
  static final List<_OptimizationRule> _optimizationRules = [
    // TYPE A: VITAMIN C + TYPE A ELEMENTS
    const _OptimizationRule(
      supplementPattern: 'vitamin c',
      elementType: ElementCategory.typeA,
      checkHighDose: true,
      highDoseThresholdMg: 500.0,
      severity: GuidanceLevel.warning,
      title: 'Routine Consideration',
      description: 'Vitamin C may adjust pH levels, which can influence '
          'how quickly Type A elements are processed by your body. '
          'This may change the duration of their effects.',
      recommendation: 'Consider separating usage by 1-2 hours for '
          'consistent results.',
      titleKey: 'ruleVitaminCTypeATitle',
      descriptionKey: 'ruleVitaminCTypeADesc',
      recommendationKey: 'ruleVitaminCTypeARec',
    ),

    // ASCORBIC ACID (pure form)
    const _OptimizationRule(
      supplementPattern: 'ascorbic acid',
      elementType: ElementCategory.typeA,
      severity: GuidanceLevel.warning,
      title: 'Routine Consideration',
      description: 'Ascorbic Acid (Vitamin C) may accelerate the processing '
          'of Type A elements, potentially shortening their window of activity.',
      recommendation: 'Consider separating usage by 1-2 hours for '
          'consistent results.',
      titleKey: 'ruleAscorbicAcidTypeATitle',
      descriptionKey: 'ruleAscorbicAcidTypeADesc',
      recommendationKey: 'ruleAscorbicAcidTypeARec',
    ),

    // CITRUS-BASED SUPPLEMENTS
    const _OptimizationRule(
      supplementPattern: 'citrus',
      elementType: ElementCategory.typeA,
      severity: GuidanceLevel.caution,
      title: 'Timing Consideration',
      description: 'Citrus supplements often contain acidic compounds '
          'that can influence the absorption rate of routine elements.',
      recommendation: 'Use at least 1 hour apart from Type A items.',
      titleKey: 'ruleCitrusTypeATitle',
      descriptionKey: 'ruleCitrusTypeADesc',
      recommendationKey: 'ruleCitrusTypeARec',
    ),

    // TYPE A + L-TYROSINE
    const _OptimizationRule(
      supplementPattern: 'tyrosine',
      elementType: ElementCategory.typeA,
      severity: GuidanceLevel.caution,
      title: 'Timing Consideration',
      description: 'L-Tyrosine is a precursor that may influence focus. '
          'Using it with Type A items may impact sensitivity.',
      recommendation:
          'Start with low doses and monitor for changes in sensitivity.',
      titleKey: 'ruleTyrosineTypeATitle',
      descriptionKey: 'ruleTyrosineTypeADesc',
      recommendationKey: 'ruleTyrosineTypeARec',
    ),

    // TYPE C + 5-HTP
    const _OptimizationRule(
      supplementPattern: '5-htp',
      elementType: ElementCategory.typeC,
      severity: GuidanceLevel.danger,
      title: 'Routine Consideration',
      description: '5-HTP combined with Type C elements may create '
          'unintended intensity in your routine.',
      recommendation: 'Consult your wellness advisor before combining '
          'these items.',
      titleKey: 'rule5HtpTypeCTitle',
      descriptionKey: 'rule5HtpTypeCDesc',
      recommendationKey: 'rule5HtpTypeCRec',
    ),

    // ST. JOHN'S WORT
    const _OptimizationRule(
      supplementPattern: "john's wort",
      elementType: ElementCategory.typeA,
      severity: GuidanceLevel.warning,
      title: 'Advisor Guidance',
      description: "St. John's Wort can accelerate how your body "
          'processes routine elements, potentially ensuring a shorter duration of effect.',
      recommendation: 'Discuss optimization strategies with your advisor.',
      titleKey: 'ruleJohnsWortTypeATitle',
      descriptionKey: 'ruleJohnsWortTypeADesc',
      recommendationKey: 'ruleJohnsWortTypeARec',
    ),

    // GINKGO
    const _OptimizationRule(
      supplementPattern: 'ginkgo',
      elementType: ElementCategory.typeA,
      severity: GuidanceLevel.caution,
      title: 'Circulation Consideration',
      description: 'Ginkgo supports circulation, which may '
          'synergize with Type A effects in unexpected ways.',
      recommendation:
          'Monitor your focus levels if combining. Check with an advisor '
          'for personalized guidance.',
      titleKey: 'ruleGinkgoTypeATitle',
      descriptionKey: 'ruleGinkgoTypeADesc',
      recommendationKey: 'ruleGinkgoTypeARec',
    ),
  ];

  /// Check a supplement against user's elements for optimizations
  List<CompatibilityGuidance> checkSupplement(Supplement supplement) {
    final warnings = <CompatibilityGuidance>[];
    final supplementName = supplement.name.toLowerCase();

    for (final element in _userElements) {
      for (final rule in _optimizationRules) {
        if (_matchesRule(supplementName, element, rule)) {
          warnings.add(CompatibilityGuidance(
            supplementName: supplement.name,
            elementName: element.name,
            severity: rule.severity,
            title: rule.title,
            description: rule.description,
            recommendation: rule.recommendation,
            titleKey: rule.titleKey,
            descriptionKey: rule.descriptionKey,
            recommendationKey: rule.recommendationKey,
          ));
        }
      }
    }

    return warnings;
  }

  /// Check if supplement name and item match an optimization rule
  bool _matchesRule(
    String supplementName,
    RoutineElement element,
    _OptimizationRule rule,
  ) {
    if (!supplementName.contains(rule.supplementPattern)) {
      return false;
    }

    if (element.type != rule.elementType) {
      return false;
    }

    return true;
  }

  /// Check if user is using any Type A elements
  bool get hasTypeA =>
      _userElements.any((m) => m.type == ElementCategory.typeA);

  /// Check if user is using any Type C elements
  bool get hasTypeC =>
      _userElements.any((m) => m.type == ElementCategory.typeC);

  /// Get the highest severity warning from a list
  static GuidanceLevel? getHighestSeverity(
      List<CompatibilityGuidance> warnings) {
    if (warnings.isEmpty) return null;

    const severityOrder = [
      GuidanceLevel.info,
      GuidanceLevel.caution,
      GuidanceLevel.warning,
      GuidanceLevel.danger,
    ];

    return warnings.map((w) => w.severity).reduce(
        (a, b) => severityOrder.indexOf(a) > severityOrder.indexOf(b) ? a : b);
  }
}

/// Internal rule definition
class _OptimizationRule {
  final String supplementPattern;
  final ElementCategory elementType;
  final bool checkHighDose;
  final double? highDoseThresholdMg;
  final GuidanceLevel severity;
  final String title;
  final String description;
  final String recommendation;
  final String titleKey;
  final String descriptionKey;
  final String recommendationKey;

  const _OptimizationRule({
    required this.supplementPattern,
    required this.elementType,
    this.checkHighDose = false,
    this.highDoseThresholdMg,
    required this.severity,
    required this.title,
    required this.description,
    required this.recommendation,
    required this.titleKey,
    required this.descriptionKey,
    required this.recommendationKey,
  });
}
