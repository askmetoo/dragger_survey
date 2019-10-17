import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dragger_survey/src/blocs/blocs.dart';
import 'package:dragger_survey/src/services/models.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:async';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn _googleSignIn = GoogleSignIn();

class AuthService {
  Firestore _db = Firestore.instance;

  AuthService() {
    print("new AuthService");
  }

  Future getCurrentUser() async {
    FirebaseUser _currentUser = await _auth.currentUser();
    return _currentUser;
  }

  Future lougout() {
    var result = FirebaseAuth.instance.signOut();
    return result;
  }

  Future<FirebaseUser> createUser({email, password}) async {
    final FirebaseUser user = (await _auth.createUserWithEmailAndPassword(
            email: email, password: password))
        .user;

    return user;
  }

  Future<User> createUserInFirestore({GoogleSignInAccount account}) async {
    // 1) check if user exists in users collection in database (according to their id)
    final GoogleSignInAccount user = _googleSignIn.currentUser;
    FirebaseUser _currentUser = await _auth.currentUser();

    print(
        "In AuthService createUserInFirestore value of account.id: ${account.id}");
    DocumentSnapshot doc =
        await _db.collection('users').document(account.id).get();
    // 1b) check if FirebaseUser _currentUser is the same currentUser

    print("user.displayName ${user?.displayName}");
    print("_currentUser.displayName: ${_currentUser?.displayName}");
    print(
        "user.displayName == _currentUser.displayName: ${user?.displayName == _currentUser?.displayName}");

    if (!doc.exists) {
      // 2) if the user doesn't exist, then create account
      User newUser = User(
        providersUID: _currentUser?.uid,
        displayName: _currentUser?.displayName,
        email: _currentUser?.email,
        created: DateTime.now(),
        photoUrl: _currentUser?.photoUrl,
        providerId: _currentUser.providerId,
      );
      UserBloc userBloc = UserBloc();
      userBloc.addUserToDb(
        user: newUser,
      );

      doc = await _db.collection('users').document(user.id).get();
    }
    User returnUser = User.fromDocument(doc);

    return returnUser;
  }

  Future<FirebaseUser> signInWithGoogle() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final FirebaseUser _user =
        (await _auth.signInWithCredential(credential)).user;
    log("In AuthService signInWithGoogle() - displayName: ${_user.displayName}, user.uid: ${_user.uid}");

    return _user;
  }
}
