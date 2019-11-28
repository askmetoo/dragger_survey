import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dragger_survey/src/styles.dart';
import 'package:dragger_survey/src/widgets/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:dragger_survey/src/blocs/blocs.dart';
import 'package:provider/provider.dart';

class SurveySetsListScreen extends StatefulWidget {
  final String teamId;
  SurveySetsListScreen({Key key, this.teamId}) : super(key: key);

  @override
  _SurveySetsListScreenState createState() => _SurveySetsListScreenState();
}

class _SurveySetsListScreenState extends State<SurveySetsListScreen> {
  Stream<QuerySnapshot> streamQueryTeamsForUser(
      {TeamBloc teamBloc, FirebaseUser user}) {
    Stream<QuerySnapshot> teamsQuery = teamBloc
        .streamTeamsQueryByArray(
          fieldName: 'users',
          arrayValue: user?.uid,
        )
        .handleError((err) => log(
            "ERROR in _SurveySetsListScreenState getTeamsQueryByArray: $err"));
    return teamsQuery;
  }

  @override
  Widget build(BuildContext context) {
    final TeamBloc teamBloc = Provider.of<TeamBloc>(context);
    FirebaseUser user = Provider.of<FirebaseUser>(context);

    bool loggedIn = user != null;
    if (!loggedIn) {
      log("In SurveySetsListScreen - User is not signed in!");
    }

    return StreamBuilder<QuerySnapshot>(
        stream: streamQueryTeamsForUser(teamBloc: teamBloc, user: user),
        builder:
            (BuildContext context, AsyncSnapshot<QuerySnapshot> teamsSnapshot) {
          if (teamsSnapshot.connectionState != ConnectionState.active) {
            return CircularProgressIndicator();
          }

          bool teamsSnapshotDataIsNull = teamsSnapshot.data == null;
          bool teamDocsLengthNotZero = teamsSnapshot.data.documents.length > 0;
          bool teamDocsIsEmpty = teamsSnapshot.data.documents.isEmpty;
          bool currSelectedTeamIdIsNotNull = teamDocsLengthNotZero &&
              teamsSnapshot?.data?.documents[0]?.documentID != null;

          return Scaffold(
            backgroundColor: Styles.color_AppBackground,
            endDrawer: UserDrawer(),
            appBar: AppBar(
              actions: <Widget>[
                SignedInUserCircleAvatar(),
              ],
              title: Text("Survey Sets"),
            ),
            body: Column(
              children: <Widget>[
                teamsSnapshotDataIsNull || teamDocsIsEmpty
                    ? Container()
                    : BuildTeamsDropdownButton(
                        teamsSnapshot: teamsSnapshot,
                      ),
                Expanded(
                  child: BuildSurveySetsListView(),
                ),
              ],
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: currSelectedTeamIdIsNotNull
                // CREATE A NEW SURVEY
                ? FloatingActionButton.extended(
                    elevation: 12,
                    backgroundColor: Styles.color_Secondary,
                    label: Text(
                      "Create new survey set",
                      style: TextStyle(
                        color: Styles.color_Text.withOpacity(0.8),
                      ),
                    ),
                    icon: Icon(
                      Icons.library_add,
                      color: Styles.color_SecondaryDeepDark,
                    ),
                    tooltip: "Add new Survey Set",
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              titleTextStyle: TextStyle(
                                fontFamily: 'Bitter',
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Styles.color_Text.withOpacity(.8),
                              ),
                              titlePadding: EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 4),
                              elevation: 10,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(3),
                                  bottomLeft: Radius.circular(20),
                                  bottomRight: Radius.circular(20),
                                ),
                              ),
                              title: Text("New survey set"),
                              backgroundColor: Styles.color_Secondary,
                              contentTextStyle:
                                  TextStyle(color: Styles.color_Text),
                              content: SurveySetForm(),
                            );
                          });
                    },
                  )
                :
                // CREATE A NEW TEAM
                FloatingActionButton.extended(
                    backgroundColor: Styles.color_Secondary,
                    icon: Icon(
                      Icons.people,
                      color: Styles.color_Text.withOpacity(.8),
                    ),
                    label: Text(
                      'Create new Team',
                      style: TextStyle(
                        color: Styles.color_Text.withOpacity(0.8),
                      ),
                    ),
                    onPressed: () {
                      teamBloc.updatingTeamData = false;
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text(
                              "Create new Team",
                              style: TextStyle(
                                fontFamily: 'Bitter',
                                fontWeight: FontWeight.w200,
                              ),
                            ),
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
        });
  }
}
