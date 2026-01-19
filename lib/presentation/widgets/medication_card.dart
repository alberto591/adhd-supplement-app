import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

enum MedicationStatus { pending, taken, upcoming }

class MedicationCard extends StatelessWidget {
  final String name;
  final String dosage;
  final String instructions; // e.g. "With food", "Before bed", "Taken at 8:30 AM"
  final IconData icon;
  final Color iconColor;
  final Color iconBackgroundColor;
  final MedicationStatus status;
  final VoidCallback? onTake;

  const MedicationCard({
    super.key,
    required this.name,
    required this.dosage,
    required this.instructions,
    required this.icon,
    required this.iconColor,
    required this.iconBackgroundColor,
    this.status = MedicationStatus.pending,
    this.onTake,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isTaken = status == MedicationStatus.taken;
    final isUpcoming = status == MedicationStatus.upcoming;

    // Card Background Color
    Color cardColor;
    if (isTaken) {
       cardColor = isDark ? Colors.blueGrey.withValues(alpha: 0.1) : Colors.grey[50]!;
    } else if (isUpcoming) {
       cardColor = isDark ? AppColors.cardDark.withValues(alpha: 0.6) : Colors.white.withValues(alpha: 0.6);
    } else {
       cardColor = isDark ? AppColors.cardDark : AppColors.cardLight;
    }

    // Border Color
    Color borderColor = Colors.transparent;
    if (!isTaken && !isUpcoming) {
      borderColor = isDark ? Colors.grey[800]! : Colors.grey[100]!;
    }

    // Opacity for taken state
    final opacity = isTaken || isUpcoming ? 0.75 : 1.0;

    return Opacity(
      opacity: opacity,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor),
          boxShadow: (!isTaken && !isUpcoming)
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  )
                ]
              : null,
        ),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: isTaken 
                          ? (isDark ? Colors.grey[800] : Colors.grey[200]) 
                          : iconBackgroundColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        icon,
                        size: 32,
                        color: isTaken 
                          ? (isDark ? Colors.grey[400] : Colors.grey[400])
                          : iconColor,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                decoration: isTaken ? TextDecoration.lineThrough : null,
                                color: isTaken 
                                  ? (isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight)
                                  : (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
                              ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '$dosage • $instructions',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                                fontWeight: FontWeight.w500,
                              ),
                        ),
                      ],
                    ),
                  ],
                ),
                if (isTaken)
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: Colors.green.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.check, color: Colors.green, size: 20),
                  )
                else if (isUpcoming)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: isDark ? Colors.grey[800] : Colors.grey[100],
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      'Upcoming',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                      ),
                    ),
                  )
                else
                  Icon(
                    Icons.more_vert,
                    color: isDark ? AppColors.textSecondaryDark : Colors.grey[400],
                  ),
              ],
            ),
            if (!isTaken && !isUpcoming) ...[
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton.icon(
                  onPressed: onTake,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 4,
                    shadowColor: AppColors.primary.withValues(alpha: 0.4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Icons.check_circle, size: 20),
                  label: const Text(
                    'Mark as Taken',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
