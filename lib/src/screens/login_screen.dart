import 'package:dragger_survey/src/blocs/sing_in_bloc.dart';
import 'package:dragger_survey/src/styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final SignInBloc signInBloc = Provider.of<SignInBloc>(context);

    print(signInBloc.signedInUser);
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
              _getSignInButtons(context: context, bloc: signInBloc)
            ],
          ),
        ),
      ),
    );
  }

  Widget _getSignInButtons({BuildContext context, SignInBloc bloc}) {
    print(
        "=====> in _getSignInButtons - bloc.signedInUser: ${bloc.signedInUser}");
    if ( (bloc?.signedInUser) != null) {
    print("-----> before _singOutButton - bloc.signedInUser: ${bloc.signedInUser}");
    return _singOutButton(context: context, bloc: bloc);
    }
    print("-----> before _signInButton - bloc.signedInUser: ${bloc.signedInUser}");
    return _signInButton(context: context, bloc: bloc);
  }

  Widget _signInButton({BuildContext context, SignInBloc bloc}) {
    return OutlineButton(
      splashColor: Styles.colorAecondary,
      onPressed: () async {
        await bloc.signInWithGoogle();
        print(
            "----> In _signInButton - bloc.signedInUser: ${bloc.signedInUser}");
        Navigator.pushNamed(context, '/home');
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
      highlightElevation: 0,
      borderSide: BorderSide(color: Styles.colorAecondary),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Sign-In with Google",
              style: TextStyle(fontSize: 20, color: Styles.colorAecondary),
            )
          ],
        ),
      ),
    );
  }

  Widget _singOutButton({BuildContext context, SignInBloc bloc}) {
    return OutlineButton(
      splashColor: Styles.colorAecondary,
      onPressed: () {
        bloc.signOut();
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
      highlightElevation: 0,
      borderSide: BorderSide(color: Styles.colorAecondary),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Sign-Out",
              style: TextStyle(fontSize: 20, color: Styles.colorAecondary),
            )
          ],
        ),
      ),
    );
  }
}
