import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:neurostack_app/presentation/views/onboarding_explainer_screen.dart';
import 'package:neurostack_app/l10n/generated/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  testWidgets(
      'OnboardingExplainerScreen renders without overflow on small screen',
      (WidgetTester tester) async {
    // Set screen size to iPhone SE dimensions (small device)
    tester.view.physicalSize = const Size(750, 1334);
    tester.view.devicePixelRatio = 2.0;

    // Reset view after test
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      const MaterialApp(
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [Locale('en')],
        home: OnboardingExplainerScreen(),
      ),
    );

    // Verify CustomScrollView is present
    expect(find.byType(CustomScrollView), findsOneWidget);

    // Verify basic content is present
    expect(find.text('Welcome to NeuroStack'), findsOneWidget);

    // Verify "Get Started" button is present (even if off-screen, it should be in tree)
    expect(find.text('Get Started'), findsOneWidget);

    // Scroll to see bottom elements
    await tester.drag(find.byType(CustomScrollView), const Offset(0, -500));
    await tester.pump();

    // Verify "I already have an account" is reachable
    expect(find.text('I already have an account'), findsOneWidget);
  });
}
