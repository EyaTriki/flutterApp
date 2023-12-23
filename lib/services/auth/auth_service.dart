import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService extends ChangeNotifier{
  final FirebaseAuth _firebaseAuth =FirebaseAuth.instance;
  Future <UserCredential> signInWithEmailandPassword
   (String email , String password) async{
    try{
      // sign in
      UserCredential userCredential = 
      await _firebaseAuth.signInWithEmailAndPassword
      (email: email, password: password);
   return userCredential;
    } on FirebaseAuthException catch (e){
      throw Exception(e.code);
    }
  }

 
//create new user
Future<UserCredential> signUpwithEmailandPassword(
  String email , password) async{
 try{
  UserCredential userCredential =
  await _firebaseAuth.createUserWithEmailAndPassword (
    email :email, password:password);
  return userCredential;
 }on FirebaseAuthException catch(e){
  throw Exception(e.code);
 }
}


  Future <void> signOut() async {
    return await FirebaseAuth.instance.signOut();
  }
}