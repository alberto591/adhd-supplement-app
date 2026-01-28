import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

import '../../domain/entities/supplement_compatibility.dart';

class RoutineAlertBanner extends StatelessWidget {
  final SupplementCompatibility? compatibility;
  final VoidCallback? onLearnMore;
  final VoidCallback? onDismiss;

  const RoutineAlertBanner({
    super.key,
    this.compatibility,
    this.onLearnMore,
    this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    if (compatibility == null) return const SizedBox.shrink();

    final severityColor = _getSeverityColor(compatibility!.severity);

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: severityColor.withValues(alpha: 0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: 6,
              color: severityColor,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(_getSeverityIcon(compatibility!.severity),
                            color: severityColor, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          _getSeverityLabel(compatibility!.severity),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      compatibility!.description,
                      style: const TextStyle(
                        color: AppColors.textSecondaryDark,
                        fontSize: 14,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        if (onLearnMore != null)
                          _buildActionButton(
                              'Learn More',
                              AppColors.secondary.withValues(alpha: 0.2),
                              Colors.white,
                              onLearnMore!),
                        const SizedBox(width: 12),
                        if (onDismiss != null)
                          _buildActionButton('Dismiss', Colors.transparent,
                              AppColors.textSecondaryDark, onDismiss!),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(
      String label, Color bg, Color text, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: text,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Color _getSeverityColor(CompatibilityLevel severity) {
    switch (severity) {
      case CompatibilityLevel.critical:
        return Colors.red;
      case CompatibilityLevel.caution:
        return Colors.amber;
      case CompatibilityLevel.stable:
        return Colors.blue;
    }
  }

  IconData _getSeverityIcon(CompatibilityLevel severity) {
    switch (severity) {
      case CompatibilityLevel.critical:
        return Icons.warning_amber_rounded;
      case CompatibilityLevel.caution:
        return Icons.info_outline;
      case CompatibilityLevel.stable:
        return Icons.check_circle_outline;
    }
  }

  String _getSeverityLabel(CompatibilityLevel severity) {
    switch (severity) {
      case CompatibilityLevel.critical:
        return 'Routine Consideration';
      case CompatibilityLevel.caution:
        return 'Optimization Suggested';
      case CompatibilityLevel.stable:
        return 'Balanced Combination';
    }
  }
}
