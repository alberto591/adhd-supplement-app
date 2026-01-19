import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../navigation/app_router.dart';

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new,
              color: isDark ? Colors.white : const Color(0xFF111418), size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Settings',
          style: TextStyle(
            color: isDark ? Colors.white : const Color(0xFF111418),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 40),
        child: Column(
          children: [
            // Profile Header
            const _ProfileHeader(),

            const SizedBox(height: 4), // Divider spacing

            // Personal Info Section
            const _SectionHeader(title: 'Personal Info'),
            _SettingsGroup(
              children: [
                const _SettingsTile(
                  icon: Icons.psychology,
                  iconColor: AppColors.primary,
                  title: 'ADHD Diagnosis',
                  subtitle: 'Combined Type',
                  trailing: Icon(Icons.chevron_right, color: Colors.grey),
                ),
                const SizedBox(height: 2),
                const _SettingsTile(
                  icon: Icons.medication,
                  iconColor: AppColors.primary,
                  title: 'Medications',
                  subtitle: 'Vyvanse 30mg, Magnesium',
                  trailing: Icon(Icons.chevron_right, color: Colors.grey),
                ),
                const SizedBox(height: 2),
                _SettingsTile(
                  icon: Icons.medication,
                  iconColor: AppColors.primary,
                  title: 'Medications',
                  subtitle: 'Vyvanse 30mg, Magnesium',
                  trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                  onTap: () => Navigator.pushNamed(
                      context, AppRouter.onboardingMedicationSafety),
                ),
                const SizedBox(height: 2),
                _SettingsTile(
                  icon: Icons.palette,
                  iconColor: AppColors.primary,
                  title: 'Pill Appearance',
                  subtitle: 'Customize visuals',
                  trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                  onTap: () =>
                      Navigator.pushNamed(context, AppRouter.pillMatcher),
                ),
                const SizedBox(height: 2),
                _SettingsTile(
                  icon: Icons.brush,
                  iconColor: AppColors.primary,
                  title: 'App Appearance',
                  subtitle: 'Icon & Theme',
                  trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                  onTap: () =>
                      Navigator.pushNamed(context, AppRouter.appAppearance),
                ),
              ],
            ),

            // Nudge Mode Section
            const _SectionHeader(title: 'Nudge Mode'),
            _SettingsGroup(
              children: [
                _SettingsTile(
                  icon: Icons.notifications_active,
                  iconColor: AppColors.primary,
                  title: 'Daily Reminders',
                  subtitle: 'Gentle nudge at 8:00 AM',
                  trailing: const _SwitchMock(value: true),
                  onTap: () =>
                      Navigator.pushNamed(context, AppRouter.reminders),
                ),
                const SizedBox(height: 2),
                const _SettingsTile(
                  icon: Icons.timer, // auto_timer equivalent
                  iconColor: AppColors.primary,
                  title: 'Quiet Hours',
                  subtitle: '10:00 PM - 7:00 AM',
                  trailing: Icon(Icons.chevron_right, color: Colors.grey),
                ),
              ],
            ),

            // Data & Privacy Section
            const _SectionHeader(title: 'Data & Privacy'),
            _SettingsGroup(
              children: [
                _SettingsTile(
                  icon: Icons.shield_outlined,
                  iconColor: AppColors.primary,
                  title: 'Privacy & Security',
                  subtitle: 'Data control & biometric lock',
                  trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                  onTap: () =>
                      Navigator.pushNamed(context, AppRouter.privacySettings),
                ),
                const SizedBox(height: 2),
                _SettingsTile(
                  icon: Icons.calendar_today,
                  iconColor: AppColors.primary,
                  title: 'Weekly Review',
                  subtitle: 'Check your progress',
                  trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                  onTap: () =>
                      Navigator.pushNamed(context, AppRouter.weeklyReview),
                ),
              ],
            ),

            // Support Section
            const _SectionHeader(title: 'Support'),
            _SettingsGroup(
              children: [
                _SettingsTile(
                  icon: Icons.help_outline,
                  iconColor: Colors.blue,
                  title: 'Help & Support Center',
                  subtitle: 'FAQs & Contact',
                  trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                  onTap: () =>
                      Navigator.pushNamed(context, AppRouter.helpAndSupport),
                ),
                const SizedBox(height: 2),
                const _SettingsTile(
                  icon: Icons.description, // clinical_notes equivalent
                  iconColor: AppColors.primary,
                  title: 'Medical Disclaimer',
                  subtitle: 'Important health information',
                  trailing: Icon(Icons.open_in_new,
                      color: Colors.grey, size: 20),
                ),
                const SizedBox(height: 2),
                _SettingsTile(
                  icon: Icons.shield,
                  iconColor: AppColors.primary,
                  title: 'Safety Interactions',
                  subtitle: 'Check contraindications',
                  trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                  onTap: () =>
                      Navigator.pushNamed(context, AppRouter.safetyDetail),
                ),
              ],
            ),

            // Dev Tools Section (Debug Only)
            const _SectionHeader(title: 'Developer Tools (Debug)'),
            _SettingsGroup(
              children: [
                _SettingsTile(
                  icon: Icons.monitor_heart,
                  iconColor: Colors.purple,
                  title: 'System Health Hub',
                  subtitle: 'Test permissions',
                  trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                  onTap: () =>
                      Navigator.pushNamed(context, AppRouter.systemHealth),
                ),
                const SizedBox(height: 2),
                _SettingsTile(
                  icon: Icons.science,
                  iconColor: Colors.purple,
                  title: 'Science Update',
                  subtitle: 'Preview update screen',
                  trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                  onTap: () =>
                      Navigator.pushNamed(context, AppRouter.scienceUpdate),
                ),
                const SizedBox(height: 2),
                _SettingsTile(
                  icon: Icons.code,
                  iconColor: Colors.purple,
                  title: 'Logic Triggers',
                  subtitle: 'Backend spec handoff',
                  trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                  onTap: () =>
                      Navigator.pushNamed(context, AppRouter.developerHandoff),
                ),
              ],
            ),

            // Logout Button
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
              child: SizedBox(
                width: double.infinity,
                child: TextButton.icon(
                  onPressed: () async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Log Out'),
                        content:
                            const Text('Are you sure you want to log out?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, true),
                            style: TextButton.styleFrom(
                                foregroundColor: Colors.red),
                            child: const Text('Log Out'),
                          ),
                        ],
                      ),
                    );

                    if (confirm == true) {
                      try {
                        await Provider.of<AuthProvider>(context, listen: false)
                            .signOut();
                        // Navigation handled by AuthWrapper, but ensuring cleanup
                        Navigator.pushNamedAndRemoveUntil(
                            context, AppRouter.login, (route) => false);
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Logout failed: $e')),
                        );
                      }
                    }
                  },
                  icon: Icon(Icons.logout, color: Colors.red[400]),
                  label: Text(
                    'Log Out',
                    style: TextStyle(
                      color: Colors.red[400],
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: isDark
                        ? Colors.red.withValues(alpha: 0.1)
                        : Colors.red.withValues(alpha: 0.05),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
            ),

            // Version Info
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Version 2.4.1 (102) • Proudly built for focus',
                style: TextStyle(
                  color: isDark ? Colors.grey[600] : Colors.grey[500],
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNav(BuildContext context, bool isDark) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF101822) : Colors.white,
        border: Border(
          top: BorderSide(
            color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(context, 0, Icons.home, 'Home', false, isDark),
          _buildNavItem(
              context, 1, Icons.library_books, 'Library', false, isDark),
          _buildNavItem(
              context, 2, Icons.medication, 'My Stack', false, isDark),
          _buildNavItem(context, 3, Icons.person, 'Profile', true, isDark),
        ],
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, int index, IconData icon,
      String label, bool isActive, bool isDark) {
    // Using Science Hub style (Primary Blue)
    const primary = Color(0xFF136DEC);
    final color = isActive
        ? primary
        : (isDark ? const Color(0xFF94A3B8) : const Color(0xFF94A3B8));

    return GestureDetector(
      onTap: () {
        if (index == 0) {
          Navigator.of(context)
              .popUntil((route) => route.settings.name == AppRouter.dashboard);
        } else if (index == 1) {
          Navigator.pushReplacementNamed(context, AppRouter.scienceHub);
        } else if (index == 2) {
          Navigator.pushNamed(context, AppRouter.stackBuilder);
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 10,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // Avatar
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle, // Tailwind rounded-full/aspect-sq
              border: Border.all(
                color: isDark ? Colors.grey[800]! : Colors.white,
                width: 4,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
              image: const DecorationImage(
                image: NetworkImage(
                    'https://lh3.googleusercontent.com/aida-public/AB6AXuB5gYlym23jgk2a_v5Fh5rRkrkydUuieWk7SGwkOayy1tukLNjnNpYc60TsDJH-QRDfkGs_sqjxJn3RKm9qLDXlrzZ8YQgZyae2Nq3piImh4cnCFAjiO8tA19NnNTy3esINBJWaRHwNBsBheE1rfec1HXmgCuB0lPDXik60RTBUDe1k0bAyMEObi_cFZvZqpMIiETZPU_8Y7LSm8qmh5Co2-6bJXFhUfbUmwO9T8OpG-6M7hj-inN6dyrN2ZVcQY49JvsafSotJ6jw'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Name
          Text(
            'Alex Johnson',
            style: TextStyle(
              color: isDark ? Colors.white : const Color(0xFF111418),
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          // Streak
          const SizedBox(height: 6),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.local_fire_department,
                  color: Colors.orange[500], size: 20),
              const SizedBox(width: 6),
              Text(
                '14 Day Streak',
                style: TextStyle(
                  color: isDark ? Colors.grey[400] : const Color(0xFF617289),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // App Appearance (Quick Access)
          GestureDetector(
            onTap: () => Navigator.pushNamed(context, AppRouter.appAppearance),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFFF20D93).withValues(alpha: 0.1)
                    : const Color(0xFFF20D93).withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(20),
                border:
                    Border.all(color: const Color(0xFFF20D93).withValues(alpha: 0.3)),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.palette, size: 16, color: Color(0xFFF20D93)),
                  SizedBox(width: 8),
                  Text(
                    'Customize App Icon',
                    style: TextStyle(
                      color: Color(0xFFF20D93),
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Member Since
          const SizedBox(height: 4),
          Text(
            'Member since Jan 2024',
            style: TextStyle(
              color: isDark ? Colors.grey[500] : const Color(0xFF94A3B8),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.only(left: 20, top: 16, bottom: 8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: TextStyle(
            color: isDark ? Colors.white : const Color(0xFF111418),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class _SettingsGroup extends StatelessWidget {
  final List<Widget> children;

  const _SettingsGroup({required this.children});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(children: children),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  const _SettingsTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isDark ? Colors.grey[800] : Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: iconColor, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: isDark ? Colors.white : const Color(0xFF111418),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color:
                          isDark ? Colors.grey[400] : const Color(0xFF617289),
                      fontSize: 14,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            if (trailing != null) ...[
              const SizedBox(width: 8),
              trailing!,
            ],
          ],
        ),
      ),
    );
  }
}

class _SwitchMock extends StatelessWidget {
  final bool value;

  const _SwitchMock({required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 24,
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: value ? AppColors.primary : Colors.grey[300],
        borderRadius: BorderRadius.circular(12),
      ),
      alignment: value ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        width: 20,
        height: 20,
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
