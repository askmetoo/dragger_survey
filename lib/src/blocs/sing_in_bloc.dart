import 'dart:async';
import 'package:dragger_survey/src/services/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:dragger_survey/src/services/auth_service.dart';

class SignInBloc extends ChangeNotifier {
  bool _isLoading = true;
  FirebaseUser signedInUser;
  final auth = AuthService().auth;

  Future<FirebaseUser> signInWithGoogle() async {
    final AuthService auth = AuthService();
    try {
      _setIsLoading(true);
      return signedInUser = await auth.googleSignIn();
    } catch (error) {
      print("Error while signing-in: $error");
    } finally {
      _setIsLoading(false);
    }
  }

  final StreamController<bool> _isLoadingController = StreamController<bool>();
  void _setIsLoading(bool isLoading) => _isLoadingController.add(isLoading);
  void signOut() { 
    AuthService().signOut();
    signedInUser = null;
    notifyListeners();
  }
  void dispose() => _isLoadingController.close();

}
