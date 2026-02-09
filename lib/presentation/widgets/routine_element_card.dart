import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../utils/logger.dart';
import '../theme/app_theme.dart';

class RoutineElementCard extends StatelessWidget {
  final String title;
  final String dosage;
  final String form;
  final IconData
      icon; // In real app, this might come from asset path derived from type
  final Color iconColor;
  final String? statusText; // "Taken at 8:30 AM" or "Upcoming"
  final Color? statusColor;
  final bool isTaken;
  final bool isSkipped;
  final bool isUpcoming;
  final bool isFocused;
  final bool hasStudies;
  final VoidCallback? onTake;
  final VoidCallback? onMoreOptions;
  final VoidCallback? onTap;

  const RoutineElementCard({
    super.key,
    required this.title,
    required this.dosage,
    required this.form,
    required this.icon,
    required this.iconColor,
    this.statusText,
    this.statusColor,
    this.isTaken = false,
    this.isSkipped = false,
    this.isUpcoming = false,
    this.isFocused = false,
    this.hasStudies = false,
    this.onTake,
    this.onMoreOptions,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Background color from spec: #1a1f2e (or similar dark)
    // Using AppColors or custom for now to match spec precisely
    final backgroundColor = isDark ? const Color(0xFF1A1F2E) : Colors.white;
    final borderColor = isDark
        ? Colors.white.withValues(alpha: 0.1)
        : Colors.grey.withValues(alpha: 0.2);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor),
          boxShadow: [
            BoxShadow(
              color: isFocused
                  ? AppColors.primaryGold.withValues(alpha: 0.2)
                  : Colors.black.withValues(alpha: 0.05),
              blurRadius: isFocused ? 12 : 10,
              spreadRadius: isFocused ? 1 : 0,
              offset: isFocused ? const Offset(0, 0) : const Offset(0, 4),
            ),
          ],
        ),
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 300),
          opacity: (isTaken || isSkipped || isFocused) ? 1.0 : 0.6,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    // Options button in Far Left
                    if (!isTaken)
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: onMoreOptions,
                        child: Container(
                          width: 44,
                          height: 44,
                          alignment: Alignment.center,
                          child: const Icon(
                            Icons.more_vert,
                            color: Colors.grey,
                            size: 20,
                          ),
                        ),
                      ),

                    // Icon
                    Container(
                      width: 40.0,
                      height: 40.0,
                      decoration: BoxDecoration(
                        color: (isTaken || isSkipped)
                            ? Colors.grey.withValues(alpha: 0.2)
                            : iconColor.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        isTaken
                            ? Icons.wb_sunny
                            : (isSkipped ? Icons.block : icon),
                        color: (isTaken || isSkipped) ? Colors.grey : iconColor,
                        size: 20.0,
                      ),
                    ),
                    const SizedBox(width: 10),

                    // Details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: TextStyle(
                              color: (isTaken || isSkipped)
                                  ? Colors.grey
                                  : (isDark ? Colors.white : Colors.black87),
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              decoration: (isTaken || isSkipped)
                                  ? TextDecoration.lineThrough
                                  : null,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Text(
                                '$dosage • $form',
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Status Indicator or Action Button
                    if (isTaken) ...[
                      const Icon(Icons.check_circle,
                          color: Color(0xFF4ADE80), size: 24),
                    ] else if (isSkipped) ...[
                      const Icon(Icons.block, color: Colors.grey, size: 24),
                    ] else if (isUpcoming) ...[
                      if (statusText != null)
                        Text(
                          statusText!,
                          style: TextStyle(
                            color: statusColor ?? Colors.grey,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                    ] else ...[
                      // Primary Action: Mark as Taken
                      Builder(
                        builder: (context) {
                          final isWide =
                              MediaQuery.of(context).size.width > 600;
                          final hasStatus =
                              statusText != null && !isTaken && !isSkipped;

                          // Shared Button Widget
                          final takeButton = GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () {
                              AppLogger.d('Take button HIT for $title');
                              // ADR-014: Dopamine hit - Haptic feedback
                              HapticFeedback.mediumImpact();
                              onTake?.call();
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              padding: EdgeInsets.symmetric(
                                  horizontal: isFocused ? 20 : 16,
                                  vertical: isFocused ? 14 : 12),
                              decoration: BoxDecoration(
                                color: isFocused
                                    ? AppColors.primaryGold
                                    : AppColors.primary,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: (isFocused
                                            ? AppColors.primaryGold
                                            : AppColors.primary)
                                        .withValues(alpha: 0.3),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.check,
                                      color: isFocused
                                          ? Colors.black
                                          : Colors.white,
                                      size: 18),
                                  const SizedBox(width: 6),
                                  Text(
                                    'Take',
                                    style: TextStyle(
                                      color: isFocused
                                          ? Colors.black
                                          : Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );

                          if (isWide && hasStatus) {
                            // iPad/Wide: Row Layout [Status] -- [Button]
                            return Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  statusText!,
                                  style: TextStyle(
                                    color: statusColor ?? Colors.grey,
                                    fontSize: 13, // Slightly larger for iPad
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                takeButton,
                              ],
                            );
                          } else {
                            // Mobile: Column Layout
                            // [Status]
                            // [Button]
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                if (hasStatus)
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 8),
                                    child: Text(
                                      statusText!,
                                      style: TextStyle(
                                        color: statusColor ?? Colors.grey,
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                takeButton,
                              ],
                            );
                          }
                        },
                      ),
                    ],
                  ],
                ),
              ),

              // Timestamp if taken or skipped
              if ((isTaken || isSkipped) && statusText != null)
                Padding(
                  padding:
                      const EdgeInsets.only(bottom: 8, left: 12, right: 12),
                  child: Row(
                    children: [
                      Text(
                        statusText!,
                        style:
                            const TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                      const Spacer(),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
