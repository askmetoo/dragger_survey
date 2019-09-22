import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dragger_survey/src/blocs/blocs.dart';
import 'package:dragger_survey/src/enums/connectivity_status.dart';
import 'package:dragger_survey/src/styles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  Widget _signInButton({BuildContext context}) {
    final SignInBloc signInBloc = Provider.of<SignInBloc>(context);
    final UserBloc userBloc = Provider.of<UserBloc>(context);
    FirebaseUser _user = Provider.of<FirebaseUser>(context);
    bool loggedIn = _user != null;
    GlobalKey _globalLoginKey = GlobalKey();

    return FutureBuilder<FirebaseUser>(
        future: signInBloc.currentUser,
        builder: (BuildContext context, AsyncSnapshot<FirebaseUser> currentUserSnapshot) {
          if (
            currentUserSnapshot.connectionState == ConnectionState.none ||
            currentUserSnapshot.connectionState == ConnectionState.waiting ||
            currentUserSnapshot.connectionState == ConnectionState.active
            ) CircularProgressIndicator();

          if (currentUserSnapshot.connectionState == ConnectionState.done) {
            if (!currentUserSnapshot.hasData) {
              CircularProgressIndicator();
            }
            log("In LoginScreen currentUserSnapshot: ${currentUserSnapshot?.data?.displayName}");
            log("In LoginScreen loggedIn: $loggedIn");
            log("In LoginScreen _user: $_user");
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
                  key: _globalLoginKey,
                  splashColor: Styles.drg_colorSecondary,
                  onPressed: () async {
                    signInBloc.signInWithGoogle().catchError(
                          (error) => debugPrint(
                              "ERROR in login_screen _signInButton() after signInBloc.signInWithGoogle() - error: $error"),
                        );

                    QuerySnapshot returnedUser = await userBloc
                        .getUsersQuery(
                            fieldName: 'providersUID',
                            fieldValue: currentUserSnapshot.data?.uid)
                        .catchError(
                          (error) => log(
                              "ERROR in login_screen with getUsersQuery: $error"),
                        );

                    if (returnedUser == null ||
                        currentUserSnapshot.data?.uid !=
                            returnedUser.documents[0]['providersUID']) {
                      print("USER not id DB");
                      try {
                        Map<String, dynamic> newUser = {
                          "providersUID": currentUserSnapshot.data?.uid,
                          "displayName": currentUserSnapshot.data?.displayName,
                          "email": currentUserSnapshot.data?.email,
                          "photoUrl": currentUserSnapshot.data?.photoUrl,
                          "providerId": currentUserSnapshot.data?.providerId,
                        };
                        userBloc.addUserToDb(user: newUser);
                        log(
                            "SUCCESS in 'login_screen' with adding User to DB");
                        print(
                            "------------------------------------------------------");
                        print("Added data:");
                        var returnedUser = await userBloc
                            .getUsersQuery(
                                fieldName: 'providersUID',
                                fieldValue: currentUserSnapshot.data?.uid)
                            .catchError((error) => print(
                                "ERROR In login_screen getUsersQuery: $error"));
                        // fieldValue: bloc.signedInUserProvidersUID).catchError((error) => print("ERROR In login_screen getUsersQuery: $error"));
                        print("RETURNED USER after adding to DB:");
                        print("${returnedUser.documents[0]['providersUID']}");
                        print("${returnedUser.documents[0]['displayName']}");
                        print("${returnedUser.documents[0]['email']}");
                        print("${returnedUser.documents[0]['photoUrl']}");
                        print("${returnedUser.documents[0]['providerId']}");
                        print(
                            "ROUTING NEW USER to first screen '/surveysetslist");
                        Navigator.pushNamed(_globalLoginKey.currentContext, '/surveysetslist')
                            .catchError((err) => print(
                                "ERROR In 'login_screen' routing to pushedNamed: $err"));
                      } catch (err) {
                        print(
                            "ERROR in 'login_screen' with adding User to DB: $err");
                      }
                    } else if (loggedIn || returnedUser.documents.first.data.isNotEmpty ||
                        currentUserSnapshot.data?.uid ==
                            returnedUser.documents[0]['providersUID']
                            ) {
                      log("USER found id DB");
                      print("RETURNED USER's display name and providersUID: ");
                      print("${returnedUser.documents[0]['displayName']}");
                      print("${returnedUser.documents[0]['providersUID']}");
                      print(
                          "ROUTING EXISTING USER to first screen '/surveysetslist");
                      Navigator.pushNamed(_globalLoginKey.currentContext, '/surveysetslist');
                    } else {
                      print("In 'login_screen' it's xmas time!!!");
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

  Widget _singOutButton({BuildContext context}) {
    final SignInBloc signInBloc = Provider.of<SignInBloc>(context);

    return FlatButton(
      splashColor: Styles.drg_colorSecondary,
      onPressed: () {
        signInBloc.logoutUser();
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

  Widget _getSignInButtons({BuildContext context}) {
    final SignInBloc signInBloc = Provider.of<SignInBloc>(context);

    return FutureBuilder<FirebaseUser>(
        future: signInBloc.currentUser,
        builder: (BuildContext context, AsyncSnapshot<FirebaseUser> snapshot) {
          if (snapshot.connectionState == ConnectionState.none ||
              snapshot.connectionState == ConnectionState.waiting ||
              snapshot.connectionState == ConnectionState.active
              ) CircularProgressIndicator();

          if (snapshot.connectionState == ConnectionState.done) {
            // if(!snapshot.hasData) {
            //   return CircularProgressIndicator();
            // }
            if (snapshot.data?.uid == null) {
              return _signInButton(context: context);
            }
            return _singOutButton(context: context);
          }

          return Container();
        });
  }

  Widget _openSurveyListButton({BuildContext context}) {
    final SignInBloc signInBloc = Provider.of<SignInBloc>(context);

    return FutureBuilder<FirebaseUser>(
        future: signInBloc.currentUser,
        builder:
            (BuildContext context, AsyncSnapshot<FirebaseUser> signInSnapshot) {
          if (signInSnapshot.connectionState == ConnectionState.none ||
              signInSnapshot.connectionState == ConnectionState.waiting ||
              signInSnapshot.connectionState == ConnectionState.active) {
            // return Text("Active state");
            return CircularProgressIndicator();
          }

          if (signInSnapshot.connectionState == ConnectionState.done) {
            if(!signInSnapshot.hasData) {
              return CircularProgressIndicator();
            }
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
            // break;
          }
          return Container();
        });
  }

  Text _getConnectionStatusText({BuildContext context}) {
    final connectionStatus = Provider.of<ConnectivityStatus>(context);

    print("connectionStatus: $connectionStatus");

    if (connectionStatus == ConnectivityStatus.WiFi ||
        connectionStatus == ConnectivityStatus.Cellular ||
        connectionStatus == ConnectivityStatus.Offline) {
      return Text(
        "You are connected via ${connectionStatus.toString().split('.')[1]}",
        style: TextStyle(fontSize: 20, color: Styles.drg_colorSecondaryDeepDark),
      );
    }
    return Text("Don't know more about the connection");
  }

  @override
  Widget build(BuildContext context) {
    FirebaseUser _user = Provider.of<FirebaseUser>(context);
    bool loggedIn = _user != null;

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
              loggedIn
                  ? _openSurveyListButton(context: context)
                  : _getSignInButtons(context: context),
              loggedIn ? _singOutButton(context: context) : Container(),
              _getConnectionStatusText(context: context),
            ],
          ),
        ),
      ),
    );
  }
}
