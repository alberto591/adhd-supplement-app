import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'package:google_fonts/google_fonts.dart';
import '../navigation/app_router.dart';
import 'package:provider/provider.dart';
import '../../application/providers/auth_provider.dart';
import '../../application/view_models/persistent_reminders_view_model.dart';
import '../widgets/unified_bottom_nav.dart';

import 'package:intl/intl.dart';
import '../../domain/entities/user.dart';

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
              color: isDark ? Colors.white : Colors.black),
          onPressed: () =>
              Navigator.pushReplacementNamed(context, AppRouter.dashboard),
        ),
        title: Text(
          'Settings',
          style: GoogleFonts.lexend(
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
            Consumer<AuthProvider>(
              builder: (context, auth, _) => _ProfileHeader(user: auth.user),
            ),

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
                Consumer<PersistentRemindersViewModel>(
                  builder: (context, viewModel, child) {
                    return _SettingsTile(
                      icon: Icons.notifications_active,
                      iconColor: AppColors.primary,
                      title: 'Daily Reminders',
                      subtitle:
                          'Gentle nudge at ${viewModel.nudgeTime.format(context)}',
                      trailing: Switch(
                        value: viewModel.nudgeModeEnabled,
                        activeThumbColor: AppColors.primary,
                        onChanged: (value) =>
                            viewModel.setNudgeModeEnabled(value),
                      ),
                      onTap: () =>
                          Navigator.pushNamed(context, AppRouter.reminders),
                    );
                  },
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
                  iconColor: AppColors.primaryGold,
                  title: 'Help & Support Center',
                  subtitle: 'FAQs & Contact',
                  trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                  onTap: () =>
                      Navigator.pushNamed(context, AppRouter.helpAndSupport),
                ),
                const SizedBox(height: 2),
                _SettingsTile(
                  icon: Icons.description, // clinical_notes equivalent
                  iconColor: AppColors.primary,
                  title: 'Medical Disclaimer',
                  subtitle: 'Important health information',
                  trailing: const Icon(Icons.open_in_new,
                      color: Colors.grey, size: 20),
                  onTap: () => showDialog<void>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Medical Disclaimer'),
                      content: const SingleChildScrollView(
                        child: Text(
                          'The information provided in this app is for educational and informational purposes only and is not intended as medical advice. \n\nAlways consult with a qualified healthcare professional regarding any medical condition or treatment. \n\nDo not disregard professional medical advice or delay in seeking it because of something you have read in this application.',
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Close'),
                        ),
                      ],
                    ),
                  ),
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
                  iconColor: AppColors.primaryGold,
                  title: 'System Health Hub',
                  subtitle: 'Test permissions',
                  trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                  onTap: () =>
                      Navigator.pushNamed(context, AppRouter.systemHealth),
                ),
                const SizedBox(height: 2),
                _SettingsTile(
                  icon: Icons.science,
                  iconColor: AppColors.primaryGold,
                  title: 'Science Update',
                  subtitle: 'Preview update screen',
                  trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                  onTap: () =>
                      Navigator.pushNamed(context, AppRouter.scienceUpdate),
                ),
                const SizedBox(height: 2),
                _SettingsTile(
                  icon: Icons.code,
                  iconColor: AppColors.primaryGold,
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
                      if (!context.mounted) return;
                      try {
                        await Provider.of<AuthProvider>(context, listen: false)
                            .signOut();
                        // Navigation handled by AuthWrapper, but ensuring cleanup
                        if (context.mounted) {
                          Navigator.pushNamedAndRemoveUntil(
                              context, AppRouter.login, (route) => false);
                        }
                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Logout failed: $e')),
                          );
                        }
                      }
                    }
                  },
                  icon: Icon(Icons.logout, color: Colors.red[400]),
                  label: Text(
                    'Log Out',
                    style: GoogleFonts.lexend(
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
                style: GoogleFonts.lexend(
                  color: isDark ? Colors.grey[600] : Colors.grey[500],
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const UnifiedBottomNav(currentIndex: 4),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  final User? user;
  const _ProfileHeader({this.user});

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
            _getInitials(user),
            style: GoogleFonts.lexend(
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
                style: GoogleFonts.lexend(
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
                border: Border.all(
                    color: const Color(0xFFF20D93).withValues(alpha: 0.3)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.palette, size: 16, color: Color(0xFFF20D93)),
                  const SizedBox(width: 8),
                  Text(
                    'Customize App Icon',
                    style: GoogleFonts.lexend(
                      color: const Color(0xFFF20D93),
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
            'Member since ${_formatDate(user?.createdAt)}',
            style: GoogleFonts.lexend(
              color: isDark ? Colors.grey[500] : const Color(0xFF94A3B8),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'Unknown';
    return DateFormat('MMM yyyy').format(date);
  }

  String _getInitials(User? user) {
    if (user == null) return 'G';
    final name = user.displayName;
    if (name != null && name.isNotEmpty) {
      return name[0].toUpperCase();
    }
    final email = user.email;
    if (email.isNotEmpty) {
      return email[0].toUpperCase();
    }
    return 'G';
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
          color: isDark ? AppColors.cardDark : Colors.white,
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
                    style: GoogleFonts.lexend(
                      color: isDark ? Colors.white : const Color(0xFF111418),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: GoogleFonts.lexend(
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
