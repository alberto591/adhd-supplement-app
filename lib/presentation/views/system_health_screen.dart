import 'package:flutter/material.dart';
import 'package:adhd_supplement_app/presentation/navigation/app_router.dart';
import 'package:adhd_supplement_app/infrastructure/services/seeding_service.dart';
import '../../config/locator.dart';
import '../theme/app_theme.dart';
import 'package:app_settings/app_settings.dart';

class SystemHealthScreen extends StatelessWidget {
  const SystemHealthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Determine theme brightness
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Define colors based on the design tokens provided in HTML
    const Color primaryColor = AppColors.primary;
    const Color dangerColor = Color(0xFFff4d4d);
    const Color successColor = Color(0xFF22c55e);

    final Color surfaceColor = isDark ? const Color(0xFF1c1f27) : Colors.white;
    final Color textPrimary =
        isDark ? Colors.white : const Color(0xFF0F172A); // slate-900
    final Color textSecondary =
        isDark ? const Color(0xFF9DA8B9) : const Color(0xFF475569); // slate-600

    // Background colors
    final Color bgColor =
        isDark ? AppColors.backgroundDark : AppColors.backgroundLight;

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Column(
          children: [
            // Top App Bar
            _buildTopBar(context, isDark, textPrimary, textSecondary),

            // Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),

                    // Seed Data Button (Debug)
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          try {
                            await locator<SeedingService>().seedSupplements();
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Seeding Success!')),
                              );
                            }
                          } catch (e) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Seeding Error: $e')),
                              );
                            }
                          }
                        },
                        icon: const Icon(Icons.cloud_upload),
                        label: const Text('Seed Sample Data (Firestore)'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Test AI Agent Button (Debug)
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () =>
                            Navigator.pushNamed(context, AppRouter.aiSearch),
                        icon: const Icon(Icons.psychology),
                        label: const Text('Test AI Agent (Perplexity)'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purple,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Headline
                    Text(
                      'Permissions Check',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: textPrimary,
                        letterSpacing: -0.5,
                        height: 1.1,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Ensuring we stay connected to you so you never miss a reminder.',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: textSecondary,
                        height: 1.5,
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Global Status Progress
                    _buildProgressSection(
                        isDark, textPrimary, textSecondary, primaryColor),

                    const SizedBox(height: 32),

                    // Permission Cards List

                    // Critical Card (Battery Optimization)
                    _buildCriticalCard(
                      isDark: isDark,
                      surfaceColor: surfaceColor,
                      dangerColor: dangerColor,
                      textPrimary: textPrimary,
                      textSecondary: textSecondary,
                      title: 'Battery Optimization',
                      subtitle:
                          'Restricted. This may prevent reminders from appearing when your phone is locked.',
                      actionLabel: 'Fix Now',
                      iconData: Icons.battery_alert_rounded,
                      onTap: () {
                        // Opens general app settings where users can manage battery optimization
                        AppSettings.openAppSettings();
                      },
                    ),

                    const SizedBox(height: 16),

                    // Healthy Card 1 (Notifications)
                    _buildHealthyCard(
                      isDark: isDark,
                      surfaceColor: surfaceColor,
                      primaryColor: primaryColor,
                      successColor: successColor,
                      textPrimary: textPrimary,
                      title: 'Notifications',
                      iconData: Icons.notifications_rounded,
                    ),

                    const SizedBox(height: 16),

                    // Healthy Card 2 (Background Refresh)
                    _buildHealthyCard(
                      isDark: isDark,
                      surfaceColor: surfaceColor,
                      primaryColor: primaryColor,
                      successColor: successColor,
                      textPrimary: textPrimary,
                      title: 'Background Refresh',
                      iconData: Icons.sync_rounded,
                    ),

                    const SizedBox(height: 16),

                    // Educational Card
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: isDark
                            ? const Color(0xFF151820)
                            : const Color(0xFFF1F5F9), // slate-100
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isDark
                              ? Colors.white.withValues(alpha: 0.05)
                              : Colors.transparent,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.info_rounded,
                                  color: primaryColor, size: 20),
                              const SizedBox(width: 8),
                              Text(
                                'Why do we need these?',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: textPrimary,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'To function as your external brain, the app needs permission to run in the background and send time-sensitive alerts even when you aren\'t using your phone.',
                            style: TextStyle(
                              fontSize: 14,
                              height: 1.6,
                              color: textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context, bool isDark, Color textPrimary,
      Color textSecondary) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(Icons.arrow_back, color: textPrimary, size: 24),
            style: IconButton.styleFrom(
              backgroundColor: isDark ? Colors.transparent : Colors.transparent,
              hoverColor: isDark ? Colors.white10 : Colors.black12,
            ),
          ),
          Text(
            'System Health',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: textPrimary,
              letterSpacing: -0.5,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.05)
                  : Colors.grey[200],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'Help',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressSection(
      bool isDark, Color textPrimary, Color textSecondary, Color primaryColor) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '2/3 Systems Active',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: textPrimary),
            ),
            Text(
              '66%',
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: textSecondary),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: Container(
            height: 12,
            color: isDark ? const Color(0xFF384354) : Colors.grey[300],
            child: Row(
              children: [
                Expanded(
                  flex: 66,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [primaryColor, Colors.blue.shade400],
                      ),
                    ),
                  ),
                ),
                const Expanded(flex: 34, child: SizedBox()),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCriticalCard({
    required bool isDark,
    required Color surfaceColor,
    required Color dangerColor,
    required Color textPrimary,
    required Color textSecondary,
    required String title,
    required String subtitle,
    required String actionLabel,
    required IconData iconData,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
            color: isDark
                ? dangerColor.withValues(alpha: 0.3)
                : Colors.red.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            child: Container(
              width: 6,
              decoration: BoxDecoration(
                color: dangerColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  bottomLeft: Radius.circular(16),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(22, 20, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: dangerColor.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(iconData, color: dangerColor, size: 24),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: textPrimary,
                              height: 1.1,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Action Required',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: dangerColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.5,
                    color: textSecondary,
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: onTap,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      elevation: 4,
                      shadowColor: AppColors.primary.withValues(alpha: 0.2),
                    ),
                    child: Text(
                      actionLabel,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHealthyCard({
    required bool isDark,
    required Color surfaceColor,
    required Color primaryColor,
    required Color successColor,
    required Color textPrimary,
    required String title,
    required IconData iconData,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: primaryColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(iconData, color: primaryColor, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Active',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: successColor,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: successColor,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.check, color: Colors.white, size: 18),
          ),
        ],
      ),
    );
  }
}
