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

  Future<DocumentSnapshot> createUserInFirestore({FirebaseUser account}) async {
    // 1) check if user exists in users collection in database (according to their id)
    // final GoogleSignInAccount user = _googleSignIn.currentUser;
    // FirebaseUser _currentUser = await _auth.currentUser();

    print(
        "In AuthService createUserInFirestore value of account.uid: ${account.uid}");
    // 1b) query for account.uid in DB
    QuerySnapshot doc = await _db
        .collection('users')
        .where('providersUID', isEqualTo: account.uid)
        .getDocuments()
        .catchError(
            (e) => print("ERROR in AuthService query for existing user: $e"));
    print("---------> In AuthService createUserInFirestore value of doc: $doc");

    // 2) if the user doesn't exist, then create account
    if (doc.documents.isEmpty) {
      print(
          "---------> In AuthService createUserInFirestore value of doc.documents.isEmpty: ${doc.documents.isEmpty}");

      log("In AuthService createUserInFirestore when !doc.exists - account?.uid: ${account?.uid}");
      log("In AuthService createUserInFirestore when !doc.exists - account?.displayName: ${account?.displayName}");
      log("In AuthService createUserInFirestore when !doc.exists - account?.email: ${account?.email}");
      log("In AuthService createUserInFirestore when !doc.exists - account?.photoUrl: ${account?.photoUrl}");
      log("In AuthService createUserInFirestore when !doc.exists - account?.providerId: ${account?.providerId}");
      User newUser = User(
        providersUID: account?.uid,
        displayName: account?.displayName,
        email: account?.email,
        created: DateTime.now(),
        photoUrl: account?.photoUrl,
        providerId: account?.providerId,
      );
      UserBloc userBloc = UserBloc();
      userBloc.addUserToDb(
        user: newUser,
      );
      return null;
    }

    // 3) In case user exists return first account
    if (doc.documents.first.data.isNotEmpty) {
      log("--------> In AuthService createUserInFirestore doc.documents.isNotEmpty: ${doc.documents.isNotEmpty}");
      log("--------> In AuthService createUserInFirestore doc.documents.first.data.isNotEmpty: ${doc.documents.first.data.isNotEmpty}");
      if (account.uid == doc.documents.first.data['providersUID']) {
        log("In AuthService createUserInFirestore account.uid == doc.data['providersUID']: ${account.uid == doc.documents.first.data['providersUID']}");
        print(
            "--------> In AuthService createUserInFirestore returned user doc: ${doc.documents.first.data['providersUID']}");
        return doc.documents.first;
        // return doc.documents.first.data['providersUID'];
      }
    }

    // 4) Else return new query for account
    doc = await _db
        .collection('users')
        .where('providersUID', isEqualTo: account.uid)
        .getDocuments()
        .catchError(
            (e) => print("ERROR in AuthService query for existing user: $e"));

    return doc.documents.first;
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

    assert(!_user.isAnonymous);
    assert(await _user.getIdToken() != null);

    final FirebaseUser currentUser = await _auth.currentUser();
    assert(_user.uid == currentUser.uid);

    log("In AuthService value of _user.uid: ${_user.uid}");
    log("In AuthService value of currentUser.uid: ${currentUser.uid}");

    log("In AuthService signInWithGoogle() - displayName: ${_user.displayName}, user.uid: ${_user.uid}");

    return _user;
  }
}
