import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dragger_survey/src/blocs/blocs.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BuildFilterSort extends StatefulWidget {
  @override
  _BuildFilterSortState createState() => _BuildFilterSortState();
}

class _BuildFilterSortState extends State<BuildFilterSort> {
  // ignore: unused_field
  String _selectedTeamId;
  int _sortBy = 1;

  @override
  Widget build(BuildContext context) {
    final TeamBloc teamBloc = Provider.of<TeamBloc>(context);
    final PrismSurveySetBloc surveySetBloc =
        Provider.of<PrismSurveySetBloc>(context);
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
          if (teamsListSnapshot.connectionState != ConnectionState.done) {
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
            return Text("No Team Snapshot");
          } else if (teamsListSnapshot.data.documents.isEmpty) {
            return Container();
          }
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              alignment: Alignment.centerLeft,
              child: DropdownButton(
                underline: Container(),
                icon: Icon(
                  Icons.sort,
                  size: 18,
                ),
                // hint: Text(
                //   _sortByd ? 'By Date ' : 'By Name ',
                //   style:
                //       TextStyle(fontSize: Styles.drg_fontSizeHintText),
                // ),
                isDense: true,
                isExpanded: false,
                value: _sortBy,
                onChanged: (newValue) {
                  log("In BuildFilterSort newValue: $newValue");
                  switch (newValue) {
                    case 1:
                      surveySetBloc.orderField = 'created';
                      surveySetBloc.descendingOrder = true;
                      break;
                    case 2:
                      surveySetBloc.orderField = 'created';
                      surveySetBloc.descendingOrder = false;
                      break;
                    case 3:
                      surveySetBloc.orderField = 'name';
                      surveySetBloc.descendingOrder = true;
                      break;
                    case 4:
                      surveySetBloc.orderField = 'name';
                      surveySetBloc.descendingOrder = false;
                      break;
                    default:
                      surveySetBloc.orderField = 'created';
                      surveySetBloc.descendingOrder = true;
                  }
                  setState(() {
                    _sortBy = newValue;
                  });
                },
                items: [
                  DropdownMenuItem(
                    value: 1,
                    child: Text('By date, descending'),
                  ),
                  DropdownMenuItem(
                    value: 2,
                    child: Text('By date, ascending'),
                  ),
                  DropdownMenuItem(
                    value: 3,
                    child: Text('By name, descending'),
                  ),
                  DropdownMenuItem(
                    value: 4,
                    child: Text('By name, ascending'),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
