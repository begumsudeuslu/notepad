import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:notepad/services/auth_service.dart';

class AuthController extends ChangeNotifier {
  final AuthService _authService = AuthService();

  // şimdilik private variables olarak kalsınlar
  bool _isLoggedIn = false;
  String _username = "Misafir Kullanıcı";
  String _email = "misafir@example.com";
  String _password = "123456";

  bool get isLoggedIn => _isLoggedIn;
  String get username => _username;
  String get email => _email;

  Future<void> login(String email, String password) async {
    try {
      User? user = await _authService.signIn(email, password);
      _isLoggedIn = true;
      _username = user?.displayName ?? username;
      _email = user?.email ?? email;
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> register(String username, String email, String password) async {
    try {
      User? user = await _authService.register(username, email, password);
      _isLoggedIn = true;
      _username = username;
      _email = email;
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> logout() async {
    await _authService.signOut();
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
    await _authService.resetPassword(email);
  }

  Future<void> changePassword(String oldPassword, String newPassword) async {
    await Future.delayed(const Duration(seconds: 1));

    if (oldPassword != _password) {
      throw Exception("Mevcut şifreniz yanlış.");
    }
    if (newPassword.length < 6) {
      throw Exception("Şifre en az 6 karakter olmalı.");
    }
    _password = newPassword;
    notifyListeners();
  }

  void guestLogIn() {
    _isLoggedIn = true;
    _username = "Misafir Kullanıcı";
    _email = "misafir@example.com";
    notifyListeners();
  }
}
