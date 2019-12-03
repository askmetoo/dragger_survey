import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dragger_survey/src/styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dragger_survey/src/blocs/blocs.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BuildTeamsDropdownButton extends StatelessWidget {
  AsyncSnapshot<QuerySnapshot> teamsSnapshot;

  BuildTeamsDropdownButton({this.teamsSnapshot}) : super();

  @override
  Widget build(BuildContext context) {
    final TeamBloc teamBloc = Provider.of<TeamBloc>(context);

    return Container(
      width: 200,
      child: teamsSnapshot.data.documents.length < 2
          ? Text("Only one Team")
          : PopupMenuButton<dynamic>(
              initialValue: teamBloc.currentSelectedTeamId,
              onSelected: (value) {
                teamBloc.currentSelectedTeamId = value;
              },
              itemBuilder: (context) => [
                ...teamsSnapshot.data.documentChanges.map<PopupMenuItem>(
                  (team) => PopupMenuItem(
                    value: team.document.documentID,
                    child: Text("Team: ${team.document.data['name']}"),
                  ),
                ),
              ],
            ),
    );
  }
}
