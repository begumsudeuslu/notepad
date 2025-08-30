import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:notepad/services/auth_service.dart';
import '../respositories/auth_repository.dart';

class AuthController extends ChangeNotifier {

  final IAuthRepository _authRepository;
  AuthController(this._authRepository);

  // şimdilik private variables olarak kalsınlar
  bool _isLoggedIn = false;
  String _username = "Misafir Kullanıcı";
  String _email = "misafir@example.com";

  bool get isLoggedIn => _isLoggedIn;
  String get username => _username;
  String get email => _email;

  Future<void> login(String email, String password) async {
    try {
      User? user = await _authRepository.signIn(email, password);
      _isLoggedIn = true;
      _username = user?.displayName ?? "Misafir Kullanıcı";
      _email = user?.email ?? "misafir@example.com";
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> register(String username, String email, String password) async {
    try {
      User? user = await _authRepository.register(username, email, password);
      _isLoggedIn = true;
      _username = username;
      _email = email;
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> logout() async {
    await _authRepository.signOut();
    _isLoggedIn = false;
    _username = "Misafir Kullanıcı";
    _email = "misafir@example.com";
    notifyListeners();
  }

  void updateUsername(String newUsername) {
    if (newUsername.isEmpty) {
      throw Exception("Kullanıcı adı boş olamaz.");
    }
    _username = newUsername;
    notifyListeners();
  }

  Future<void> resetPassword(String email) async {
    if (email.isEmpty) {
      throw Exception("Lütfen e-posta adresinizi girin.");
    }
    await _authRepository.resetPassword(email);
  }

  void guestLogIn() {
    _isLoggedIn = true;
    _username = "Misafir Kullanıcı";
    _email = "misafir@example.com";
    notifyListeners();
  }
}
