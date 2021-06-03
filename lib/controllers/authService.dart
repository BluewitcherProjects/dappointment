import 'dart:async';

import 'package:bot_toast/bot_toast.dart';
import 'package:dappointment/controllers/storageService.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthenticationService {
  final FirebaseAuth _firebaseAuth;

  // AuthResultStatus _authResultStatus;
  AuthenticationService(this._firebaseAuth);

  /// Changed to idTokenChanges as it updates depending on more cases.
  Stream<User> get authStateChanges => _firebaseAuth.idTokenChanges();

  User get currentUser => _firebaseAuth.currentUser;

  //GOOGLE SIGN IN

  Future<void> resetPassword(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email).whenComplete(
          () => BotToast.showText(text: "Message Sent Successfully"));
    } on FirebaseAuthException catch (e) {
      BotToast.showText(text: e.message);
    }
  }

  Future<User> signIn({String email, String password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return _firebaseAuth.currentUser;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        BotToast.showText(text: 'No user found for that email.');
      } else if (e.code == 'wrong-password') {
        BotToast.showText(text: 'Wrong password provided for that user.');
      } else {
        BotToast.showText(text: e.message);
      }
      return null;
      // BotToast.showText(contentColor: blue,backgroundColor: Colors.white,contentColor: Colors.black,
      //     text: e.message);
    }
  }

  Future<void> signOut() async {
    // User user = _firebaseAuth.currentUser;
    // if (user.providerData.contains('google.com')) {
    //   print("google sign out");
    //   await GoogleSignIn().signOut();
    // } else
    await _firebaseAuth.signOut();
    Get.reset();
  }

  Future<User> signUp({String email, String password}) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      // await _firebaseAuth.currentUser.updateProfile(displayName: name);
      return _firebaseAuth.currentUser;
    } on FirebaseAuthException catch (e) {
      print(e.message);
      BotToast.showText(text: e.message, duration: Duration(seconds: 2));
      return null;
    }
  }
}
