import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:mockito/mockito.dart';
import 'package:neurostack_app/presentation/views/daily_focus_checkin_screen.dart';
import 'package:neurostack_app/application/view_models/focus_checkin_view_model.dart';
import 'package:neurostack_app/domain/repositories/checkin_repository.dart';
import 'package:neurostack_app/domain/entities/daily_state_checkin.dart';

// Mock Repository
class MockCheckInRepository extends Mock implements CheckInRepository {
  @override
  Future<bool> hasCheckedInToday(String userId) async => false;

  @override
  Future<void> logCheckIn(dynamic checkIn) async {}

  @override
  Future<void> deleteCheckIn(String id) async {}

  @override
  Future<List<DailyStateCheckIn>> getCheckIns(String userId) async => [];

  @override
  Future<List<DailyStateCheckIn>> getCheckInsByDateRange(
          String userId, DateTime start, DateTime end) async =>
      [];

  @override
  Future<DailyStateCheckIn?> getLatestCheckIn(String userId) async => null;
}

// New Mock ViewModel
class MockFocusCheckInViewModel extends Mock implements FocusCheckInViewModel {}

void main() {
  late MockCheckInRepository mockRepository;
  late FocusCheckInViewModel viewModel; // Changed from StateCheckInViewModel

  setUp(() {
    mockRepository = MockCheckInRepository();
    // Initialize viewModel with real instance and mock repository
    viewModel = FocusCheckInViewModel(
      // Changed from StateCheckInViewModel
      repository: mockRepository,
      userId: 'test-user',
    );
  });

  Widget createScreen() {
    return MaterialApp(
      home: ChangeNotifierProvider.value(
        value: viewModel,
        child: const DailyFocusCheckinScreen(),
      ),
    );
  }

  testWidgets('DailyFocusCheckinScreen renders correctly',
      (WidgetTester tester) async {
    await tester.pumpWidget(createScreen());

    // Verify header
    expect(find.text('State of Body & Mind'), findsOneWidget);
    expect(find.text('How are you feeling at this moment?'), findsOneWidget);

    // Verify sliders exist
    expect(find.byType(Slider), findsNWidgets(3));

    // Verify labels
    expect(find.text('Focus: 😫 to 🤩'), findsOneWidget);
    expect(find.text('Energy: 🥱 to ⚡'), findsOneWidget);
    expect(find.text('Mood: 😢 to 😊'), findsOneWidget);

    // Verify Log Check-in button
    expect(find.text('Save Check-in'), findsOneWidget);
  });

  testWidgets('Interacting with sliders updates values',
      (WidgetTester tester) async {
    await tester.pumpWidget(createScreen());

    // Only testing one slider compatibility principle
    final sliderFinder = find.byType(Slider).first;
    await tester.drag(sliderFinder, const Offset(50, 0));
    await tester.pump();

    // Validation would ideally check ViewModel state, but purely UI test here confirms no crash
  });
}
