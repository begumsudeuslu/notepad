import 'package:firebase_auth/firebase_auth.dart';
import 'auth_repository.dart';

class AuthRepositoryImp implements IAuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // signIn için
  @override
  Future<User?> signIn(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } on FirebaseAuthException catch (e) {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  // register için
  @override
  Future<User?> register(String username, String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await result.user?.updateDisplayName(username);
      return result.user;
    } on FirebaseAuthException catch (e) {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  // logout için
  @override
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // forgot password için
  @override
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }
}