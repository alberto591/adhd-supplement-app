import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:get_it/get_it.dart';
import 'package:adhd_supplement_app/presentation/views/splash_screen.dart';
import 'package:adhd_supplement_app/domain/repositories/settings_repository.dart';
import 'package:adhd_supplement_app/infrastructure/services/notification_service.dart';
import 'package:adhd_supplement_app/infrastructure/services/seeding_service.dart';
import 'package:adhd_supplement_app/domain/repositories/supplement_repository.dart';
import 'package:adhd_supplement_app/domain/entities/supplement.dart';
import 'package:adhd_supplement_app/presentation/navigation/app_router.dart';

// Mocks
class MockSettingsRepository extends Mock implements SettingsRepository {
  @override
  Future<void> init() async => Future.value();
}

class MockNotificationService extends Mock implements NotificationService {
  @override
  Future<void> init() async => Future.value();
}

class MockSeedingService extends Mock implements SeedingService {
  @override
  Future<void> seedSupplements() async => Future.value();
}

class MockSupplementRepository extends Mock implements SupplementRepository {
  @override
  Future<List<Supplement>> getAllSupplements() async => [];
}

void main() {
  final locator = GetIt.instance;

  setUp(() {
    locator.reset();
    locator.registerSingleton<SettingsRepository>(MockSettingsRepository());
    locator.registerSingleton<NotificationService>(MockNotificationService());
    locator.registerSingleton<SeedingService>(MockSeedingService());
    locator.registerSingleton<SupplementRepository>(MockSupplementRepository());
  });

  tearDown(() {
    locator.reset();
  });

  testWidgets('SplashScreen initializes services and navigates',
      (WidgetTester tester) async {
    // Build SplashScreen wrapped in MaterialApp to handle navigation
    await tester.pumpWidget(
      MaterialApp(
        initialRoute: AppRouter.splash,
        onGenerateRoute: (settings) {
          debugPrint('DEBUG: Generated route for ${settings.name}');
          if (settings.name == AppRouter.home) {
            return MaterialPageRoute(
                builder: (_) => const Scaffold(body: Text('Home Screen')));
          }
          if (settings.name == AppRouter.splash) {
            return MaterialPageRoute(
                builder: (_) => const SplashScreen(isFirebaseReady: true));
          }
          return null;
        },
      ),
    );

    // Verify initial state
    expect(
        find.byType(CircularProgressIndicator), findsNothing); // We used Linear
    expect(find.byType(LinearProgressIndicator), findsOneWidget);
    expect(find.text('Loading preferences...'), findsOneWidget);

    // Pump to flush microtasks (init calls)
    await tester.pump(const Duration(milliseconds: 100)); // Short pump

    // Should be at specific step now (Settings done, Notifications done, Seeding started)
    // "Checking supplements..."
    // Note: depending on microtask scheduling, it might be fast.

    await tester.pump(const Duration(milliseconds: 100));
    expect(find.text('Checking supplements...'), findsOneWidget);

    // Wait for the specific delay in SplashScreen (1500ms)
    // We already pumped 200ms. Pump remaining + buffer.
    await tester.pump(const Duration(milliseconds: 3000));

    // Allow navigation to start
    await tester.pump();
    // Allow navigation transition to complete
    await tester.pump(const Duration(milliseconds: 800));

    expect(find.text('Home Screen'), findsOneWidget);
  });
}
