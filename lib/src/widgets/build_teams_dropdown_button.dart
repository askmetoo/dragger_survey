import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dragger_survey/src/blocs/blocs.dart';
import 'package:dragger_survey/src/styles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BuildTeamsDropdownButton extends StatefulWidget {
  final AsyncSnapshot<QuerySnapshot> teamsSnapshot;

  BuildTeamsDropdownButton({this.teamsSnapshot}) : super();
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

    if (teamBloc?.getCurrentSelectedTeamId() != null) {
      setState(() {
        _selectedTeamId = teamBloc.getCurrentSelectedTeamId();
      });
    }

    if (teamBloc?.getCurrentSelectedTeam()?.documentID != null) {
      setState(() {
        _selectedTeamId = teamBloc.getCurrentSelectedTeam().documentID;
        _selectedTeam = teamBloc.getCurrentSelectedTeam();
      });
    }

    Future<QuerySnapshot> teamsQuery = teamBloc
        .getTeamsQueryByArray(
          fieldName: 'users',
          arrayValue: _user?.uid,
        )
        .catchError((err) => log(
            "ERROR in BuildTeamsDropdownButton getTeamsQueryByArray: $err"));

    if (teamsQuery == null) {
      return Text("No Team Snapshot");
    }

    log("In BuildTeamsDropdownButton value of widget.teamsSnapshot.data.documents.first.documentID: ${widget.teamsSnapshot.data.documents.first.documentID}");

    // return FutureBuilder<QuerySnapshot>(
    //     future: teamsQuery,
    //     builder: (BuildContext context,
    //         AsyncSnapshot<QuerySnapshot> teamsListSnapshot) {
    // if (teamsListSnapshot.connectionState == ConnectionState.done) {
    //   if (!teamsListSnapshot.hasData) {
    //     return Center(
    //       child: Container(
    //         constraints: BoxConstraints(maxWidth: 50),
    //         child: AspectRatio(
    //           aspectRatio: 1,
    //           child: CircularProgressIndicator(
    //             strokeWidth: 10,
    //           ),
    //         ),
    //       ),
    //     );
    //   } else if (teamsListSnapshot.data.documents.isEmpty) {
    //     return Container();
    //   }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Container(
        child: SizedBox(
          height: 66,
          // Check if more than 2 teams in db for this user build dropdown button to select a team
          child: widget.teamsSnapshot.data.documents.length < 2
              ? buildTeamText(teamsListSnapshot: widget.teamsSnapshot)
              : DropdownButton(
                  isExpanded: true,
                  isDense: false,
                  value: _selectedTeamId,
                  onChanged: (value) {
                    String _selectedTeamId = value;
                    log("------> In BuildTeamsDropdownButton onChanged selected team value: $_selectedTeamId");
                    teamBloc.setCurrentSelectedTeamId(_selectedTeamId);
                    setState(() {
                      _selectedTeamId = _selectedTeamId;
                    });
                    teamBloc
                        .getTeamById(id: _selectedTeamId)
                        .then((returnedTeam) {
                      teamBloc.setCurrentSelectedTeam(returnedTeam);
                      teamBloc
                          .setCurrentSelectedTeamId(returnedTeam.documentID);
                      setState(() {
                        _selectedTeam = returnedTeam;
                      });
                    });
                  },
                  iconSize: 46,
                  icon: Icon(
                    Icons.people,
                    color: Styles.drg_colorSecondary,
                  ),
                  elevation: 12,
                  hint: Text(
                    "Please Select a Team",
                    style: TextStyle(
                        color: Styles.drg_colorText.withOpacity(.8),
                        fontFamily: 'Bitter',
                        fontWeight: FontWeight.w700,
                        height: 3),
                    maxLines: 1,
                  ),
                  items:
                      widget.teamsSnapshot.data.documents.map<DropdownMenuItem>(
                    (team) {
                      return DropdownMenuItem(
                        value: team.documentID,
                        child: SingleChildScrollView(
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: Styles.drg_colorAppBackground
                                      .withOpacity(.6),
                                  width: .5,
                                ),
                              ),
                            ),
                            width: double.infinity,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  height: 33,
                                  padding: EdgeInsetsDirectional.only(top: 6),
                                  child: Text(
                                    "${team['name']}\n",
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      color:
                                          Styles.drg_colorText.withOpacity(0.8),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w900,
                                      fontFamily: 'Bitter',
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 28,
                                  child: Padding(
                                    padding: EdgeInsets.only(bottom: 0.0),
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
                                          height: 1),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ).toList(),
                ),
        ),
      ),
    );
  }
  //         return Container();
  //       });
  // }

  Widget buildTeamText({AsyncSnapshot<QuerySnapshot> teamsListSnapshot}) {
    DocumentSnapshot teamDoc;

    if (teamsListSnapshot.connectionState != ConnectionState.done) {
      return Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: 80),
          child: AspectRatio(
            aspectRatio: 1,
            child: Center(
              child: Container(
                constraints: BoxConstraints(maxWidth: 50),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: CircularProgressIndicator(
                    strokeWidth: 10,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }

    if (!teamsListSnapshot.hasData) {
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
