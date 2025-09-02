import 'package:firebase_auth/firebase_auth.dart';


// normalde user değil AppUser gibi bir şey kullanmalıyız ama şimdilik öğrenmek için kalsın
abstract class IAuthRepository  {
  Future<User?> signIn(String email, String password);
  Future<User?> register(String username, String email, String password);
  Future<void> signOut();
  Future<void> resetPassword(String email);
}