import 'dart:developer';
import 'dart:math' hide log;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dragger_survey/src/blocs/blocs.dart';
import 'package:dragger_survey/src/screens/survey_sets_list/widgets/widgets.dart';
import 'package:dragger_survey/src/shared/shared.dart';
import 'package:dragger_survey/src/styles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BuildSurveySetsListView extends StatelessWidget {
  BuildSurveySetsListView({Key key}) : super(key: key);

  Stream<QuerySnapshot> streamQueryTeamsForUser({TeamBloc teamBloc, user}) {
    Stream<QuerySnapshot> teamsQuery = teamBloc
        .streamTeamsQueryByArray(
          fieldName: 'users',
          arrayValue: user?.uid,
        )
        .handleError((err) =>
            log("ERROR in BuildSurveySetsListView queryTeamsForUser: $err"));

    return teamsQuery;
  }

  @override
  Widget build(BuildContext context) {
    final PrismSurveySetBloc surveySetsBloc =
        Provider.of<PrismSurveySetBloc>(context);
    final TeamBloc teamBloc = Provider.of<TeamBloc>(context);
    FirebaseUser _user = Provider.of<FirebaseUser>(context);

    return StreamBuilder(
      stream: streamQueryTeamsForUser(teamBloc: teamBloc, user: _user)
          .handleError((e) => log("ERROR: $e")),
      builder:
          (BuildContext context, AsyncSnapshot<QuerySnapshot> teamsSnapshot) {
        if (teamsSnapshot.connectionState != ConnectionState.active) {
          return Loader();
        }

        if (teamsSnapshot.data.documents.isEmpty) {
          return buildNotMemberOfATeamBText();
        }

        if (teamsSnapshot.data.documents.length == 1) {
          teamBloc.currentSelectedTeamId =
              teamsSnapshot.data.documents[0].documentID;
          teamBloc.getTeamById(id: teamsSnapshot.data.documents[0].documentID);
        }

        if (teamBloc.currentSelectedTeam.documentID == null &&
            teamBloc.currentSelectedTeamId == null &&
            teamsSnapshot.data.documents.length > 1) {
          return buildChooseATeamBeforeYouStartText();
        }

        return StreamBuilder<QuerySnapshot>(
          stream: surveySetsBloc.streamPrismSurveySetQueryOrderByField(
              fieldName: 'createdByTeam',
              fieldValue: teamBloc.currentSelectedTeamId,
              orderField: surveySetsBloc.orderField,
              descending: surveySetsBloc.descendingOrder),
          builder: (BuildContext context,
              AsyncSnapshot<QuerySnapshot> surveySetSnapshot) {
            if (surveySetSnapshot.connectionState != ConnectionState.active) {
              return Loader();
            }

            if (surveySetSnapshot.data.documents.isEmpty) {
              return buildNoSurveySetsAvailableText();
            }

            return Column(
              children: <Widget>[
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text(
                    "Select a Survey Set from below \nor create a new Set.",
                    textAlign: TextAlign.start,
                  ),
                ),
                Text("Current Team: ${teamBloc?.currentSelectedTeamId}"),
                Text(
                    "Current Survey Set: ${surveySetSnapshot.data.documents.first.documentID}"),
                Expanded(
                    child: BuildListOfSets(
                  surveySetsBloc: surveySetsBloc,
                  surveySetSnapshot: surveySetSnapshot,
                  user: _user,
                )),
              ],
            );
          },
        );
      },
    );
  }

  Widget buildNoSurveySetsAvailableText() {
    return Center(
      child: Column(
        children: <Widget>[
          Spacer(
            flex: 7,
          ),
          Icon(
            Icons.announcement,
            size: 80,
            color: Styles.color_Secondary,
          ),
          Container(
            height: 24,
            child: Text(
              "Sorry, currently          ",
              textAlign: TextAlign.left,
              style: TextStyle(
                fontFamily: 'SonsieOne',
                fontSize: 18,
                letterSpacing: -2,
                color: Styles.color_SecondaryDeepDark,
                shadows: [
                  Shadow(
                    color: Styles.color_Text.withOpacity(.2),
                    blurRadius: 5,
                  ),
                  Shadow(
                      color: Styles.color_Text.withOpacity(.2),
                      blurRadius: 3,
                      offset: Offset(2, 3)),
                ],
              ),
            ),
          ),
          Text(
            "no survey sets",
            textAlign: TextAlign.left,
            style: TextStyle(
              fontFamily: 'SonsieOne',
              fontSize: 32,
              letterSpacing: -2,
              color: Styles.color_Secondary,
              shadows: [
                Shadow(
                  color: Styles.color_Text.withOpacity(.3),
                  blurRadius: 8,
                ),
                Shadow(
                    color: Styles.color_Text.withOpacity(.1),
                    blurRadius: 3,
                    offset: Offset(5, 6)),
              ],
            ),
          ),
          Text(
            "available.          ",
            textAlign: TextAlign.left,
            style: TextStyle(
              fontFamily: 'SonsieOne',
              fontSize: 24,
              letterSpacing: -2,
              color: Styles.color_SecondaryDeepDark,
              shadows: [
                Shadow(
                  color: Styles.color_Text.withOpacity(.2),
                  blurRadius: 5,
                ),
                Shadow(
                    color: Styles.color_Text.withOpacity(.2),
                    blurRadius: 3,
                    offset: Offset(2, 3)),
              ],
            ),
          ),
          Spacer(),
          Text(
            "Please select another team",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Bitter',
              fontWeight: FontWeight.w700,
              color: Styles.color_Text.withOpacity(.7),
            ),
          ),
          Text(
            "or create a new set.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Bitter',
              fontWeight: FontWeight.w700,
              color: Styles.color_Text.withOpacity(.7),
            ),
          ),
          Spacer(
            flex: 1,
          ),
          Transform.rotate(
            angle: -pi * 2,
            child: Image.asset(
              'assets/message-arrow-down.png',
              fit: BoxFit.contain,
              height: 150,
              width: 80,
              alignment: Alignment.topLeft,
            ),
          ),
          Spacer(
            flex: 3,
          ),
        ],
      ),
    );
  }

  Center buildChooseATeamBeforeYouStartText() {
    return Center(
      child: Column(
        children: <Widget>[
          Transform.rotate(
            angle: -pi / 9,
            child: Image.asset(
              'assets/message-arrow.png',
              fit: BoxFit.contain,
              height: 150,
              width: 120,
              alignment: Alignment.topLeft,
            ),
          ),
          Spacer(
            flex: 2,
          ),
          Icon(
            Icons.announcement,
            size: 80,
            color: Styles.color_Secondary,
          ),
          Text(
            "Before you      ",
            style: TextStyle(
              fontFamily: 'SonsieOne',
              fontSize: 34,
              letterSpacing: -2,
              color: Styles.color_Secondary,
              shadows: [
                Shadow(
                  color: Styles.color_Text.withOpacity(.3),
                  blurRadius: 8,
                ),
                Shadow(
                    color: Styles.color_Text.withOpacity(.1),
                    blurRadius: 3,
                    offset: Offset(5, 6)),
              ],
            ),
          ),
          Text(
            "           can start",
            style: TextStyle(
              fontFamily: 'SonsieOne',
              fontSize: 28,
              letterSpacing: -2,
              color: Styles.color_Text.withOpacity(0.7),
              shadows: [
                Shadow(
                  color: Styles.color_Text.withOpacity(.2),
                  blurRadius: 5,
                ),
                Shadow(
                    color: Styles.color_Text.withOpacity(.2),
                    blurRadius: 3,
                    offset: Offset(2, 3)),
              ],
            ),
          ),
          Spacer(),
          Text(
            "please, first choose a team for which",
            style: TextStyle(
              fontFamily: 'Bitter',
              fontWeight: FontWeight.w700,
              color: Styles.color_Text.withOpacity(.7),
            ),
          ),
          Text(
            "you want to conduct the survey.",
            style: TextStyle(
              fontFamily: 'Bitter',
              fontWeight: FontWeight.w700,
              color: Styles.color_Text.withOpacity(.7),
            ),
          ),
          Spacer(
            flex: 8,
          ),
          Spacer(
            flex: 8,
          ),
        ],
      ),
    );
  }

  Center buildNotMemberOfATeamBText() {
    return Center(
      child: Column(
        children: <Widget>[
          Spacer(
            flex: 8,
          ),
          Icon(
            Icons.announcement,
            size: 80,
            color: Styles.color_Secondary,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              "       You are not            \n  a Member of \n           any Team      ",
              style: TextStyle(
                fontFamily: 'SonsieOne',
                fontSize: 34,
                letterSpacing: -2,
                color: Styles.color_Secondary,
                shadows: [
                  Shadow(
                    color: Styles.color_Text.withOpacity(.3),
                    blurRadius: 8,
                  ),
                  Shadow(
                      color: Styles.color_Text.withOpacity(.1),
                      blurRadius: 3,
                      offset: Offset(5, 6)),
                ],
              ),
            ),
          ),
          Text(
            "        First create one  \n    or get invited\n           to start.",
            style: TextStyle(
              fontFamily: 'SonsieOne',
              fontSize: 28,
              letterSpacing: -2,
              color: Styles.color_Text.withOpacity(0.7),
              shadows: [
                Shadow(
                  color: Styles.color_Text.withOpacity(.2),
                  blurRadius: 5,
                ),
                Shadow(
                    color: Styles.color_Text.withOpacity(.2),
                    blurRadius: 3,
                    offset: Offset(2, 3)),
              ],
            ),
          ),
          Spacer(
            flex: 8,
          ),
          Spacer(
            flex: 8,
          ),
        ],
      ),
    );
  }
}
