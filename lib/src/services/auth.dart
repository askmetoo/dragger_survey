import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
//  final Firestore _db = Firestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<FirebaseUser> get getUser => _auth.currentUser();

  Stream<FirebaseUser> get user => _auth.onAuthStateChanged;

  Future<FirebaseUser> anonLogin() async {
    final FirebaseUser user = await _auth.signInAnonymously() as FirebaseUser;

//    updateUserData(user);

    return user;
  }

  Future<FirebaseUser> googleSignIn() async {
    try {
      GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();
      GoogleSignInAuthentication googleAuth =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      FirebaseUser user =
          await _auth.signInWithCredential(credential) as FirebaseUser;

//      assert(!user.isAnonymous);
      print(
          '--------> signInWithGoogle user.getIdToken(): ${user.getIdToken()}');
      assert(await user.getIdToken() != null);

      final FirebaseUser currentUser = await _auth.currentUser();
      assert(user.uid == currentUser.uid);
      print('--------> signInWithGoogle succeeded: $user');

//      updateUserData(user);
      return user;
    } catch (error) {
      print("---------> Error during anonymous sign in $error");
      return null;
    }
  }

//  Future<void> updateUserData(FirebaseUser user) {
//    DocumentReference reportRef = _db.collection('reports').document(user.uid);
//
//    return reportRef.setData(
//      {
//        'uid': user.uid,
//        'lastActivity': DateTime.now(),
//      },
//      merge: true,
//    );
//  }

  Future<void> signOut() {
    print('User sign out');
    return _auth.signOut();
  }
}
