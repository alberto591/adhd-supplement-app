import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase with error handling
  try {
    // Note: On web, this requires firebase_options.dart or manual configuration
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    debugPrint('Firebase initialized successfully');
  } catch (e) {
    debugPrint('Firebase initialization error: $e');
    // We continue so the app can at least show the UI in dev mode
  }

  // Setup Dependency Injection
  try {
    setupLocator();
    // Initialize Settings
    await locator<SettingsRepository>().init();
    // Initialize Notifications
    await locator<NotificationService>().init();
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
      ],
      child: MaterialApp(
        title: 'Daily Stack',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        debugShowCheckedModeBanner: false,
        // Start with login screen for now
        // Start with AuthWrapper to determine destination
        home: const AuthWrapper(),
        onGenerateRoute: AppRouter.generateRoute,
      ),
    );
  }
}
