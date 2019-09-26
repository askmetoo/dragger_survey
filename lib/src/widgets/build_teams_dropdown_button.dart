import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dragger_survey/src/blocs/blocs.dart';
import 'package:dragger_survey/src/services/models.dart';
import 'package:dragger_survey/src/styles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BuildTeamsDropdownButton extends StatefulWidget {
  @override
  _BuildTeamsDropdownButtonState createState() =>
      _BuildTeamsDropdownButtonState();
}

class _BuildTeamsDropdownButtonState extends State<BuildTeamsDropdownButton> {
  String _selectedTeamId;
  DocumentSnapshot _selectedTeam;

  @override
  Widget build(BuildContext context) {
    final TeamBloc teamBloc = Provider.of<TeamBloc>(context);
    FirebaseUser _user = Provider.of<FirebaseUser>(context);

    return FutureBuilder<QuerySnapshot>(
        future: teamBloc
            .getTeamsQueryByArray(
              fieldName: 'users',
              arrayValue: _user?.uid,
            )
            .catchError((err) => log(
                "ERROR in BuildTeamsDropdownButton getTeamsQueryByArray: $err")),
        builder: (BuildContext context,
            AsyncSnapshot<QuerySnapshot> teamsListSnapshot) {
          if (teamsListSnapshot.connectionState == ConnectionState.done) {
            if (!teamsListSnapshot.hasData) {
              return CircularProgressIndicator();
            }
            log("In BuildTeamsDropdownButton - length: ${teamsListSnapshot?.data?.documents?.length}");

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Container(
                child: SizedBox(
                  height: 60,
                  // Check if more than 2 teams in db for this user build dropdown button to select a team
                  child: teamsListSnapshot.data.documents.length < 2
                      ? buildTeamText(teamsListSnapshot: teamsListSnapshot)
                      : DropdownButton(
                          isExpanded: true,
                          value: _selectedTeamId,
                          onChanged: (value) {
                            setState(() {
                              _selectedTeamId = value;
                            });
                            teamBloc.getTeamById(id: value).then((returnValue) {
                              teamBloc.setCurrentSelectedTeam(returnValue);
                              setState(() {
                                _selectedTeam = returnValue;
                              });
                            });
                          },
                          icon: Icon(Icons.people, color: Styles.drg_colorSecondary,),
                          elevation: 12,
                          // hint: Text("Hint text"),
                          hint: teamBloc.currentSelectedTeam == null
                          // hint: _selectedTeamId == null
                              ? Text(
                                  "Please Select a Team",
                                  style: TextStyle(
                                    color: Styles.drg_colorText.withOpacity(.8),
                                    fontFamily: 'Bitter',
                                    fontWeight: FontWeight.w700,
                                  ),
                                )
                              : RichText(
                                  overflow: TextOverflow.clip,
                                  maxLines: 1,
                                  text: TextSpan(
                                    text: "Team: ",
                                    style: TextStyle(
                                        color: Styles.drg_colorText,
                                        fontSize: 20),
                                    children: [
                                      TextSpan(
                                        text: "{_selectedTeam.data['name']}",
                                        style: TextStyle(
                                          color: Styles.drg_colorText,
                                          fontSize: 26,
                                          fontFamily: 'SonsieOne',
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      TextSpan(
                                        text: _selectedTeam
                                                    .data['description'] !=
                                                ''
                                            ? "\n${_selectedTeam.data['description']}"
                                            : "\nTeam has no description",
                                        style: TextStyle(
                                          color: Styles.drg_colorText,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                          items: teamsListSnapshot.data.documents
                              .map<DropdownMenuItem>(
                            (team) {
                              return DropdownMenuItem(
                                value: team.documentID,
                                // value: team['id'].toString(),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        height: 21,
                                        child: Text(
                                          "${team['name']}\n",
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                            color: Styles.drg_colorText
                                                .withOpacity(0.8),
                                            fontSize: 16,
                                            fontWeight: FontWeight.w900,
                                            fontFamily: 'Bitter',
                                          ),
                                        ),
                                      ),
                                      Container(
                                        height: 20,
                                        child: Text(
                                          team['description'] != ''
                                              ? "${team['description']}"
                                              : 'Team has no description',
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                          softWrap: true,
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                            color:
                                                Styles.drg_colorSecondaryDeepDark,
                                            fontFamily: 'Bitter',
                                            fontWeight: FontWeight.w700,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                              );
                            },
                          ).toList(),
                        ),
                ),
              ),
            );
          }
          return Container();
        });
  }

  Widget buildTeamText({AsyncSnapshot<QuerySnapshot> teamsListSnapshot}) {
    DocumentSnapshot teamDoc;

    if (!teamsListSnapshot.hasData) {
      return CircularProgressIndicator();
    }

    teamDoc = teamsListSnapshot?.data?.documents[0];

    return Padding(
      padding: EdgeInsets.only(top: 10),
      child: RichText(
        overflow: TextOverflow.clip,
        maxLines: 2,
        text: TextSpan(
          text: "Your Team: ",
          style: TextStyle(color: Styles.drg_colorText, fontSize: 20),
          children: [
            TextSpan(
              text: "${teamDoc['name']}",
              style: TextStyle(
                  color: Styles.drg_colorText,
                  fontSize: 22,
                  fontWeight: FontWeight.w600),
            ),
            TextSpan(
              text: teamDoc['description'] != ''
                  ? "\n${teamDoc['description']}"
                  : "\nTeam has no description",
              style: TextStyle(
                color: Styles.drg_colorText,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
