import 'dart:async';
import 'package:dragger_survey/src/services/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignInBloc extends ChangeNotifier {
  bool _isLoading = true;
  FirebaseUser signedInUser;
  final auth = AuthService().auth;
  String _signedInUserProvidersUID = '';
  Future<FirebaseUser> _currentUserFuture;
  FirebaseUser _currentUser;
  String _currentUserUID = '';
  FirebaseUser _signedInUser;

  Future<FirebaseUser> get currentUser {
    try {
      _currentUserFuture = AuthService().currentUser;
      _currentUserFuture.then((value) {
        _currentUser = value;
        _currentUserUID = value?.uid;
      });
    } catch (error) {}
    return _currentUserFuture;
  }

  String get currentUserUID {
    return _currentUserUID;
  }

  setCurrentUser(userObject) {
    _currentUser = userObject;
  }

  setCurrentUserUID(id) {
    _currentUserUID = id;
  }

  String get signedInUserProvidersUID {
    return _signedInUserProvidersUID;
  }

  Future<FirebaseUser> signInWithGoogle() async {
    final AuthService auth = AuthService();
    try {
      _setIsLoading(true);
      _signedInUser = await auth.googleSignIn();
      _signedInUserProvidersUID = _signedInUser.uid;
      return _signedInUser;
    } catch (error) {
      print("Error while signing-in: $error");
    } finally {
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
