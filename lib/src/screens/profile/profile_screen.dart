import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:dragger_survey/src/blocs/blocs.dart';
import 'package:dragger_survey/src/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:dragger_survey/src/styles.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';


class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    FirebaseUser user = Provider.of<FirebaseUser>(context);
    final SignInBloc signInBloc = Provider.of<SignInBloc>(context);
    final UserBloc userBloc = Provider.of<UserBloc>(context);
    final TeamBloc teamBloc = Provider.of<TeamBloc>(context);
    final PrismSurveySetBloc surveySetBloc = Provider.of<PrismSurveySetBloc>(context);

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    void _showDialog({@required userId}) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title:
                new Text("Are you sure to delete your account from Dragger?"),
            content: new Text("This action isn't reversible!"),
            actions: <Widget>[
              FlatButton(
                child: Text(
                  "No, cancel action",
                  style: TextStyle(color: Styles.drg_colorTextMediumDark),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              MaterialButton(
                child: Text("Yes, please"),
                color: Styles.drg_colorAttention,
                elevation: 4,
                onPressed: () async {

                  QuerySnapshot teamsFromUser;
                  QuerySnapshot surveySetsByUser;

                  // 1) Find all Teams created by USER
                  teamsFromUser = await teamBloc.getTeamsQuery(fieldName: 'createdByUser', fieldValue: userId);
                  teamsFromUser.documents.forEach((team) {
                    print("-----> Teams user is member ID: ${team.documentID}");
                  });

                  teamsFromUser.documents.forEach((team) async {
                    log("In ProfileScreen - delete Team with ID ${team.documentID}");

                    // 2) find all SurveySets from Team
                    surveySetsByUser = await surveySetBloc.getPrismSurveySetQuery(fieldName: 'createdByTeam', fieldValue: team.documentID);

                    // 3) Remove each teams Survey Sets and every Sets Surveys
                    surveySetsByUser.documents.forEach((surveySet) async {
                      log("In ProfileScreen - delete PrismSurveySet with ID ${surveySet.documentID}");

                      // First find remove the SURVEYS
                      await surveySetBloc.deleteAllSurveysFromSurveySetById(surveySetId: surveySet.documentID);
                      // Then find remove the SET itself
                      await surveySetBloc.deletePrismSurveySetById(surveySetId: surveySet.documentID);
                    });

                  });

                  // 4) Find and remove all TEAMS from this User
                  await teamBloc.getTeamsQuery(fieldName: 'createdByUser', fieldValue: userId)
                                .then((QuerySnapshot teams) {
                                  teams.documents.forEach((team) {
                                    print("-----> Teams user is member ID: ${team..documentID}");
                                    teamBloc.deleteTeamByIdOnlyIfUserIsOwner(id: team.documentID);
                                  });
                                });

                  // Remove USER FROM all TEAMS he is MEMBER in
                  teamBloc.deleteUserFromTeamsArrayById(id: userId);

                  // Remove USER
                  userBloc.deleteUserByIdQuery(id: userId);

                  Navigator.pop(context, true);
                  Navigator.pushNamed(context, '/login');
                  signInBloc.logoutUser();
                },
              ),
            ],
          );
        },
      );
    }

    return FutureBuilder<FirebaseUser>(
      future: signInBloc.currentUser,
      builder: (context, signinSnapshot) {
        if (signinSnapshot.connectionState != ConnectionState.done) {
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
        if(user == null) {
          return Container();
        }
        return FutureBuilder<QuerySnapshot>(
            future: userBloc.getUsersQuery(
                fieldName: 'providersUID', fieldValue: user.uid),
            builder: (context, usersSnapshot) {
              if (usersSnapshot.connectionState != ConnectionState.done) {
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
              } else if (!usersSnapshot.hasData) {
                return Container(
                  color: Colors.red,
                );
              }
              return Scaffold(
                backgroundColor: Styles.drg_colorSecondary,
                appBar: AppBar(
                  title: Text(
                    "Your Profile",
                    textAlign: TextAlign.center,
                  ),
                ),
                body: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  physics: BouncingScrollPhysics(),
                  child: Container(
                    height: !isPortrait ? screenHeight * 2 : screenHeight * .9,
                    padding: EdgeInsets.symmetric(horizontal: 0, vertical: 12),
                    alignment: Alignment.topCenter,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        SignedInUserCircleAvatar(
                          radiusSmall: isPortrait
                              ? screenWidth * .17
                              : screenWidth * .05,
                        ),
                        Text(
                          "${signinSnapshot.data.displayName}",
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        Text(
                          "${signinSnapshot.data.email}",
                          style: TextStyle(fontSize: 16),
                        ),
                        Text(
                          "Email: ${signinSnapshot.data.email}",
                          style: TextStyle(fontSize: 16),
                        ),
                        Text(
                          "Created: ${formatDate(usersSnapshot.data.documents[0]['created'].toDate(), [
                            DD,
                            ' ',
                            dd,
                            '.',
                            MM,
                            '.',
                            yyyy
                          ])}",
                          style: TextStyle(fontSize: 16),
                        ),
                        Spacer(
                          flex: 1,
                        ),
                        SizedBox(
                          width:
                              isPortrait ? screenWidth * .5 : screenWidth * .3,
                          child: FlatButton.icon(
                            label: Text('Delete Account'),
                            icon: Icon(Icons.delete_forever),
                            disabledColor:
                                Colors.orange.shade50.withOpacity(0.4),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            color: Styles.drg_colorPrimary,
                            textColor: Colors.white,
                            onPressed: () {
                              log("!!!-----> In ProfileScreen button 'Delete Account' pressed with signinSnapshot.data.uid: ${signinSnapshot.data.uid}");
                              if (signinSnapshot.data.uid != null) {
                                _showDialog(userId: signinSnapshot.data.uid);
                              }
                            },
                          ),
                        ),
                        Spacer(
                          flex: 1,
                        ),
                        Text(
                          "Your Created Teams:",
                          style: TextStyle(height: 1),
                        ),
                        BuildOwnersTeamsList(teamBloc: teamBloc, user: user),
                        // Spacer(
                        //   flex: 12,
                        // ),
                      ],
                    ),
                  ),
                ),
              );
            });
      },
    );
  }
}

class BuildOwnersTeamsList extends StatelessWidget {
  const BuildOwnersTeamsList({
    Key key,
    @required this.teamBloc,
    @required this.user,
  }) : super(key: key);

  final TeamBloc teamBloc;
  final FirebaseUser user;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: teamBloc.getTeamsQuery(
          fieldName: 'createdByUser', fieldValue: user.uid),
      builder: (context, teamsSnapshot) {
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
        }

        teamsSnapshot.data.documents.forEach((doc) =>
            log("In ProfileScreen - value of team name: ${doc.data['name']}"));

        return Flexible(
          flex: 12,
          child: ListView(
            padding: EdgeInsets.only(top: 16),
            scrollDirection: Axis.vertical,
            physics: BouncingScrollPhysics(),
            children: teamsSnapshot.data.documents.map((DocumentSnapshot doc) {
              return Container(
                margin: EdgeInsets.only(left: 24, bottom: 1, top: 1),
                color: Styles.drg_colorSecondary.withOpacity(0),
                child: ClipRRect(
                  clipBehavior: Clip.antiAlias,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(65),
                    bottomLeft: Radius.circular(65),
                  ),
                  child: Container(
                    padding: EdgeInsets.only(left: 24, bottom: 4),
                    decoration: BoxDecoration(
                      color: Styles.drg_colorPrimary.withOpacity(.4),
                    ),
                    child: ListTile(
                      dense: true,
                      title: Text(
                        "${doc.data['name']}",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
