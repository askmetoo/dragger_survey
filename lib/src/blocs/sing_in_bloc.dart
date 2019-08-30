import 'dart:async';
import 'package:dragger_survey/src/services/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignInBloc extends ChangeNotifier {
  bool _isLoading = true;
  FirebaseUser signedInUser;
  final auth = AuthService().auth;
  String signedInUserProvidersUID = '';
  Future<FirebaseUser> _currentUser;

  Future<FirebaseUser> get currentUser {
    _currentUser = AuthService().getUser;
    return _currentUser;
  }

  Future<FirebaseUser> signInWithGoogle() async {
    final AuthService auth = AuthService();
    try {
      _setIsLoading(true);
      return signedInUser = await auth.googleSignIn();
    } catch (error) {
      print("Error while signing-in: $error");
    } finally {
      print("In SignInBloc - after auth.googleSignIn() - signedInUser: $signedInUser");
      _setIsLoading(false);
    }
    return null;
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
