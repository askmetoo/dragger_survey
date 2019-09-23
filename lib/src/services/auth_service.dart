import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:async';


final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn _googleSignIn = GoogleSignIn();

class AuthService {
  // final GoogleSignInAccount user = _googleSignIn.currentUser;

  AuthService() {
    print("new AuthService");
  }

  Future getCurrentUser() async {
    _auth
        .currentUser()
        .then( (val) {
          log("In AuthService getCurrentUser() - value of _auth.currentUser(): ${val?.uid}");
          }
        );
    FirebaseUser _currentUser = await  _auth.currentUser();

    return _currentUser;
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

    final FirebaseUser _user = (await _auth.signInWithCredential(credential)).user;
    log("In AuthService signInWithGoogle() - displayName: ${_user.displayName}, user.uid: ${_user.uid}");

    return _user;
  }
}