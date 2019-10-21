import 'dart:async';
import 'package:dragger_survey/src/services/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignInBloc extends ChangeNotifier {
  final AuthService authService = AuthService();

  Future<FirebaseUser> get currentUser async {
    FirebaseUser _user = (await authService.getCurrentUser());
    return _user;
  }

  Future logoutUser() async {
    var _result = (await authService.lougout());
    notifyListeners();
    return _result;
  }

  Future<FirebaseUser> signInWithGoogle() async {
    FirebaseUser _user = (await authService.signInWithGoogle());
    notifyListeners();
    return _user;
  }

  Future<User> createUserInDbIfNotExist({account}) async {
    User _createdUser =
        await authService.createUserInFirestore(account: account);
    notifyListeners();
    return _createdUser;
  }
}
