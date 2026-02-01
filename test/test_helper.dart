import 'package:flutter/material.dart';
import 'package:neurostack_app/config/locator.dart';
import 'package:neurostack_app/application/providers/auth_provider.dart';
import 'package:neurostack_app/l10n/generated/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:mockito/mockito.dart';

/// Standard wrapper for widget tests that provides localization, navigation,
/// and common providers.
Widget createTestableWidget({
  required Widget child,
  List<SingleChildWidget>? providers,
}) {
  return MultiProvider(
    providers: providers ??
        [
          // Default Mock AuthProvider if none provided
          ChangeNotifierProvider<AuthProvider>(
            create: (_) => MockAuthProvider(),
          ),
        ],
    child: MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en')],
      home: child,
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

  // Add other common getters as needed
}
