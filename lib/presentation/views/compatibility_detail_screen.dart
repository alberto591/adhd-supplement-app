import 'package:flutter/material.dart';
import '../../domain/entities/routine_element.dart';
import '../../domain/entities/supplement_compatibility.dart';
import '../theme/app_theme.dart';
import '../navigation/app_router.dart';
import 'package:neurostack_app/l10n/generated/app_localizations.dart';

class CompatibilityDetailScreen extends StatelessWidget {
  final CompatibilityGuidance? guidance;
  final SupplementCompatibility? compatibility;

  const CompatibilityDetailScreen({
    super.key,
    this.guidance,
    this.compatibility,
  }) : assert(guidance != null || compatibility != null);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    final title = guidance != null
        ? _translateRule(l10n, guidance!.titleKey, guidance!.title)
        : l10n.routineConsideration;
    final description = guidance != null
        ? _translateRule(l10n, guidance!.descriptionKey, guidance!.description)
        : compatibility?.description ?? '';
    final recommendation = guidance != null
        ? _translateRule(
            l10n, guidance!.recommendationKey, guidance!.recommendation)
        : compatibility?.recommendation ?? '';
    final scientificReferences = guidance?.scientificReferences ??
        compatibility?.scientificReferences ??
        [];

    final severity = guidance?.severity;
    final compSeverity = compatibility?.severity;

    return Scaffold(
      backgroundColor:
          isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(title),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (severity != null) _buildMedSeverityHeader(l10n, severity),
            if (compSeverity != null)
              _buildCompSeverityHeader(l10n, compSeverity),

            const SizedBox(height: 32),

            // Compatibility Description
            Text(
              l10n.compatibilityDetails,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              description,
              style: TextStyle(
                fontSize: 16,
                height: 1.6,
                color: isDark ? Colors.grey[300] : Colors.grey[800],
              ),
            ),

            const SizedBox(height: 32),

            // Personalized Recommendation
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: _getThemeColor(severity, compSeverity)
                    .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: _getThemeColor(severity, compSeverity)
                      .withValues(alpha: 0.3),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.lightbulb_outline,
                        color: _getThemeColor(severity, compSeverity),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        l10n.recommendationLabel,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: _getThemeColor(severity, compSeverity),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    recommendation,
                    style: TextStyle(
                      fontSize: 15,
                      height: 1.5,
                      color: isDark ? Colors.grey[300] : Colors.grey[800],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Scientific References
            if (scientificReferences.isNotEmpty) ...[
              Text(
                l10n.scientificContext,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
              const SizedBox(height: 16),
              ...scientificReferences.map((ref) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.check_circle_outline,
                          size: 18,
                          color: isDark ? Colors.grey[500] : Colors.grey[600],
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            ref,
                            style: TextStyle(
                              fontSize: 14,
                              fontStyle: FontStyle.italic,
                              color:
                                  isDark ? Colors.grey[400] : Colors.grey[600],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ))
            ],

            const SizedBox(height: 48),

            // Action Buttons
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Text(l10n.acknowledged),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    AppRouter.safetyOverrideConfirmation,
                    arguments: guidance ?? compatibility,
                  );
                },
                child: Text(
                  l10n.confirmAdvisorConsultation,
                  style: TextStyle(
                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  String _translateRule(AppLocalizations l10n, String? key, String fallback) {
    if (key == null) return fallback;
    switch (key) {
      case 'ruleVitaminCTypeATitle':
        return l10n.ruleVitaminCTypeATitle;
      case 'ruleVitaminCTypeADesc':
        return l10n.ruleVitaminCTypeADesc;
      case 'ruleVitaminCTypeARec':
        return l10n.ruleVitaminCTypeARec;
      case 'ruleAscorbicAcidTypeATitle':
        return l10n.ruleAscorbicAcidTypeATitle;
      case 'ruleAscorbicAcidTypeADesc':
        return l10n.ruleAscorbicAcidTypeADesc;
      case 'ruleAscorbicAcidTypeARec':
        return l10n.ruleAscorbicAcidTypeARec;
      case 'ruleCitrusTypeATitle':
        return l10n.ruleCitrusTypeATitle;
      case 'ruleCitrusTypeADesc':
        return l10n.ruleCitrusTypeADesc;
      case 'ruleCitrusTypeARec':
        return l10n.ruleCitrusTypeARec;
      case 'ruleTyrosineTypeATitle':
        return l10n.ruleTyrosineTypeATitle;
      case 'ruleTyrosineTypeADesc':
        return l10n.ruleTyrosineTypeADesc;
      case 'ruleTyrosineTypeARec':
        return l10n.ruleTyrosineTypeARec;
      case 'rule5HtpTypeCTitle':
        return l10n.rule5HtpTypeCTitle;
      case 'rule5HtpTypeCDesc':
        return l10n.rule5HtpTypeCDesc;
      case 'rule5HtpTypeCRec':
        return l10n.rule5HtpTypeCRec;
      case 'ruleJohnsWortTypeATitle':
        return l10n.ruleJohnsWortTypeATitle;
      case 'ruleJohnsWortTypeADesc':
        return l10n.ruleJohnsWortTypeADesc;
      case 'ruleJohnsWortTypeARec':
        return l10n.ruleJohnsWortTypeARec;
      case 'ruleGinkgoTypeATitle':
        return l10n.ruleGinkgoTypeATitle;
      case 'ruleGinkgoTypeADesc':
        return l10n.ruleGinkgoTypeADesc;
      case 'ruleGinkgoTypeARec':
        return l10n.ruleGinkgoTypeARec;
      default:
        return fallback;
    }
  }

  Widget _buildMedSeverityHeader(
      AppLocalizations l10n, GuidanceLevel severity) {
    final color = _getMedColor(severity);
    final icon = _getMedIcon(severity);
    final label = _getMedLabel(l10n, severity);

    return _buildBaseHeader(l10n, color, icon, label);
  }

  Widget _buildCompSeverityHeader(
      AppLocalizations l10n, CompatibilityLevel severity) {
    final color = _getCompColor(severity);
    final icon = _getCompIcon(severity);
    final label = _getCompLabel(l10n, severity);

    return _buildBaseHeader(l10n, color, icon, label);
  }

  Widget _buildBaseHeader(
      AppLocalizations l10n, Color color, IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                Text(
                  l10n.routineAnalysisStatus,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getThemeColor(GuidanceLevel? med, CompatibilityLevel? comp) {
    if (med != null) return _getMedColor(med);
    if (comp != null) return _getCompColor(comp);
    return AppColors.primary;
  }

  Color _getMedColor(GuidanceLevel severity) {
    switch (severity) {
      case GuidanceLevel.danger:
        return Colors.red;
      case GuidanceLevel.warning:
        return AppColors.warningAmber;
      case GuidanceLevel.caution:
        return AppColors.primary;
      case GuidanceLevel.info:
        return AppColors.secondary;
    }
  }

  IconData _getMedIcon(GuidanceLevel severity) {
    switch (severity) {
      case GuidanceLevel.danger:
        return Icons.report_problem;
      case GuidanceLevel.warning:
        return Icons.warning_amber_rounded;
      case GuidanceLevel.caution:
        return Icons.info_outline;
      case GuidanceLevel.info:
        return Icons.help_outline;
    }
  }

  String _getMedLabel(AppLocalizations l10n, GuidanceLevel severity) {
    switch (severity) {
      case GuidanceLevel.danger:
        return l10n.priorityConsideration;
      case GuidanceLevel.warning:
        return l10n.routineAlertLabel;
      case GuidanceLevel.caution:
        return l10n.timingConsiderationLabel;
      case GuidanceLevel.info:
        return l10n.routineOptimizedLabel;
    }
  }

  Color _getCompColor(CompatibilityLevel severity) {
    switch (severity) {
      case CompatibilityLevel.critical:
        return Colors.red;
      case CompatibilityLevel.caution:
        return AppColors.warningAmber;
      case CompatibilityLevel.stable:
        return AppColors.primary;
    }
  }

  IconData _getCompIcon(CompatibilityLevel severity) {
    switch (severity) {
      case CompatibilityLevel.critical:
        return Icons.report_problem;
      case CompatibilityLevel.caution:
        return Icons.warning_amber_rounded;
      case CompatibilityLevel.stable:
        return Icons.check_circle_outline;
    }
  }

  String _getCompLabel(AppLocalizations l10n, CompatibilityLevel severity) {
    switch (severity) {
      case CompatibilityLevel.critical:
        return l10n.notOptimal;
      case CompatibilityLevel.caution:
        return l10n.timingConsiderationLabel;
      case CompatibilityLevel.stable:
        return l10n.optimized;
    }
  }
}
