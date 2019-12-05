import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dragger_survey/src/styles.dart';
import 'package:flutter/material.dart';

class BuildTeamTextWidget extends StatelessWidget {
  const BuildTeamTextWidget({
    Key key,
    @required this.teamSnapshotData,
  }) : super(key: key);

  final QuerySnapshot teamSnapshotData;

  @override
  Widget build(BuildContext context) {
    DocumentSnapshot teamDoc;

    // if (teamSnapshotData.connectionState != ConnectionState.active) {
    //   return Center(
    //     child: Container(
    //       constraints: BoxConstraints(maxWidth: 50),
    //       child: AspectRatio(
    //         aspectRatio: 1,
    //         child: CircularProgressIndicator(
    //           strokeWidth: 10,
    //         ),
    //       ),
    //     ),
    //   );
    // }

    // if (!teamsListSnapshot.hasData) {
    //   return Center(
    //     child: Container(
    //       constraints: BoxConstraints(maxWidth: 50),
    //       child: AspectRatio(
    //         aspectRatio: 1,
    //         child: CircularProgressIndicator(
    //           strokeWidth: 10,
    //         ),
    //       ),
    //     ),
    //   );
    // }

    teamDoc = teamSnapshotData.documents[0];

    return Padding(
      padding: EdgeInsets.only(top: 10),
      child: RichText(
        overflow: TextOverflow.clip,
        maxLines: 2,
        text: TextSpan(
          text: "Your Team: ",
          style: TextStyle(color: Styles.color_Text, fontSize: 20),
          children: [
            TextSpan(
              text: "${teamDoc['name']}",
              style: TextStyle(
                  color: Styles.color_Text,
                  fontSize: 22,
                  fontWeight: FontWeight.w600),
            ),
            TextSpan(
              text: teamDoc['description'] != ''
                  ? "\n${teamDoc['description']}"
                  : "\nTeam has no description",
              style: TextStyle(
                color: Styles.color_Text,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
