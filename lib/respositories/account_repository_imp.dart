import 'package:firebase_auth/firebase_auth.dart';
import 'account_repository.dart';

class AccountRepositoryImp implements IAccountRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Future<void> deleteAccount() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        await user.delete();
      }
    } on FirebaseAuthException catch (e) {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }
  
  @override
  Future<void> changePassword(String oldPassword, String newPassword) async {
    try {
      User? user =_auth.currentUser;   // zaten bu widget görünmediğinden bu fonksyiona da erişilemez ama güvenlik amacıyla eklendi
      if(user==null) throw Exception("Kullanıcı oturumu açık değil.");

      final cred =EmailAuthProvider.credential(email: user.email!, password: oldPassword);  //kimlik doğrulaması

      await user.reauthenticateWithCredential(cred);
      await user.updatePassword(newPassword);

    } on FirebaseAuthException catch (e) {
      rethrow;
    } catch (e)  {
      rethrow;
    }
  }
}
