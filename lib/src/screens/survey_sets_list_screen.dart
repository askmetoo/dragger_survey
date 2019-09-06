import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dragger_survey/src/screens/splash_screen.dart';
import 'package:dragger_survey/src/styles.dart';
import 'package:dragger_survey/src/widgets/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:dragger_survey/src/blocs/blocs.dart';
import 'package:provider/provider.dart';
import 'package:date_format/date_format.dart';

class SurveySetsListScreen extends StatefulWidget {
  final String teamId;
  SurveySetsListScreen({Key key, this.teamId}) : super(key: key);

  @override
  _SurveySetsListScreenState createState() => _SurveySetsListScreenState();
}

class _SurveySetsListScreenState extends State<SurveySetsListScreen> {
  String _selectedTeamId = '';
  String currentUser = '';

  @override
  Widget build(BuildContext context) {
    Provider.of<PrismSurveySetBloc>(context);
    final SignInBloc signInBloc = Provider.of<SignInBloc>(context);
    final TeamBloc teamBloc = Provider.of<TeamBloc>(context);

    var user = Provider.of<FirebaseUser>(context);
    bool loggedIn = user != null;

    return FutureBuilder<FirebaseUser>(
        future: signInBloc.currentUser,
        builder: (BuildContext context, AsyncSnapshot<FirebaseUser> snapshot) {
          if (!loggedIn) {
            log("In SurveySetsListScreen - User is not signed in!");
            return SplashScreen();
          }
          if (snapshot.connectionState == ConnectionState.none ||
              snapshot.connectionState == ConnectionState.waiting ||
              snapshot.connectionState == ConnectionState.active) {
            return CircularProgressIndicator();
          }

          if (snapshot.connectionState == ConnectionState.done) {
            return Scaffold(
              backgroundColor: Styles.drg_colorAppBackground,
              endDrawer: UserDrawer(),
              appBar: AppBar(
                actions: <Widget>[
                  SigendInUserCircleAvatar(),
                ],
                title: Text("Survey Sets"),
              ),
              body: Column(
                children: <Widget>[
                  _buildTeamsDropdownButton(context: context),
                  Expanded(
                    child: _buildSurveySetsListView(
                      context: context,
                      id: widget.teamId,
                    ),
                  ),
                ],
              ),
              floatingActionButton: FloatingActionButton(
                backgroundColor: Styles.drg_colorSecondary,
                child: Icon(
                  Icons.library_add,
                  color: Styles.drg_colorDarkerGreen,
                ),
                tooltip: "Add new Survey Set",
                onPressed: () {
                  print("Add new Survey Set button pressed");
                  print("----------=======> Current Team id: ${widget.teamId}");
                  print(
                      "----------=======> Current Team: ${teamBloc.currentTeamId}");
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
          }
          return Container();
        });
  }

  Widget _buildTeamsDropdownButton({@required context}) {
    final TeamBloc teamBloc = Provider.of<TeamBloc>(context);
    final SignInBloc signInBloc = Provider.of<SignInBloc>(context);
    FirebaseUser _user = Provider.of<FirebaseUser>(context);
    String _selectedTeamId = '';
    String _selectedTeamName = '';

    return FutureBuilder<FirebaseUser>(
        future: signInBloc.currentUser,
        builder:
            (BuildContext context, AsyncSnapshot<FirebaseUser> signInSnapshot) {
          if (signInSnapshot.connectionState == ConnectionState.none) {
            log("In SurveySetsListScreen _buildTeamsDropdownButton - ConnectionState.none");
            CircularProgressIndicator();
          }

          if (signInSnapshot.connectionState == ConnectionState.waiting) {
            log("In SurveySetsListScreen _buildTeamsDropdownButton - ConnectionState.waiting");
            CircularProgressIndicator();
          }
          if (signInSnapshot.connectionState == ConnectionState.active) {
            log("In SurveySetsListScreen _buildTeamsDropdownButton - ConnectionState.active");
            CircularProgressIndicator();
          }

          if (signInSnapshot.connectionState == ConnectionState.done) {
            Future<QuerySnapshot> teamQuery = teamBloc.getTeamsQueryByArray(
                  fieldName: 'users',
                  arrayValue: _user.uid,
                );
            return FutureBuilder<QuerySnapshot>(
                future: teamQuery,
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> teamsListSnapshot) {
                  if (teamsListSnapshot.hasError) {
                    return Center(
                      child: Container(
                        child: Text(
                            "Loading Set has error: ${teamsListSnapshot.error}"),
                      ),
                    );
                  }

                  if (teamsListSnapshot.connectionState == ConnectionState.none) print("ConnectionState.none");
                  if (teamsListSnapshot.connectionState == ConnectionState.waiting) print("ConnectionState.waiting");
                  if (teamsListSnapshot.connectionState == ConnectionState.active) print("ConnectionState.active");
                  if (teamsListSnapshot.connectionState == ConnectionState.done) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 4),
                      child: Container(
                        child: SizedBox(
                          height: 60,
                          child: DropdownButton(
                              isExpanded: true,
                              onChanged: (value) {
                                log("In SurveySetsListScreen _buildTeamsDropdownButton - ConnectionState.done value: $value");
                                setState(() {
                                  _selectedTeamId = value;
                                });
                                teamBloc.currentTeamId = value;
                                teamBloc
                                    .getTeamById(id: value)
                                    .then((returnValue) {
                                      log("In SurveySetsListScreen from teamBloc name: ${teamBloc.currentSelectedTeam.name}, description: ${teamBloc.currentSelectedTeam.description}");
                                });
                                print("Selected Team Name: $_selectedTeamName, $_selectedTeamId");
                              },
                              hint: teamBloc.currentSelectedTeam == null 
                                  ? Text(
                                      "Please Select a Team",
                                      style: TextStyle(
                                          color: Styles.drg_colorText),
                                    )
                                  : RichText(
                                      text: TextSpan(
                                        text: "Team: ",
                                        style: TextStyle(
                                            color: Styles.drg_colorText,
                                            fontSize: 22),
                                        children: [
                                          TextSpan(
                                            text: "${teamBloc.currentSelectedTeam?.name}",
                                            style: TextStyle(
                                                color: Styles.drg_colorText,
                                                fontSize: 22,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          TextSpan(
                                            text: teamBloc.currentSelectedTeam?.description != ''
                                                ? "\n${teamBloc.currentSelectedTeam?.description}"
                                                : "\nTeam has no description",
                                            style: TextStyle(
                                              color: Styles.drg_colorText,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                              disabledHint: teamBloc.currentTeamId != null
                                  ? Text("${teamBloc.currentTeamId}")
                                  : Text("You don't have any Team"),
                              items: teamsListSnapshot.data.documents
                                  .map<DropdownMenuItem>((team) {
                                return DropdownMenuItem(
                                  value: team.documentID,
                                  child: RichText(
                                    text: TextSpan(
                                      text: "${team['name']}\n",
                                      style: TextStyle(
                                        color: Styles.drg_colorText,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      children: [
                                        TextSpan(
                                          text: team['description'] != ''
                                              ? "${team['description']}"
                                              : 'Team has no description',
                                          style: TextStyle(
                                            color: Styles.drg_colorTextLighter,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }).toList()),
                        ),
                      ),
                    );
                  }
                  return Text('No Dropdown Button available');
                });
          }
          return Container();
        });
  }

  Widget _buildSurveySetsListView({BuildContext context, @required String id}) {
    final PrismSurveySetBloc surveySetsBloc =
        Provider.of<PrismSurveySetBloc>(context);
    final SignInBloc signInBloc = Provider.of<SignInBloc>(context);

    return FutureBuilder<FirebaseUser>(
        future: signInBloc.currentUser,
        builder:
            (BuildContext context, AsyncSnapshot<FirebaseUser> signInSnapshot) {
          if (signInSnapshot.connectionState == ConnectionState.active) {
            return FutureBuilder<QuerySnapshot>(
              future: surveySetsBloc.getPrismSurveySetQuery(
                  fieldName: 'createdByTeam', fieldValue: _selectedTeamId),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> surveySetSnapshot) {
                if (surveySetSnapshot.hasError) {
                  return Center(
                    child: Container(
                      child: Text(
                          "Loading Set has erroro: ${surveySetSnapshot.error}"),
                    ),
                  );
                }

                switch (surveySetSnapshot.connectionState) {
                  case ConnectionState.waiting:
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  case ConnectionState.active:
                  case ConnectionState.done:
                  default:
                    if (_selectedTeamId == '') {
                      return Center(
                        child: Container(
                          child: Text(
                            "Currently no team selected, \nplease choose a team to list \n all it's survey sets.",
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    }
                    if (surveySetSnapshot.data.documents.length <= 0 ||
                        surveySetSnapshot == null) {
                      return Center(
                        child: Container(
                          child: Text("This Team has no Survey Sets"),
                        ),
                      );
                    }

                    return ListView(
                        scrollDirection: Axis.vertical,
                        children: surveySetSnapshot.data.documents
                            .map((DocumentSnapshot snapshot) {
                          return Dismissible(
                            key: ValueKey(snapshot.data.hashCode),
                            direction: DismissDirection.endToStart,
                            onDismissed: (direction) => print(
                                '------>>> Item ${snapshot?.data['name']} is dismissed'),
                            child: ListTile(
                              onTap: () {
                                print(
                                    "Before Navigator in ListTile of Teams - teamId: ${snapshot?.documentID}");
                                Navigator.pushNamed(
                                    context, '/surveysetscaffold', arguments: {
                                  "id": "${snapshot?.documentID}"
                                });
                              },
                              title: Text(
                                "Name: ${snapshot['name']}, id: ${snapshot.documentID}",
                                style: Styles.drg_textListTitle,
                              ),
                              subtitle: Text(
                                "Created: ${formatDate(snapshot['created'].toDate(), [
                                  dd,
                                  '. ',
                                  MM,
                                  ' ',
                                  yyyy,
                                  ', ',
                                  HH,
                                  ':',
                                  nn
                                ])} by ${signInSnapshot.data.displayName}",
                                style: Styles.drg_textListContent,
                              ),
                            ),
                          );
                        }).toList());
                }
              },
            );
          }
          return Container();
        });
  }
}
