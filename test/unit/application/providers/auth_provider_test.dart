import 'package:flutter_test/flutter_test.dart';
import 'package:adhd_supplement_app/application/providers/auth_provider.dart';
import 'package:adhd_supplement_app/domain/entities/user.dart';
import 'package:adhd_supplement_app/domain/repositories/auth_repository.dart';
import 'package:adhd_supplement_app/domain/services/billing_service.dart';
import 'package:adhd_supplement_app/domain/errors/failure.dart';
import 'dart:async';

class FakeAuthRepository implements AuthRepository {
  User? currentUser;
  Object? errorToThrow;
  final _authStateController = StreamController<User?>.broadcast();
  final _userSnapshotController = StreamController<User?>.broadcast();

  @override
  Future<User?> getCurrentUser() async => currentUser;

  @override
  Stream<User?> authStateChanges() => _authStateController.stream;

  @override
  Stream<User?> watchUser(String userId) => _userSnapshotController.stream;

  void emitAuthState(User? user) {
    currentUser = user;
    _authStateController.add(user);
  }

  void emitUserSnapshot(User? user) {
    currentUser = user;
    _userSnapshotController.add(user);
  }

  @override
  Future<User> signInWithEmail(String email, String password) async {
    if (errorToThrow != null) throw errorToThrow!;
    return currentUser!;
  }

  @override
  Future<User> signUpWithEmail(
      String email, String password, String displayName) async {
    if (errorToThrow != null) throw errorToThrow!;
    return currentUser!;
  }

  @override
  Future<void> signOut() async => emitAuthState(null);
  @override
  Future<void> updateUserProfile(User user) async => currentUser = user;
  @override
  Future<User> signInAnonymously() async => currentUser!;
  @override
  Future<void> deleteUser() async {}
  @override
  Future<void> sendPasswordResetEmail(String email) async {
    if (errorToThrow != null) throw errorToThrow!;
  }
}

class FakeBillingService implements BillingService {
  @override
  Future<bool> initialize() async => true;

  @override
  Future<bool> purchaseSubscription({required String planId}) async => true;

  @override
  Future<bool> restorePurchases() async => true;

  @override
  Future<bool> get isSubscribed async => false;

  @override
  Future<bool> hasEntitlement(String entitlementId) async => false;

  @override
  Future<List<String>> getEntitlements() async => [];

  @override
  Future<void> presentCustomerCenter() async {}
}

void main() {
  late AuthProvider authProvider;
  late FakeAuthRepository fakeAuthRepo;
  late FakeBillingService fakeBillingService;

  setUp(() {
    fakeAuthRepo = FakeAuthRepository();
    fakeBillingService = FakeBillingService();
    // AuthProvider starts initializing and listening in constructor
    authProvider = AuthProvider(fakeAuthRepo, fakeBillingService);
  });

  group('AuthProvider Tests', () {
    test('initial status is initial', () {
      expect(authProvider.status, AuthStatus.initial);
    });

    test('updates user and status when auth state changes', () async {
      final user = User(
        id: 'user1',
        email: 'test@test.com',
        createdAt: DateTime.now(),
        xp: 100,
      );

      fakeAuthRepo.emitAuthState(user);

      // Wait for stream listener to trigger
      await Future<void>.delayed(Duration.zero);

      expect(authProvider.user?.id, 'user1');
      expect(authProvider.status, AuthStatus.authenticated);
      expect(authProvider.isAuthenticated, true);
    });

    test('real-time profile syncing: updates XP when Firestore snapshot emits',
        () async {
      final user = User(
        id: 'user1',
        email: 'test@test.com',
        createdAt: DateTime.now(),
        xp: 100,
      );

      // 1. Initial login
      fakeAuthRepo.emitAuthState(user);
      await Future<void>.delayed(Duration.zero);
      expect(authProvider.user?.xp, 100);

      // 2. XP update in Firestore (triggers watchUser stream)
      final updatedUser = user.copyWith(xp: 150);
      fakeAuthRepo.emitUserSnapshot(updatedUser);

      await Future<void>.delayed(Duration.zero);

      // 3. AuthProvider should have updated its internal user
      expect(authProvider.user?.xp, 150);
    });

    test('clears user on sign out', () async {
      final user = User(
        id: 'user1',
        email: 'test@test.com',
        createdAt: DateTime.now(),
      );

      fakeAuthRepo.emitAuthState(user);
      await Future<void>.delayed(Duration.zero);
      expect(authProvider.isAuthenticated, true);

      await authProvider.signOut();
      await Future<void>.delayed(Duration.zero);

      expect(authProvider.user, isNull);
      expect(authProvider.status, AuthStatus.unauthenticated);
    });

    test('sets errorMessage when sign in fails with AuthFailure', () async {
      fakeAuthRepo.errorToThrow = const AuthFailure('Invalid credentials');

      try {
        await authProvider.signIn('test@test.com', 'wrongpassword');
      } catch (_) {
        // Expected to throw
      }

      expect(authProvider.status, AuthStatus.unauthenticated);
      expect(authProvider.errorMessage, 'Invalid credentials');
    });

    test('sets errorMessage using toString for non-Failure errors', () async {
      fakeAuthRepo.errorToThrow = Exception('Network error');

      try {
        await authProvider.signIn('test@test.com', 'password');
      } catch (_) {
        // Expected to throw
      }

      expect(authProvider.status, AuthStatus.unauthenticated);
      expect(authProvider.errorMessage, 'Exception: Network error');
    });

    test('sendPasswordResetEmail succeeds and clears error', () async {
      // Arrange
      fakeAuthRepo.errorToThrow = null;

      // Act
      await authProvider.sendPasswordResetEmail('test@test.com');

      // Assert
      expect(authProvider.errorMessage, isNull);
    });

    test('sendPasswordResetEmail sets errorMessage on failure', () async {
      // Arrange
      fakeAuthRepo.errorToThrow = const AuthFailure('Invalid email address.');

      // Act & Assert
      try {
        await authProvider.sendPasswordResetEmail('invalid-email');
      } catch (_) {
        // Expected to throw
      }

      expect(authProvider.errorMessage, 'Invalid email address.');
    });
  });
}
