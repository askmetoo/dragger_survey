import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dragger_survey/src/enums/connectivity_status.dart';
import 'package:dragger_survey/src/shared/shared.dart';
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
  // TODO: "isOnline" maybe not necessary anymore, because firestore is set to "persistenceEnabled: true" in db.dart
  bool isOnline = true;
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
    final connectionStatus = Provider.of<ConnectivityStatus>(context);

    // TODO: Maybe not necessary anymore, because firestore is set to "persistenceEnabled: true" in db.dart
    // if (connectionStatus == ConnectivityStatus.Offline) {
    //   setState(() {
    //     isOnline = true;
    //   });
    // } else if (connectionStatus != ConnectivityStatus.Offline) {
    //   setState(() {
    //     isOnline = true;
    //   });
    // }

    bool loggedIn = user != null;
    if (!loggedIn) {
      log("In SurveySetsListScreen - User is not signed in!");
    }

    return StreamBuilder<QuerySnapshot>(
        stream: streamQueryTeamsForUser(teamBloc: teamBloc, user: user),
        builder:
            (BuildContext context, AsyncSnapshot<QuerySnapshot> teamsSnapshot) {
          if (teamsSnapshot.connectionState != ConnectionState.active) {
            return Loader();
          }

          bool teamsSnapshotDataIsNull = teamsSnapshot.data == null;

          bool teamDocsLengthNotZero = teamsSnapshot.data.documents.length > 0;

          bool teamDocsIsEmpty = teamsSnapshot.data.documents.isEmpty;

          bool currSelectedTeamIdIsNotNull = teamDocsLengthNotZero &&
              teamsSnapshot?.data?.documents[0]?.documentID != null;

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
                // CREATE A NEW SURVEY
                ? FloatingActionButton.extended(
                    elevation: 12,
                    backgroundColor:
                        isOnline // TODO: "isOnline" maybe not necessary anymore, because firestor is set to "persistenceEnabled: true" in db.dart
                            ? Styles.drg_colorSecondary
                            : Styles.drg_colorPrimary.withOpacity(.4),
                    label: Text(
                      "Create new survey set",
                      style: TextStyle(
                        color:
                            isOnline // TODO: "isOnline" maybe not necessary anymore, because firestor is set to "persistenceEnabled: true" in db.dart
                                ? Styles.drg_colorText.withOpacity(0.8)
                                : Styles.drg_colorText.withOpacity(0.3),
                      ),
                    ),
                    icon: Icon(
                      Icons.library_add,
                      color:
                          isOnline // TODO: "isOnline" maybe not necessary anymore, because firestor is set to "persistenceEnabled: true" in db.dart
                              ? Styles.drg_colorDarkerGreen
                              : Styles.drg_colorDarkerGreen.withOpacity(.4),
                    ),
                    tooltip:
                        isOnline // TODO: "isOnline" maybe not necessary anymore, because firestor is set to "persistenceEnabled: true" in db.dart
                            ? "Add new Survey Set"
                            : "Sorry, you are currently offline. Hence it is not possible to create a new Survey Set.",
                    onPressed: () {
                      if (isOnline) // TODO: "isOnline" maybe not necessary anymore, because firestor is set to "persistenceEnabled: true" in db.dart
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                titleTextStyle: TextStyle(
                                  fontFamily: 'Bitter',
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: Styles.drg_colorText.withOpacity(.8),
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
