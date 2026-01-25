import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:adhd_supplement_app/presentation/views/quick_setup_wizard_screen.dart';

import 'package:adhd_supplement_app/domain/repositories/settings_repository.dart';
import 'package:adhd_supplement_app/infrastructure/services/notification_service.dart';
import 'package:adhd_supplement_app/config/locator.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    if (locator.isRegistered<SettingsRepository>()) {
      locator.reset();
    }
    locator.registerLazySingleton<SettingsRepository>(
        () => FakeSettingsRepository());
  });

  tearDown(() {
    locator.reset();
  });
  testWidgets('QuickSetupWizardScreen renders initial step',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: QuickSetupWizardScreen(),
    ));

    // Initially shows Medical Disclaimer
    expect(find.text('Medical Disclaimer'), findsOneWidget);
    expect(find.byType(Checkbox), findsOneWidget);

    // Accept disclaimer
    final checkbox = find.byType(Checkbox);
    await tester.ensureVisible(checkbox);
    await tester.tap(checkbox);
    await tester.pumpAndSettle();

    // Tap Next
    final nextButton = find.text('Next');
    await tester.ensureVisible(nextButton);
    await tester.tap(nextButton);
    await tester.pumpAndSettle();

    // Verify Step 1 content
    expect(find.text('Quick Setup'), findsOneWidget);
    expect(find.text('What\'s your main goal?'), findsOneWidget);

    // Verify Goal options
    expect(find.text('Mental Clarity'), findsOneWidget);
    expect(find.text('Better Sleep'), findsOneWidget);
    expect(find.text('Energy Boost'), findsOneWidget);
  });

  testWidgets('Navigation through steps works', (WidgetTester tester) async {
    // Set a larger surface size to avoid scrolling issues
    tester.view.physicalSize = const Size(800, 1200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(const MaterialApp(
      home: QuickSetupWizardScreen(),
    ));

    // Accept disclaimer
    final checkbox = find.byType(Checkbox);
    await tester.ensureVisible(checkbox);
    await tester.tap(checkbox);
    await tester.pumpAndSettle();

    final nextButton = find.text('Next');
    await tester.ensureVisible(nextButton);
    await tester.tap(nextButton);
    await tester.pumpAndSettle();

    // Select a goal
    final goalOption = find.text('Mental Clarity');
    await tester.ensureVisible(goalOption);
    await tester.tap(goalOption);
    await tester.pumpAndSettle();

    // Tap Next
    await tester.ensureVisible(nextButton);
    await tester.tap(nextButton);
    await tester.pumpAndSettle();

    // Verify Step 2 (Stack Selection)
    expect(find.text('Choose a starter stack'), findsOneWidget);
    expect(find.text('Focus Stack'), findsOneWidget);

    final fogLifter = find.text('Morning Fog Lifter');
    expect(fogLifter, findsOneWidget);
    expect(find.text('Vitamin D, Tyrosine, Alpha-GPC'), findsOneWidget);

    // Select Morning Fog Lifter
    await tester.tap(fogLifter);
    await tester.pumpAndSettle();

    // Tap Next to go to confirmation
    final nextButtonAgain = find.text('Next');
    await tester.tap(nextButtonAgain);
    await tester.pumpAndSettle();

    // Verify confirmation screen
    expect(find.text('You\'re all set!'), findsOneWidget);
    expect(find.textContaining('Your Morning Fog Lifter is ready'),
        findsOneWidget);
  });
}

class FakeSettingsRepository implements SettingsRepository {
  @override
  Future<void> setAcceptedDisclaimer(bool accepted) async {}
  @override
  bool hasAcceptedDisclaimer() => false;
  @override
  Future<void> init() async {}
  @override
  bool getNudgeModeEnabled() => true;
  @override
  Future<void> setNudgeModeEnabled(bool enabled) async {}

  @override
  NotificationMode getNotificationMode() => NotificationMode.gentle;

  @override
  Future<void> setNotificationMode(NotificationMode mode) async {}

  @override
  TimeOfDay getNudgeTime() => const TimeOfDay(hour: 8, minute: 0);
  @override
  Future<void> setNudgeTime(TimeOfDay time) async {}
  @override
  TimeOfDay getSlotTime(String slot) => const TimeOfDay(hour: 8, minute: 0);
  @override
  Future<void> setSlotTime(String slot, TimeOfDay time) async {}
  @override
  String getWarningNudgeOption() => '15m';
  @override
  Future<void> setWarningNudgeOption(String option) async {}
  @override
  bool getReducedMotionEnabled() => false;
  @override
  Future<void> setReducedMotionEnabled(bool enabled) async {}
  @override
  bool getHapticFeedbackEnabled() => true;
  @override
  Future<void> setHapticFeedbackEnabled(bool enabled) async {}
  @override
  double getFontSizeScale() => 1.0;
  @override
  Future<void> setFontSizeScale(double scale) async {}
  @override
  bool getExtendedRemindersEnabled() => true;
  @override
  Future<void> setExtendedRemindersEnabled(bool enabled) async {}
  @override
  bool getBiometricLockEnabled() => false;
  @override
  Future<void> setBiometricLockEnabled(bool enabled) async {}
  @override
  bool getLocalStorageOnly() => false;
  @override
  Future<void> setLocalStorageOnly(bool enabled) async {}
  @override
  bool getAnalyticsEnabled() => true;
  @override
  Future<void> setAnalyticsEnabled(bool enabled) async {}
  @override
  bool getCrashReportingEnabled() => true;
  @override
  Future<void> setCrashReportingEnabled(bool enabled) async {}
  @override
  ThemeMode getThemeMode() => ThemeMode.system;
  @override
  Future<void> setThemeMode(ThemeMode mode) async {}

  @override
  bool getSoundsEnabled() => true;

  @override
  Future<void> setSoundsEnabled(bool enabled) async {}
}
