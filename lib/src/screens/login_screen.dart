import 'package:dragger_survey/src/blocs/blocs.dart';
import 'package:dragger_survey/src/enums/connectivity_status.dart';
import 'package:dragger_survey/src/styles.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
              _openSurveyListButton(context: context, bloc: signInBloc),
              _getSignInButtons(context: context, bloc: signInBloc),
              _getConnectionStatusText(context: context),
              // _getCurrentUserStatus(context: context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _getSignInButtons({BuildContext context, SignInBloc bloc}) {
    // String _currentUserId;

    return FutureBuilder(
        future: bloc.currentUser,
        builder: (BuildContext context, AsyncSnapshot<FirebaseUser> snapshot) {
          if (snapshot.data == null) {
            return _signInButton(context: context, bloc: bloc);
          }
          return _singOutButton(context: context, bloc: bloc);
        });
  }

  Widget _signInButton({BuildContext context, SignInBloc bloc}) {
    final UserBloc userBloc = Provider.of<UserBloc>(context);
    String _signedInUser = '';

    return FutureBuilder<FirebaseUser>(
        future: bloc.currentUser,
        builder: (context, snapshot) {
          if (snapshot.data == null || snapshot.data.uid.isEmpty) {
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
                    await bloc.signInWithGoogle()
                    .catchError((error) => print(
                          "ERROR after await bloc.signInWithGoogle() - error: $error"));
                    
                    var returnedUser = await userBloc.getUsersQuery(
                        fieldName: 'providersUID',
                        fieldValue: bloc.signedInUserProvidersUID);

                    if (returnedUser.documents.isEmpty ||
                        _signedInUser !=
                            returnedUser?.documents[0]['providersUID']) {
                      print("USER not id DB");
                      try {
                        Map<String, dynamic> newUser = {
                          "providersUID": bloc.signedInUserProvidersUID,
                          "displayName": bloc.signedInUser.displayName,
                          "email": bloc.signedInUser.email,
                          "photoUrl": bloc.signedInUser.photoUrl,
                          "providerId": bloc.signedInUser.providerId,
                        };
                        userBloc.addUserToDb(user: newUser);
                        print(
                            "SUCCESS in 'login_screen.dart' with adding User to DB");
                        print(
                            "------------------------------------------------------");
                        print("Added data:");
                        var returnedUser = await userBloc.getUsersQuery(
                            fieldName: 'providersUID',
                            fieldValue: bloc.signedInUserProvidersUID);
                        print("RETURNED USER after adding to DB:");
                        print("${returnedUser?.documents[0]['providersUID']}");
                        print("${returnedUser?.documents[0]['displayName']}");
                        print("${returnedUser?.documents[0]['email']}");
                        print("${returnedUser?.documents[0]['photoUrl']}");
                        print("${returnedUser?.documents[0]['providerId']}");
                        print(
                            "ROUTING NEW USER to first screen '/surveysetslist");
                        Navigator.pushNamed(context, '/surveysetslist');
                      } catch (err) {
                        print(
                            "ERROR in 'login_screen.dart' with adding User to DB: $err");
                      }
                    } else if (returnedUser.documents.isNotEmpty ||
                        _signedInUser ==
                            returnedUser?.documents[0]['providersUID']) {
                      print("USER found id DB");
                      print("RETURNED USER's display name and providersUID: ");
                      print("${returnedUser?.documents[0]['displayName']}");
                      print("${returnedUser?.documents[0]['providersUID']}");
                      print(
                          "ROUTING EXISTING USER to first screen '/surveysetslist");
                      Navigator.pushNamed(context, '/surveysetslist');
                    } else {
                      print("In login_screen it's xmas time!!!");
                    }
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40)),
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
                          style: TextStyle(
                              fontSize: 20, color: Styles.drg_colorSecondary),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            );
          }
          return Container();
        });
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

  Widget _openSurveyListButton({BuildContext context, SignInBloc bloc}) {
    return FutureBuilder<FirebaseUser>(
        future: bloc.currentUser,
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return Text("No snapshot data");
          } else if (snapshot.data.uid == null) {
            return Text(
                "No signedInUser (${bloc?.signedInUser}) or _currentUserId (${bloc.signedInUserProvidersUID})?");
          }
          if (snapshot.data.uid != null) {
            print(
                "-----> 1) In _openSurveyListButton - bloc.currentUserUID: ${bloc.currentUserUID}");
            return OutlineButton(
              splashColor: Styles.drg_colorSecondary,
              onPressed: () async {
                Navigator.pushNamed(context, '/surveysetslist');
              },
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40)),
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
                      style: TextStyle(
                          fontSize: 20, color: Styles.drg_colorSecondary),
                    )
                  ],
                ),
              ),
            );
          }
          return Text("To be done.");
        });
  }

  Text _getConnectionStatusText({BuildContext context}) {
    final connectionStatus = Provider.of<ConnectivityStatus>(context);

    print("connectionStatus: $connectionStatus");

    if (connectionStatus == ConnectivityStatus.WiFi) {
      return Text("You're connected via WiFi.");
    } else if (connectionStatus == ConnectivityStatus.Cellular) {
      return Text("You're connected via Mobile Network.");
    } else if (connectionStatus == ConnectivityStatus.Offline) {
      return Text("Your connection is offline.");
    }
    return Text("Don't know more about the connection");
  }

  Widget _getCurrentUserStatus({BuildContext context}) {
    final SignInBloc signInBloc = Provider.of<SignInBloc>(context);

    return Container(
      child: FutureBuilder(
        future: signInBloc.currentUser,
        builder: (BuildContext context, AsyncSnapshot<FirebaseUser> snapshot) {
          if (snapshot.hasData) {
            signInBloc.setCurrentUser(snapshot.data);
            signInBloc.setCurrentUserUID(snapshot.data.uid);
            print(
              '1) In login_screen.dart _getCurrentUserStatus _currentUser in future signInBloc.currentUser.uid: ${snapshot.data.uid} \n2) signedInUserProvidersUID: ${signInBloc.signedInUserProvidersUID}',
            );
            return Text(
              '1) In login_screen.dart _getCurrentUserStatus _currentUser in future signInBloc.currentUser.uid: ${snapshot.data.uid} \n2) signedInUserProvidersUID: ${signInBloc.signedInUserProvidersUID}',
            );
          }
          return Text('No snapshot data');
        },
      ),
    );
  }
}
