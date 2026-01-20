import 'package:get_it/get_it.dart';

import 'package:adhd_supplement_app/application/view_models/supplement_view_model.dart';
import 'package:adhd_supplement_app/application/providers/auth_provider.dart';
import 'package:adhd_supplement_app/domain/repositories/supplement_repository.dart';
import 'package:adhd_supplement_app/domain/repositories/auth_repository.dart';
import 'package:adhd_supplement_app/domain/repositories/stack_repository.dart';
import 'package:adhd_supplement_app/domain/repositories/log_repository.dart';

import 'package:adhd_supplement_app/infrastructure/repositories/firebase_stack_repository.dart';
import 'package:adhd_supplement_app/infrastructure/repositories/firebase_log_repository.dart';
import 'package:adhd_supplement_app/infrastructure/repositories/firebase_auth_repository.dart';
import 'package:adhd_supplement_app/infrastructure/repositories/firebase_safety_repository.dart';
import 'package:adhd_supplement_app/infrastructure/services/seeding_service.dart';
import 'package:adhd_supplement_app/infrastructure/services/perplexity_service.dart';
import 'package:adhd_supplement_app/infrastructure/repositories/perplexity_repository.dart';
import 'package:adhd_supplement_app/infrastructure/services/url_service.dart';
import 'package:adhd_supplement_app/domain/services/billing_service.dart';
import 'package:adhd_supplement_app/infrastructure/services/revenue_cat_billing_service.dart';
import 'package:adhd_supplement_app/domain/services/interaction_service.dart';
import 'package:adhd_supplement_app/infrastructure/services/fda_interaction_service.dart';
import 'package:adhd_supplement_app/infrastructure/services/report_pdf_service.dart';
import 'package:adhd_supplement_app/presentation/view_models/daily_stack_view_model.dart';

import 'package:adhd_supplement_app/presentation/view_models/history_log_view_model.dart';
import 'package:adhd_supplement_app/presentation/view_models/library_view_model.dart';
import 'package:adhd_supplement_app/domain/repositories/symptom_repository.dart';

// import 'package:adhd_supplement_app/infrastructure/repositories/firebase_symptom_repository.dart'; // Unused
import 'package:adhd_supplement_app/infrastructure/repositories/mock_symptom_repository.dart';
import 'package:adhd_supplement_app/infrastructure/repositories/firebase_supplement_repository.dart';
import 'package:adhd_supplement_app/infrastructure/repositories/firebase_streak_repository.dart';
import 'package:adhd_supplement_app/domain/repositories/safety_repository.dart';
import 'package:adhd_supplement_app/domain/repositories/streak_repository.dart';
import 'package:adhd_supplement_app/application/view_models/safety_view_model.dart';
import 'package:adhd_supplement_app/application/view_models/symptom_checkin_viewmodel.dart';
import 'package:adhd_supplement_app/application/view_models/subscription_view_model.dart';
import 'package:adhd_supplement_app/application/view_models/privacy_view_model.dart';
import 'package:adhd_supplement_app/application/view_models/notification_history_view_model.dart';
// import 'package:adhd_supplement_app/application/view_models/streak_view_model.dart'; // Unused
import 'package:adhd_supplement_app/infrastructure/services/streak_service.dart';
import 'package:adhd_supplement_app/infrastructure/services/notification_service.dart';
import 'package:adhd_supplement_app/domain/repositories/settings_repository.dart';
import 'package:adhd_supplement_app/infrastructure/repositories/shared_prefs_settings_repository.dart';
import 'package:adhd_supplement_app/application/view_models/persistent_reminders_view_model.dart';
import 'package:adhd_supplement_app/application/view_models/focus_buddies_view_model.dart';
import 'package:adhd_supplement_app/application/view_models/trophy_room_view_model.dart';
import 'package:adhd_supplement_app/domain/repositories/gamification_repository.dart';
import 'package:adhd_supplement_app/infrastructure/repositories/mock_gamification_repository.dart';
import '../application/view_models/article_detail_view_model.dart';
import '../application/view_models/science_hub_view_model.dart';
import '../application/view_models/community_view_model.dart';
import '../application/view_models/pill_matcher_view_model.dart';
import '../domain/repositories/article_repository.dart';
import '../domain/repositories/community_repository.dart';
import '../infrastructure/repositories/mock_article_repository.dart';
import '../infrastructure/repositories/mock_community_repository.dart';
import '../domain/repositories/referral_repository.dart';
import '../infrastructure/repositories/mock_referral_repository.dart';
// import '../application/view_models/refer_friend_view_model.dart'; // Duplicate
import '../domain/repositories/reflection_repository.dart';
import '../infrastructure/repositories/mock_reflection_repository.dart';
// import '../application/view_models/nightly_reflection_view_model.dart'; // Duplicate

import '../application/view_models/refer_friend_view_model.dart';
import '../application/view_models/nightly_reflection_view_model.dart';
import '../application/view_models/doctor_export_view_model.dart';

final locator = GetIt.instance;

void setupLocator() {
  // Services
  locator
      .registerLazySingleton<BillingService>(() => RevenueCatBillingService());
  locator.registerLazySingleton<UrlService>(() => UrlService());
  locator
      .registerLazySingleton<NotificationService>(() => NotificationService());
  locator.registerLazySingleton<StreakService>(() => StreakService());

  locator
      .registerLazySingleton<InteractionService>(() => FDAInteractionService());
  locator.registerLazySingleton<ReportPdfService>(() => ReportPdfService());

  // Repositories
  locator.registerLazySingleton<SupplementRepository>(
      () => FirebaseSupplementRepository());
  locator.registerLazySingleton<PerplexityService>(() => PerplexityService());
  locator.registerLazySingleton<PerplexityRepository>(
      () => PerplexityRepositoryImpl(locator<PerplexityService>()));
  locator
      .registerLazySingleton<StackRepository>(() => FirebaseStackRepository());
  locator.registerLazySingleton<AuthRepository>(() => FirebaseAuthRepository());
  locator.registerLazySingleton<StreakRepository>(
      () => FirebaseStreakRepository());

  locator.registerLazySingleton<LogRepository>(() => FirebaseLogRepository());
  locator
      .registerLazySingleton<SymptomRepository>(() => MockSymptomRepository());
  locator.registerLazySingleton<GamificationRepository>(
      () => MockGamificationRepository());
  locator.registerLazySingleton<CommunityRepository>(
      () => MockCommunityRepository());
  locator.registerLazySingleton<SafetyRepository>(
      () => FirebaseSafetyRepository());
  locator.registerLazySingleton<SettingsRepository>(
      () => SharedPrefsSettingsRepository());
  locator.registerLazySingleton<ReferralRepository>(
      () => MockReferralRepository());
  locator.registerLazySingleton<ReflectionRepository>(
      () => MockReflectionRepository());

  // Providers
  locator.registerLazySingleton(() => AuthProvider(locator<AuthRepository>()));

  // ViewModels
  locator.registerFactory(() => SupplementViewModel(
        locator<SupplementRepository>(),
        locator<UrlService>(),
      ));

  locator.registerFactory(() => PersistentRemindersViewModel(
        locator<SettingsRepository>(),
        locator<NotificationService>(),
      ));

  // New ViewModels - require userId from AuthProvider at runtime
  // These are factory functions that take userId parameter
  locator.registerFactoryParam<DailyStackViewModel, String, void>(
    (userId, _) => DailyStackViewModel(
      stackRepository: locator<StackRepository>(),
      logRepository: locator<LogRepository>(),
      supplementRepository: locator<SupplementRepository>(),
      notificationService: locator<NotificationService>(),
      authRepository: locator<AuthRepository>(),
      userId: userId,
    ),
  );

  locator.registerFactory(() => LibraryViewModel(
        supplementRepository: locator<SupplementRepository>(),
      ));

  locator.registerFactory(() => SubscriptionViewModel());
  locator.registerFactory(
      () => CommunityViewModel(locator<CommunityRepository>()));
  locator.registerFactory(() => PillMatcherViewModel());
  locator.registerFactory(() => PrivacyViewModel());
  locator.registerFactory(() => NotificationHistoryViewModel());
  locator.registerFactory(() => FocusBuddiesViewModel(
      locator<AuthRepository>(), locator<LogRepository>()));

  locator.registerFactoryParam<TrophyRoomViewModel, String, void>(
    (userId, _) =>
        TrophyRoomViewModel(locator<GamificationRepository>(), userId),
  );

  locator.registerFactoryParam<HistoryLogViewModel, String, void>(
    (userId, _) => HistoryLogViewModel(
      logRepository: locator<LogRepository>(),
      userId: userId,
    ),
  );

  locator.registerFactoryParam<SymptomCheckInViewModel, String, void>(
    (userId, _) => SymptomCheckInViewModel(
      repository: locator<SymptomRepository>(),
      userId: userId,
    ),
  );

  locator.registerFactoryParam<SafetyViewModel, String, void>(
    (userId, _) => SafetyViewModel(
      repository: locator<SafetyRepository>(),
      userId: userId,
    ),
  );
  locator.registerLazySingleton<SeedingService>(() => SeedingService());
  locator
      .registerLazySingleton<ArticleRepository>(() => MockArticleRepository());

  locator.registerFactory(
      () => ArticleDetailViewModel(locator<ArticleRepository>()));
  locator
      .registerFactory(() => ScienceHubViewModel(locator<ArticleRepository>()));
  locator.registerFactory(
      () => ReferFriendViewModel(locator<ReferralRepository>()));
  locator.registerFactoryParam<NightlyReflectionViewModel, String, void>(
    (userId, _) => NightlyReflectionViewModel(
      logRepository: locator<LogRepository>(),
      userId: userId,
    ),
  );

  locator.registerFactoryParam<DoctorExportViewModel, String, void>(
    (userId, _) => DoctorExportViewModel(
      logRepository: locator<LogRepository>(),
      authRepository: locator<AuthRepository>(),
      pdfService: locator<ReportPdfService>(),
      userId: userId,
    ),
  );
}
