import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/locator.dart';
import '../../application/providers/auth_provider.dart';
import '../../application/view_models/focus_checkin_view_model.dart';
import '../../application/view_models/routine_safety_view_model.dart';
import '../views/auth/login_screen.dart';
import '../views/auth/signup_screen.dart';
import '../views/auth/forgot_password_screen.dart';
import '../views/splash_screen.dart';
import '../views/daily_stack_screen.dart';
import '../views/insights_screen.dart';
import '../views/level_up_screen.dart';
import '../views/library_screen.dart';
import '../views/stack_builder_screen.dart';
import '../views/streak_saved_screen.dart';
import '../views/streak_recovery_screen.dart';
import '../views/onboarding_grace_period_screen.dart';

import '../views/onboarding_goal_selection_screen.dart';

import '../views/visual_pill_matcher_screen.dart';
import '../views/persistent_reminders_screen.dart';
import '../views/compatibility_detail_screen.dart';
import '../views/weekly_review_screen.dart';
import '../views/user_profile_screen.dart';
import '../view_models/library_view_model.dart';
import '../views/home_widgets_preview_screen.dart';
import '../views/advisor_report_screen.dart';
import '../views/history_log_screen.dart';
import 'package:neurostack_app/domain/repositories/stack_repository.dart';
import 'package:neurostack_app/domain/repositories/supplement_repository.dart';
import 'package:neurostack_app/presentation/view_models/stack_builder_view_model.dart';
import '../views/community_screen.dart';
import '../views/trophy_room_screen.dart';
import '../views/strategy_hub_screen.dart';
import '../views/chemist_screen.dart';
import '../views/focus_buddies_screen.dart';
import '../views/privacy_settings_screen.dart';
// import '../views/nightly_reflection_screen.dart';
import '../views/refer_friend_screen.dart';
import 'auth_wrapper.dart';

import '../views/daily_focus_checkin_screen.dart';
import '../views/quick_setup_wizard_screen.dart';
import '../views/notification_reliability_setup_screen.dart';
import '../views/late_serving_triage_screen.dart';
import '../views/routine_confirmation_screen.dart';
import '../views/system_health_screen.dart';
import '../views/strategy_library_update_screen.dart';
import '../views/developer_handoff_logic_triggers_screen.dart';
import '../views/help_and_support_screen.dart';
import '../views/ai_search_screen.dart';
import '../views/milestone_success_screen.dart';
import '../views/notification_history_screen.dart';
import '../views/emergency_contact_screen.dart';
import '../views/first_stack_success_screen.dart';
import '../views/educational_article_detail_screen.dart';
import '../views/article_detail_screen.dart';
import '../views/disclaimer_screen.dart';
import '../views/supplement_detail.dart';
import '../views/global_search_screen.dart';
import '../views/paywall_screen.dart';
import '../../domain/entities/supplement.dart';
import '../../domain/entities/supplement_compatibility.dart';
import '../../domain/entities/educational_article.dart';
import '../../domain/entities/routine_element.dart';
import '../../config/feature_flags.dart';

class AppRouter {
  // Route names
  static const String splash = '/splash';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String forgotPassword = '/forgot-password';
  static const String onboardingGracePeriod = '/onboarding/grace-period';
  static const String onboardingDisclaimer = '/onboarding-disclaimer';

  static const String onboardingGoals = '/onboarding/goals';

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
  static const String safetyDetail = '/optimization-detail';
  static const String widgetsPreview = '/widgets-preview';
  static const String advisorReport = '/advisor-report';
  static const String historyLog = '/history-log';
  static const String community = '/community';
  static const String trophyRoom = '/trophy-room';
  static const String strategyHub = '/strategy-hub';
  static const String chemist = '/mixer';
  static const String focusBuddies = '/focus-buddies';
  static const String privacySettings = '/privacy-settings';
  // static const String nightlyReflection = '/nightly-reflection';
  static const String appAppearance = '/app-appearance';
  static const String referFriend = '/refer-friend';
  static const String routineFocusReport = '/routine-focus-report';
  static const String routineAdherence = '/routine-adherence';
  static const String subscription = '/subscription';
  static const String paywall = '/paywall';
  static const String stateCheckin = '/state-checkin';
  static const String quickSetup = '/quick-setup';
  static const String notificationReliability = '/notification-reliability';
  static const String lateDoseTriage = '/late-dose-triage';
  static const String safetyCompatibilityDetail = '/compatibility-detail';
  static const String safetyOverrideConfirmation = '/optimization-confirmation';
  static const String helpAndSupport = '/help-and-support';
  static const String systemHealth = '/system-health';
  static const String scienceUpdate = '/science-update';
  static const String developerHandoff = '/developer-handoff';
  static const String aiSearch = '/ai-search';
  static const String articleDetail = '/article-detail';
  static const String emergencyContact = '/emergency-contact';
  static const String milestoneSuccess = '/milestone-success';
  static const String notificationHistory = '/notification-history';
  static const String firstStackSuccess = '/first-stack-success';
  static const String supplementDetail = '/supplement-detail';
  static const String globalSearch = '/global-search';
  static const String eduArticleDetail = '/edu-article-detail';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        final args = settings.arguments as Map<String, dynamic>? ?? {};
        return MaterialPageRoute(
          builder: (_) => SplashScreen(
            isFirebaseReady: (args['isFirebaseReady'] as bool?) ?? true,
            initError: args['initError'] as String?,
          ),
        );

      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());

      case signup:
        return MaterialPageRoute(builder: (_) => const SignupScreen());

      case forgotPassword:
        return MaterialPageRoute(builder: (_) => const ForgotPasswordScreen());

      case onboardingDisclaimer:
        return MaterialPageRoute(builder: (_) => const DisclaimerScreen());

      case onboardingGracePeriod:
        return MaterialPageRoute(
            builder: (_) => const OnboardingGracePeriodScreen());

      case onboardingGoals:
        return MaterialPageRoute(
            builder: (_) => const OnboardingGoalSelectionScreen());

      case home:
        return MaterialPageRoute(builder: (_) => const AuthWrapper());

      case privacySettings:
        return MaterialPageRoute(
            builder: (_) => PrivacySettingsScreen.withProvider());

      // case nightlyReflection:
      //   return MaterialPageRoute(
      //       builder: (_) => const NightlyReflectionScreen());

      case dailyStack:
        return MaterialPageRoute(builder: (_) => const DailyStackScreen());

      case emergencyContact:
        return MaterialPageRoute(
            builder: (_) => const EmergencyContactScreen());

      case dashboard:
        return MaterialPageRoute(builder: (_) => const DailyStackScreen());

      case insights:
      case routineAdherence: // Changed from successStats
        return MaterialPageRoute(
          builder: (context) {
            final authProvider =
                Provider.of<AuthProvider>(context, listen: false);

            if (!authProvider.canAccess('pro')) {
              return const PaywallScreen(returnTo: insights);
            }
            return const InsightsScreen();
          },
        );

      case library:
        return MaterialPageRoute(builder: (_) => const LibraryScreen());

      case stackBuilder:
        return MaterialPageRoute(
          builder: (context) {
            final authProvider =
                Provider.of<AuthProvider>(context, listen: false);

            if (!authProvider.canAccess('stack_builder')) {
              return const PaywallScreen(returnTo: stackBuilder);
            }

            final userId = authProvider.user?.id ?? '';
            final safetyVM = locator<RoutineSafetyViewModel>(param1: userId);
            return MultiProvider(
              providers: [
                ChangeNotifierProvider.value(value: safetyVM),
                ChangeNotifierProvider(
                  create: (_) => StackBuilderViewModel(
                    stackRepository: locator<StackRepository>(),
                    supplementRepository: locator<SupplementRepository>(),
                    safetyViewModel: safetyVM,
                    userId: userId,
                  )..initialize(),
                ),
              ],
              child: const StackBuilderScreen(),
            );
          },
        );

      case pillMatcher:
        return MaterialPageRoute(
            builder: (_) => VisualPillMatcherScreen.withProvider());

      case reminders:
        return MaterialPageRoute(
            builder: (_) => PersistentRemindersScreen.withProvider());

      case profile:
        return MaterialPageRoute(builder: (_) => const UserProfileScreen());

      case weeklyReview:
        return MaterialPageRoute(
            builder: (_) => WeeklyReviewScreen.withProvider());

      case levelUp:
        return MaterialPageRoute(builder: (_) => const LevelUpScreen());

      case streakSaved:
        return MaterialPageRoute(builder: (_) => const StreakSavedScreen());

      case streakRecovery:
        return MaterialPageRoute(builder: (_) => const StreakRecoveryScreen());

      case safetyDetail:
        final guidance = settings.arguments as CompatibilityGuidance;
        return MaterialPageRoute(
          builder: (_) => CompatibilityDetailScreen(guidance: guidance),
        );

      case widgetsPreview:
        return MaterialPageRoute(
            builder: (_) => const HomeWidgetsPreviewScreen());

      case advisorReport:
        return MaterialPageRoute(
          builder: (context) {
            final authProvider =
                Provider.of<AuthProvider>(context, listen: false);

            if (!authProvider.canAccess('pro')) {
              return const PaywallScreen(returnTo: advisorReport);
            }
            return AdvisorReportScreen.withProvider();
          },
        );

      case historyLog:
        return MaterialPageRoute(
            builder: (_) => HistoryLogScreen.withProvider());

      case community:
        return MaterialPageRoute(
            builder: (_) => CommunityScreen.withProvider());

      case trophyRoom:
        return MaterialPageRoute(
            builder: (_) => TrophyRoomScreen.withProvider());

      case strategyHub:
        return MaterialPageRoute(
          builder: (context) {
            final authProvider =
                Provider.of<AuthProvider>(context, listen: false);

            if (!authProvider.canAccess('pro')) {
              return const PaywallScreen(returnTo: strategyHub);
            }
            return const StrategyHubScreen();
          },
        );
      case chemist:
        return MaterialPageRoute(builder: (_) => ChemistScreen.withProvider());

      case focusBuddies:
        if (!FeatureFlags.focusBuddies) {
          return MaterialPageRoute(
            builder: (_) => Scaffold(
              appBar: AppBar(title: const Text('Coming Soon')),
              body:
                  const Center(child: Text('Focus Buddies is coming in v1.1')),
            ),
          );
        }
        return MaterialPageRoute(
            builder: (_) => FocusBuddiesScreen.withProvider());

//      case appAppearance:
//        return MaterialPageRoute(builder: (_) => const AppAppearanceScreen());
      case subscription:
      case paywall:
        final returnTo = settings.arguments as String?;
        return MaterialPageRoute(
            builder: (_) => PaywallScreen(returnTo: returnTo));
      case referFriend:
        return MaterialPageRoute(builder: (_) => const ReferFriendScreen());
      case stateCheckin:
        return MaterialPageRoute(
          builder: (context) {
            final authProvider =
                Provider.of<AuthProvider>(context, listen: false);
            final userId = authProvider.user?.id ?? 'demo_user';
            return ChangeNotifierProvider(
              create: (_) => locator<FocusCheckInViewModel>(param1: userId),
              child: const DailyFocusCheckinScreen(),
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
          builder: (_) => const LateServingTriageScreen(),
          fullscreenDialog: true,
        );

      case safetyCompatibilityDetail:
        final compatibility = settings.arguments as SupplementCompatibility;
        return MaterialPageRoute(
          builder: (_) =>
              CompatibilityDetailScreen(compatibility: compatibility),
        );

      case safetyOverrideConfirmation:
        final compatibility = settings.arguments as SupplementCompatibility;
        return MaterialPageRoute(
          builder: (_) =>
              RoutineOverrideConfirmationScreen(compatibility: compatibility),
        );

      case systemHealth:
        return MaterialPageRoute(builder: (_) => const SystemHealthScreen());

      case scienceUpdate:
        return MaterialPageRoute(
            builder: (_) => const StrategyLibraryUpdateScreen());

      case developerHandoff:
        return MaterialPageRoute(
          builder: (_) => const DeveloperHandoffLogicTriggersScreen(),
        );
      case aiSearch:
        return MaterialPageRoute(
          builder: (_) => const AiSearchScreen(),
        );
      case helpAndSupport:
        return MaterialPageRoute(builder: (_) => const HelpAndSupportScreen());

      case articleDetail:
        final articleId = settings.arguments as String;
        return MaterialPageRoute(
            builder: (_) => ArticleDetailScreen.withProvider(articleId));

      case milestoneSuccess:
        return MaterialPageRoute(
            builder: (_) => const MilestoneSuccessScreen());

      case notificationHistory:
        return MaterialPageRoute(
            builder: (_) => NotificationHistoryScreen.withProvider());

      case firstStackSuccess:
        return MaterialPageRoute(
            builder: (_) => const FirstStackSuccessScreen());

      case supplementDetail:
        final supplement = settings.arguments as Supplement;
        final authProvider = locator<AuthProvider>();
        final userId = authProvider.user?.id ?? 'demo_user';
        return MaterialPageRoute(
            builder: (_) => ChangeNotifierProvider(
                  create: (_) =>
                      locator<LibraryViewModel>(param1: userId)..initialize(),
                  child: SupplementDetail(supplement: supplement),
                ));

      case globalSearch:
        return MaterialPageRoute(builder: (_) => const GlobalSearchScreen());

      case eduArticleDetail:
        final article = settings.arguments as EducationalArticle;
        return MaterialPageRoute(
          builder: (_) => EducationalArticleDetailScreen(article: article),
        );

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
