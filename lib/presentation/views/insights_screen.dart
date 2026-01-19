import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/focus_correlation_chart.dart';
import '../widgets/quick_win_card.dart';
import '../widgets/symptom_improvement_card.dart';
import '../navigation/app_router.dart';

class InsightsScreen extends StatelessWidget {
  const InsightsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildCircleButton(context, Icons.arrow_back),
                  Text(
                    'Insights',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: isDark
                              ? AppColors.textPrimaryDark
                              : AppColors.textPrimaryLight,
                        ),
                  ),
                  _buildCircleButton(context, Icons.ios_share),
                ],
              ),
            ),

            // Date Filter
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: Row(
                children: [
                  _buildFilterChip(
                      context, 'Last 30 Days', true, Icons.calendar_today),
                  const SizedBox(width: 12),
                  _buildFilterChip(context, 'Last 7 Days', false, null),
                  const SizedBox(width: 12),
                  _buildFilterChip(context, 'This Month', false, null),
                  const SizedBox(width: 12),
                  _buildFilterChip(context, 'Last Month', false, null),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Chart Section
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.cardDark : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isDark ? Colors.grey[800]! : Colors.grey[100]!,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '30-Day Focus Correlation',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: isDark
                                      ? AppColors.textPrimaryDark
                                      : AppColors.textPrimaryLight,
                                ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Consistent supplement use boosts focus by ~15%.',
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: isDark
                                          ? AppColors.textSecondaryDark
                                          : AppColors.textSecondaryLight,
                                    ),
                          ),
                          const SizedBox(height: 16),

                          // Legend
                          Row(
                            children: [
                              _buildLegendItem(context, AppColors.accentGreen,
                                  'Consistency'),
                              const SizedBox(width: 16),
                              _buildLegendItem(
                                  context, AppColors.primary, 'Focus Level',
                                  isRect: true),
                            ],
                          ),
                          const SizedBox(height: 24),

                          // Chart
                          const FocusCorrelationChart(),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Quick Wins
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Quick Wins',
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: isDark
                                        ? AppColors.textPrimaryDark
                                        : AppColors.textPrimaryLight,
                                  ),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: const Text('View all',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    QuickWinCard(
                      title: 'Omega-3 Effect',
                      descriptionPrefix: 'You were ',
                      descriptionHighlight: '20% more focused',
                      descriptionSuffix: ' on days you took Omega-3.',
                      icon: Icons.water_drop,
                      showGlow: true,
                      colors: QuickWinColors(
                        backgroundColor:
                            isDark ? const Color(0xFF1E293B) : Colors.blue[50]!,
                        darkBackgroundColor: const Color(0xFF1E293B),
                        iconBackgroundColor: isDark
                            ? Colors.blue.withValues(alpha: 0.2)
                            : Colors.blue[100]!,
                        darkIconBackgroundColor: Colors.blue.withValues(alpha: 0.2),
                        iconColor:
                            isDark ? Colors.blue[400]! : AppColors.primary,
                        darkIconColor: Colors.blue[400]!,
                        highlightColor: AppColors.primary,
                        darkHighlightColor: Colors.blue[400]!,
                      ),
                    ),

                    QuickWinCard(
                      title: 'Weekend Warrior',
                      descriptionPrefix: 'Your consistency remains ',
                      descriptionHighlight: '90%',
                      descriptionSuffix: ' even on weekends.',
                      icon: Icons.calendar_month,
                      colors: QuickWinColors(
                        backgroundColor:
                            isDark ? AppColors.cardDark : Colors.white,
                        darkBackgroundColor: AppColors.cardDark,
                        iconBackgroundColor: isDark
                            ? AppColors.accentGreen.withValues(alpha: 0.2)
                            : const Color(0xFFD1FAE5),
                        darkIconBackgroundColor:
                            AppColors.accentGreen.withValues(alpha: 0.2),
                        iconColor: AppColors.accentGreen,
                        darkIconColor: AppColors.accentGreen,
                        highlightColor: AppColors.accentGreen,
                        darkHighlightColor: AppColors.accentGreen,
                      ),
                    ),

                    QuickWinCard(
                      title: 'Streak Bonus',
                      descriptionPrefix: "You've tracked for ",
                      descriptionHighlight: '12 days',
                      descriptionSuffix: ' in a row. Keep it up!',
                      icon: Icons.local_fire_department,
                      colors: QuickWinColors(
                        backgroundColor:
                            isDark ? AppColors.cardDark : Colors.white,
                        darkBackgroundColor: AppColors.cardDark,
                        iconBackgroundColor: isDark
                            ? Colors.orange.withValues(alpha: 0.2)
                            : Colors.orange[100]!,
                        darkIconBackgroundColor: Colors.orange.withValues(alpha: 0.2),
                        iconColor: Colors.orange,
                        darkIconColor: Colors.orange,
                        highlightColor: Colors.orange,
                        darkHighlightColor: Colors.orange,
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Symptom Improvements
                    Text(
                      'Symptom Improvements',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: isDark
                                ? AppColors.textPrimaryDark
                                : AppColors.textPrimaryLight,
                          ),
                    ),
                    const SizedBox(height: 16),

                    const Row(
                      children: [
                        SymptomImprovementCard(
                          label: 'Impulsivity',
                          percentage: 0.7,
                          changeText: '▼ 15%',
                          isImprovement: true,
                        ),
                        SizedBox(width: 12),
                        SymptomImprovementCard(
                          label: 'Memory',
                          percentage: 0.45,
                          changeText: '▲ 8%',
                          isImprovement: true,
                        ),
                      ],
                    ),

                    const SizedBox(height: 48), // Padding for bottom nav
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: isDark ? AppColors.cardDark : Colors.white,
          border: Border(
              top: BorderSide(
                  color: isDark ? Colors.grey[800]! : Colors.grey[200]!)),
        ),
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(context, Icons.home, 'Home', false),
              _buildNavItem(context, Icons.edit_note, 'Log', false),
              _buildNavItem(context, Icons.analytics, 'Insights', true),
              _buildNavItem(context, Icons.settings, 'Settings', false),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCircleButton(BuildContext context, IconData icon) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: icon == Icons.arrow_back ? () => Navigator.pop(context) : null,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: isDark ? Colors.transparent : Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Icon(icon, color: isDark ? Colors.white : Colors.black),
        ),
      ),
    );
  }

  Widget _buildFilterChip(
      BuildContext context, String label, bool isSelected, IconData? icon) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected
            ? AppColors.primary
            : (isDark ? AppColors.cardDark : Colors.white),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: isSelected
              ? Colors.transparent
              : (isDark ? Colors.grey[700]! : Colors.grey[200]!),
        ),
        boxShadow: isSelected
            ? [
                BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4))
              ]
            : null,
      ),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, size: 18, color: Colors.white),
            const SizedBox(width: 8),
          ],
          Text(
            label,
            style: TextStyle(
              color: isSelected
                  ? Colors.white
                  : (isDark ? Colors.grey[300] : Colors.grey[600]),
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(BuildContext context, Color color, String text,
      {bool isRect = false}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Row(
      children: [
        Container(
          width: isRect ? 16 : 12,
          height: isRect ? 4 : 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(isRect ? 2 : 6),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(
            color: isDark ? Colors.grey[300] : Colors.grey[600],
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildNavItem(
      BuildContext context, IconData icon, String label, bool isSelected) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final color = isSelected
        ? AppColors.primary
        : (isDark ? Colors.grey[400] : Colors.grey[400]);

    return InkWell(
      onTap: () {
        if (label == 'Home') {
          Navigator.pushNamedAndRemoveUntil(
              context, AppRouter.dashboard, (route) => false);
        } else if (label == 'Log') {
          Navigator.pushNamed(context, AppRouter.historyLog);
        } else if (label == 'Settings') {
          Navigator.pushNamed(context, AppRouter.profile);
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            children: [
              Icon(icon, color: color, size: 28),
              if (isSelected)
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 10,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
