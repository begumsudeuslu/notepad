import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Akış olarak anlık kullanıcı durumunu dinler
  Stream<User?> get user {
    return _auth.authStateChanges();
  }

  // E-posta ve şifre ile yeni kullanıcı kaydı
  Future<User?> signUpWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException {
      rethrow;
    }
  }

  // E-posta ve şifre ile giriş yapma
  Future<User?> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException {
      rethrow;
    }
  }

  // Anonim olarak giriş yapma
  Future<User?> signInAnonymously() async {
    try {
      final userCredential = await _auth.signInAnonymously();
      return userCredential.user;
    } on FirebaseAuthException {
      rethrow;
    }
  }

  // Kullanıcı adı güncelleme işlemi
  Future<void> updateUsername(String newUsername) async {
    final user = _auth.currentUser;
    if (user != null) {
      await user.updateDisplayName(newUsername);
    }
  }

  // Şifre sıfırlama işlemi
  Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  // Şifre değiştirme işlemi
  Future<void> changePassword(String oldPassword, String newPassword) async {
    final user = _auth.currentUser;
    if (user != null) {
      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: oldPassword,
      );
      await user.reauthenticateWithCredential(credential);
      await user.updatePassword(newPassword);
    }
  }

  // Çıkış yapma
  Future<void> logout() async {
    await _auth.signOut();
  }
}
