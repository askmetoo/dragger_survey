import 'package:dragger_survey/src/blocs/sing_in_bloc.dart';
import 'package:dragger_survey/src/blocs/user_bloc.dart';
import 'package:dragger_survey/src/styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final SignInBloc signInBloc = Provider.of<SignInBloc>(context);

    return Scaffold(
      body: Container(
        color: Styles.drg_colorAppBackground,
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
              _getSignInButtons(context: context, bloc: signInBloc),
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
    final UserBloc userBloc = Provider.of<UserBloc>(context);
    String _signedInUser = '';

    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Text(
            "You are currently not signed-in.",
            style: TextStyle(
              color: Styles.drg_colorSecondary,
            ),
          ),
        ),
        OutlineButton(
          splashColor: Styles.drg_colorSecondary,
          onPressed: () async {
            await bloc.signInWithGoogle();
            _signedInUser = bloc.signedInUser.uid;
            print("USER UID after Google SignIn: $_signedInUser (in SignInBloc)");
            var returnedUser = await userBloc.getUsersQuery(fieldName: 'providersUID', fieldValue: bloc.signedInUser.uid);
            var returnedUserUID = returnedUser?.documents[0]['providersUID'];
            bloc.signedInUserProvidersUID = returnedUserUID;
            
            if (returnedUser.documents.isEmpty || _signedInUser != returnedUser?.documents[0]['providersUID']) {
              print("USER not id DB");
              try {
                Map<String, dynamic> newUser = {
                  "providersUID": bloc.signedInUser.uid,
                  "displayName": bloc.signedInUser.displayName,
                  "email": bloc.signedInUser.email,
                  "photoUrl": bloc.signedInUser.photoUrl,
                  "providerId": bloc.signedInUser.providerId,                  
                };
                userBloc.addUserToDb(user: newUser);
                print("SUCCESS in 'login_screen.dart' with adding User to DB");
                print("------------------------------------------------------");
                print("Added data:");
                var returnedUser = await userBloc.getUsersQuery(fieldName: 'providersUID', fieldValue: bloc.signedInUser.uid);
                print("RETURNED USER after adding to DB:");
                print("${returnedUser?.documents[0]['providersUID']}");
                print("${returnedUser?.documents[0]['displayName']}");
                print("${returnedUser?.documents[0]['email']}");
                print("${returnedUser?.documents[0]['photoUrl']}");
                print("${returnedUser?.documents[0]['providerId']}"); 
                print("ROUTING to first screen '/surveysetslist");
                Navigator.pushNamed(context, '/surveysetslist');
              } catch (err) {
                print("ERROR in 'login_screen.dart' with adding User to DB: $err");
              }
            } else if (returnedUser.documents.isNotEmpty || _signedInUser == returnedUser?.documents[0]['providersUID']) {
              print("USER found id DB");
              print("RETURNED USER's display name and providersUID: ");
              print("${returnedUser?.documents[0]['displayName']}");
              print("${returnedUser?.documents[0]['providersUID']}");
              print("ROUTING to first screen '/surveysetslist");
              Navigator.pushNamed(context, '/surveysetslist');
            } else {
              print("DUNNO what to do!!!");
            }
          },
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
          highlightElevation: 0,
          borderSide: BorderSide(color: Styles.drg_colorSecondary),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Sign-In with Google",
                  style: TextStyle(fontSize: 20, color: Styles.drg_colorSecondary),
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
      splashColor: Styles.drg_colorSecondary,
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
              style: TextStyle(fontSize: 20, color: Styles.drg_colorSecondary),
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
      splashColor: Styles.drg_colorSecondary,
      onPressed: () async {
        Navigator.pushNamed(context, '/surveysetslist');
        // Navigator.pushNamed(context, '/teams');
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
              "Back to my Survey Sets List",
              style: TextStyle(fontSize: 20, color: Styles.drg_colorSecondary),
            )
          ],
        ),
      ),
    );
  }
}
