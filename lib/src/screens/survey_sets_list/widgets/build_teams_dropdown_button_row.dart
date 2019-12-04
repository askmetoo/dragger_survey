import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dragger_survey/src/blocs/blocs.dart';
import 'package:dragger_survey/src/screens/survey_sets_list/widgets/widgets.dart';
import 'package:dragger_survey/src/shared/shared.dart';
import 'package:dragger_survey/src/styles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rounded_letter/rounded_letter.dart';
import 'package:rounded_letter/shape_type.dart';

class BuildTeamsDropdownButtonRow extends StatefulWidget {
  AsyncSnapshot<QuerySnapshot> teamsSnapshot;

  BuildTeamsDropdownButtonRow({this.teamsSnapshot}) : super();
  @override
  _BuildTeamsDropdownButtonRowState createState() =>
      _BuildTeamsDropdownButtonRowState(teamsSnapshot);
}

class _BuildTeamsDropdownButtonRowState
    extends State<BuildTeamsDropdownButtonRow> {
  AsyncSnapshot<QuerySnapshot> _teamsSnapshot;
  _BuildTeamsDropdownButtonRowState(this._teamsSnapshot);
  String _selectedTeamId;
  // DocumentSnapshot _selectedTeam;

  @override
  Widget build(BuildContext context) {
    final TeamBloc teamBloc = Provider.of<TeamBloc>(context);
    FirebaseUser _user = Provider.of<FirebaseUser>(context);
    MediaQueryData mq = MediaQuery.of(context);
    double mqWidth = mq.size.width;

    //// Check if there's a current selected team in the bloc (selected via dropdown or teams list)
    // if (teamBloc?.currentSelectedTeamId != null) {
    //   setState(() {
    //     _selectedTeamId = teamBloc.currentSelectedTeamId;
    //   });
    // }

    if (teamBloc.currentSelectedTeamId == null &&
        widget.teamsSnapshot?.data != null) {
      teamBloc.currentSelectedTeamId =
          widget.teamsSnapshot?.data?.documents[0]?.documentID;
      teamBloc.currentSelectedTeam = widget.teamsSnapshot?.data?.documents[0];
    }
    // if (_selectedTeamId == null && widget.teamsSnapshot?.data != null) {
    //   setState(() {
    //     _selectedTeamId = widget.teamsSnapshot?.data?.documents[0]?.documentID;
    //     _selectedTeam = widget.teamsSnapshot?.data?.documents[0];
    //   });
    //   teamBloc.currentSelectedTeamId = _selectedTeamId;
    //   teamBloc.currentSelectedTeam = _selectedTeam;
    // }

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
                // BuildTeamsDropdownButton(teamsSnapshot: _teamsSnapshot,),
                BuildDropdownButtonWidget(
                    teamsSnapshot: _teamsSnapshot,
                    teamBloc: teamBloc,
                    mqWidth: mqWidth),

                /// END
                BuildFilterSortButton(),
              ],
            ),
          ),
        ),
        Divider(
          height: 1,
          thickness: 1,
          color: Styles.color_Secondary.withOpacity(.2),
        ),
      ],
    );
  }
}
