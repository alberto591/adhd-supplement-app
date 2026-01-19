import 'package:flutter/foundation.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';

enum AuthStatus { initial, authenticated, unauthenticated }

class AuthProvider extends ChangeNotifier {
  final AuthRepository _authRepository;

  User? _user;
  AuthStatus _status = AuthStatus.initial;
  String? _errorMessage;

  AuthProvider(this._authRepository) {
    _initialize();
  }

  User? get user => _user;
  AuthStatus get status => _status;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _status == AuthStatus.authenticated;

  void _initialize() {
    _authRepository.authStateChanges().listen((user) {
      _user = user;
      _status = user != null ? AuthStatus.authenticated : AuthStatus.unauthenticated;
      notifyListeners();
    });
  }

  Future<void> signIn(String email, String password) async {
    try {
      _errorMessage = null;
      notifyListeners();

      _user = await _authRepository.signInWithEmail(email, password);
      _status = AuthStatus.authenticated;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _status = AuthStatus.unauthenticated;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> signUp(String email, String password, String displayName) async {
    try {
      _errorMessage = null;
      notifyListeners();

      _user = await _authRepository.signUpWithEmail(email, password, displayName);
      _status = AuthStatus.authenticated;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _status = AuthStatus.unauthenticated;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> signOut() async {
    await _authRepository.signOut();
    _user = null;
    _status = AuthStatus.unauthenticated;
    _errorMessage = null;
    notifyListeners();
  }

  Future<void> updateProfile(User user) async {
    await _authRepository.updateUserProfile(user);
    _user = user;
    notifyListeners();
  }
}
