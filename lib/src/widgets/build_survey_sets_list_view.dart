import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dragger_survey/src/blocs/blocs.dart';
import 'package:dragger_survey/src/enums/connectivity_status.dart';
import 'package:dragger_survey/src/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:date_format/date_format.dart';

class BuildSurveySetsListView extends StatefulWidget {
  BuildSurveySetsListView({Key key}) : super(key: key);

  @override
  _BuildSurveySetsListViewState createState() =>
      _BuildSurveySetsListViewState();
}

class _BuildSurveySetsListViewState extends State<BuildSurveySetsListView> {
  @override
  Widget build(BuildContext context) {
    final PrismSurveySetBloc surveySetsBloc =
        Provider.of<PrismSurveySetBloc>(context);
    final TeamBloc teamBloc = Provider.of<TeamBloc>(context);
    if (teamBloc?.currentSelectedTeam?.documentID == null) {
      return Center(
        child: Column(
          children: <Widget>[
            Spacer(),
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
            Text(
              "please, first chose a team for which",
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
            Spacer(),
            Spacer(),
          ],
        ),
      );
    }
    return FutureBuilder<QuerySnapshot>(
      future: surveySetsBloc
          .getPrismSurveySetQuery(
              fieldName: 'createdByTeam',
              fieldValue: teamBloc?.currentSelectedTeam?.documentID)
          .catchError((err) => log(
              "ERROR in BuildSurveySetsListView getPrismSurveySetQuery: $err")),
      builder: (BuildContext context,
          AsyncSnapshot<QuerySnapshot> surveySetSnapshot) {
        final connectionStatus = Provider.of<ConnectivityStatus>(context);

        if (surveySetSnapshot.connectionState == ConnectionState.done) {
          if (!surveySetSnapshot.hasData) {
            return CircularProgressIndicator();
          }

          if (connectionStatus == ConnectivityStatus.Offline) {
            return Text(
              "You are currently ${connectionStatus.toString().split('.')[1]}",
              style: TextStyle(
                  fontSize: 20, color: Styles.drg_colorSecondaryDeepDark),
            );
          }
          if (surveySetSnapshot.data.documents.isEmpty) {
            return Center(
              child: Column(
                children: <Widget>[
                  Spacer(),
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
                  Spacer(),
                  Spacer(),
                ],
              ),
            );
          }

          return ListView(
            scrollDirection: Axis.vertical,
            children: surveySetSnapshot.data.documents.map(
              (DocumentSnapshot surveySetDokumentSnapshot) {
                if (!(surveySetSnapshot.connectionState ==
                    ConnectionState.done)) {
                  return Center(child: CircularProgressIndicator());
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
                          // fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: Text(
                        "By Team: ${surveySetDokumentSnapshot.data['createdByTeamName']} \nCreated: ${formatDate(surveySetDokumentSnapshot['created'].toDate(), [
                          dd,
                          '. ',
                          MM,
                          ' ',
                          yyyy,
                          ', ',
                          HH,
                          ':',
                          nn
                        ])}",
                        style: Styles.drg_textListContent,
                      )),
                );
              },
            ).toList(),
          );
        }
        return Container();
      },
    );
  }
}
