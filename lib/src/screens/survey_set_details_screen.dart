import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dragger_survey/src/blocs/blocs.dart';
import 'package:dragger_survey/src/styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter_slidable/flutter_slidable.dart';

class SurveySetDetailsScreen extends StatelessWidget {
  final String surveySetId;
  SurveySetDetailsScreen({Key key, this.surveySetId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final PrismSurveySetBloc surveySetsBloc =
        Provider.of<PrismSurveySetBloc>(context);

    log("In SurveySetDetailsScreen - id: $surveySetId");

    return FutureBuilder<DocumentSnapshot>(
      future: surveySetsBloc.getPrismSurveySetById(id: surveySetId),
      builder: (BuildContext context,
          AsyncSnapshot<DocumentSnapshot> surveySetsSnapshot) {
        if (surveySetsSnapshot.connectionState == ConnectionState.done) {
          if (surveySetsSnapshot.data.documentID == null) {
            log("In survey_set_details_screen - Snapshot has no data.");
            return Center(
              child: Container(
                child: Text("No Content"),
              ),
            );
          }
          return Padding(
            padding: EdgeInsets.only(top: 20.0),
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  buildMetaHeader(surveySetsSnapshot: surveySetsSnapshot),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    child: Text("Surveys made:"),
                  ),
                  buildSurveyList(
                      context: context, surveySetsSnapshot: surveySetsSnapshot)
                ],
              ),
            ),
          );
        }
        return Text("Nothing here");
      },
    );
  }

  buildSurveyList({
    BuildContext context,
    AsyncSnapshot<DocumentSnapshot> surveySetsSnapshot,
  }) {
    final PrismSurveyBloc surveyBloc = Provider.of<PrismSurveyBloc>(context);
    final PrismSurveySetBloc surveySetBloc =
        Provider.of<PrismSurveySetBloc>(context);
    Future<QuerySnapshot> _surveyList;

    if (surveySetsSnapshot.connectionState == ConnectionState.done) {
      if (!surveySetsSnapshot.hasData) {
        return CircularProgressIndicator();
      }

      try {
        surveySetBloc.setCurrentPrismSurveySetId(
            id: surveySetsSnapshot?.data?.documentID);
        surveySetBloc.setCurrentPrismSurveySetById(
            id: surveySetsSnapshot?.data?.documentID);
        _surveyList = surveyBloc.getPrismSurveyQueryOrderCreatedDesc(
            fieldName: 'surveySet',
            fieldValue: surveySetsSnapshot.data.documentID);
      } catch (e) {
        log("ERROR in SurveySetDetailsScreen try surveysArray: $e");
      }

      return FutureBuilder<QuerySnapshot>(
          future: _surveyList,
          builder: (context, AsyncSnapshot<QuerySnapshot> surveySnapshot) {
            if (surveySnapshot.connectionState == ConnectionState.done) {
              if (surveySnapshot.data.documents == null) {
                return Text(">>> No Surveys yet! <<<");
              }
              return Expanded(
                  child: ListView.builder(
                itemCount: surveySnapshot.data.documents.length,
                scrollDirection: Axis.vertical,
                itemBuilder: (BuildContext context, int index) {
                  log("-----> In SurveySetDetailsScreen ListView index: $index");
                  DocumentSnapshot document =
                      surveySnapshot.data.documents[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14.0),
                    child: Slidable(
                      key: ValueKey(index),
                      actionPane: SlidableDrawerActionPane(),
                      actionExtentRatio: 0.25,
                      secondaryActions: <Widget>[
                        IconSlideAction(
                          caption: 'Delete',
                          color: Styles.drg_colorAttention,
                          icon: Icons.delete,
                          onTap: () {
                            log("In SurveySetDetailsScreen Slidable 'Delete': ${document.documentID}");
                            surveyBloc.deletePrismSurveyById(id: document.documentID);
                          },
                        ),
                      ],
                      child: Container(
                        margin: EdgeInsets.only(bottom: 1),
                        color: Styles.drg_colorSecondary.withOpacity(.13),
                        height: 36,
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: ListTile(
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              RichText(
                                text: TextSpan(
                                  text: "${document.data['askedPerson']} ",
                                  style: TextStyle(
                                    color: Styles.drg_colorText,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: "was asked.",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w200,
                                      ),
                                    ),
                                    TextSpan(
                                      text: timeago.format(DateTime.now()
                                          .subtract(DateTime.now().difference(
                                              document.data['created']
                                                  .toDate()))),
                                      style: TextStyle(
                                        fontWeight: FontWeight.w200,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ));
            }
            return Container();
          });
    }
  }

  buildMetaHeader({surveySetsSnapshot}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: <Widget>[
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "${surveySetsSnapshot?.data['name']}",
              style: TextStyle(
                  fontSize: Styles.drg_fontSizeMediumHeadline,
                  fontFamily: 'Bitter',
                  fontWeight: FontWeight.w700),
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Text("${surveySetsSnapshot.data['description']}",
                style: TextStyle(
                    fontSize: Styles.drg_fontSizesubHeadline,
                    fontWeight: FontWeight.w500)),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Granularity: ${surveySetsSnapshot.data['resolution']} \nCreated by User ID: ${surveySetsSnapshot.data['createdByUser']} \nUser displayName: TODO",
              style: TextStyle(fontSize: Styles.drg_fontSizeCopyText),
            ),
          ),
        ],
      ),
    );
  }
}
