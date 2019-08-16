import 'package:dragger_survey/src/blocs/sing_in_bloc.dart';
import 'package:dragger_survey/src/styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final SignInBloc signInBloc = Provider.of<SignInBloc>(context);

    return Scaffold(
      body: Container(
        color: Styles.appBackground,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image(
                image: AssetImage('assets/dragger-logo.png'),
              ),
              SizedBox(
                height: 50,
              ),
              _backToSurveyListButton(context: context, bloc: signInBloc),
              _getSignInButtons(context: context, bloc: signInBloc)
            ],
          ),
        ),
      ),
    );
  }

  Widget _getSignInButtons({BuildContext context, SignInBloc bloc}) {
    if ((bloc?.signedInUser) != null) {
      return _singOutButton(context: context, bloc: bloc);
    }
    return _signInButton(context: context, bloc: bloc);
  }

  Widget _signInButton({BuildContext context, SignInBloc bloc}) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Text(
            "You are currently not signed-in.",
            style: TextStyle(
              color: Styles.colorSecondary,
            ),
          ),
        ),
        OutlineButton(
          splashColor: Styles.colorSecondary,
          onPressed: () async {
            await bloc.signInWithGoogle();
            Navigator.pushNamed(context, '/home');
          },
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
          highlightElevation: 0,
          borderSide: BorderSide(color: Styles.colorSecondary),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Sign-In with Google",
                  style: TextStyle(fontSize: 20, color: Styles.colorSecondary),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _singOutButton({BuildContext context, SignInBloc bloc}) {
    return FlatButton(
      splashColor: Styles.colorSecondary,
      onPressed: () {
        bloc.signOut();
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
              style: TextStyle(fontSize: 20, color: Styles.colorSecondary),
            )
          ],
        ),
      ),
    );
  }

  Widget _backToSurveyListButton({BuildContext context, SignInBloc bloc}) {
    if (bloc.signedInUser == null) {
      return Container();
    }
    return OutlineButton(
      splashColor: Styles.colorSecondary,
      onPressed: () async {
        Navigator.pushNamed(context, '/home');
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
      highlightElevation: 0,
      borderSide: BorderSide(color: Styles.colorSecondary),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Back to Survey Sets List",
              style: TextStyle(fontSize: 20, color: Styles.colorSecondary),
            )
          ],
        ),
      ),
    );
  }
}
