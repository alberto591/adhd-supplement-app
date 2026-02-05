import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:neurostack_app/presentation/widgets/skeleton_loader.dart';
import 'package:provider/provider.dart';
import 'package:neurostack_app/application/view_models/theme_view_model.dart';
import 'package:neurostack_app/domain/repositories/settings_repository.dart';

class _FakeSettingsRepository extends Fake implements SettingsRepository {
  @override
  ThemeMode getThemeMode() => ThemeMode.light;
  @override
  bool getReducedMotionEnabled() => false;
  @override
  bool getHapticFeedbackEnabled() => true;
  @override
  double getFontSizeScale() => 1.0;
}

void main() {
  testWidgets('SkeletonLoader renders correctly', (WidgetTester tester) async {
    // Build the widget
    final fakeSettings = _FakeSettingsRepository();
    final themeViewModel = ThemeViewModel(fakeSettings);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ChangeNotifierProvider<ThemeViewModel>.value(
            value: themeViewModel,
            child: const SkeletonLoader(
              width: 100,
              height: 20,
              borderRadius: 8,
            ),
          ),
        ),
      ),
    );

    // Verify it exists in the tree
    expect(find.byType(SkeletonLoader), findsOneWidget);
    expect(find.byType(Container), findsOneWidget);

    // Verify dimensions (indirectly via layout if needed, but existence is good for now)
  });

  testWidgets('SkeletonLoader animates', (WidgetTester tester) async {
    final fakeSettings = _FakeSettingsRepository();
    final themeViewModel = ThemeViewModel(fakeSettings);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ChangeNotifierProvider<ThemeViewModel>.value(
            value: themeViewModel,
            child: const SkeletonLoader(width: 100, height: 20),
          ),
        ),
      ),
    );

    // Advance time to verify ticker doesn't crash
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pump(const Duration(milliseconds: 500));
  });
}
