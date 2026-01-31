import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'package:neurostack_app/l10n/generated/app_localizations.dart';

class UpNextCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String timeLabel;
  final int itemCount;
  final String imagePath;
  final String? slot;
  final VoidCallback? onTakeAll;

  const UpNextCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.timeLabel,
    required this.itemCount,
    required this.imagePath,
    this.slot,
    this.onTakeAll,
  });

  @override
  Widget build(BuildContext context) {
    // Capture theme brightness
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : AppColors.textPrimaryLight;
    final l10n = AppLocalizations.of(context)!;

    String displayTitle = title;
    if (slot != null) {
      switch (slot!.toLowerCase()) {
        case 'morning':
          displayTitle = l10n.morning;
          break;
        case 'afternoon':
          displayTitle = l10n.afternoon;
          break;
        case 'evening':
          displayTitle = l10n.evening;
          break;
        case 'night':
          displayTitle = l10n.night;
          break;
      }
    }

    String displaySubtitle = subtitle;
    if (slot != null) {
      displaySubtitle = slot!.toLowerCase() == 'morning'
          ? l10n.startYourDay
          : l10n.stayOnTrack;
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.upNext,
                style: TextStyle(
                  color: textColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primaryGold.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  displayTitle,
                  style: const TextStyle(
                    color: AppColors.primaryGold,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          height: 220, // Aspect ratio approx from wireframe
          decoration: BoxDecoration(
            color: AppColors.cardDark,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Background Image with Gradient
              Image.asset(
                imagePath,
                fit: BoxFit.cover,
                errorBuilder: (ctx, err, stack) =>
                    Container(color: AppColors.cardDark),
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.2),
                      AppColors.cardDark.withValues(alpha: 0.9),
                    ],
                    stops: const [0.3, 0.9],
                  ),
                ),
              ),

              // Content Overlay
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      displayTitle.toUpperCase(),
                      style: const TextStyle(
                        color: AppColors.primaryGold,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      displaySubtitle,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.schedule,
                            color: Color(0xFF9DB9A8), size: 14),
                        const SizedBox(width: 4),
                        Text(
                          '$timeLabel • $itemCount Supplements',
                          style: const TextStyle(
                            color: Color(0xFF9DB9A8),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: onTakeAll,
                        icon: const Icon(Icons.done_all, size: 20),
                        label: Text(
                          AppLocalizations.of(context)!.markAllTaken,
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.accentGreen,
                          foregroundColor: const Color(0xFF111814),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 4,
                          shadowColor:
                              AppColors.accentGreen.withValues(alpha: 0.3),
                          textStyle: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
