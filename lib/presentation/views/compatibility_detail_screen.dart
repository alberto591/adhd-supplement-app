import 'package:flutter/material.dart';
import '../../domain/entities/routine_element.dart';
import '../../domain/entities/supplement_compatibility.dart';
import '../theme/app_theme.dart';
import '../navigation/app_router.dart';

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

    final title = guidance?.title ?? 'Routine Consideration';
    final description =
        guidance?.description ?? compatibility?.description ?? '';
    final recommendation =
        guidance?.recommendation ?? compatibility?.recommendation ?? '';
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
            if (severity != null) _buildMedSeverityHeader(severity),
            if (compSeverity != null) _buildCompSeverityHeader(compSeverity),

            const SizedBox(height: 32),

            // Compatibility Description
            Text(
              'Compatibility Details',
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
                        'Recommendation',
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
                'Scientific Context',
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
                child: const Text('Acknowledged'),
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
                  'Confirm advisor consultation',
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

  Widget _buildMedSeverityHeader(GuidanceLevel severity) {
    final color = _getMedColor(severity);
    final icon = _getMedIcon(severity);
    final label = _getMedLabel(severity);

    return _buildBaseHeader(color, icon, label);
  }

  Widget _buildCompSeverityHeader(CompatibilityLevel severity) {
    final color = _getCompColor(severity);
    final icon = _getCompIcon(severity);
    final label = _getCompLabel(severity);

    return _buildBaseHeader(color, icon, label);
  }

  Widget _buildBaseHeader(Color color, IconData icon, String label) {
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
                const Text(
                  'Routine Analysis Status',
                  style: TextStyle(
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

  String _getMedLabel(GuidanceLevel severity) {
    switch (severity) {
      case GuidanceLevel.danger:
        return 'PRIORITY CONSIDERATION';
      case GuidanceLevel.warning:
        return 'ROUTINE ALERT';
      case GuidanceLevel.caution:
        return 'TIMING CONSIDERATION';
      case GuidanceLevel.info:
        return 'ROUTINE OPTIMIZED';
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

  String _getCompLabel(CompatibilityLevel severity) {
    switch (severity) {
      case CompatibilityLevel.critical:
        return 'NOT OPTIMAL';
      case CompatibilityLevel.caution:
        return 'TIMING CONSIDERATION';
      case CompatibilityLevel.stable:
        return 'OPTIMIZED';
    }
  }
}
