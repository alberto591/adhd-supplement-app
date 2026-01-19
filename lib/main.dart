import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'config/locator.dart';
import 'presentation/theme/app_theme.dart';
import 'presentation/navigation/app_router.dart';
import 'presentation/views/auth/login_screen.dart';
import 'application/providers/auth_provider.dart';
import 'application/view_models/supplement_view_model.dart';
import 'application/view_models/safety_view_model.dart';
import 'presentation/navigation/auth_wrapper.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase with error handling
  try {
    // Note: On web, this requires firebase_options.dart or manual configuration
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('Firebase initialized successfully');
  } catch (e) {
    print('Firebase initialization error: $e');
    // We continue so the app can at least show the UI in dev mode
  }

  // Setup Dependency Injection
  try {
    setupLocator();
  } catch (e) {
    print('Locator setup error: $e');
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
      ],
      child: MaterialApp(
        title: 'Daily Stack',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        debugShowCheckedModeBanner: false,
        // Start with login screen for now
        // TODO: Check auth state and redirect accordingly
        home: const AuthWrapper(),
        onGenerateRoute: AppRouter.generateRoute,
      ),
    );
  }
}
