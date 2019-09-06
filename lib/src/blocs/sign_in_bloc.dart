import 'dart:async';
import 'dart:developer';
import 'package:dragger_survey/src/services/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignInBloc extends ChangeNotifier {
  final AuthService authService = AuthService();

  Future<FirebaseUser> get currentUser async {
    FirebaseUser _user = (await authService.getCurrentUser());
    log("In SignInBloc getting currentUser: $_user, UID: ${_user.uid}");
    return _user;
  }

  Future logoutUser() async {
    var _result = (await authService.lougout());
    log("In SignInBloc logoutuser: $_result");
    return _result;
  }

  Future<FirebaseUser> signInWithGoogle() async {
    FirebaseUser _user = (await authService.signInWithGoogle());
    log("In SignInBloc getting currentUser: $_user, UID: ${_user.uid}");
    return _user;
  }

}