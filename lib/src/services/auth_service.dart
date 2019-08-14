import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dragger_survey/src/services/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:async';
import 'package:meta/meta.dart';

abstract class AuthService {
  Future<User> currentUser();

  Future<User> signInAnonymously();

  Future<User> signInWithEmailAndPassword(String email, String password);

  Future<User> createUserWithEmailAndPassword(String email, String password);

  Future<void> sendPasswordResetEmail(String email);

  Future<User> signInWithEmailAndLink({String email, String link});

  Future<bool> isSignInWithEmailLink(String link);

  Future<void> sendSignInWithEmailLink({
    @required String email,
    @required String url,
    @required bool handleCodeInApp,
    @required String iOSBundleId,
    @required String androidPackageName,
    @required bool androidInstallIfNotAvailable,
    @required String androidMinimumVersion,
  });

  Future<User> signInWithGoogle();
  Future<User> signInWithFacebook();
  Future<void> signOut();
  Stream<User> get onAuthStateChanged;
  void dispose();
}

//// OLD VERSION ////
//  final FirebaseAuth _auth = FirebaseAuth.instance;
//  final Firestore _db = Firestore.instance;
//  final GoogleSignIn _googleSignIn = GoogleSignIn();
//
//  Future<User> get getUser => _auth.currentUser();
//
//  Stream<User> get user => _auth.onAuthStateChanged;
//
//  Future<User> anonLogin() async {
//    final User user = await _auth.signInAnonymously() as User;
//
//    updateUserData(user);
//
//    return user;
//  }
//
//  Future<User> googleSignIn() async {
//    try {
//      GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();
//      GoogleSignInAuthentication googleAuth =
//          await googleSignInAccount.authentication;
//
//      final AuthCredential credential = GoogleAuthProvider.getCredential(
//        accessToken: googleAuth.accessToken,
//        idToken: googleAuth.idToken,
//      );
//
//      FirebaseUser user =
//          await _auth.signInWithCredential(credential) as FirebaseUser;
//
////      assert(!user.isAnonymous);
//      print(
//          '--------> signInWithGoogle user.getIdToken(): ${user.getIdToken()}');
//      assert(await user.getIdToken() != null);
//
//      final FirebaseUser currentUser = await _auth.currentUser();
//      assert(user.uid == currentUser.uid);
//      print('--------> signInWithGoogle succeeded: $user');
//
////      updateUserData(user);
//      return user;
//    } catch (error) {
//      print("---------> Error during anonymous sign in $error");
//      return null;
//    }
//  }
//
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
//
//  Future<void> signOut() {
//    print('User sign out');
//    return _auth.signOut();
//  }
// }
