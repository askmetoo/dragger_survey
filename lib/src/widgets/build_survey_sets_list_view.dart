import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dragger_survey/src/blocs/blocs.dart';
import 'package:dragger_survey/src/enums/connectivity_status.dart';
import 'package:dragger_survey/src/styles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

class BuildSurveySetsListView extends StatefulWidget {
  BuildSurveySetsListView({Key key}) : super(key: key);

  @override
  _BuildSurveySetsListViewState createState() =>
      _BuildSurveySetsListViewState();
}

class _BuildSurveySetsListViewState extends State<BuildSurveySetsListView> {
  Future<QuerySnapshot> queryTeamsForUser({teamBloc, user}) async {
    QuerySnapshot teamsQuery = await teamBloc
        .getTeamsQueryByArray(
          fieldName: 'users',
          arrayValue: user?.uid,
        )
        .catchError((err) =>
            log("ERROR in BuildSurveySetsListView queryTeamsForUser: $err"));
    return teamsQuery;
  }

  @override
  Widget build(BuildContext context) {
    final PrismSurveySetBloc surveySetsBloc =
        Provider.of<PrismSurveySetBloc>(context);
    final TeamBloc teamBloc = Provider.of<TeamBloc>(context);
    FirebaseUser _user = Provider.of<FirebaseUser>(context);

    return FutureBuilder(
      future: queryTeamsForUser(teamBloc: teamBloc, user: _user),
      builder:
          (BuildContext context, AsyncSnapshot<QuerySnapshot> teamsSnapshot) {
        if (teamsSnapshot.connectionState != ConnectionState.done) {
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

        if (teamsSnapshot.data.documents.isEmpty) {
          return buildNotMemberOfATeamBText();
        }

        if (teamsSnapshot.data.documents.length == 1) {
          teamBloc.currentSelectedTeamId =
              teamsSnapshot.data.documents[0].documentID;
          teamBloc.getTeamById(id: teamsSnapshot.data.documents[0].documentID);
        }

        log("In BuildSurveySetsListView - value of teamsSnapshot.data.documents.length: ${teamsSnapshot.data.documents.length}");
        log("In BuildSurveySetsListView - value of team ID teamsSnapshot.data.documents[0].documentID: ${teamsSnapshot.data.documents[0].documentID}");

        if (teamBloc?.currentSelectedTeam?.documentID == null &&
            teamsSnapshot.data.documents.length != 1) {
          return buildChooseATeamBeforeYouStartText();
        }

        return FutureBuilder<QuerySnapshot>(
          // TODO: implement sorting by date and name
          future: surveySetsBloc
              .getPrismSurveySetQueryOrderByField(
                  fieldName: 'createdByTeam',
                  fieldValue: teamBloc?.currentSelectedTeamId,
                  orderField: teamBloc.orderField,
                  descending: teamBloc.descendingOrder)
              .catchError((err) => log(
                  "ERROR in BuildSurveySetsListView getPrismSurveySetQuery: $err")),
          builder: (BuildContext context,
              AsyncSnapshot<QuerySnapshot> surveySetSnapshot) {
            log("In BuildSurveySetsListView value of teamBloc?.getCurrentSelectedTeamId(): ${teamBloc?.getCurrentSelectedTeamId()}");
            final connectionStatus = Provider.of<ConnectivityStatus>(context);

            if (surveySetSnapshot.connectionState == ConnectionState.done) {
              if (!surveySetSnapshot.hasData) {
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

              if (connectionStatus == ConnectivityStatus.Offline) {
                return Text(
                  "You are currently ${connectionStatus.toString().split('.')[1]}",
                  style: TextStyle(
                      fontSize: 20, color: Styles.drg_colorSecondaryDeepDark),
                );
              }
              log("In BuildSurveySetsListView build - surveySetSnapshot.data.documents.isEmpty: ${surveySetSnapshot.data.documents.isEmpty}");
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
                  Expanded(
                      child: BuildListOfSets(
                    surveySetsBloc: surveySetsBloc,
                    surveySetSnapshot: surveySetSnapshot,
                  )),
                ],
              );
            }
            return Container();
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
            flex: 8,
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
                color: Styles.drg_colorSecondaryDeepDark,
                shadows: [
                  Shadow(
                    color: Styles.drg_colorText.withOpacity(.2),
                    blurRadius: 5,
                  ),
                  Shadow(
                      color: Styles.drg_colorText.withOpacity(.2),
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
              color: Styles.drg_colorSecondary,
              shadows: [
                Shadow(
                  color: Styles.drg_colorText.withOpacity(.3),
                  blurRadius: 8,
                ),
                Shadow(
                    color: Styles.drg_colorText.withOpacity(.1),
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
              color: Styles.drg_colorSecondaryDeepDark,
              shadows: [
                Shadow(
                  color: Styles.drg_colorText.withOpacity(.2),
                  blurRadius: 5,
                ),
                Shadow(
                    color: Styles.drg_colorText.withOpacity(.2),
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
              color: Styles.drg_colorText.withOpacity(.7),
            ),
          ),
          Text(
            "or create a new set.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Bitter',
              fontWeight: FontWeight.w700,
              color: Styles.drg_colorText.withOpacity(.7),
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

  Center buildChooseATeamBeforeYouStartText() {
    return Center(
      child: Column(
        children: <Widget>[
          Spacer(
            flex: 8,
          ),
          Text(
            "Before you      ",
            style: TextStyle(
              fontFamily: 'SonsieOne',
              fontSize: 34,
              letterSpacing: -2,
              color: Styles.drg_colorSecondary,
              shadows: [
                Shadow(
                  color: Styles.drg_colorText.withOpacity(.3),
                  blurRadius: 8,
                ),
                Shadow(
                    color: Styles.drg_colorText.withOpacity(.1),
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
              color: Styles.drg_colorText.withOpacity(0.7),
              shadows: [
                Shadow(
                  color: Styles.drg_colorText.withOpacity(.2),
                  blurRadius: 5,
                ),
                Shadow(
                    color: Styles.drg_colorText.withOpacity(.2),
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
              color: Styles.drg_colorText.withOpacity(.7),
            ),
          ),
          Text(
            "you want to conduct the survey.",
            style: TextStyle(
              fontFamily: 'Bitter',
              fontWeight: FontWeight.w700,
              color: Styles.drg_colorText.withOpacity(.7),
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              "  You are not            \na Member of \n           a Team      ",
              style: TextStyle(
                fontFamily: 'SonsieOne',
                fontSize: 34,
                letterSpacing: -2,
                color: Styles.drg_colorSecondary,
                shadows: [
                  Shadow(
                    color: Styles.drg_colorText.withOpacity(.3),
                    blurRadius: 8,
                  ),
                  Shadow(
                      color: Styles.drg_colorText.withOpacity(.1),
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
              color: Styles.drg_colorText.withOpacity(0.7),
              shadows: [
                Shadow(
                  color: Styles.drg_colorText.withOpacity(.2),
                  blurRadius: 5,
                ),
                Shadow(
                    color: Styles.drg_colorText.withOpacity(.2),
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

class BuildListOfSets extends StatelessWidget {
  const BuildListOfSets({
    Key key,
    @required this.surveySetsBloc,
    @required this.surveySetSnapshot,
  }) : super(key: key);

  final PrismSurveySetBloc surveySetsBloc;
  final AsyncSnapshot<QuerySnapshot> surveySetSnapshot;

  @override
  Widget build(BuildContext context) {
    return ListView(
      scrollDirection: Axis.vertical,
      padding: EdgeInsets.only(bottom: 90),
      physics: BouncingScrollPhysics(),
      children: surveySetSnapshot.data.documents.map(
        (DocumentSnapshot surveySetDokumentSnapshot) {
          if (!(surveySetSnapshot.connectionState == ConnectionState.done)) {
            return Center(
                child: CircularProgressIndicator(
              strokeWidth: 10,
            ));
          }
          if (!surveySetDokumentSnapshot.exists) {
            Text("surveySetDokumentSnapshot does not exist");
          }
          return Slidable(
            key: ValueKey(surveySetDokumentSnapshot.hashCode),
            actionPane: SlidableBehindActionPane(),
            actionExtentRatio: .20,
            // actions: <Widget>[
            //   IconSlideAction(
            //     caption: 'Archive',
            //     color: Colors.blue,
            //     icon: Icons.archive,
            //     onTap: () {},
            //   ),
            // ],
            secondaryActions: <Widget>[
              // IconSlideAction(
              //   caption: 'More',
              //   color: Styles.drg_colorSecondaryDeepDark,
              //   icon: Icons.more_horiz,
              //   onTap: () {
              //     log("In BuildSurveySesListView Slidable 'More..'");
              //   },
              // ),
              IconSlideAction(
                caption: 'Delete',
                color: Styles.drg_colorAttention,
                icon: Icons.delete,
                onTap: () {
                  log("In BuildSurveySesListView ListView Dismissible Item name: ${surveySetDokumentSnapshot.data['name']}, id: ${surveySetDokumentSnapshot.documentID} is dismissed'");
                  surveySetsBloc.deletePrismSurveySetById(
                      id: surveySetDokumentSnapshot.documentID);

                  Scaffold.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: Styles.drg_colorAttention,
                      elevation: 20,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40)),
                      content: Text(
                          "${surveySetDokumentSnapshot.data['name']} has been deleted."),
                    ),
                  );
                },
              ),
            ],
            // onDismissed: (direction) {
            //   surveySetsBloc.deletePrismSurveySetById(
            //       id: surveySetDokumentSnapshot.documentID);
            // },
            child: Container(
              margin: EdgeInsets.only(left: 14, bottom: 1, top: 1),
              color: Styles.drg_colorSecondary.withOpacity(0),
              child: ClipRRect(
                clipBehavior: Clip.antiAlias,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(65),
                  bottomLeft: Radius.circular(65),
                ),
                child: Container(
                  padding: EdgeInsets.only(left: 16, bottom: 4),
                  decoration: BoxDecoration(
                    color: Styles.drg_colorSecondary.withOpacity(.7),
                  ),
                  child: ListTile(
                    onTap: () {
                      surveySetsBloc.setCurrentPrismSurveySetById(
                          id: surveySetDokumentSnapshot.documentID);
                      Navigator.pushNamed(context, '/surveysetscaffold',
                          arguments: {
                            "id": "${surveySetDokumentSnapshot.documentID}"
                          });
                    },
                    title: Text(
                      "${surveySetDokumentSnapshot.data['name']}",
                      style: TextStyle(
                        color: Styles.drgColorTextMediumLight,
                        fontFamily: 'Bitter',
                        fontSize: Styles.drg_fontSizeMediumHeadline,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Text(
                        "Resolution: ${surveySetDokumentSnapshot.data['resolution']} \n${timeago.format(DateTime.now().subtract(DateTime.now().difference(surveySetDokumentSnapshot['created'].toDate())))}"),
                  ),
                ),
              ),
            ),
          );
        },
      ).toList(),
    );
  }
}
