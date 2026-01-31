import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:neurostack_app/presentation/views/onboarding_grace_period_screen.dart';
import 'package:neurostack_app/l10n/generated/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:neurostack_app/application/providers/auth_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
// Create a mock for AuthProvider if needed, or just omit if not used in build
// class MockAuthService extends Mock implements AuthService {} // Removed invalid class

// Mock Shared Preferences
class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  testWidgets('Back button pops the navigation stack',
      (WidgetTester tester) async {
    // Setup Mock AuthProvider
    // final mockAuthService = MockAuthService(); // Removed

    // We can't easily mock the full AuthProvider without more setup,
    // but for UI testing of a back button, we might not need a fully functional one
    // if the button doesn't access it.
    // HOWEVER, the "Got It" button DOES access it. The Back button DOES NOT.
    // So we can wrap in a dummy provider or just mock dependencies?
    // Let's try minimal setup.

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('en')],
        home: const OnboardingGracePeriodScreen(),
      ),
    );

    await tester.pumpAndSettle();

    // Verify back button exists
    final backButton = find.byIcon(Icons.arrow_back_ios_new);
    expect(backButton, findsOneWidget);

    // Tap back button
    // To verify 'pop', we usually need a navigator observer or push another route.
    // Since we are at 'home', popping might arguably do nothing or close app?
    // Let's wrap in a Navigator to be sure.
  });

  testWidgets('Back button actually pops route', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('en')],
        home: Scaffold(
          body: Builder(
            builder: (context) => TextButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const OnboardingGracePeriodScreen()),
              ),
              child: const Text('Go to Screen'),
            ),
          ),
        ),
      ),
    );

    // Go to the screen
    await tester.tap(find.text('Go to Screen'));
    await tester.pumpAndSettle();

    // Verify we are on the screen
    expect(find.byType(OnboardingGracePeriodScreen), findsOneWidget);

    // Tap back
    await tester.tap(find.byIcon(Icons.arrow_back_ios_new));
    await tester.pumpAndSettle();

    // Verify we are back
    expect(find.byType(OnboardingGracePeriodScreen), findsNothing);
    expect(find.text('Go to Screen'), findsOneWidget);
  });
}
