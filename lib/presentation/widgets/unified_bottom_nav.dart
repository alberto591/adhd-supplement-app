import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../navigation/app_router.dart';
import '../../application/providers/auth_provider.dart';

class UnifiedBottomNav extends StatelessWidget {
  final int currentIndex;

  const UnifiedBottomNav({
    super.key,
    required this.currentIndex,
  });

  void _onItemTapped(BuildContext context, int index) {
    if (index == currentIndex) return;

    String routeName;
    switch (index) {
      case 0:
        routeName = AppRouter.dashboard;
        break;
      case 1:
        routeName = AppRouter.library;
        break;
      case 2:
        routeName = AppRouter.scienceHub;
        break;
      case 3:
        routeName = AppRouter.profile;
        break;
      default:
        routeName = AppRouter.dashboard;
    }

    // For the premium "Hub" tab, we use pushNamed so the back button (on the paywall)
    // returns the user to their previous screen instead of exiting or getting stuck.
    if (index == 2) {
      Navigator.pushNamed(context, routeName);
    } else {
      // Use pushReplacement for others to maintain the "tab" feel
      Navigator.pushReplacementNamed(context, routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    const primaryColor = AppColors.primaryGold;
    final unselectedColor = isDark ? Colors.grey[500] : Colors.grey[400];
    final backgroundColor =
        (isDark ? const Color(0xFF221D10) : const Color(0xFFF8F8F6))
            .withValues(alpha: 0.95);

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border(
          top: BorderSide(
            color: isDark
                ? Colors.white.withValues(alpha: 0.1)
                : Colors.black.withValues(alpha: 0.05),
          ),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Consumer<AuthProvider>(
            builder: (BuildContext context, AuthProvider auth, _) {
              final isPremium = auth.canAccess('pro');
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavItem(
                    context,
                    index: 0,
                    icon: Icons.calendar_today,
                    label: 'Today',
                    isSelected: currentIndex == 0,
                    primaryColor: primaryColor,
                    unselectedColor: unselectedColor!,
                  ),
                  _buildNavItem(
                    context,
                    index: 1,
                    icon: Icons.auto_stories,
                    label: 'Library',
                    isSelected: currentIndex == 1,
                    primaryColor: primaryColor,
                    unselectedColor: unselectedColor,
                  ),
                  _buildNavItem(
                    context,
                    index: 2,
                    icon: Icons.science_outlined,
                    label: 'Hub',
                    isSelected: currentIndex == 2,
                    primaryColor: primaryColor,
                    unselectedColor: unselectedColor,
                    showLock: !isPremium,
                  ),
                  _buildNavItem(
                    context,
                    index: 3,
                    icon: Icons.account_circle,
                    label: 'Profile',
                    isSelected: currentIndex == 3,
                    primaryColor: primaryColor,
                    unselectedColor: unselectedColor,
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context, {
    required int index,
    required IconData icon,
    required String label,
    required bool isSelected,
    required Color primaryColor,
    required Color unselectedColor,
    bool showLock = false,
  }) {
    return InkWell(
      onTap: () => _onItemTapped(context, index),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(
                  icon,
                  color: isSelected ? primaryColor : unselectedColor,
                  size: 24,
                ),
                if (showLock)
                  Positioned(
                    top: -4,
                    right: -4,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(
                        color: AppColors.primaryGold,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.lock,
                        size: 8,
                        color: Colors.black,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.lexend(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: isSelected ? primaryColor : unselectedColor,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
