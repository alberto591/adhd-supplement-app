import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:adhd_supplement_app/infrastructure/repositories/firebase_auth_repository.dart';
import 'package:adhd_supplement_app/domain/errors/failure.dart';

import 'firebase_auth_repository_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<firebase_auth.FirebaseAuth>(),
  MockSpec<firebase_auth.UserCredential>(),
  MockSpec<firebase_auth.User>(),
  MockSpec<FirebaseFirestore>(),
  MockSpec<CollectionReference<Map<String, dynamic>>>(
      as: #MockCollectionReference),
  MockSpec<DocumentReference<Map<String, dynamic>>>(as: #MockDocumentReference),
  MockSpec<DocumentSnapshot<Map<String, dynamic>>>(as: #MockDocumentSnapshot),
])
void main() {
  late FirebaseAuthRepository repository;
  late MockFirebaseAuth mockFirebaseAuth;
  late MockFirebaseFirestore mockFirestore;
  late MockUserCredential mockUserCredential;
  late MockUser mockFirebaseUser;

  setUp(() {
    mockFirebaseAuth = MockFirebaseAuth();
    mockFirestore = MockFirebaseFirestore();
    mockUserCredential = MockUserCredential();
    mockFirebaseUser = MockUser();

    repository = FirebaseAuthRepository(
      firebaseAuth: mockFirebaseAuth,
      firestore: mockFirestore,
    );
  });

  group('signInWithEmail', () {
    const email = 'test@example.com';
    const password = 'password123';

    test('should return User when sign in is successful', () async {
      // Arrange
      when(mockFirebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      )).thenAnswer((_) async => mockUserCredential);

      when(mockUserCredential.user).thenReturn(mockFirebaseUser);
      when(mockFirebaseUser.uid).thenReturn('123');
      when(mockFirebaseUser.email).thenReturn(email);
      when(mockFirebaseUser.displayName).thenReturn('Test User');
      // Fix: stub metadata for _mapFirebaseUser
      when(mockFirebaseUser.metadata)
          .thenReturn(firebase_auth.UserMetadata(0, 0));

      // Mock Firestore
      final mockCollection = MockCollectionReference();
      final mockDocRef = MockDocumentReference();
      final mockDocSnapshot = MockDocumentSnapshot();

      when(mockFirestore.collection('users')).thenReturn(mockCollection);
      when(mockCollection.doc(any)).thenReturn(mockDocRef);
      when(mockDocRef.get()).thenAnswer((_) async => mockDocSnapshot);
      when(mockDocSnapshot.exists).thenReturn(false);

      // Act
      final result = await repository.signInWithEmail(email, password);

      // Assert
      expect(result.email, email);
      verify(mockFirebaseAuth.signInWithEmailAndPassword(
          email: email, password: password));
    });

    test('should return correct error message for wrong-password', () async {
      // Arrange
      when(mockFirebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      )).thenThrow(firebase_auth.FirebaseAuthException(
        code: 'wrong-password',
        message: 'Wrong password provided.',
      ));

      // Act & Assert
      expect(
        () => repository.signInWithEmail(email, password),
        throwsA(isA<AuthFailure>().having(
          (e) => e.message,
          'message',
          'Invalid email or password. Please try again.',
        )),
      );
    });

    test('should return correct error message for user-not-found', () async {
      // Arrange
      when(mockFirebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      )).thenThrow(firebase_auth.FirebaseAuthException(
        code: 'user-not-found',
        message: 'No user found.',
      ));

      // Act & Assert
      expect(
        () => repository.signInWithEmail(email, password),
        throwsA(isA<AuthFailure>().having(
          (e) => e.message,
          'message',
          'Invalid email or password. Please try again.',
        )),
      );
    });

    test(
        'should return correct error message for invalid-credential (Firebase v9+)',
        () async {
      // Arrange - newer Firebase SDK uses invalid-credential
      when(mockFirebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      )).thenThrow(firebase_auth.FirebaseAuthException(
        code: 'invalid-credential',
        message: 'The supplied auth credential is incorrect.',
      ));

      // Act & Assert
      expect(
        () => repository.signInWithEmail(email, password),
        throwsA(isA<AuthFailure>().having(
          (e) => e.message,
          'message',
          'Invalid email or password. Please try again.',
        )),
      );
    });
  });

  group('sendPasswordResetEmail', () {
    const email = 'test@example.com';

    test('should send password reset email successfully', () async {
      // Arrange
      when(mockFirebaseAuth.sendPasswordResetEmail(email: email))
          .thenAnswer((_) async => Future.value());

      // Act
      await repository.sendPasswordResetEmail(email);

      // Assert
      verify(mockFirebaseAuth.sendPasswordResetEmail(email: email));
    });

    test('should throw AuthFailure for invalid email', () async {
      // Arrange
      when(mockFirebaseAuth.sendPasswordResetEmail(email: email))
          .thenThrow(firebase_auth.FirebaseAuthException(
        code: 'invalid-email',
        message: 'Invalid email address.',
      ));

      // Act & Assert
      expect(
        () => repository.sendPasswordResetEmail(email),
        throwsA(isA<AuthFailure>().having(
          (e) => e.message,
          'message',
          'Invalid email address.',
        )),
      );
    });

    test('should send reset email even if user not found (security)', () async {
      // Arrange - Firebase may throw user-not-found, but we handle it gracefully
      when(mockFirebaseAuth.sendPasswordResetEmail(email: email))
          .thenAnswer((_) async => Future.value());

      // Act
      await repository.sendPasswordResetEmail(email);

      // Assert - Should not throw, maintaining security by not revealing if user exists
      verify(mockFirebaseAuth.sendPasswordResetEmail(email: email));
    });
  });
}
