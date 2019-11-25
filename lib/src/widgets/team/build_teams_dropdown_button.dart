import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dragger_survey/src/blocs/blocs.dart';
import 'package:dragger_survey/src/shared/shared.dart';
import 'package:dragger_survey/src/styles.dart';
import 'package:dragger_survey/src/widgets/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rounded_letter/rounded_letter.dart';
import 'package:rounded_letter/shape_type.dart';

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

    if (_selectedTeamId == null && widget.teamsSnapshot?.data != null) {
      setState(() {
        _selectedTeamId = widget.teamsSnapshot?.data?.documents[0]?.documentID;
        _selectedTeam = widget.teamsSnapshot?.data?.documents[0];
      });
    }

    if (teamBloc?.getCurrentSelectedTeam()?.documentID != null) {
      setState(() {
        _selectedTeamId = teamBloc.getCurrentSelectedTeam().documentID;
        _selectedTeam = teamBloc.getCurrentSelectedTeam();
      });
    }

    Stream<QuerySnapshot> streamTeamsQuery = teamBloc
        .streamTeamsQueryByArray(
          fieldName: 'users',
          arrayValue: _user?.uid,
        )
        .handleError((err) => log(
            "ERROR in BuildTeamsDropdownButton getTeamsQueryByArray: $err"));

    if (streamTeamsQuery == null) {
      return Text("No Team Snapshot");
    }

    return Column(
      children: <Widget>[
        Padding(
          padding:
              const EdgeInsets.only(left: 16, right: 16, top: 0, bottom: 0),
          child: SizedBox(
            height: 66,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  child: Flexible(
                    flex: 1,
                    // Check if more than 2 teams in db for this user build dropdown button to select a team
                    child: widget.teamsSnapshot.data.documents.length < 2
                        ? buildTeamText(teamsListSnapshot: widget.teamsSnapshot)
                        : DropdownButton(
                            underline: Container(),
                            isExpanded: true,
                            isDense: false,
                            value: _selectedTeamId,
                            onChanged: (value) {
                              String _selectedTeamId = value;
                              teamBloc
                                  .setCurrentSelectedTeamId(_selectedTeamId);
                              setState(() {
                                _selectedTeamId = _selectedTeamId;
                              });

                              teamBloc
                                  .streamTeamById(id: _selectedTeamId)
                                  .listen((team) {
                                teamBloc.setCurrentSelectedTeam(team);
                                teamBloc
                                    .setCurrentSelectedTeamId(team.documentID);
                                if (this.mounted) {
                                  return;
                                } else {
                                  setState(() {
                                    _selectedTeam = team;
                                  });
                                }
                              });
                            },
                            iconSize: 28,
                            icon: Icon(
                              Icons.arrow_drop_down,
                              color: Styles.drg_colorSecondary,
                            ),
                            elevation: 12,
                            hint: Text(
                              "Please Select a Team",
                              style: TextStyle(
                                  color: Styles.drg_colorText.withOpacity(.8),
                                  fontFamily: 'Bitter',
                                  fontWeight: FontWeight.w700,
                                  height: 2.4),
                              maxLines: 1,
                            ),
                            items: widget.teamsSnapshot.data.documents
                                .map<DropdownMenuItem>(
                              (team) {
                                return DropdownMenuItem(
                                  value: team.documentID,
                                  child: SingleChildScrollView(
                                    child: Container(
                                      height: 54,
                                      padding: EdgeInsets.only(bottom: 0),
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
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Padding(
                                            padding: EdgeInsets.only(
                                                right: 12.0, bottom: 4),
                                            child: RoundedLetter(
                                              text: buildInitials(
                                                  name: team['name']),
                                              fontColor:
                                                  Styles.drg_colorSecondary,
                                              shapeType: ShapeType.circle,
                                              shapeColor:
                                                  Styles.drg_colorPrimary,
                                              borderColor:
                                                  Styles.drg_colorSecondary,
                                              shapeSize: 34,
                                              fontSize: 15,
                                              borderWidth: 2,
                                            ),
                                          ),
                                          Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                padding:
                                                    EdgeInsetsDirectional.only(
                                                        top: 6, bottom: 0),
                                                child: Text(
                                                  "${team['name']}",
                                                  textAlign: TextAlign.start,
                                                  style: TextStyle(
                                                    color: Styles.drg_colorText
                                                        .withOpacity(0.8),
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w900,
                                                    fontFamily: 'Bitter',
                                                    height: .7,
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                child: Padding(
                                                  padding:
                                                      EdgeInsets.only(right: 4),
                                                  child: Text(
                                                    team['description'] != ''
                                                        ? "${team['description']}"
                                                        : 'Team has no description',
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 1,
                                                    softWrap: true,
                                                    textAlign: TextAlign.start,
                                                    style: TextStyle(
                                                        color: Styles
                                                            .drg_colorSecondaryDeepDark
                                                            .withOpacity(.8),
                                                        fontFamily: 'Bitter',
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        fontSize: 14,
                                                        height: 1.6),
                                                  ),
                                                ),
                                              ),
                                            ],
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
                BuildFilterSort(),
              ],
            ),
          ),
        ),
        Divider(
          height: 1,
          thickness: 1,
          color: Styles.drg_colorSecondary.withOpacity(.2),
        ),
      ],
    );
  }

  Widget buildTeamText({AsyncSnapshot<QuerySnapshot> teamsListSnapshot}) {
    DocumentSnapshot teamDoc;

    if (teamsListSnapshot.connectionState != ConnectionState.active) {
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
