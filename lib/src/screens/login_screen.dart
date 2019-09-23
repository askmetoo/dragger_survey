import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dragger_survey/src/blocs/blocs.dart';
import 'package:dragger_survey/src/enums/connectivity_status.dart';
import 'package:dragger_survey/src/services/models.dart';
import 'package:dragger_survey/src/styles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  final GlobalKey _globalLoginKey = GlobalKey();

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
            children: [
              Image(
                image: AssetImage('assets/dragger-logo.png'),
              ),
              SizedBox(
                height: 50,
              ),
              loggedIn // User is logged in?
                  ? Column(children: [
                      _openSurveyListButton(context: context),
                      _singOutButton(context: context),
                    ])
                  : _getSignInButton(context: context),
              _getConnectionStatusText(context: context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _singOutButton({BuildContext context}) {
    final SignInBloc signInBloc = Provider.of<SignInBloc>(context);

    return FlatButton(
      splashColor: Styles.drg_colorSecondary,
      onPressed: () {
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

  Widget _getSignInButton({BuildContext context}) {
    final SignInBloc signInBloc = Provider.of<SignInBloc>(context);

    return FutureBuilder<FirebaseUser>(
        future: signInBloc.currentUser,
        builder: (BuildContext context, AsyncSnapshot<FirebaseUser> snapshot) {
          if (snapshot.connectionState == ConnectionState.none ||
              snapshot.connectionState == ConnectionState.waiting ||
              snapshot.connectionState == ConnectionState.active) {
            return CircularProgressIndicator();
          }

          if (!(snapshot.connectionState == ConnectionState.done &&
              snapshot.data?.uid == null)) {
            Container();
          }
          return Center(
            child: _signInButton(signInButtonContext: context),
          );
        });
  }

  Widget _signInButton({BuildContext signInButtonContext}) {
    final SignInBloc signInBloc = Provider.of<SignInBloc>(signInButtonContext);
    final UserBloc userBloc = Provider.of<UserBloc>(signInButtonContext);
    FirebaseUser _user = Provider.of<FirebaseUser>(signInButtonContext);
    bool loggedIn = _user != null;

    FirebaseUser _returnedLoginFirebaseUser;

    return FutureBuilder<FirebaseUser>(
        future: signInBloc.currentUser,
        builder: (signInButtonContext,
            AsyncSnapshot<FirebaseUser> currentUserSnapshot) {
          if (currentUserSnapshot.connectionState == ConnectionState.none ||
              currentUserSnapshot.connectionState == ConnectionState.waiting ||
              currentUserSnapshot.connectionState == ConnectionState.active)
            CircularProgressIndicator();

          if (currentUserSnapshot.connectionState == ConnectionState.done) {
            if (!currentUserSnapshot.hasData) {
              CircularProgressIndicator();
            }
            log("In LoginScreen value of 'currentUserSnapshot': ${currentUserSnapshot?.data?.displayName}");
            log("In LoginScreen value of 'loggedIn': $loggedIn");
            log("In LoginScreen value of '_user': $_user");

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
                    log("In LoginScreen OutlineButton 'Sign-In with Google' pressed");
                    _returnedLoginFirebaseUser =
                        await signInBloc.signInWithGoogle().catchError(
                              (error) => debugPrint(
                                  """ERROR in login_screen _signInButton() after
                                 signInBloc.signInWithGoogle()
                                 - error: $error"""),
                            );
                    log("In LoginScreen OutlineButton value of fbUser.displayName: ${_returnedLoginFirebaseUser.displayName}");
                    log("In LoginScreen OutlineButton value of fbUser.uid: ${_returnedLoginFirebaseUser.uid}");

                    QuerySnapshot returnedUserQuerySnapshot = await userBloc
                        .getUsersQuery(
                            fieldName: 'providersUID',
                            fieldValue: _returnedLoginFirebaseUser.uid)
                        .catchError(
                          (error) => log(
                              "ERROR in login_screen with getUsersQuery: $error"),
                        );

                    if (returnedUserQuerySnapshot == null ||
                        returnedUserQuerySnapshot.documents.isEmpty) {
                      log("In LoginScreen OutlineButton returnedUserQuerySnapshot is empty}");
                    }
                    if (returnedUserQuerySnapshot.documents.isEmpty ||
                        _returnedLoginFirebaseUser?.uid !=
                            returnedUserQuerySnapshot
                                ?.documents?.first?.data['providersUID']) {
                      // if (_returnedLoginFirebaseUser?.uid !=
                      //         returnedUserQuerySnapshot.documents.first.data['providersUID']) {
                      log("In LoginScreen - USER not id DB");
                      try {
                        log("returnedUserQuerySnapshot?.documents[0]['providersUID']: ${returnedUserQuerySnapshot?.documents[0]['providersUID']}");
                      } catch (e) {
                        log("ERROR returnedUserQuerySnapshot?.documents[0]['providersUID'] is empty: $e");
                      }
                      log("_returnedLoginFirebaseUser?.uid: ${_returnedLoginFirebaseUser?.uid}");
                      log("_returnedLoginFirebaseUser?.displayName: ${_returnedLoginFirebaseUser?.displayName}");
                      try {
                        User newUser = User(
                          providersUID: _returnedLoginFirebaseUser?.uid,
                          displayName: _returnedLoginFirebaseUser?.displayName,
                          email: _returnedLoginFirebaseUser?.email,
                          created: DateTime.now(),
                          photoUrl: _returnedLoginFirebaseUser?.photoUrl,
                          providerId: _returnedLoginFirebaseUser?.providerId,
                        );
                        userBloc.addUserToDb(user: newUser);
                        log("SUCCESS in 'login_screen' with adding User to DB");
                        print(
                            "------------------------------------------------------");
                        print("Added data:");
                        QuerySnapshot returnedAddedataFromDb = await userBloc
                            .getUsersQuery(
                                fieldName: 'providersUID',
                                fieldValue: _returnedLoginFirebaseUser?.uid)
                            .catchError((error) => log(
                                "ERROR In login_screen getUsersQuery: $error"));
                        print("RETURNED USER DATA after adding to DB:");
                        print(
                            "${returnedAddedataFromDb.documents[0]['providersUID']}");
                        print(
                            "${returnedAddedataFromDb.documents[0]['displayName']}");
                        print(
                            "${returnedAddedataFromDb.documents[0]['email']}");
                        print(
                            "${returnedAddedataFromDb.documents[0]['photoUrl']}");
                        print(
                            "${returnedAddedataFromDb.documents[0]['providerId']}");
                        print(
                            "ROUTING NEW USER to first screen '/surveysetslist");
                      } catch (err) {
                        print(
                            "ERROR in 'login_screen' with adding User to DB: $err");
                      }
                      Navigator.pushNamed(
                              signInButtonContext, '/surveysetslist')
                          // Navigator.pushNamed(_globalLoginKey.currentContext,
                          //         '/surveysetslist')
                          .catchError((err) => print(
                              "ERROR In 'login_screen' routing to pushedNamed: $err"));
                    } else if (loggedIn ||
                        returnedUserQuerySnapshot
                            .documents.first.data.isNotEmpty ||
                        currentUserSnapshot.data?.uid ==
                            returnedUserQuerySnapshot.documents[0]
                                ['providersUID']) {
                      log("USER found id DB");
                      print("ROUTING to first screen '/surveysetslist");
                      await Navigator.pushNamed(
                          signInButtonContext, '/surveysetslist');
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
            if (!signInSnapshot.hasData) {
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

  Widget _getConnectionStatusText({BuildContext context}) {
    final connectionStatus = Provider.of<ConnectivityStatus>(context);

    print("connectionStatus: $connectionStatus");

    if (connectionStatus == ConnectivityStatus.WiFi ||
        connectionStatus == ConnectivityStatus.Cellular ||
        connectionStatus == ConnectivityStatus.Offline) {
      return Text(
        "You are connected via ${connectionStatus.toString().split('.')[1]}",
        style: TextStyle(
          fontSize: 14,
          color: Styles.drg_colorSecondaryDeepDark.withOpacity(0.6),
        ),
      );
    }
    return Container();
    // return Padding(
    //   padding: const EdgeInsets.only(top: 14.0),
    //   child: Text(
    //     "No connection status available",
    //     style: TextStyle(
    //       fontSize: 14,
    //       color: Styles.drg_colorText.withOpacity(0.6),
    //     ),
    //   ),
    // );
  }
}
