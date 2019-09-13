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
  String _selectedTeamId = '';
  String _selectedTeamName = '';
  DocumentSnapshot _selectedTeam;

  @override
  Widget build(BuildContext context) {
    final TeamBloc teamBloc = Provider.of<TeamBloc>(context);
    final SignInBloc signInBloc = Provider.of<SignInBloc>(context);
    FirebaseUser _user = Provider.of<FirebaseUser>(context);

    return FutureBuilder<FirebaseUser>(
        future: signInBloc.currentUser,
        builder:
            (BuildContext context, AsyncSnapshot<FirebaseUser> signInSnapshot) {
          if (signInSnapshot.connectionState == ConnectionState.none ||
              signInSnapshot.connectionState == ConnectionState.waiting ||
              signInSnapshot.connectionState == ConnectionState.active) {
            CircularProgressIndicator();
          }

          if (signInSnapshot.connectionState == ConnectionState.done) {

            if(!signInSnapshot.hasData) CircularProgressIndicator();

            return FutureBuilder<QuerySnapshot>(
                future: teamBloc.getTeamsQueryByArray(
                  fieldName: 'users',
                  arrayValue: _user?.uid,
                ).catchError((err) => log("ERROR in BuildTeamsDropdownButton getTeamsQueryByArray: $err")),
                builder: (BuildContext context, teamsListSnapshot) {
                  if (teamsListSnapshot.connectionState == ConnectionState.none ||
                      teamsListSnapshot.connectionState == ConnectionState.waiting ||
                      teamsListSnapshot.connectionState == ConnectionState.active) {
                    return CircularProgressIndicator();
                  }

                  if (teamsListSnapshot.connectionState ==
                      ConnectionState.done) {
                    if(!teamsListSnapshot.hasData) CircularProgressIndicator();
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 4),
                      child: Container(
                        child: SizedBox(
                          height: 60,
                          child: DropdownButton(
                              isExpanded: true,
                              onChanged: (value) {
                                setState(() {
                                  _selectedTeamId = value;
                                });
                                teamBloc
                                    .getTeamById(id: value)
                                    .then((returnValue) {
                                  teamBloc.setCurrentSelectedTeam(returnValue);
                                  setState(() {
                                    _selectedTeam = returnValue;
                                  });
                                });
                              },
                              hint: _selectedTeamId == null || _selectedTeamId.isEmpty || _selectedTeamId == ''
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
                                            text: "${_selectedTeam.data['name']}",
                                            style: TextStyle(
                                                color: Styles.drg_colorText,
                                                fontSize: 22,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          TextSpan(
                                            text: _selectedTeam.data['description'] !=
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
                              // disabledHint: _selectedTeam?.id != null
                              //     ? Text("${_selectedTeam?.id}")
                              //     : Text("You don't have any Team"),
                              items: !teamsListSnapshot.hasData
                                  ? null
                                  : teamsListSnapshot.data.documents
                                      .map<DropdownMenuItem>((team) {
                                      return DropdownMenuItem(
                                        value: team['id'],
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
                                                  color: Styles
                                                      .drg_colorTextLighter,
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
                  return Container();
                });
          }
          return Text('No Dropdown Button available');
        });
  }
}

// Widget _buildTeamsDropdownButton({@required context}) {
//     final TeamBloc teamBloc = Provider.of<TeamBloc>(context);
//     final SignInBloc signInBloc = Provider.of<SignInBloc>(context);
//     FirebaseUser _user = Provider.of<FirebaseUser>(context);
//     String _selectedTeamId = '';
//     String _selectedTeamName = '';

//     return FutureBuilder<FirebaseUser>(
//         future: signInBloc.currentUser,
//         builder:
//             (BuildContext context, AsyncSnapshot<FirebaseUser> signInSnapshot) {
//           if (signInSnapshot.connectionState == ConnectionState.none) {
//             log("In SurveySetsListScreen _buildTeamsDropdownButton - ConnectionState.none");
//             CircularProgressIndicator();
//           }

//           if (signInSnapshot.connectionState == ConnectionState.waiting) {
//             log("In SurveySetsListScreen _buildTeamsDropdownButton - ConnectionState.waiting");
//             CircularProgressIndicator();
//           }
//           if (signInSnapshot.connectionState == ConnectionState.active) {
//             log("In SurveySetsListScreen _buildTeamsDropdownButton - ConnectionState.active");
//             CircularProgressIndicator();
//           }

//           if (signInSnapshot.connectionState == ConnectionState.done) {
//             Future<QuerySnapshot> teamQuery = teamBloc.getTeamsQueryByArray(
//               fieldName: 'users',
//               arrayValue: _user?.uid,
//             );
//             return FutureBuilder<QuerySnapshot>(
//                 future: teamQuery,
//                 builder: (BuildContext context,
//                     AsyncSnapshot<QuerySnapshot> teamsListSnapshot) {
//                   if (teamsListSnapshot.hasError) {
//                     return Center(
//                       child: Container(
//                         child: Text(
//                             "Loading Set has error: ${teamsListSnapshot.error}"),
//                       ),
//                     );
//                   }

//                   if (
//                     teamsListSnapshot.connectionState == ConnectionState.none ||
//                     teamsListSnapshot.connectionState == ConnectionState.waiting ||
//                     teamsListSnapshot.connectionState == ConnectionState.active
//                   ) print("ConnectionState is none, waiting or active");

//                   if (teamsListSnapshot.connectionState == ConnectionState.done) {
//                     return Padding(
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 16, vertical: 4),
//                       child: Container(
//                         child: SizedBox(
//                           height: 60,
//                           child: DropdownButton(
//                               isExpanded: true,
//                               onChanged: (value) {
//                                 log("In SurveySetsListScreen _buildTeamsDropdownButton - ConnectionState.done value: $value");
//                                 setState(() {
//                                   _selectedTeamId = value;
//                                 });
//                                 teamBloc.currentTeamId = value;
//                                 teamBloc
//                                     .getTeamById(id: value)
//                                     .then((returnValue) {
//                                   log("In SurveySetsListScreen from teamBloc name: ${teamBloc.currentSelectedTeam.name}, description: ${teamBloc.currentSelectedTeam.description}");
//                                 });
//                                 print(
//                                     "Selected Team Name: $_selectedTeamName, $_selectedTeamId");
//                               },
//                               hint: teamBloc.currentSelectedTeam == null
//                                   ? Text(
//                                       "Please Select a Team",
//                                       style: TextStyle(
//                                           color: Styles.drg_colorText),
//                                     )
//                                   : RichText(
//                                       text: TextSpan(
//                                         text: "Team: ",
//                                         style: TextStyle(
//                                             color: Styles.drg_colorText,
//                                             fontSize: 22),
//                                         children: [
//                                           TextSpan(
//                                             text:
//                                                 "${teamBloc.currentSelectedTeam?.name}",
//                                             style: TextStyle(
//                                                 color: Styles.drg_colorText,
//                                                 fontSize: 22,
//                                                 fontWeight: FontWeight.w600),
//                                           ),
//                                           TextSpan(
//                                             text: teamBloc.currentSelectedTeam
//                                                         ?.description !=
//                                                     ''
//                                                 ? "\n${teamBloc.currentSelectedTeam?.description}"
//                                                 : "\nTeam has no description",
//                                             style: TextStyle(
//                                               color: Styles.drg_colorText,
//                                               fontSize: 14,
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                               disabledHint: teamBloc.currentTeamId != null
//                                   ? Text("${teamBloc.currentTeamId}")
//                                   : Text("You don't have any Team"),
//                               items: teamsListSnapshot.data.documents
//                                   .map<DropdownMenuItem>((team) {
//                                 return DropdownMenuItem(
//                                   value: team.documentID,
//                                   child: RichText(
//                                     text: TextSpan(
//                                       text: "${team['name']}\n",
//                                       style: TextStyle(
//                                         color: Styles.drg_colorText,
//                                         fontSize: 18,
//                                         fontWeight: FontWeight.w600,
//                                       ),
//                                       children: [
//                                         TextSpan(
//                                           text: team['description'] != ''
//                                               ? "${team['description']}"
//                                               : 'Team has no description',
//                                           style: TextStyle(
//                                             color: Styles.drg_colorTextLighter,
//                                             fontSize: 12,
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 );
//                               }).toList()),
//                         ),
//                       ),
//                     );
//                   }
//                   return Text('No Dropdown Button available');
//                 });
//           }
//           return Container();
//         });
//   }
