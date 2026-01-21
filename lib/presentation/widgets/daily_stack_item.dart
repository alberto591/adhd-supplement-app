import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class DailyStackItem extends StatelessWidget {
  final String name;
  final String details;
  final IconData icon;
  final bool isTaken;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;
  final VoidCallback? onInfoTap;

  const DailyStackItem({
    super.key,
    required this.name,
    required this.details,
    required this.icon,
    this.isTaken = false,
    required this.onTap,
    this.onLongPress,
    this.onInfoTap,
  });

  @override
  Widget build(BuildContext context) {
    // Capture theme brightness
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? AppColors.cardDark : AppColors.cardLight;
    final borderColor = isDark
        ? Colors.white.withValues(alpha: 0.05)
        : Colors.black.withValues(alpha: 0.05);
    final textColor = isDark ? Colors.white : AppColors.textPrimaryLight;
    final secondaryTextColor =
        isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;

    return GestureDetector(
      onLongPress: onLongPress,
      onTap: onTap, // Making the whole card tappable for toggle
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor),
          boxShadow: isDark
              ? null
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.primaryGold.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: AppColors.primaryGold, size: 22),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          name,
                          style: TextStyle(
                            color: textColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (onInfoTap != null) ...[
                          const SizedBox(width: 4),
                          GestureDetector(
                            onTap: onInfoTap,
                            child: Icon(Icons.info_outline,
                                size: 14,
                                color: AppColors.primaryGold
                                    .withValues(alpha: 0.6)),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      details,
                      style: TextStyle(
                        color: secondaryTextColor,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(99),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isTaken ? Colors.transparent : Colors.transparent,
                  border: Border.all(
                    color: isTaken
                        ? AppColors.accentGreen.withValues(alpha: 0.4)
                        : (isDark
                            ? Colors.white.withValues(alpha: 0.1)
                            : Colors.black.withValues(alpha: 0.1)),
                    width: 2,
                  ),
                ),
                child: isTaken
                    ? const Center(
                        child: Icon(Icons.check,
                            color: AppColors.accentGreen, size: 20))
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
