import 'dart:developer';

import 'package:dragger_survey/src/blocs/blocs.dart';
import 'package:dragger_survey/src/styles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _loggedIn = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        backgroundColor: Styles.drg_colorAppBackground,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(
                image: AssetImage('assets/dragger-logo.png'),
              ),
              SizedBox(
                height: 50,
              ),
              buildLoginPart(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildLoginPart(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          _loggedIn
              ? Column(
                  children: <Widget>[
                    _openSurveyListButton(context: context),
                    _singOutButton(context: context),
                  ],
                )
              : _singInButton(context: context),
          Text("ConnectionStatus")
        ],
      ),
    );
  }

  Widget _singInButton({BuildContext context}) {
    final SignInBloc signInBloc = Provider.of<SignInBloc>(context);

    return OutlineButton(
      splashColor: Styles.drg_colorSecondary,
      onPressed: () async {
        FirebaseUser returnedUser = await signInBloc
            .signInWithGoogle()
            .catchError(
                (e) => print("ERROR in LoginScreen signInwithGoogle: $e "));
        log("In LoginScreen _singInButton - value of returnedUser.uid: ${returnedUser.uid}");
        if (returnedUser != null) {
          setState(() {
            _loggedIn = true;
          });
          signInBloc.createUserInDbIfNotExist(account: returnedUser);
        }
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
      highlightElevation: 0,
      borderSide: BorderSide(color: Styles.drg_colorSecondary),
      child: Padding(
        padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Text(
          "Sign-In with Google",
          style: TextStyle(fontSize: 20, color: Styles.drg_colorSecondary),
        ),
      ),
    );
  }

  Widget _openSurveyListButton({BuildContext context}) {
    return OutlineButton(
      splashColor: Styles.drg_colorSecondary,
      onPressed: () async {
        Navigator.pushNamed(context, '/surveysetslist');
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
      highlightElevation: 0,
      borderSide: BorderSide(color: Styles.drg_colorSecondary),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Open Survey Sets List",
              style: TextStyle(fontSize: 20, color: Styles.drg_colorSecondary),
            )
          ],
        ),
      ),
    );
  }

  Widget _singOutButton({BuildContext context}) {
    final SignInBloc signInBloc = Provider.of<SignInBloc>(context);

    return FlatButton(
      splashColor: Styles.drg_colorSecondary,
      onPressed: () {
        setState(() {
          _loggedIn = false;
        });
        signInBloc.logoutUser();
        Navigator.pushNamed(context, '/login');
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Sign-Out",
              style: TextStyle(fontSize: 20, color: Styles.drg_colorSecondary),
            )
          ],
        ),
      ),
    );
  }
}
