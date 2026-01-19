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

    return Container(
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
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                // Icon
                Container(
                  width: 48, // Slightly smaller than previous design
                  height: 48,
                  decoration: BoxDecoration(
                    color: isTaken
                        ? Colors.grey.withValues(alpha: 0.2)
                        : iconColor.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    isTaken
                        ? Icons.wb_sunny
                        : icon, // Example logic for check icon vs med icon
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

                // Status Indicator or Menu
                if (isTaken || isUpcoming) ...[
                  if (isTaken)
                    const Icon(Icons.check_circle,
                        color: Color(0xFF4ADE80), size: 20)
                  else if (statusText != null)
                    Text(
                      statusText!,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                ],

                // Menu (always visible per spec, but maybe hidden if taken? Spec says "Click three-dot menu for...")
                // Spec says "Card Functionality: Click three-dot menu for..."
                if (!isTaken) ...[
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: onMoreOptions,
                    child: const Icon(Icons.more_vert,
                        color: Colors.grey, size: 20),
                  ),
                ]
              ],
            ),
          ),

          // Action Button (Only if active and not taken)
          if (!isTaken && !isUpcoming)
            GestureDetector(
              onTap: onTake,
              child: Container(
                width: double.infinity,
                height: 44,
                decoration: const BoxDecoration(
                  color: AppColors.primary, // Blue
                  borderRadius:
                      BorderRadius.vertical(bottom: Radius.circular(16)),
                ),
                alignment: Alignment.center,
                child: const Text(
                  '✓ Mark as Taken',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
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
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  const Icon(Icons.check, size: 28, color: Colors.white),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
