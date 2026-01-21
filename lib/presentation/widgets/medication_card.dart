import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class MedicationCard extends StatelessWidget {
  final String title;
  final String dosage;
  final String form;
  final IconData
      icon; // In real app, this might come from asset path derived from type
  final Color iconColor;
  final String? statusText; // "Taken at 8:30 AM" or "Upcoming"
  final bool isTaken;
  final bool isUpcoming;
  final VoidCallback? onTake;
  final VoidCallback? onMoreOptions;
  final VoidCallback? onTap;

  const MedicationCard({
    super.key,
    required this.title,
    required this.dosage,
    required this.form,
    required this.icon,
    required this.iconColor,
    this.statusText,
    this.isTaken = false,
    this.isUpcoming = false,
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
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Options button in Top Left
            if (!isTaken)
              Positioned(
                top: 8,
                left: 8,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: onMoreOptions,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    child: const Icon(
                      Icons.more_horiz,
                      color: Colors.grey,
                      size: 18,
                    ),
                  ),
                ),
              ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      // Icon
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: isTaken
                              ? Colors.grey.withValues(alpha: 0.2)
                              : iconColor.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          isTaken ? Icons.wb_sunny : icon,
                          color: isTaken ? Colors.grey : iconColor,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),

                      // Details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: TextStyle(
                                color: isTaken
                                    ? Colors.grey
                                    : (isDark ? Colors.white : Colors.black87),
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                decoration:
                                    isTaken ? TextDecoration.lineThrough : null,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '$dosage • $form',
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Status Indicator or Action Button
                      if (isTaken) ...[
                        const Icon(Icons.check_circle,
                            color: Color(0xFF4ADE80), size: 24),
                      ] else if (isUpcoming) ...[
                        if (statusText != null)
                          Text(
                            statusText!,
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                      ] else ...[
                        // Primary Action: Mark as Taken (Right aligned)
                        GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {
                            debugPrint('Take button HIT for $title');
                            onTake?.call();
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color:
                                      AppColors.primary.withValues(alpha: 0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.check,
                                    color: Colors.white, size: 18),
                                SizedBox(width: 6),
                                Text(
                                  'Take',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                // Timestamp if taken
                if (isTaken && statusText != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12, left: 16),
                    child: Row(
                      children: [
                        Text(
                          statusText!,
                          style:
                              const TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                        const Icon(Icons.check, size: 28, color: Colors.white),
                      ],
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
