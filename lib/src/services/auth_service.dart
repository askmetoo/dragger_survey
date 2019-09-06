import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:async';


class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  AuthService() {
    print("new AuthService");
  }

  Future getCurrentUser() {
    return _auth.currentUser();
  }

  Future lougout() {
    var result = FirebaseAuth.instance.signOut();
    return result;
  }

  Future<FirebaseUser> createUser({email, password}) async{
    final FirebaseUser user = (await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password
    )).user;

    return user;
  }

  Future<FirebaseUser> signInWithGoogle() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final FirebaseUser user = (await _auth.signInWithCredential(credential)).user;
    log("signing-in - displayName: ${user.displayName}, user.uid: ${user.uid}");

    return user;
  }
}