import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:adhd_supplement_app/config/locator.dart';
import 'package:adhd_supplement_app/presentation/views/insights_screen.dart';
import 'package:adhd_supplement_app/presentation/views/science_hub_screen.dart';
import 'package:adhd_supplement_app/application/view_models/science_hub_view_model.dart';
import 'package:adhd_supplement_app/presentation/widgets/unified_bottom_nav.dart';
import 'package:adhd_supplement_app/domain/entities/article.dart';

class MockScienceHubViewModel extends ChangeNotifier
    implements ScienceHubViewModel {
  @override
  bool get isLoading => false;
  @override
  String? get error => null;
  @override
  Article? get articleOfTheDay => null;
  @override
  List<Article> get articles => [];
  @override
  Future<void> loadData() async {}
}

class MockInsightsViewModel extends ChangeNotifier {
  int get streakCount => 7;
  double get dailyProgress => 0.85;
  double get consistencyRate => 0.85;
  List<dynamic> get weeklyStats => [];
}

void main() {
  setUp(() {
    locator.reset();
    locator
        .registerFactory<ScienceHubViewModel>(() => MockScienceHubViewModel());
  });

  testWidgets('InsightsScreen renders and has correct bottom nav index',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: ChangeNotifierProvider<MockInsightsViewModel>(
          create: (_) => MockInsightsViewModel(),
          child: const InsightsScreen(),
        ),
      ),
    );
    await tester.pump();

    final navFinder = find.byType(UnifiedBottomNav);
    expect(navFinder, findsOneWidget);

    final nav = tester.widget<UnifiedBottomNav>(navFinder);
    expect(nav.currentIndex, 4); // Insights is now part of Profile
  });

  testWidgets('ScienceHubScreen renders without crashing',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: ScienceHubScreen(),
      ),
    );
    await tester.pump();
    expect(find.byType(Scaffold), findsOneWidget);
  });
}
