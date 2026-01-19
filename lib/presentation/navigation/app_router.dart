import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/locator.dart';
import '../../application/providers/auth_provider.dart';
import '../../application/view_models/symptom_checkin_viewmodel.dart';
import '../views/auth/login_screen.dart';
import '../views/auth/signup_screen.dart';
import '../views/daily_stack_screen.dart';
import '../views/dashboard_screen.dart';
import '../views/insights_screen.dart';
import '../views/level_up_screen.dart';
import '../views/library_screen.dart';
import '../views/stack_builder_screen.dart';
import '../views/streak_saved_screen.dart';
import '../views/streak_recovery_screen.dart';
import '../views/onboarding_grace_period_screen.dart';
import '../views/medication_safety_screen.dart';
import '../views/onboarding_goal_selection_screen.dart';
import '../views/onboarding_stack_setup_screen.dart';
import '../views/visual_pill_matcher_screen.dart';
import '../views/persistent_reminders_screen.dart';
import '../views/safety_detail_screen.dart';
import '../views/weekly_review_screen.dart';
import '../views/user_profile_screen.dart';
import '../views/home_widgets_preview_screen.dart';
import '../views/doctor_export_screen.dart';
import '../views/history_log_screen.dart';
import '../views/community_screen.dart';
import '../views/trophy_room_screen.dart';
import '../views/science_hub_screen.dart';
import '../views/focus_buddies_screen.dart';
import '../views/privacy_settings_screen.dart';
import '../views/nightly_reflection_screen.dart';
import '../views/app_appearance_screen.dart';
import '../views/refer_friend_screen.dart';
import '../views/success_stats_screen.dart';
import '../views/subscription_screen.dart';
import '../views/daily_symptom_checkin_screen.dart';
import '../views/quick_setup_wizard_screen.dart';
import '../views/notification_reliability_setup_screen.dart';
import '../views/late_dose_triage_screen.dart';
import '../views/safety_interaction_detail_screen.dart';
import '../views/safety_override_confirmation_screen.dart';
import '../views/system_health_screen.dart';
import '../views/science_library_update_screen.dart';
import '../views/developer_handoff_logic_triggers_screen.dart';
import '../views/help_and_support_screen.dart';
import '../views/article_detail_screen.dart';
import '../views/milestone_success_screen.dart';
import '../views/notification_history_screen.dart';
import '../views/emergency_contact_screen.dart';
import '../../domain/entities/supplement_interaction.dart';

class AppRouter {
  // Route names
  static const String login = '/login';
  static const String signup = '/signup';
  static const String onboardingGracePeriod = '/onboarding/grace-period';
  static const String onboardingMedicationSafety =
      '/onboarding/medication-safety';
  static const String onboardingGoals = '/onboarding/goals';
  static const String onboardingStackSetup = '/onboarding/stack-setup';
  static const String home = '/';
  static const String dailyStack = '/daily-stack';
  static const String dashboard = '/dashboard';
  static const String insights = '/insights';
  static const String library = '/library';
  static const String stackBuilder = '/stack-builder';
  static const String pillMatcher = '/pill-matcher';
  static const String reminders = '/reminders';
  static const String profile = '/profile';
  static const String weeklyReview = '/weekly-review';
  static const String levelUp = '/level-up';
  static const String streakSaved = '/streak-saved';
  static const String streakRecovery = '/streak-recovery';
  static const String safetyDetail = '/safety-detail';
  static const String widgetsPreview = '/widgets-preview';
  static const String doctorExport = '/doctor-export';
  static const String historyLog = '/history-log';
  static const String community = '/community';
  static const String trophyRoom = '/trophy-room';
  static const String scienceHub = '/science-hub';
  static const String focusBuddies = '/focus-buddies';
  static const String privacySettings = '/privacy-settings';
  static const String nightlyReflection = '/nightly-reflection';
  static const String appAppearance = '/app-appearance';
  static const String referFriend = '/refer-friend';
  static const String successStats = '/success-stats';
  static const String subscription = '/subscription';
  static const String symptomCheckin = '/symptom-checkin';
  static const String quickSetup = '/quick-setup';
  static const String notificationReliability = '/notification-reliability';
  static const String lateDoseTriage = '/late-dose-triage';
  static const String safetyInteractionDetail = '/safety-interaction-detail';
  static const String safetyOverrideConfirmation =
      '/safety-override-confirmation';
  static const String helpAndSupport = '/help-and-support';
  static const String systemHealth = '/system-health';
  static const String scienceUpdate = '/science-update';
  static const String developerHandoff = '/developer-handoff';
  static const String articleDetail = '/article-detail';
  static const String emergencyContact = '/emergency-contact';
  static const String milestoneSuccess = '/milestone-success';
  static const String notificationHistory = '/notification-history';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());

      case signup:
        return MaterialPageRoute(builder: (_) => const SignupScreen());

      case onboardingGracePeriod:
        return MaterialPageRoute(
            builder: (_) => const OnboardingGracePeriodScreen());

      case onboardingMedicationSafety:
        return MaterialPageRoute(
            builder: (_) => const MedicationSafetyScreen());

      case onboardingGoals:
        return MaterialPageRoute(
            builder: (_) => const OnboardingGoalSelectionScreen());

      case onboardingStackSetup:
        return MaterialPageRoute(
            builder: (_) => const OnboardingStackSetupScreen());

      case home:
      case privacySettings:
        return MaterialPageRoute(builder: (_) => const PrivacySettingsScreen());

      case nightlyReflection:
        return MaterialPageRoute(
            builder: (_) => const NightlyReflectionScreen());

      case dailyStack: // dailyStack was previously grouped with home, now it's separate
        return MaterialPageRoute(builder: (_) => const DailyStackScreen());

      case emergencyContact:
        return MaterialPageRoute(
            builder: (_) => const EmergencyContactScreen());

      case dashboard:
        return MaterialPageRoute(builder: (_) => const DashboardScreen());

      case insights:
        return MaterialPageRoute(builder: (_) => const InsightsScreen());

      case library:
        return MaterialPageRoute(builder: (_) => const LibraryScreen());

      case stackBuilder:
        return MaterialPageRoute(builder: (_) => const StackBuilderScreen());

      case pillMatcher:
        return MaterialPageRoute(
            builder: (_) => const VisualPillMatcherScreen());

      case reminders:
        return MaterialPageRoute(
            builder: (_) => const PersistentRemindersScreen());

      case profile:
        return MaterialPageRoute(builder: (_) => const UserProfileScreen());

      case weeklyReview:
        return MaterialPageRoute(builder: (_) => const WeeklyReviewScreen());

      case levelUp:
        return MaterialPageRoute(builder: (_) => const LevelUpScreen());

      case streakSaved:
        return MaterialPageRoute(builder: (_) => const StreakSavedScreen());

      case streakRecovery:
        return MaterialPageRoute(builder: (_) => const StreakRecoveryScreen());

      case safetyDetail:
        return MaterialPageRoute(builder: (_) => const SafetyDetailScreen());

      case widgetsPreview:
        return MaterialPageRoute(
            builder: (_) => const HomeWidgetsPreviewScreen());

      case doctorExport:
        return MaterialPageRoute(builder: (_) => const DoctorExportScreen());

      case historyLog:
        return MaterialPageRoute(builder: (_) => const HistoryLogScreen());

      case community:
        return MaterialPageRoute(builder: (_) => const CommunityScreen());

      case trophyRoom:
        return MaterialPageRoute(builder: (_) => const TrophyRoomScreen());

      case scienceHub:
        return MaterialPageRoute(builder: (_) => const ScienceHubScreen());

      case focusBuddies:
        return MaterialPageRoute(builder: (_) => const FocusBuddiesScreen());

      case appAppearance:
        return MaterialPageRoute(builder: (_) => const AppAppearanceScreen());
      case referFriend:
        return MaterialPageRoute(builder: (_) => const ReferFriendScreen());
      case successStats:
        return MaterialPageRoute(builder: (_) => const SuccessStatsScreen());
      case subscription:
        return MaterialPageRoute(
            builder: (_) => SubscriptionScreen.withProvider());

      case symptomCheckin:
        return MaterialPageRoute(
          builder: (context) {
            final authProvider =
                Provider.of<AuthProvider>(context, listen: false);
            final userId = authProvider.user?.id ?? '';
            return ChangeNotifierProvider(
              create: (_) => locator<SymptomCheckInViewModel>(param1: userId),
              child: const DailySymptomCheckinScreen(),
            );
          },
          fullscreenDialog: true,
        );

      case quickSetup:
        return MaterialPageRoute(
            builder: (_) => const QuickSetupWizardScreen());

      case notificationReliability:
        return MaterialPageRoute(
            builder: (_) => const NotificationReliabilitySetupScreen());

      case lateDoseTriage:
        return MaterialPageRoute(
          builder: (_) => const LateDoseTriageScreen(),
          fullscreenDialog: true,
        );

      case safetyInteractionDetail:
        final interaction = settings.arguments as SupplementInteraction;
        return MaterialPageRoute(
          builder: (_) =>
              SafetyInteractionDetailScreen(interaction: interaction),
        );

      case safetyOverrideConfirmation:
        final interaction = settings.arguments as SupplementInteraction;
        return MaterialPageRoute(
          builder: (_) =>
              SafetyOverrideConfirmationScreen(interaction: interaction),
        );

      case systemHealth:
        return MaterialPageRoute(builder: (_) => const SystemHealthScreen());

      case scienceUpdate:
        return MaterialPageRoute(
            builder: (_) => const ScienceLibraryUpdateScreen());

      case developerHandoff:
        return MaterialPageRoute(
            builder: (_) => const DeveloperHandoffLogicTriggersScreen());

      case helpAndSupport:
        return MaterialPageRoute(builder: (_) => const HelpAndSupportScreen());

      case articleDetail:
        return MaterialPageRoute(builder: (_) => const ArticleDetailScreen());

      case milestoneSuccess:
        return MaterialPageRoute(
            builder: (_) => const MilestoneSuccessScreen());

      case notificationHistory:
        return MaterialPageRoute(
            builder: (_) => NotificationHistoryScreen.withProvider());

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }

  // Navigation helpers
  static void navigateTo(BuildContext context, String routeName) {
    Navigator.pushNamed(context, routeName);
  }

  static void navigateToHome(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(context, dashboard, (route) => false);
  }

  static void navigateToLogin(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(context, login, (route) => false);
  }

  static void back(BuildContext context) {
    Navigator.pop(context);
  }
}
