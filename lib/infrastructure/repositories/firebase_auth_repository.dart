import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/errors/failure.dart';
import '../../utils/logger.dart';

class FirebaseAuthRepository implements AuthRepository {
  final firebase_auth.FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  FirebaseAuthRepository({
    firebase_auth.FirebaseAuth? firebaseAuth,
    FirebaseFirestore? firestore,
  })  : _firebaseAuth = firebaseAuth ?? firebase_auth.FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<User?> getCurrentUser() async {
    final firebaseUser = _firebaseAuth.currentUser;
    if (firebaseUser == null) return null;

    // Try to get user data from Firestore
    try {
      final doc =
          await _firestore.collection('users').doc(firebaseUser.uid).get();
      if (doc.exists) {
        return User.fromJson(doc.data()!);
      }
    } catch (e) {
      // Fall back to Firebase Auth data
    }

    return _mapFirebaseUser(firebaseUser);
  }

  @override
  Future<User> signInWithEmail(String email, String password) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user == null) {
        throw const AuthFailure('Sign in failed');
      }

      // Get user data from Firestore
      final doc =
          await _firestore.collection('users').doc(credential.user!.uid).get();
      if (doc.exists) {
        return User.fromJson(doc.data()!);
      }

      return _mapFirebaseUser(credential.user!);
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw _mapAuthException(e);
    } catch (e) {
      if (e is Failure) rethrow;
      throw AuthFailure('Sign in failed', e);
    }
  }

  @override
  Future<User> signUpWithEmail(
      String email, String password, String displayName) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user == null) {
        throw const AuthFailure('Sign up failed');
      }

      // Update display name
      await credential.user!.updateDisplayName(displayName);

      final user = User(
        id: credential.user!.uid,
        email: email,
        displayName: displayName,
        createdAt: DateTime.now(),
        hasCompletedOnboarding: false,
      );

      // Save to Firestore
      await _firestore.collection('users').doc(user.id).set(user.toJson());

      return user;
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw _mapAuthException(e);
    } catch (e) {
      if (e is Failure) rethrow;
      throw AuthFailure('Sign up failed', e);
    }
  }

  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  @override
  Stream<User?> authStateChanges() {
    return _firebaseAuth.authStateChanges().asyncMap((firebaseUser) async {
      if (firebaseUser == null) return null;

      try {
        final doc = await _firestore
            .collection('users')
            .doc(firebaseUser.uid)
            .get(const GetOptions(source: Source.serverAndCache))
            .timeout(const Duration(seconds: 3));
        if (doc.exists) {
          return User.fromJson(doc.data()!);
        }
      } catch (e) {
        // Fall back to local cache if server is slow
        AppLogger.w('Firestore server fetch timed out, trying cache', e);
        try {
          final doc = await _firestore
              .collection('users')
              .doc(firebaseUser.uid)
              .get(const GetOptions(source: Source.cache));
          if (doc.exists) {
            return User.fromJson(doc.data()!);
          }
        } catch (cacheErr) {
          AppLogger.e('Firestore cache fetch failed', cacheErr);
        }
      }

      return _mapFirebaseUser(firebaseUser);
    });
  }

  @override
  Future<void> updateUserProfile(User user) async {
    await _firestore
        .collection('users')
        .doc(user.id)
        .set(user.toJson(), SetOptions(merge: true));
  }

  @override
  Stream<User?> watchUser(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .snapshots()
        .map((doc) => doc.exists ? User.fromJson(doc.data()!) : null);
  }

  @override
  Future<void> deleteUser() async {
    final user = _firebaseAuth.currentUser;
    if (user == null) {
      throw const AuthFailure('No user signed in');
    }

    // Delete from Firestore
    await _firestore.collection('users').doc(user.uid).delete();

    // Delete from Firebase Auth
    // Note: This requires recent login. If it fails with 'requires-recent-login',
    // the UI should prompt to re-authenticate.
    await user.delete();
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email.trim());
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw _mapAuthException(e);
    } catch (e) {
      if (e is Failure) rethrow;
      throw AuthFailure('Failed to send password reset email', e);
    }
  }

  @override
  Future<User> signInAnonymously() async {
    try {
      final credential = await _firebaseAuth.signInAnonymously();

      if (credential.user == null) {
        throw const AuthFailure('Anonymous sign in failed');
      }

      // Check if user already exists in Firestore
      final doc =
          await _firestore.collection('users').doc(credential.user!.uid).get();
      if (doc.exists) {
        return User.fromJson(doc.data()!);
      }

      // Create a temporary user profile
      final user = User(
        id: credential.user!.uid,
        email: 'anonymous@dev.mode',
        displayName: 'Guest Hero',
        createdAt: DateTime.now(),
        hasCompletedOnboarding: true,
      );

      // Save to Firestore so other repositories can find it
      await _firestore.collection('users').doc(user.id).set(user.toJson());

      return user;
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw _mapAuthException(e);
    } catch (e) {
      if (e is Failure) rethrow;
      throw AuthFailure('Anonymous sign in failed', e);
    }
  }

  User _mapFirebaseUser(firebase_auth.User firebaseUser) {
    return User(
      id: firebaseUser.uid,
      email: firebaseUser.email ?? '',
      displayName: firebaseUser.displayName,
      photoUrl: firebaseUser.photoURL,
      createdAt: firebaseUser.metadata.creationTime ?? DateTime.now(),
    );
  }

  AuthFailure _mapAuthException(firebase_auth.FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
      case 'invalid-login-credentials':
      case 'INVALID_LOGIN_CREDENTIALS':
        // Standardized message for security (does not reveal which field is wrong)
        return const AuthFailure(
            'Invalid email or password. Please try again.');
      case 'email-already-in-use':
        return const AuthFailure('An account already exists with this email.');
      case 'weak-password':
        return const AuthFailure('Password is too weak.');
      case 'invalid-email':
        return const AuthFailure('Invalid email address.');
      case 'admin-restricted-operation':
      case 'operation-not-allowed':
        return const AuthFailure(
            'Anonymous login is disabled. Please enable it in Firebase Console -> Authentication -> Sign-in method.');
      default:
        return AuthFailure(e.message ?? 'Authentication failed.');
    }
  }
}
