import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AuthService {
  final FirebaseAuth _auth=FirebaseAuth.instance;

  // signIn için
  Future<User?> signIn(String email, String password) async  {
    try {
      UserCredential result= await _auth.signInWithEmailAndPassword(email: email, password: password);
      return result.user;
    } on FirebaseAuthException catch(e)   {
      String message= '';
      if(e.code == 'weak-password')  {
        message='The password provided is too weak';
      } else if(e.code == 'email-already-in-use')   {
        message='An account already exists with that email.';
      }
      Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: Colors.black54,
        textColor: Colors.white,
        fontSize: 14,
      );
      return null; 
    } catch (e)  {
      throw Exception("Giriş sırasında bir hata oluştu.");
    }
  }

  // register için
  Future<User?> register(String username, String email, String password) async  {
    try{ 
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      await result.user?.updateDisplayName(username);
      return result.user;
    } on FirebaseAuthException catch (e)  {
      String message ='';
      message=e.message??"Kayıt sırasında (firebase) bir hata oluştu.";
      Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: Colors.black54,
        textColor: Colors.white,
        fontSize: 14,
      );
      return null;
    } catch (e)  {
      throw Exception("Kayıt sırasında bir hata oluştu.");
    }

  }

}