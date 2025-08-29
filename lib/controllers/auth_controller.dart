import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:notepad/services/auth_service.dart';

class AuthController extends ChangeNotifier {
  // Manuel olarak yönetilen durum değişkenleri
  bool _isLoggedIn = false;
  String _username = "Misafir Kullanıcı";
  String _email = "misafir@example.com";

  bool get isLoggedIn => _isLoggedIn;
  String get username => _username;
  String get email => _email;

  final AuthService _authService = AuthService();

  // Gerçek zamanlı kullanıcı oturum durumunu dinler
  Stream<User?> get user => FirebaseAuth.instance.authStateChanges();

  // Giriş yapma işlemi
  Future<void> login(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      throw Exception("Lütfen tüm alanları doldurun.");
    }
    try {
      await _authService.signInWithEmailAndPassword(email, password);
      // Başarılı giriş sonrası durum güncellemesi
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        _isLoggedIn = true;
        _username = user.displayName ?? "Kullanıcı";
        _email = user.email ?? "E-posta bulunamadı";
      }
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message ?? "E-posta veya şifre hatalı.");
    }
  }

  // Kayıt olma işlemi
  Future<void> register(String username, String mail, String password) async {
    if (username.isEmpty || mail.isEmpty || password.isEmpty) {
      throw Exception("Lütfen tüm alanları doldurun.");
    }
    try {
      final newUser = await _authService.signUpWithEmailAndPassword(
        mail,
        password,
      );
      await _authService.updateUsername(username);
      // Başarılı kayıt sonrası durum güncellemesi
      if (newUser != null) {
        _isLoggedIn = true;
        _username = newUser.displayName ?? "Kullanıcı";
        _email = newUser.email ?? "E-posta bulunamadı";
      }
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    }
  }

  // Misafir olarak giriş yapma işlemi
  Future<void> signInAnonymously() async {
    try {
      final user = await _authService.signInAnonymously();
      if (user != null) {
        _isLoggedIn = true;
        _username = "Misafir Kullanıcı";
        _email = "misafir@example.com";
      }
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    }
  }

  // Çıkış yapma işlemi
  void logout() async {
    await _authService.logout();
    _isLoggedIn = false;
    _username = "Misafir Kullanıcı";
    _email = "misafir@example.com";
    notifyListeners();
  }

  // Kullanıcı adı güncelleme işlemi
  Future<void> updateUsername(String newUsername) async {
    if (newUsername.isEmpty) {
      throw Exception("Kullanıcı adı boş olamaz.");
    }
    try {
      await _authService.updateUsername(newUsername);
      _username = newUsername; // Manuel durumu güncelle
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    }
  }

  // Şifre sıfırlama işlemi
  Future<void> resetPassword(String email) async {
    if (email.isEmpty) {
      throw Exception("Lütfen e-posta adresinizi girin.");
    }
    try {
      await _authService.resetPassword(email);
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    }
  }

  // Şifre değiştirme işlemi
  Future<void> changePassword(String oldPassword, String newPassword) async {
    if (newPassword.length < 6) {
      throw Exception("Şifre en az 6 karakter olmalı.");
    }
    try {
      await _authService.changePassword(oldPassword, newPassword);
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    }
  }
}
