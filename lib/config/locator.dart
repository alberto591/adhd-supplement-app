import 'package:get_it/get_it.dart';

import 'package:adhd_supplement_app/application/view_models/supplement_view_model.dart';
import 'package:adhd_supplement_app/application/providers/auth_provider.dart';
import 'package:adhd_supplement_app/domain/repositories/supplement_repository.dart';
import 'package:adhd_supplement_app/domain/repositories/auth_repository.dart';
import 'package:adhd_supplement_app/domain/repositories/stack_repository.dart';
import 'package:adhd_supplement_app/domain/repositories/log_repository.dart';
import 'package:adhd_supplement_app/infrastructure/repositories/firebase_supplement_repository.dart';
import 'package:adhd_supplement_app/infrastructure/repositories/firebase_auth_repository.dart';
import 'package:adhd_supplement_app/infrastructure/repositories/firebase_stack_repository.dart';
import 'package:adhd_supplement_app/infrastructure/repositories/firebase_log_repository.dart';
import 'package:adhd_supplement_app/infrastructure/services/url_service.dart';
import 'package:adhd_supplement_app/presentation/view_models/daily_stack_view_model.dart';
import 'package:adhd_supplement_app/presentation/view_models/library_view_model.dart';
import 'package:adhd_supplement_app/presentation/view_models/library_view_model.dart';
import 'package:adhd_supplement_app/presentation/view_models/history_log_view_model.dart';
import 'package:adhd_supplement_app/domain/repositories/symptom_repository.dart';
import 'package:adhd_supplement_app/infrastructure/repositories/firebase_symptom_repository.dart';
import 'package:adhd_supplement_app/domain/repositories/safety_repository.dart';
import 'package:adhd_supplement_app/infrastructure/repositories/firebase_safety_repository.dart';
import 'package:adhd_supplement_app/application/view_models/safety_view_model.dart';
import 'package:adhd_supplement_app/application/view_models/symptom_checkin_viewmodel.dart';
import 'package:adhd_supplement_app/application/view_models/subscription_view_model.dart';
import 'package:adhd_supplement_app/application/view_models/privacy_view_model.dart';
import 'package:adhd_supplement_app/application/view_models/notification_history_view_model.dart';

final locator = GetIt.instance;

void setupLocator() {
  // Services
  locator.registerLazySingleton<BillingService>(() => MockBillingService());
  locator.registerLazySingleton<UrlService>(() => UrlService());

  // Repositories
  locator.registerLazySingleton<SupplementRepository>(
      () => FirebaseSupplementRepository());
  locator.registerLazySingleton<AuthRepository>(() => FirebaseAuthRepository());
  locator
      .registerLazySingleton<StackRepository>(() => FirebaseStackRepository());
  locator.registerLazySingleton<LogRepository>(() => FirebaseLogRepository());
  locator.registerLazySingleton<SymptomRepository>(
      () => FirebaseSymptomRepository());
  locator.registerLazySingleton<SafetyRepository>(
      () => FirebaseSafetyRepository());

  // Providers
  locator.registerLazySingleton(() => AuthProvider(locator<AuthRepository>()));

  // ViewModels
  locator.registerFactory(() => SupplementViewModel(
        locator<SupplementRepository>(),
        locator<UrlService>(),
      ));

  // New ViewModels - require userId from AuthProvider at runtime
  // These are factory functions that take userId parameter
  locator.registerFactoryParam<DailyStackViewModel, String, void>(
    (userId, _) => DailyStackViewModel(
      stackRepository: locator<StackRepository>(),
      logRepository: locator<LogRepository>(),
      supplementRepository: locator<SupplementRepository>(),
      userId: userId,
    ),
  );

  locator.registerFactory(() => LibraryViewModel(
        supplementRepository: locator<SupplementRepository>(),
      ));

  locator.registerFactory(() => SubscriptionViewModel());
  locator.registerFactory(() => PrivacyViewModel());
  locator.registerFactory(() => NotificationHistoryViewModel());

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
}
