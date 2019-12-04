import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dragger_survey/src/blocs/blocs.dart';
import 'package:dragger_survey/src/screens/survey_sets_list/widgets/widgets.dart';
import 'package:dragger_survey/src/shared/build_initials.dart';
import 'package:dragger_survey/src/styles.dart';
import 'package:flutter/material.dart';
import 'package:rounded_letter/rounded_letter.dart';
import 'package:rounded_letter/shape_type.dart';

class BuildDropdownButtonWidget extends StatelessWidget {
  const BuildDropdownButtonWidget({
    Key key,
    @required AsyncSnapshot<QuerySnapshot> teamsSnapshot,
    @required this.teamBloc,
    @required this.mqWidth,
  })  : _teamsSnapshot = teamsSnapshot,
        super(key: key);

  final AsyncSnapshot<QuerySnapshot> _teamsSnapshot;
  final TeamBloc teamBloc;
  final double mqWidth;

  @override
  Widget build(BuildContext context) {
    return Container(
      /// START
      /// DROPDOWN BUTTON
      child: Flexible(
        flex: 1,
        // Check if more than 2 teams in db for this user build dropdown button to select a team
        child: _teamsSnapshot.data.documents.length < 2
            ? BuildTeamTextWidget(teamsListSnapshot: _teamsSnapshot)
            : DropdownButton(
                underline: Container(),
                isExpanded: true,
                isDense: false,
                // value: _selectedTeamId,
                value: teamBloc.currentSelectedTeamId,
                onChanged: (value) {
                  // setState(() {
                  //   _selectedTeamId = value;
                  // });
                  teamBloc.currentSelectedTeamId = value;

                  // showDialog(
                  //     context: context,
                  //     builder: (context) {
                  //       return AlertDialog(
                  //         title: Text("Current Team: $value"),
                  //         content: Text(
                  //           "...in bloc: ${teamBloc.currentSelectedTeamId}",
                  //         ),
                  //       );
                  //     });
                  // teamBloc.setCurrentSelectedTeamId(value);

                  // teamBloc
                  //     .streamTeamById(id: value)
                  //     .listen((team) {
                  //   teamBloc.currentSelectedTeam = team;
                  //   teamBloc.currentSelectedTeamId =
                  //       team.documentID;
                  //   if (this.mounted) {
                  //     return;
                  //   } else {
                  //     setState(() {
                  //       _selectedTeam = team;
                  //     });
                  //   }
                  // });
                },
                iconSize: 28,
                icon: Icon(
                  Icons.arrow_drop_down,
                  color: Styles.color_Secondary,
                ),
                elevation: 12,
                hint: Text(
                  "Please Select a Team",
                  style: TextStyle(
                      color: Styles.color_Text.withOpacity(.8),
                      fontFamily: 'Bitter',
                      fontWeight: FontWeight.w700,
                      height: 2.4),
                  maxLines: 1,
                ),
                items: <DropdownMenuItem<dynamic>>[
                  ..._teamsSnapshot.data.documents.map<DropdownMenuItem>(
                    (team) {
                      return DropdownMenuItem(
                        key: ValueKey(team.documentID),
                        value: team.documentID,
                        child: SingleChildScrollView(
                          child: Container(
                            height: 54,
                            padding: const EdgeInsets.only(bottom: 0),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: Styles.color_AppBackground
                                      .withOpacity(.6),
                                  width: .5,
                                ),
                              ),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(
                                      right: 12.0, bottom: 4),
                                  child: RoundedLetter(
                                    text: buildInitials(name: team['name']),
                                    fontColor: Styles.color_Secondary,
                                    shapeType: ShapeType.circle,
                                    shapeColor: Styles.color_Primary,
                                    borderColor: Styles.color_Secondary,
                                    shapeSize: 34,
                                    fontSize: 15,
                                    borderWidth: 2,
                                  ),
                                ),
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      padding: EdgeInsetsDirectional.only(
                                          top: 6, bottom: 0),
                                      child: Text(
                                        "${team['name']}",
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                          color: Styles.color_Text
                                              .withOpacity(0.8),
                                          fontSize: 16,
                                          fontWeight: FontWeight.w900,
                                          fontFamily: 'Bitter',
                                          height: .7,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: mqWidth * .55,
                                      child: Padding(
                                        padding: EdgeInsets.only(right: 4),
                                        child: Text(
                                          team['description'] != ''
                                              ? "${team['description']}"
                                              : 'Team has no description',
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                          softWrap: true,
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                              color: Styles
                                                  .color_SecondaryDeepDark
                                                  .withOpacity(.8),
                                              fontFamily: 'Bitter',
                                              fontWeight: FontWeight.w700,
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
                  ).toList()
                ],
              ),
      ),
    );
  }
}
