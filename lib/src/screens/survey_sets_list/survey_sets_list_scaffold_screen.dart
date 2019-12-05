import 'dart:developer';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:dragger_survey/src/screens/survey_sets_list/widgets/widgets.dart';
import 'package:dragger_survey/src/styles.dart';
import 'package:dragger_survey/src/widgets/widgets.dart';
import 'package:dragger_survey/src/blocs/blocs.dart';

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
    final TeamBloc teamBloc = Provider.of<TeamBloc>(context, listen: true);
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
          QuerySnapshot teamSnapshotData = teamsSnapshot?.data;
          bool teamsSnapshotDataIsNull = teamSnapshotData == null;
          bool teamDocsLengthNotZero = teamSnapshotData.documents.length > 0;
          bool teamDocsIsEmpty = teamSnapshotData.documents.isEmpty;
          bool currSelectedTeamIdIsNotNull = teamDocsLengthNotZero &&
              teamSnapshotData.documents[0]?.documentID != null;

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
                    : BuildTeamsDropdownButtonRow(
                        teamSnapshotData: teamSnapshotData,
                      ),
                Expanded(
                  child: BuildSurveySetsListView(),
                ),
              ],
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: currSelectedTeamIdIsNotNull
                // CREATE A NEW SURVEY SET
                ? new CreateNewSurveySetFAB()
                :
                // CREATE A NEW TEAM
                new CreateNewTeamFAB(teamBloc: teamBloc),
          );
        });
  }
}
