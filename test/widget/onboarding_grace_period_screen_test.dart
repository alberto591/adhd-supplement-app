import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:neurostack_app/presentation/views/onboarding_grace_period_screen.dart';
import '../test_helper.dart';

void main() {
  testWidgets('Back button pops the navigation stack',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      createTestableWidget(
        child: const OnboardingGracePeriodScreen(),
      ),
    );

    await tester.pumpAndSettle();

    // Verify back button exists
    final backButton = find.byIcon(Icons.arrow_back_ios_new);
    expect(backButton, findsOneWidget);
  });

  testWidgets('Back button actually pops route', (WidgetTester tester) async {
    await tester.pumpWidget(
      createTestableWidget(
        child: Builder(
          builder: (context) => TextButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute<void>(
                  builder: (context) => const OnboardingGracePeriodScreen()),
            ),
            child: const Text('Go to Screen'),
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
