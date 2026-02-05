import 'package:flutter/material.dart';
import 'package:neurostack_app/config/locator.dart';
import 'package:neurostack_app/application/providers/auth_provider.dart';
import 'package:neurostack_app/l10n/generated/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:mockito/mockito.dart';
import 'package:neurostack_app/application/view_models/theme_view_model.dart';

/// Standard wrapper for widget tests that provides localization, navigation,
/// and common providers.
Widget createTestableWidget({
  required Widget child,
  List<SingleChildWidget>? providers,
  Route<dynamic>? Function(RouteSettings)? onGenerateRoute,
  String? initialRoute,
}) {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider<ThemeViewModel>(
        create: (_) => locator.isRegistered<ThemeViewModel>()
            ? locator<ThemeViewModel>()
            : MockThemeViewModel(),
      ),
      if (providers != null)
        ...providers
      else ...[
        ChangeNotifierProvider<AuthProvider>(
          create: (_) => MockAuthProvider(),
        ),
      ],
    ],
    child: MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en')],
      home: initialRoute == null ? child : null,
      initialRoute: initialRoute,
      onGenerateRoute: onGenerateRoute,
    ),
  );
}

/// Helper to reset and prepare the locator for a widget test.
void setupTestLocator(void Function() registerMocks) {
  locator.allowReassignment = true;
  registerMocks();
}

/// Common Mock for AuthProvider used across tests.
class MockAuthProvider extends Mock implements AuthProvider {
  @override
  bool get isAuthenticated => true;

  @override
  AuthStatus get status => AuthStatus.authenticated;

  // Add other common getters as needed
}

/// Common Mock for ThemeViewModel used across tests.
class MockThemeViewModel extends Mock implements ThemeViewModel {
  @override
  bool get reducedMotion => false;

  @override
  double get fontScale => 1.0;

  @override
  ThemeMode get themeMode => ThemeMode.light;

  @override
  bool get isDarkMode => false;

  @override
  bool get hapticEnabled => true;

  @override
  bool get soundsEnabled => true;

  @override
  void addListener(VoidCallback listener) {}

  @override
  void removeListener(VoidCallback listener) {}
}
