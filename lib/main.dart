import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:provider/provider.dart';
import 'config/locator.dart';
import 'presentation/theme/app_theme.dart';
import 'presentation/navigation/app_router.dart';
import 'application/providers/auth_provider.dart';
import 'application/view_models/supplement_view_model.dart';
import 'application/view_models/safety_view_model.dart';
import 'application/view_models/persistent_reminders_view_model.dart';
import 'presentation/navigation/auth_wrapper.dart';
import 'firebase_options.dart';
import 'domain/repositories/settings_repository.dart';
import 'infrastructure/services/notification_service.dart';
import 'infrastructure/services/seeding_service.dart';
import 'domain/repositories/supplement_repository.dart';
import 'application/view_models/theme_view_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase with error handling
  try {
    // Note: On web, this requires firebase_options.dart or manual configuration
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    ).timeout(const Duration(seconds: 10));
    debugPrint('Firebase initialized successfully');

    // Initialize Crashlytics (disabled in debug mode)
    if (!kDebugMode) {
      FlutterError.onError =
          FirebaseCrashlytics.instance.recordFlutterFatalError;
      // Pass all uncaught asynchronous errors to Crashlytics
      PlatformDispatcher.instance.onError = (error, stack) {
        FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
        return true;
      };
    }
  } catch (e) {
    debugPrint('Firebase initialization error: $e');
    // We continue so the app can at least show the UI in dev mode
  }

  // Setup Dependency Injection
  try {
    setupLocator();
    // Initialize Settings
    await locator<SettingsRepository>()
        .init()
        .timeout(const Duration(seconds: 5));
    // Initialize Notifications
    await locator<NotificationService>().init();

    // RE-ADDED: Run Seeding Script with Timeout to prevent hang
    debugPrint('Running Seeding Script...');
    try {
      await locator<SeedingService>()
          .seedSupplements()
          .timeout(const Duration(seconds: 10));
      debugPrint('Seeding Script Completed.');

      // Background Pre-fetch: Load supplements into cache immediately
      // We don't await this so it doesn't block startup
      locator<SupplementRepository>()
          .getAllSupplements()
          .then((_) => debugPrint('Background pre-fetch complete'))
          .catchError((Object e) =>
              debugPrint('Background pre-fetch failed (ignored): $e'));
    } catch (e) {
      debugPrint('Seeding/Pre-fetch timed out or failed (likely offline): $e');
    }
  } catch (e) {
    debugPrint('Locator/Init setup error: $e');
  }

  runApp(const AdhdSupplementApp());
}

class AdhdSupplementApp extends StatelessWidget {
  const AdhdSupplementApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => locator<SupplementViewModel>()),
        ChangeNotifierProvider(create: (_) => locator<AuthProvider>()),
        ChangeNotifierProxyProvider<AuthProvider, SafetyViewModel>(
          create: (_) => locator<SafetyViewModel>(param1: ''),
          update: (_, auth, previous) =>
              locator<SafetyViewModel>(param1: auth.user?.id ?? ''),
        ),
        ChangeNotifierProvider(
            create: (_) => locator<PersistentRemindersViewModel>()),
        ChangeNotifierProvider(create: (_) => locator<ThemeViewModel>()),
      ],
      child: Consumer<ThemeViewModel>(
        builder: (context, themeVM, _) => MaterialApp(
          title: 'Daily Stack',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeVM.themeMode,
          debugShowCheckedModeBanner: false,
          home: const AuthWrapper(),
          onGenerateRoute: AppRouter.generateRoute,
        ),
      ),
    );
  }
}
