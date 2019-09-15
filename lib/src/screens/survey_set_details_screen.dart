import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dragger_survey/src/blocs/blocs.dart';
import 'package:dragger_survey/src/styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SurveySetDetailsScreen extends StatelessWidget {
  final String surveyId;
  SurveySetDetailsScreen({Key key, this.surveyId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final PrismSurveySetBloc surveySetsBloc =
        Provider.of<PrismSurveySetBloc>(context);

        log("In SurveySetDetailsScreen - id: ${surveyId}");

            return FutureBuilder<DocumentSnapshot>(
                future: surveySetsBloc.getPrismSurveySetById(
                    id: surveyId),
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> surveySetsSnapshot) {

                  if (surveySetsSnapshot.connectionState ==
                      ConnectionState.done) {
                    if (surveySetsSnapshot.data.documentID == null) {
                      log(
                          "In survey_set_details_screen - Snapshot has no data.");
                      return Center(child: Container(child: Text("No Content"),),);
                    }
                    log("In SurveySetDetailsScreen - surveySetsSnapshot.data.documentID: ${surveySetsSnapshot.data.documentID}");
                    return Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "Survey name: ${surveySetsSnapshot?.data['name']}",
                              style: TextStyle(
                                  fontSize: Styles.drg_fontSizeMediumHeadline),
                            ),
                            Text(
                                "Survey description: ${surveySetsSnapshot.data['description']}",
                                style: TextStyle(
                                    fontSize: Styles.drg_fontSizesubHeadline)),
                            Text(
                              "Granularity: ${surveySetsSnapshot.data['resolution']} \nCreated by User ID: ${surveySetsSnapshot.data['createdByUser']} \nUser displayName: TODO",
                              style: TextStyle(
                                  fontSize: Styles.drg_fontSizeCopyText),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                  return Text("Nothing here");
                });
          }
}
