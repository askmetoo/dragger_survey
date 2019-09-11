import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dragger_survey/src/blocs/blocs.dart';
import 'package:dragger_survey/src/enums/connectivity_status.dart';
import 'package:dragger_survey/src/services/models.dart';
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
  String _currentTeamID;

  @override
  Widget build(BuildContext context) {
    final PrismSurveySetBloc surveySetsBloc =
        Provider.of<PrismSurveySetBloc>(context);
    final SignInBloc signInBloc = Provider.of<SignInBloc>(context);
    final TeamBloc teamBloc = Provider.of<TeamBloc>(context);

    return FutureBuilder<DocumentSnapshot>(
        future: teamBloc.currentSelectedTeam,
        builder: (context, AsyncSnapshot<DocumentSnapshot> selectedTeamSnapshot) {
          if (selectedTeamSnapshot.connectionState == ConnectionState.none ||
              selectedTeamSnapshot.connectionState == ConnectionState.waiting ||
              selectedTeamSnapshot.connectionState == ConnectionState.active) {
            print("In BuildSurveySetsListView - selectedTeamSnapshot.connectionState: ${selectedTeamSnapshot.connectionState}");
            return Text("BuildSurveySetsListView - documentID: ${selectedTeamSnapshot?.data?.documentID}");
          }
          if (selectedTeamSnapshot.connectionState == ConnectionState.done) {
            print("In BuildSurveySetsListView - selectedTeamSnapshot.connectionState: ${selectedTeamSnapshot.connectionState}");
            print("In BuildSurveySetsListView before FutureBuilder getPrismSurveySetQuery - _currentTeamID: $_currentTeamID");
            return FutureBuilder<QuerySnapshot>(
              future: surveySetsBloc.getPrismSurveySetQuery(
                  fieldName: 'createdByTeam',
                  fieldValue: _currentTeamID).catchError((err) => log("ERROR in BuildSurveySetsListView getPrismSurveySetQuery: $err")),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> surveySetSnapshot) {
                final connectionStatus = Provider.of<ConnectivityStatus>(context);

                if (
                  surveySetSnapshot.connectionState == ConnectionState.none ||
                  surveySetSnapshot.connectionState == ConnectionState.waiting ||
                  surveySetSnapshot.connectionState == ConnectionState.active
                ) log("In BuildSurveySetsListView surveySetSnapshot ConntectionState: ${surveySetSnapshot.connectionState}");

                if (surveySetSnapshot.connectionState == ConnectionState.done) {
                  
                  if (connectionStatus == ConnectivityStatus.Offline) {
                    return Text(
                      "You are currently ${connectionStatus.toString().split('.')[1]}",
                      style: TextStyle(fontSize: 20, color: Styles.drg_colorSecondaryDeepDark),
                    );
                  }

                  log("In BuildSurveySetsListView - future surveySetsBloc ConnectionState.done");
                  log("In BuildSurveySetsListView - future current teamId: ${selectedTeamSnapshot?.data['id']}");
                  log("In BuildSurveySetsListView - future surveySetSnapshot ${selectedTeamSnapshot?.data}");
                  log("In BuildSurveySetsListView - future surveySetSnapshot ${selectedTeamSnapshot?.data['created']}");
                  return ListView(
                      scrollDirection: Axis.vertical,
                      children: surveySetSnapshot.data.documents.map(
                        (DocumentSnapshot surveySetDokumentSnapshot) {
                          return Dismissible(
                            key: ValueKey(
                                surveySetDokumentSnapshot.hashCode),
                            direction: DismissDirection.endToStart,
                            onDismissed: (direction) => print(
                                '------>>> Item ${surveySetDokumentSnapshot['name']} is dismissed'),
                            child: ListTile(
                              onTap: () {
                                Navigator.pushNamed(
                                    context, '/surveysetscaffold', arguments: {
                                  "id":
                                      "${surveySetDokumentSnapshot['id']}"
                                });
                              },
                              title: Text(
                                "Name: ${surveySetDokumentSnapshot['name']}, id: ${surveySetDokumentSnapshot['id']}",
                                style: Styles.drg_textListTitle,
                              ),
                              subtitle: Text(
                                "Created: ${formatDate( DateTime.parse(surveySetDokumentSnapshot['created']) , [
                                  dd,
                                  '. ',
                                  MM,
                                  ' ',
                                  yyyy,
                                  ', ',
                                  HH,
                                  ':',
                                  nn
                                ])} by ${signInBloc.currentUser}",
                                style: Styles.drg_textListContent,
                              ),
                            ),
                          );
                        },
                      ).toList());
                }
                return Container();
              },
            );
          }
          return Container();
        });
  }
}