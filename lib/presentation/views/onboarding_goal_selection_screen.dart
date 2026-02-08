import 'package:flutter/material.dart';
import 'package:neurostack_app/l10n/generated/app_localizations.dart';
import '../theme/app_theme.dart';
import '../widgets/goal_selection_card.dart';
import '../navigation/app_router.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../application/providers/auth_provider.dart';
import '../../utils/logger.dart';

class OnboardingGoalSelectionScreen extends StatefulWidget {
  const OnboardingGoalSelectionScreen({super.key});

  @override
  State<OnboardingGoalSelectionScreen> createState() =>
      _OnboardingGoalSelectionScreenState();
}

class _OnboardingGoalSelectionScreenState
    extends State<OnboardingGoalSelectionScreen> {
  // Using a Set to allow multiple selections
  final Set<String> _selectedGoals = {'Better Sleep'};
  List<Map<String, dynamic>>? _cachedGoals;

  List<Map<String, dynamic>> _getGoals(BuildContext context) {
    if (_cachedGoals != null) return _cachedGoals!;

    _cachedGoals = [
      {
        'id': 'Mental Clarity',
        'title': AppLocalizations.of(context)!.goalMentalClarity,
        'description': AppLocalizations.of(context)!.goalMentalClarityDesc,
        'icon': Icons.auto_awesome,
      },
      {
        'id': 'Better Sleep',
        'title': AppLocalizations.of(context)!.goalBetterSleep,
        'description': AppLocalizations.of(context)!.goalBetterSleepDesc,
        'icon': Icons.bedtime,
      },
      {
        'id': 'Emotional Balance',
        'title': AppLocalizations.of(context)!.goalEmotionalBalance,
        'description': AppLocalizations.of(context)!.goalEmotionalBalanceDesc,
        'icon': Icons.favorite,
      },
      {
        'id': 'Energy Levels',
        'title': AppLocalizations.of(context)!.goalEnergyLevels,
        'description': AppLocalizations.of(context)!.goalEnergyLevelsDesc,
        'icon': Icons.bolt,
      },
    ];
    return _cachedGoals!;
  }

  void _toggleGoal(String title) {
    setState(() {
      if (_selectedGoals.contains(title)) {
        _selectedGoals.remove(title);
      } else {
        _selectedGoals.add(title);
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Pre-cache the hero image for the next onboarding screen
    precacheImage(
      const CachedNetworkImageProvider(
        'https://lh3.googleusercontent.com/aida-public/AB6AXuCEKRevVdokOjFtFZvmgLdF8d_XggCSOWA8CgNp72pCfqV2jX6lj0_jbLWDth-3k1BnGNUfDRUeeAeFykEbYysmc9A13Np-e9ONWM9CenQ1GC24jycAAAO5-XUXbgBa-0XYdBSc9RiUUQ8Nq1w5Pt8BypRIx5aNyG0YdAueulirzo_SS9maP3ft_L8N9NbEujaoXx95tSu9QHJCY83pqpHW6ivG1APvJBPKJttkqNyhqG9TF0v3C8BB3GoSW28sOnf3HuA4OJCTRAQ',
      ),
      context,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;

    // Responsive grid calculations
    int crossAxisCount = 2;
    double childAspectRatio = 0.75;

    if (screenWidth > 1200) {
      crossAxisCount = 4;
      childAspectRatio = 0.9;
    } else if (screenWidth > 800) {
      crossAxisCount = 3;
      childAspectRatio = 0.85;
    } else if (screenWidth > 600) {
      crossAxisCount = 2;
      childAspectRatio = 1.0;
    }

    return Scaffold(
      backgroundColor:
          isDark ? const Color(0xFF112117) : const Color(0xFFF6F8F6),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                // Header / Progress Indicator
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 32,
                        height: 8,
                        decoration: BoxDecoration(
                          color: AppColors.accentGreen,
                          borderRadius: BorderRadius.circular(99),
                        ),
                      ),
                      const SizedBox(width: 8),
                      for (int i = 0; i < 1; i++) ...[
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: isDark ? Colors.grey[700] : Colors.grey[200],
                            shape: BoxShape.circle,
                          ),
                        ),
                        if (i < 0) const SizedBox(width: 8),
                      ],
                    ],
                  ),
                ),

                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 1000),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 8),
                            Text(
                              AppLocalizations.of(context)!.whatsYourFocus,
                              style: TextStyle(
                                color: isDark
                                    ? Colors.white
                                    : const Color(0xFF111713),
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                height: 1.1,
                                letterSpacing: -0.5,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              AppLocalizations.of(context)!.pickGoals,
                              style: TextStyle(
                                color: isDark
                                    ? Colors.grey[400]
                                    : Colors.grey[500],
                                fontSize: 16,
                                height: 1.5,
                              ),
                            ),

                            const SizedBox(height: 32),

                            // Grid layout
                            GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: crossAxisCount,
                                crossAxisSpacing: 16,
                                mainAxisSpacing: 16,
                                childAspectRatio: childAspectRatio,
                              ),
                              itemCount: _getGoals(context).length,
                              itemBuilder: (context, index) {
                                final goals = _getGoals(context);
                                final goal = goals[index];
                                final id = goal['id'] as String;
                                final title = goal['title'] as String;
                                return GoalSelectionCard(
                                  title: title,
                                  description: goal['description'] as String,
                                  icon: goal['icon'] as IconData,
                                  isSelected: _selectedGoals.contains(id),
                                  onTap: () => _toggleGoal(id),
                                );
                              },
                            ),

                            const SizedBox(
                                height: 100), // Spacing for bottom bar
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Fixed Bottom Bar
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      isDark
                          ? const Color(0xFF112117)
                          : const Color(0xFFF6F8F6),
                      (isDark
                              ? const Color(0xFF112117)
                              : const Color(0xFFF6F8F6))
                          .withValues(alpha: 0.9),
                      Colors.transparent,
                    ],
                    stops: const [0.0, 0.7, 1.0],
                  ),
                ),
                child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: () async {
                          final auth = context.read<AuthProvider>();
                          final user = auth.user;

                          if (user != null) {
                            // Fire-and-forget update to prevent blocking navigation
                            auth
                                .updateProfile(
                                  user.copyWith(goals: _selectedGoals.toList()),
                                )
                                .timeout(
                                  const Duration(seconds: 10),
                                  onTimeout: () => AppLogger.w(
                                      'Onboarding goals sync timed out in background'),
                                )
                                .catchError((Object e) => AppLogger.e(
                                    'Failed to sync goals in background', e));
                          }

                          if (!context.mounted) return;
                          Navigator.pushNamed(
                              context, AppRouter.onboardingGracePeriod);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.accentGreen,
                          foregroundColor: const Color(
                              0xFF112117), // Dark text on green button
                          elevation: 4,
                          shadowColor: Colors.black.withValues(alpha: 0.2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Text(
                          AppLocalizations.of(context)!.next,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: () {
                        final auth = context.read<AuthProvider>();
                        final user = auth.user;

                        if (user != null) {
                          // Fire-and-forget clear goals to prevent blocking navigation
                          auth
                              .updateProfile(
                                user.copyWith(goals: []),
                              )
                              .timeout(
                                const Duration(seconds: 10),
                                onTimeout: () => AppLogger.w(
                                    'Skipping goals sync timed out in background'),
                              )
                              .catchError((Object e) => AppLogger.e(
                                  'Failed to clear goals in background', e));
                        }

                        Navigator.pushNamed(
                            context, AppRouter.onboardingGracePeriod);
                      },
                      style: TextButton.styleFrom(
                        foregroundColor:
                            isDark ? Colors.grey[400] : Colors.grey[500],
                      ),
                      child: Text(
                        AppLocalizations.of(context)!.chooseLater,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          decoration: TextDecoration.underline,
                        ),
                      ),
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
}
