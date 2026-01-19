// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:adhd_supplement_app/main.dart';
import 'package:adhd_supplement_app/config/locator.dart';
import 'package:adhd_supplement_app/application/providers/auth_provider.dart';
import 'package:adhd_supplement_app/application/view_models/safety_view_model.dart';
import 'package:adhd_supplement_app/application/view_models/supplement_view_model.dart';
import 'package:adhd_supplement_app/domain/entities/user.dart';
import 'package:adhd_supplement_app/domain/repositories/auth_repository.dart';
import 'package:adhd_supplement_app/domain/repositories/safety_repository.dart';
import 'package:adhd_supplement_app/domain/repositories/supplement_repository.dart';
import 'package:adhd_supplement_app/domain/entities/supplement.dart';
import 'package:adhd_supplement_app/domain/entities/supplement_interaction.dart';
import 'package:adhd_supplement_app/domain/entities/safety_override.dart';
import 'package:adhd_supplement_app/infrastructure/services/url_service.dart';

void main() {
  setUp(() {
    // Ensure GetIt has the minimal registrations needed for AdhdSupplementApp.build.
    locator.reset();

    locator.registerFactory<SupplementViewModel>(
      () => SupplementViewModel(_FakeSupplementRepository(), UrlService()),
    );

    locator.registerLazySingleton<AuthRepository>(() => _FakeAuthRepository());
    locator.registerFactory<AuthProvider>(
      () => AuthProvider(locator<AuthRepository>()),
    );

    locator.registerLazySingleton<SafetyRepository>(() => _FakeSafetyRepository());
    locator.registerFactoryParam<SafetyViewModel, String, void>(
      (userId, _) => SafetyViewModel(
        repository: locator<SafetyRepository>(),
        userId: userId,
      ),
    );
  });

  testWidgets('App builds (smoke test)', (WidgetTester tester) async {
    await tester.pumpWidget(const AdhdSupplementApp());
    await tester.pump();

    expect(find.byType(MaterialApp), findsOneWidget);
  });
}

class _FakeAuthRepository implements AuthRepository {
  @override
  Future<void> deleteUser() async {}

  @override
  Stream<User?> authStateChanges() => Stream<User?>.value(null);

  @override
  Future<User?> getCurrentUser() async => null;

  @override
  Future<User> signInAnonymously() async {
    return User(id: 'u1', email: 'test@example.com', createdAt: DateTime.now());
  }

  @override
  Future<User> signInWithEmail(String email, String password) async {
    return User(id: 'u1', email: email, createdAt: DateTime.now());
  }

  @override
  Future<User> signUpWithEmail(String email, String password, String displayName) async {
    return User(
      id: 'u1',
      email: email,
      displayName: displayName,
      createdAt: DateTime.now(),
    );
  }

  @override
  Future<void> signOut() async {}

  @override
  Future<void> updateUserProfile(User user) async {}
}

class _FakeSupplementRepository implements SupplementRepository {
  @override
  Future<List<Supplement>> getAllSupplements() async => [];

  @override
  Future<Supplement?> getSupplement(String id) async => null;

  @override
  Future<List<Supplement>> getSupplementsByCategory(String category) async => [];

  @override
  Future<List<Supplement>> searchSupplements(String query) async => [];

  @override
  Future<void> trackReferralClick(String supplementId) async {}

  @override
  Stream<List<Supplement>> watchSupplements() => const Stream.empty();
}

class _FakeSafetyRepository implements SafetyRepository {
  @override
  Future<List<SupplementInteraction>> getInteractionsForSupplements(
    List<String> supplementIds,
  ) async =>
      [];

  @override
  Future<void> logSafetyOverride(SafetyOverride override) async {}

  @override
  Future<List<SafetyOverride>> getSafetyOverrides(String userId) async => [];

  @override
  Future<SupplementInteraction?> getInteractionById(String id) async => null;
}
