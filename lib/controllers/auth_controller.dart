import 'package:flutter/material.dart';

class AuthController extends ChangeNotifier {
  // şimdilik private variables olarak kalsınlar
  bool _isLoggedIn = false;
  String _username = "Misafir Kullanıcı";
  String _email = "misafir@example.com";
  String _password = "123456";

  bool get isLoggedIn => _isLoggedIn;
  String get username => _username;
  String get email => _email;

  Future<void> login(String email, String password) async {
    // normalde burada api çağrısıyla database atraması yapılır
    await Future.delayed(const Duration(seconds: 1));

    if (email.isEmpty || password.isEmpty) {
      throw Exception("Lütfen tüm alanları doldurun.");
    }

    if (email == 'flutterserver@example.com' && password == '123456') {
      _isLoggedIn = true;
      _username = "Flutter Server";
      _email = email;
      notifyListeners(); //arayüz güncellemesi
    } else {
      throw Exception("E-posta veya şifre hatalı.");
    }
  }

  Future<void> register(String username, String mail, String password) async {
    await Future.delayed(const Duration(seconds: 1));

    if (username.isEmpty || mail.isEmpty || password.isEmpty) {
      throw Exception("Lütfen tüm alanları doldurun.");
    }
  }

  void logout() {
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
    await Future.delayed(const Duration(seconds: 1));
    if (email.isEmpty) {
      throw Exception("Lütfen e-posta adresinizi girin.");
    }
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
}
