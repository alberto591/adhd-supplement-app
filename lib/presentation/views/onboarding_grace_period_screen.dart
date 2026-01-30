import 'package:flutter/material.dart';
import 'package:neurostack_app/l10n/generated/app_localizations.dart';
import '../theme/app_theme.dart';
import '../navigation/app_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import '../../application/providers/auth_provider.dart';
import '../../utils/logger.dart';

class OnboardingGracePeriodScreen extends StatelessWidget {
  const OnboardingGracePeriodScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Center(
            child: CircleAvatar(
              backgroundColor: isDark ? Colors.grey[800] : Colors.grey[200],
              radius: 20,
              child: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios_new,
                  color: isDark ? Colors.white : Colors.black,
                  size: 16,
                ),
                padding: EdgeInsets.zero,
                onPressed: () {},
              ),
            ),
          ),
        ),
        title: Text(
          AppLocalizations.of(context)!.graceDayPhilosophy,
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Progress Bar Area
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.step2of2,
                        style: TextStyle(
                          color: isDark ? Colors.white : Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        AppLocalizations.of(context)!.complete100,
                        style: TextStyle(
                          color: isDark ? Colors.grey[400] : Colors.grey[500],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    height: 8,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: isDark ? Colors.grey[800] : Colors.grey[200],
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: 1.0,
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(999),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    const SizedBox(height: 16), // Spacing from top bar
                    // Hero Illustration
                    SizedBox(
                      width: 220,
                      height: 220,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Blur Effect
                          Container(
                            width: 200,
                            height: 200,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.primary
                                  .withValues(alpha: isDark ? 0.2 : 0.1),
                            ),
                          ),
                          // Image
                          Container(
                            width: 180,
                            height: 180,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(24),
                              image: const DecorationImage(
                                image: CachedNetworkImageProvider(
                                  'https://lh3.googleusercontent.com/aida-public/AB6AXuCEKRevVdokOjFtFZvmgLdF8d_XggCSOWA8CgNp72pCfqV2jX6lj0_jbLWDth-3k1BnGNUfDRUeeAeFykEbYysmc9A13Np-e9ONWM9CenQ1GC24jycAAAO5-XUXbgBa-0XYdBSc9RiUUQ8Nq1w5Pt8BypRIx5aNyG0YdAueulirzo_SS9maP3ft_L8N9NbEujaoXx95tSu9QHJCY83pqpHW6ivG1APvJBPKJttkqNyhqG9TF0v3C8BB3GoSW28sOnf3HuA4OJCTRAQ',
                                ),
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          // Overlay Icons (fallback/enhancement)
                          // Note: The image url likely already contains the heart/flame composition.
                          // But I'll add them if the image fails or just rely on the image.
                          // The wireframe HTML has an image + overlay icons.
                          // I'll trust the visual from the wireframe screenshot which shows a nice composition.
                          // The image seems to be the main driver.
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),

                    Text(
                      AppLocalizations.of(context)!.lifeHappens,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: isDark ? Colors.white : Colors.black,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        height: 1.1,
                      ),
                    ),

                    const SizedBox(height: 16),

                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: TextStyle(
                          color: isDark ? Colors.grey[300] : Colors.grey[600],
                          fontSize: 18,
                          height: 1.5,
                          fontFamily: 'Lexend', // Ensure font is consistent
                        ),
                        children: [
                          TextSpan(
                              text: AppLocalizations.of(context)!.weBelieveIn),
                          TextSpan(
                            text: AppLocalizations.of(context)!.graceDays,
                            style: const TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                              text: AppLocalizations.of(context)!
                                  .graceDaysDescription),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    // Non-Medical Disclaimer
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isDark
                            ? Colors.red.withValues(alpha: 0.1)
                            : Colors.red.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isDark
                              ? Colors.red.withValues(alpha: 0.3)
                              : Colors.red.withValues(alpha: 0.2),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.medical_information_outlined,
                            color: isDark ? Colors.red[300] : Colors.red[700],
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              AppLocalizations.of(context)!.medicalDisclaimer,
                              style: TextStyle(
                                color:
                                    isDark ? Colors.red[200] : Colors.red[800],
                                fontSize: 11,
                                height: 1.3,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                        height: 24), // Bottom spacing for center content
                  ],
                ),
              ),
            ),

            // Bottom Action
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        final auth = context.read<AuthProvider>();
                        final user = auth.user;

                        // Start the update but don't let it block navigation indefinitely
                        // if Firestore is having connectivity/permission issues.
                        if (user != null) {
                          try {
                            await auth
                                .updateProfile(
                                    user.copyWith(hasCompletedOnboarding: true))
                                .timeout(const Duration(seconds: 2));
                          } catch (e) {
                            AppLogger.w(
                                'Onboarding completion update failed/timed out: $e');
                            // We still proceed to dashboard; the flag will be synced
                            // eventually or handles by AuthWrapper retry logic.
                          }
                        }

                        if (!context.mounted) return;
                        Navigator.pushNamedAndRemoveUntil(
                            context, AppRouter.dashboard, (route) => false);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 8,
                        shadowColor: AppColors.primary.withValues(alpha: 0.25),
                        textStyle: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      child: Text(AppLocalizations.of(context)!.gotIt),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
