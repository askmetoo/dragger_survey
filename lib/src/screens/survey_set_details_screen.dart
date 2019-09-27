import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:dragger_survey/src/blocs/blocs.dart';
import 'package:dragger_survey/src/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

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
            padding: const EdgeInsets.all(20.0),
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ...buildMetaDataList(surveySetsSnapshot: surveySetsSnapshot),
                  Divider(),
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
    Future<QuerySnapshot> _surveyList;


    if (surveySetsSnapshot.connectionState == ConnectionState.done) {
      if (!surveySetsSnapshot.hasData) {
        return CircularProgressIndicator();
      }

      try {
        // log("In SurveySetDetailsScreen surveySetsSnapshot.data.documentID: ${surveySetsSnapshot.data.documentID}");
        _surveyList = surveyBloc.getPrismSurveyQueryOrderCreatedDesc(fieldName: 'surveySet', fieldValue: surveySetsSnapshot.data.documentID);
      } catch (e) {
        log("ERROR in SurveySetDetailsScreen try surveysArray: $e");
      }

      return FutureBuilder<QuerySnapshot>(
        future: _surveyList,
        builder: (context, AsyncSnapshot<QuerySnapshot> surveySnapshot) {
          if (surveySnapshot.connectionState == ConnectionState.done) {
            if( surveySnapshot.data.documents == null ) {
              return Text(">>> No Surveys yet! <<<");
            }
          return Expanded(
                  child: ListView.builder(
                  itemCount: surveySnapshot.data.documents.length,
                  // itemCount: surveySetsSnapshot?.data?.data['surveys']?.length,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (BuildContext context, int index) {
                    log("-----> In SurveySetDetailsScreen ListView index: $index");
                    DocumentSnapshot document = surveySnapshot.data.documents[index];
                    return Slidable(
                      key: ValueKey(index),
                      actionPane: SlidableDrawerActionPane(),
                      actionExtentRatio: 0.25,
                      // actions: <Widget>[
                      //   IconSlideAction(
                      //     caption: 'Archive',
                      //     color: Colors.blue,
                      //     icon: Icons.archive,
                      //     onTap: () {},
                      //   ),
                      // ],
                      secondaryActions: <Widget>[
                        IconSlideAction(
                          caption: 'More',
                          color: Styles.drg_colorSecondaryDeepDark,
                          icon: Icons.more_horiz,
                          onTap: () {
                            log("In SurveySetDetailsScreen Slidable 'More..'");
                          },
                        ),
                        IconSlideAction(
                          caption: 'Delete',
                          color: Styles.drg_colorAttention,
                          icon: Icons.delete,
                          onTap: () {
                            String _surveyId =
                                surveySetsSnapshot?.data?.data['surveys'][index];
                            log("In SurveySetDetailsScreen Slidable 'Delete': $_surveyId");
                          },
                        ),
                      ],
                      child: ListTile(
                        onTap: () {},
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text("Asked: ${document.data['askedPerson']}"),
                            Text("Created: ${formatDate(
                                      document.data['created'].toDate(), [
                                    'dd',
                                    '.',
                                    'mm',
                                    '.',
                                    'yyyy',
                                    ', ',
                                    'HH',
                                    ':',
                                    'nn',
                                    ':',
                                    'ss'
                                  ])
                                  }"),
                          ],
                        ),
                        // title: FutureBuilder<Object>(
                        //     future: surveyBloc.getPrismSurveyById(
                        //         id: surveySnapshot?.data?.documents[index]),
                        //     builder: (context, AsyncSnapshot surveySnapshot) {
                        //       if (!(surveySnapshot.connectionState ==
                        //           ConnectionState.done)) {
                        //         return CircularProgressIndicator();
                        //       }
                        //       if (!surveySnapshot.hasData) {
                        //         return Text("No data in survey");
                        //       }

                        //       try {
                        //         if (surveySnapshot.data['created'] != null) {
                        //           String formattedDate = formatDate(
                        //               surveySnapshot?.data['created'].toDate(), [
                        //             'dd',
                        //             '.',
                        //             'mm',
                        //             '.',
                        //             'yyyy',
                        //             ', ',
                        //             'HH',
                        //             ':',
                        //             'nn',
                        //             ':',
                        //             'ss'
                        //           ]);
                        //           return Text(
                        //               "Survey created: $formattedDate h \nid: ${surveySetsSnapshot.data.data['surveys'][index]}");
                        //         }
                        //       } catch (e) {
                        //         return Container();
                        //       }
                        //       return Container();
                        //     }),
                      ),
                    );
                  },
                ));
                }
                return Container();
        }
      );
    }
  }

  buildMetaDataList({surveySetsSnapshot}) {
    List<Widget> metaDataList = [
      Text(
        "${surveySetsSnapshot?.data['name']}",
        style: TextStyle(
            fontSize: Styles.drg_fontSizeMediumHeadline,
            fontFamily: 'Bitter',
            fontWeight: FontWeight.w700),
      ),
      Text("${surveySetsSnapshot.data['description']}",
          style: TextStyle(
              fontSize: Styles.drg_fontSizesubHeadline,
              fontWeight: FontWeight.w500)),
      Text(
        "Granularity: ${surveySetsSnapshot.data['resolution']} \nCreated by User ID: ${surveySetsSnapshot.data['createdByUser']} \nUser displayName: TODO",
        style: TextStyle(fontSize: Styles.drg_fontSizeCopyText),
      ),
    ];
    return metaDataList;
  }
}
