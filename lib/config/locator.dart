import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

// --- Domain ---
import 'package:neurostack_app/domain/repositories/auth_repository.dart';
import 'package:neurostack_app/domain/repositories/supplement_repository.dart';
import 'package:neurostack_app/domain/repositories/stack_repository.dart';
import 'package:neurostack_app/domain/repositories/log_repository.dart';
import 'package:neurostack_app/domain/repositories/checkin_repository.dart';
import 'package:neurostack_app/domain/repositories/streak_repository.dart';
import 'package:neurostack_app/domain/repositories/gamification_repository.dart';
import 'package:neurostack_app/domain/repositories/routine_safety_repository.dart';
import 'package:neurostack_app/domain/repositories/settings_repository.dart';
import 'package:neurostack_app/domain/repositories/article_repository.dart';
import 'package:neurostack_app/domain/repositories/community_repository.dart';
import 'package:neurostack_app/domain/repositories/referral_repository.dart';
import 'package:neurostack_app/domain/services/billing_service.dart';
import 'package:neurostack_app/domain/services/compatibility_service.dart';
import 'package:neurostack_app/domain/services/analytics_service.dart';

// --- Infrastructure ---
import 'package:neurostack_app/infrastructure/services/no_op_billing_service.dart';
import 'package:neurostack_app/infrastructure/repositories/firebase_auth_repository.dart';
import 'package:neurostack_app/infrastructure/repositories/firebase_supplement_repository.dart';
import 'package:neurostack_app/infrastructure/repositories/firebase_stack_repository.dart';
import 'package:neurostack_app/infrastructure/repositories/firebase_log_repository.dart';
import 'package:neurostack_app/infrastructure/repositories/firebase_checkin_repository.dart';
import 'package:neurostack_app/infrastructure/repositories/firebase_streak_repository.dart';
import 'package:neurostack_app/infrastructure/repositories/firebase_gamification_repository.dart';
import 'package:neurostack_app/infrastructure/repositories/firebase_routine_safety_repository.dart';
import 'package:neurostack_app/infrastructure/repositories/firebase_article_repository.dart';
import 'package:neurostack_app/infrastructure/repositories/firebase_community_repository.dart';
import 'package:neurostack_app/infrastructure/repositories/firebase_referral_repository.dart';
import 'package:neurostack_app/infrastructure/repositories/perplexity_repository.dart';
import 'package:neurostack_app/infrastructure/repositories/shared_prefs_settings_repository.dart';
import 'package:neurostack_app/infrastructure/services/routine_data_service.dart';
import 'package:neurostack_app/infrastructure/services/firebase_analytics_service.dart';
import 'package:neurostack_app/infrastructure/services/notification_service.dart';
import 'package:neurostack_app/infrastructure/services/streak_service.dart';
import 'package:neurostack_app/infrastructure/services/url_service.dart';
import 'package:neurostack_app/infrastructure/services/sound_service.dart';
import 'package:neurostack_app/infrastructure/services/routine_pdf_service.dart';
import 'package:neurostack_app/infrastructure/services/seeding_service.dart';
import 'package:neurostack_app/infrastructure/services/perplexity_service.dart';

// --- Application ---
import 'package:neurostack_app/application/providers/auth_provider.dart';
import 'package:neurostack_app/application/services/haptic_service.dart';
import 'package:neurostack_app/application/view_models/supplement_view_model.dart';
import 'package:neurostack_app/application/view_models/routine_safety_view_model.dart';
import 'package:neurostack_app/application/view_models/state_checkin_viewmodel.dart';
import 'package:neurostack_app/application/view_models/subscription_view_model.dart';
import 'package:neurostack_app/application/view_models/privacy_view_model.dart';
import 'package:neurostack_app/application/view_models/notification_history_view_model.dart';
import 'package:neurostack_app/application/view_models/persistent_reminders_view_model.dart';
import 'package:neurostack_app/application/view_models/focus_buddies_view_model.dart';
import 'package:neurostack_app/application/view_models/trophy_room_view_model.dart';
import 'package:neurostack_app/application/view_models/community_view_model.dart';
import 'package:neurostack_app/application/view_models/history_log_view_model.dart';
import 'package:neurostack_app/application/view_models/article_detail_view_model.dart';
import 'package:neurostack_app/application/view_models/science_hub_view_model.dart';
import 'package:neurostack_app/application/view_models/refer_friend_view_model.dart';
import 'package:neurostack_app/application/view_models/nightly_reflection_view_model.dart';
import 'package:neurostack_app/application/view_models/advisor_report_view_model.dart';
import 'package:neurostack_app/application/view_models/chemist_view_model.dart';
import 'package:neurostack_app/application/view_models/theme_view_model.dart';
import 'package:neurostack_app/application/view_models/insights_view_model.dart';
import 'package:neurostack_app/application/view_models/global_search_view_model.dart';
import 'package:neurostack_app/application/view_models/pill_matcher_view_model.dart';

// --- Presentation ---
import 'package:neurostack_app/presentation/view_models/daily_stack_view_model.dart';
import 'package:neurostack_app/presentation/view_models/library_view_model.dart';
import 'package:neurostack_app/presentation/view_models/stack_builder_view_model.dart';

final locator = GetIt.instance;

Future<void> setupLocator() async {
  final prefs = await SharedPreferences.getInstance();

  _setupCore(prefs);
  _setupInfrastructure(prefs);
  _setupApplication();
  _setupViewModels();
}

void _setupCore(SharedPreferences prefs) {
  locator.registerLazySingleton<SettingsRepository>(
      () => SharedPrefsSettingsRepository(prefs));
  locator.registerLazySingleton<HapticService>(() => HapticService());
  locator.registerLazySingleton<SoundService>(
      () => SoundService(locator<SettingsRepository>()));
  locator.registerLazySingleton<UrlService>(() => UrlService());
  locator.registerLazySingleton<RoutinePdfService>(() => RoutinePdfService());
  locator.registerLazySingleton<SeedingService>(() => SeedingService());
}

void _setupInfrastructure(SharedPreferences prefs) {
  // Services
  locator.registerLazySingleton<BillingService>(() => NoOpBillingService());
  locator.registerLazySingleton<AnalyticsService>(
      () => FirebaseAnalyticsService());
  locator
      .registerLazySingleton<NotificationService>(() => NotificationService());
  locator
      .registerLazySingleton<CompatibilityService>(() => RoutineDataService());
  locator.registerLazySingleton<StreakService>(() => StreakService());
  locator.registerLazySingleton<PerplexityService>(() => PerplexityService());

  // Repositories
  locator.registerLazySingleton<AuthRepository>(() => FirebaseAuthRepository());
  locator.registerLazySingleton<SupplementRepository>(
      () => FirebaseSupplementRepository());
  locator
      .registerLazySingleton<StackRepository>(() => FirebaseStackRepository());
  locator.registerLazySingleton<LogRepository>(
      () => FirebaseLogRepository(prefs: prefs));
  locator.registerLazySingleton<CheckInRepository>(
      () => FirebaseCheckInRepository());
  locator.registerLazySingleton<StreakRepository>(
      () => FirebaseStreakRepository());
  locator.registerLazySingleton<GamificationRepository>(
      () => FirebaseGamificationRepository());
  locator.registerLazySingleton<RoutineSafetyRepository>(
      () => FirebaseRoutineSafetyRepository());
  locator
      .registerLazySingleton<ArticleRepository>(() => FirebaseArticleRepository(
            perplexityService: locator<PerplexityService>(),
          ));
  locator.registerLazySingleton<CommunityRepository>(
      () => FirebaseCommunityRepository());
  locator.registerLazySingleton<ReferralRepository>(
      () => FirebaseReferralRepository());
  locator.registerLazySingleton<PerplexityRepository>(
      () => PerplexityRepositoryImpl(locator<PerplexityService>()));
}

void _setupApplication() {
  locator.registerLazySingleton(
      () => AuthProvider(locator<AuthRepository>(), locator<BillingService>()));
}

void _setupViewModels() {
  // Singleton ViewModels
  locator.registerLazySingleton(
      () => ThemeViewModel(locator<SettingsRepository>()));
  locator.registerFactory(() => SubscriptionViewModel());
  locator.registerFactory(() => PillMatcherViewModel());
  locator.registerFactory(() => PrivacyViewModel());
  locator.registerFactory(() => NotificationHistoryViewModel());

  // Factory ViewModels (Basic)
  locator.registerFactory(() => SupplementViewModel(
        locator<SupplementRepository>(),
        locator<UrlService>(),
        locator<AnalyticsService>(),
        locator<SettingsRepository>(),
      ));
  locator.registerFactory(() => PersistentRemindersViewModel(
        locator<SettingsRepository>(),
        locator<NotificationService>(),
      ));
  locator.registerFactory(
      () => CommunityViewModel(locator<CommunityRepository>()));
  locator.registerFactory(
      () => ArticleDetailViewModel(locator<ArticleRepository>()));
  locator
      .registerFactory(() => ScienceHubViewModel(locator<ArticleRepository>()));
  locator.registerFactory(
      () => ReferFriendViewModel(locator<ReferralRepository>()));
  locator
      .registerFactory(() => ChemistViewModel(locator<PerplexityRepository>()));

  // Parametric ViewModels (Require userId)
  locator.registerFactoryParam<DailyStackViewModel, String, void>(
    (userId, _) => DailyStackViewModel(
      stackRepository: locator<StackRepository>(),
      logRepository: locator<LogRepository>(),
      supplementRepository: locator<SupplementRepository>(),
      settingsRepository: locator<SettingsRepository>(),
      notificationService: locator<NotificationService>(),
      authRepository: locator<AuthRepository>(),
      analyticsService: locator<AnalyticsService>(),
      soundService: locator<SoundService>(),
      userId: userId,
    ),
  );

  locator.registerFactoryParam<LibraryViewModel, String, void>(
    (userId, _) => LibraryViewModel(
      supplementRepository: locator<SupplementRepository>(),
      stackRepository: locator<StackRepository>(),
      settingsRepository: locator<SettingsRepository>(),
      userId: userId,
    ),
  );

  locator.registerFactoryParam<TrophyRoomViewModel, String, void>(
    (userId, _) =>
        TrophyRoomViewModel(locator<GamificationRepository>(), userId),
  );

  locator.registerFactoryParam<HistoryLogViewModel, String, void>(
    (userId, _) => HistoryLogViewModel(
      logRepository: locator<LogRepository>(),
      stackRepository: locator<StackRepository>(),
      userId: userId,
    ),
  );

  locator.registerFactoryParam<StateCheckInViewModel, String, void>(
    (userId, _) => StateCheckInViewModel(
      repository: locator<CheckInRepository>(),
      userId: userId,
    ),
  );

  locator.registerFactoryParam<RoutineSafetyViewModel, String, void>(
    (userId, _) => RoutineSafetyViewModel(
      repository: locator<RoutineSafetyRepository>(),
      userId: userId,
    ),
  );

  locator.registerFactoryParam<FocusBuddiesViewModel, String, void>(
    (userId, _) => FocusBuddiesViewModel(
      locator<AuthRepository>(),
      locator<LogRepository>(),
    ),
  );

  locator.registerFactoryParam<NightlyReflectionViewModel, String, void>(
    (userId, _) => NightlyReflectionViewModel(
      logRepository: locator<LogRepository>(),
      userId: userId,
    ),
  );

  locator.registerFactoryParam<AdvisorReportViewModel, String, void>(
    (userId, _) => AdvisorReportViewModel(
      logRepository: locator<LogRepository>(),
      authRepository: locator<AuthRepository>(),
      pdfService: locator<RoutinePdfService>(),
      userId: userId,
    ),
  );

  locator.registerFactoryParam<InsightsViewModel, String, void>(
    (userId, _) => InsightsViewModel(
      logRepository: locator<LogRepository>(),
      userId: userId,
    ),
  );

  locator.registerFactoryParam<GlobalSearchViewModel, String, void>(
    (userId, _) => GlobalSearchViewModel(
      supplementRepository: locator<SupplementRepository>(),
      stackRepository: locator<StackRepository>(),
      userId: userId,
    ),
  );

  locator.registerFactoryParam<StackBuilderViewModel, String, void>(
    (userId, _) => StackBuilderViewModel(
      stackRepository: locator<StackRepository>(),
      supplementRepository: locator<SupplementRepository>(),
      safetyViewModel: locator<RoutineSafetyViewModel>(param1: userId),
      userId: userId,
    ),
  );
}
