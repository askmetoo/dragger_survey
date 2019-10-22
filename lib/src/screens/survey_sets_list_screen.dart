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
          // log("In SurveySetsListScreen - value of teamsSnapshot.data.documents.length: ${teamsSnapshot.data.documents.length}");
          // log("In SurveySetsListScreen - value of teamsSnapshot.data.documents[0].documentID: ${teamsSnapshot.data.documents[0].documentID}");
          // log("In SurveySetsListScreen - value of teamsSnapshot.data.documents.isEmpty: ${teamsSnapshot.data.documents.isEmpty}");
          if (teamsSnapshot.connectionState != ConnectionState.done) {
            return CircularProgressIndicator();
          } else if (!teamsSnapshot.hasData) {
            return CircularProgressIndicator();
          } else if (teamsSnapshot.data.documents.isNotEmpty) {
            teamBloc.setCurrentSelectedTeamId(
                teamsSnapshot?.data?.documents[0].documentID);
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
                BuildTeamsDropdownButton(),
                Expanded(
                  child: BuildSurveySetsListView(),
                ),
              ],
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton:
                (teamBloc?.currentSelectedTeam?.documentID == null &&
                        teamsSnapshot.data.documents.length < 1)
                    ? teamsSnapshot.data.documents.isEmpty
                        ? FloatingActionButton.extended(
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
                              // TODO:
                              print(
                                  "In SurveySetsListScreen 'Create new Team' button pressed");
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
                                    backgroundColor: Styles.drg_colorSecondary,
                                    contentTextStyle:
                                        TextStyle(color: Styles.drg_colorText),
                                  );
                                },
                              );
                            },
                          )
                        : null
                    : FloatingActionButton.extended(
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
                      ),
          );
        });
  }
}
