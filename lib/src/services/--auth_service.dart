import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:async';

class AuthService {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore _db = Firestore.instance;
  FirebaseUser _currentUser;

  FirebaseAuth get auth => _auth;

  Future<FirebaseUser> get getCurrentUser => _auth.currentUser().then((val) => _currentUser = val);

  FirebaseUser get currentUser => _currentUser;

  Stream<FirebaseUser> get user => _auth.onAuthStateChanged;

  Future<FirebaseUser> anonLogin() async {
    final FirebaseUser user = await _auth.signInAnonymously() as FirebaseUser;
    updateUserData(user);
    return user;
  }

  Future<FirebaseUser> googleSignIn() async {
    
    GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn()
      .catchError((e) => print("ERROR in auth_service during 'await _googleSignIn.signIn()' in googleSignIn $e"));
    log('LOG 1) auth_service googleSignInAccount value: $googleSignInAccount');
    
    GoogleSignInAuthentication googleAuth =
        await googleSignInAccount.authentication
            .catchError((e) => print("ERROR in auth_service during 'await googleSignInAccount.authentication' in googleSignIn $e"));
    log('LOG 2) auth_service googleAuth value: $googleSignInAccount');

    //// Get credentials from GoogleAuth of current signing-in user ////
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    log('LOG 3) auth_service credential value: $credential');

    ////---- Signing in with corrent user's credentials ----////
    FirebaseUser user = (await _auth.signInWithCredential(credential)).user;
    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);
    log('LOG 4) auth_service user value: $user');

    FirebaseUser _currentUser = (await auth.currentUser());

    // _auth.currentUser()
    //   .then((value) {
    //     log('LOG 5) auth_service _auth.currentUser() value: $value');
    //     _currentUser = value;
    //   })
    //   .catchError( (e) => print("ERROR in auth_service during '_auth.currentUser()' in googleSignIn $e"));
    
    // assert(user?.uid == _currentUser?.uid);
    if (user?.uid == null ) {
      log('LOG 6a) In auth_service user.uid is null');
    } else if (_currentUser?.uid == null) {
      log('LOG 6b) In auth_service _currentUser.uid is null but user.uid is ${user.uid}');
    } else if (user?.uid == _currentUser?.uid) {
      log('LOG 6c) In auth_service user.uid == _currentUser.uid: ${(user.uid == _currentUser.uid)}');
    } else {
      log('LOG 6d) In auth_service _currentUser value: $_currentUser, user.uid: ${user.uid}');

    }

    //      updateUserData(user);
    return user;
  }

  Future<void> updateUserData(FirebaseUser user) {
    DocumentReference reportRef = _db.collection('reports').document(user.uid);

    return reportRef.setData(
      {
        'uid': user.uid,
        'lastActivity': DateTime.now(),
      },
      merge: true,
    );
  }

  Future<void> signOut() {
    log('auth_service User signOut');
    return _auth.signOut();
  }
}

