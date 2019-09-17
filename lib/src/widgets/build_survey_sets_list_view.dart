import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dragger_survey/src/blocs/blocs.dart';
import 'package:dragger_survey/src/enums/connectivity_status.dart';
import 'package:dragger_survey/src/styles.dart';
import 'package:flutter/material.dart';
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
        child: Text("Please select a team"),
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
              child: Text(
                "Currently no available survey sets. \n\nPlease select another team \nor create a set",
                textAlign: TextAlign.center,
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
                return Dismissible(
                  key: ValueKey(surveySetDokumentSnapshot.hashCode),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) {
                    print(
                        '----> Item ${surveySetDokumentSnapshot['name']} is dismissed');
                    surveySetsBloc.deletePrismSurveySetById(
                        id: surveySetDokumentSnapshot.documentID);
                  },
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
                        style: Styles.drg_textListTitle,
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
