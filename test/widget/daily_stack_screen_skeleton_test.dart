import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:neurostack_app/presentation/views/daily_stack_screen.dart';
import 'package:neurostack_app/presentation/view_models/daily_stack_view_model.dart';
import 'package:neurostack_app/application/view_models/routine_safety_view_model.dart';
import 'package:mockito/mockito.dart';
import 'package:neurostack_app/config/locator.dart';
import '../test_helper.dart';

import 'package:neurostack_app/domain/entities/supplement_stack.dart';

// Mock replacements for complex ViewModels
class MockDailyStackViewModel extends Mock implements DailyStackViewModel {
  @override
  bool get isLoading => true;
  @override
  String? get error => null;
  @override
  List<SupplementStack> get stacks => [];

  @override
  Future<void> initialize() async {}
  @override
  void dispose() {}
  @override
  void addListener(VoidCallback listener) {}
  @override
  void removeListener(VoidCallback listener) {}
}

class MockRoutineSafetyViewModel extends Mock
    implements RoutineSafetyViewModel {
  @override
  Future<void> checkCompatibilitys(List<String> supplementIds) async {}

  @override
  void dispose() {}
  @override
  void addListener(VoidCallback listener) {}
  @override
  void removeListener(VoidCallback listener) {}
}

void main() {
  setUp(() {
    setupTestLocator(() {
      locator.registerFactoryParam<DailyStackViewModel, String, void>(
        (userId, _) => MockDailyStackViewModel(),
      );
      locator.registerFactoryParam<RoutineSafetyViewModel, String, void>(
        (userId, _) => MockRoutineSafetyViewModel(),
      );
    });
  });

  testWidgets('DailyStackScreen shows scrollable skeleton when loading',
      (WidgetTester tester) async {
    // Set screen size to small device (iPhone SE)
    tester.view.physicalSize = const Size(750, 1334);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      createTestableWidget(
        child: const DailyStackScreen(),
      ),
    );

    // Allow InitState to run
    await tester.pump();

    // Verify loading state is shown (Mock returns isLoading = true)
    // The skeleton structure uses SingleChildScrollView now
    expect(find.byType(SingleChildScrollView), findsAtLeastNWidgets(1));

    // Verify no overflow errors
    expect(tester.takeException(), isNull);
  });
}
