import 'dart:developer';

import 'package:dragger_survey/src/widgets/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dragger_survey/src/styles.dart';
import 'package:dragger_survey/src/blocs/blocs.dart';
import 'package:dragger_survey/src/screens/login/splash_screen.dart';

class TeamsListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final TeamBloc teamBloc = Provider.of<TeamBloc>(context);
    final SignInBloc signInBloc = Provider.of<SignInBloc>(context);

    return FutureBuilder<FirebaseUser>(
        future: signInBloc.currentUser,
        builder: (BuildContext context, AsyncSnapshot<FirebaseUser> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (!snapshot.hasData) {
              return Center(
                child: Container(
                  constraints: BoxConstraints(maxWidth: 50),
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: CircularProgressIndicator(
                      strokeWidth: 10,
                    ),
                  ),
                ),
              );
            }

            if (snapshot.data.uid == null) {
              log("In teams_list_screen - User is not signed in! - forward to SplashScreen()");
              return SplashScreen();
            }
            return Scaffold(
              backgroundColor: Styles.color_AppBackground,
              endDrawer: UserDrawer(),
              appBar: AppBar(
                actions: <Widget>[
                  SignedInUserCircleAvatar(),
                ],
                title: Text("You're memder of these teams"),
              ),
              body: buildTeamsListView(
                context: context,
              ),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerFloat,
              floatingActionButton: FloatingActionButton.extended(
                backgroundColor: Styles.color_Secondary,
                label: Text(
                  "Create new Team",
                  style: TextStyle(
                    color: Styles.color_Text.withOpacity(0.8),
                  ),
                ),
                icon: Icon(
                  Icons.people,
                  color: Styles.color_DarkerGreen,
                ),
                tooltip: "Create new Team",
                onPressed: () {
                  print("Add new Team button pressed");
                  teamBloc.updatingTeamData = false;
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("Create new Team"),
                        content: CreateTeamForm(),
                        elevation: 10,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(3),
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                          ),
                        ),
                        backgroundColor: Styles.color_Secondary,
                        contentTextStyle:
                            TextStyle(color: Styles.color_Text),
                      );
                    },
                  );
                },
              ),
            );
          }
          return Container();
        });
  }
}
