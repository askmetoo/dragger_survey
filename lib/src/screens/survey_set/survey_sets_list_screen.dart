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
  Future<QuerySnapshot> queryTeamsForUser(
      {TeamBloc teamBloc, FirebaseUser user}) async {
    QuerySnapshot teamsQuery = await teamBloc
        .getTeamsQueryByArray(
          fieldName: 'users',
          arrayValue: user?.uid,
        )
        .catchError((err) => log(
            "ERROR in BuildTeamsDropdownButton getTeamsQueryByArray: $err"));
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

    return FutureBuilder<QuerySnapshot>(
        future: queryTeamsForUser(teamBloc: teamBloc, user: user),
        builder:
            (BuildContext context, AsyncSnapshot<QuerySnapshot> teamsSnapshot) {
          if (teamsSnapshot.connectionState != ConnectionState.done) {
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
          } else if (!teamsSnapshot.hasData) {
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

          bool teamsSnapshotDataIsNull = teamsSnapshot.data == null;
          log("oooooo===========-------> teamsSnapshotDataIsNull: $teamsSnapshotDataIsNull");

          int teamDocsLength = teamsSnapshot.data.documents.length;
          log("oooooo===========-------> teamDocsLength: $teamDocsLength");

          bool teamDocsLengthNotZero = teamsSnapshot.data.documents.length > 0;
          log("oooooo===========-------> teamDocsLengthNotZero: $teamDocsLengthNotZero");

          bool teamDocsIsEmpty = teamsSnapshot.data.documents.isEmpty;
          log("oooooo===========-------> teamDocsIsEmpty: $teamDocsIsEmpty");

          bool currSelectedTeamIdIsNotNull = teamDocsLengthNotZero &&
              teamsSnapshot?.data?.documents[0]?.documentID != null;
          log("oooooo===========-------> currSelectedTeamIdIsNotNull: $currSelectedTeamIdIsNotNull");

          if (teamDocsLengthNotZero) {
            String snapShotCurrSelectedTeamId =
                teamsSnapshot.data.documents[0].documentID;
            log("oooooo===========-------> snapShotCurrSelectedTeamId: $snapShotCurrSelectedTeamId");
          }

          return Scaffold(
            backgroundColor: Styles.drg_colorAppBackground,
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
                // && teamDocsLengthNotZero
                // CREATE A NEW SURVEY
                ? FloatingActionButton.extended(
                    elevation: 12,
                    backgroundColor: Styles.drg_colorSecondary,
                    label: Text(
                      "Create new survey set",
                      style: TextStyle(
                        color: Styles.drg_colorText.withOpacity(0.8),
                      ),
                    ),
                    icon: Icon(
                      Icons.library_add,
                      color: Styles.drg_colorDarkerGreen,
                    ),
                    tooltip: "Add new Survey Set",
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
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
                              backgroundColor: Styles.drg_colorSecondary,
                              contentTextStyle:
                                  TextStyle(color: Styles.drg_colorText),
                              content: SurveySetForm(),
                            );
                          });
                    },
                  )
                :
                // CREATE A NEW TEAM
                FloatingActionButton.extended(
                    backgroundColor: Styles.drg_colorSecondary,
                    icon: Icon(
                      Icons.people,
                      color: Styles.drg_colorText.withOpacity(.8),
                    ),
                    label: Text(
                      'Create new Team',
                      style: TextStyle(
                        color: Styles.drg_colorText.withOpacity(0.8),
                      ),
                    ),
                    onPressed: () {
                      print(
                          "In SurveySetsListScreen 'Create new Team' button pressed");
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
                            backgroundColor: Styles.drg_colorSecondary,
                            contentTextStyle:
                                TextStyle(color: Styles.drg_colorText),
                          );
                        },
                      );
                    },
                  ),
          );
        });
  }
}
