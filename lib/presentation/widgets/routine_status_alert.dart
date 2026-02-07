import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../domain/services/routine_compatibility_service.dart';
import '../../domain/entities/routine_element.dart';
import 'package:neurostack_app/l10n/generated/app_localizations.dart';

class RoutineStatusAlert extends StatelessWidget {
  final List<CompatibilityGuidance> warnings;
  final bool isDark;

  const RoutineStatusAlert({
    super.key,
    required this.warnings,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (warnings.isEmpty) return const SizedBox.shrink();

    // Determine highest severity for overall styling
    final highestSeverity =
        RoutineCompatibilityService.getHighestSeverity(warnings);
    final alertColor = _getSeverityColor(highestSeverity);

    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: alertColor.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: alertColor.withValues(alpha: 0.3),
          width: 2,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            color: alertColor.withValues(alpha: 0.1),
            child: Row(
              children: [
                Icon(
                  _getSeverityIcon(highestSeverity),
                  color: alertColor,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Text(
                  _getSeverityLabel(l10n, highestSeverity),
                  style: GoogleFonts.lexend(
                    color: alertColor,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.0,
                  ),
                ),
              ],
            ),
          ),

          // Warnings List
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...warnings.map((warning) => Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.withElementLabel(warning.elementName),
                            style: GoogleFonts.lexend(
                              color: isDark ? Colors.white : Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _translateRule(l10n, warning.descriptionKey,
                                warning.description),
                            style: GoogleFonts.lexend(
                              color:
                                  isDark ? Colors.grey[300] : Colors.grey[700],
                              fontSize: 14,
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(Icons.lightbulb_outline,
                                  size: 16, color: alertColor),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  _translateRule(
                                      l10n,
                                      warning.recommendationKey,
                                      warning.recommendation),
                                  style: GoogleFonts.lexend(
                                    color: alertColor,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )),
                const Divider(),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.info_outline,
                        size: 14, color: Colors.grey),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        l10n.consultAdvisorRoutineNote,
                        style: GoogleFonts.lexend(
                          color: Colors.grey,
                          fontSize: 11,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
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

  Color _getSeverityColor(GuidanceLevel? severity) {
    switch (severity) {
      case GuidanceLevel.danger:
        return const Color(0xFFEF4444); // Red
      case GuidanceLevel.warning:
        return const Color(0xFFF59E0B); // Amber
      case GuidanceLevel.caution:
        return const Color(0xFF3B82F6); // Blue
      default:
        return const Color(0xFF10B981); // Green
    }
  }

  IconData _getSeverityIcon(GuidanceLevel? severity) {
    switch (severity) {
      case GuidanceLevel.danger:
        return Icons.gpp_maybe;
      case GuidanceLevel.warning:
        return Icons.warning_amber_rounded;
      case GuidanceLevel.caution:
        return Icons.info_outline;
      default:
        return Icons.check_circle_outline;
    }
  }

  String _getSeverityLabel(AppLocalizations l10n, GuidanceLevel? severity) {
    switch (severity) {
      case GuidanceLevel.danger:
        return l10n.priorityConsideration;
      case GuidanceLevel.warning:
        return l10n.routineAlertLabel;
      case GuidanceLevel.caution:
        return l10n.timingConsiderationLabel;
      default:
        return l10n.routineOptimizedLabel;
    }
  }
}
