import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dragger_survey/src/blocs/blocs.dart';
import 'package:dragger_survey/src/services/models.dart';
import 'package:dragger_survey/src/styles.dart';
import 'package:flutter/material.dart';
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

  buildSurveyList(
      {BuildContext context,
      AsyncSnapshot<DocumentSnapshot> surveySetsSnapshot}) {
    final PrismSurveySetBloc surveySetBloc =
        Provider.of<PrismSurveySetBloc>(context);
    final PrismSurveyBloc surveyBloc =
        Provider.of<PrismSurveyBloc>(context);

    return Expanded(
      child: ListView.builder(
        itemCount: surveySetsSnapshot.data.data['surveys'].length,
        scrollDirection: Axis.vertical,
        itemBuilder: (BuildContext context, int index){
          // return Text('Test item $index');
          return Dismissible(
            key: ValueKey(index),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) {},
            child: ListTile(
              onTap: () {},
              title: FutureBuilder<Object>(
                future: surveyBloc.getPrismSurveyById(id: surveySetsSnapshot.data.data['surveys'][index]),
                builder: (context, AsyncSnapshot surveySnapshot) {
                  if (!(surveySnapshot.connectionState == ConnectionState.done)) {
                    return CircularProgressIndicator();
                  }
                  if (!surveySnapshot.hasData ) {
                    return Text("No data in survey");
                  }

                  try {
                     if (surveySnapshot.data['created'] != null) {
                       return Text("Survey created: ${surveySnapshot?.data['created']} \nid: ${surveySetsSnapshot.data.data['surveys'][index]}");
                     }
                  } catch (e) {
                    return Container();
                  }
                  return Container();
                }
              ),
            ),
          );
        },
      )
    );
  }

  aaabuildSurveyList(
      {@required BuildContext context,
      AsyncSnapshot<DocumentSnapshot> surveySetsSnapshot}) {
    final PrismSurveySetBloc surveySetBloc =
        Provider.of<PrismSurveySetBloc>(context);
    final PrismSurveyBloc prismSurveyBloc =
        Provider.of<PrismSurveyBloc>(context);

    return FutureBuilder<DocumentSnapshot>(
      future: surveySetBloc.getPrismSurveySetById(
          id: surveySetsSnapshot.data.documentID),
      builder: (context, AsyncSnapshot<DocumentSnapshot> surveySetSnapshot) {
        if (!(surveySetsSnapshot.connectionState == ConnectionState.done)) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        if (!surveySetSnapshot.hasData || surveySetSnapshot.data == null) {
          return Center(
            child: Text("No data available"),
          );
        }

        return Expanded(
          child: ListView(
            scrollDirection: Axis.vertical,
            children: surveySetSnapshot.data.data['surveys'].map(
              (PrismSurvey survey) {
                return Dismissible(
                  key: ValueKey(surveySetSnapshot.data.hashCode),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) {},
                  child: ListTile(
                    onTap: () {},
                    title: Text("Survey id: {survey.data}"),
                  ),
                );
              },
            ).toList,
          ),
        );
      },
    );

    // return ListView(
    //   scrollDirection: Axis.vertical,
    //   children: <Widget>[
    //     FutureBuilder<DocumentSnapshot>(
    //       future: surveySetBloc.getPrismSurveySetById(id: surveySetsSnapshot.data.documentID),
    //       builder: (context, AsyncSnapshot<DocumentSnapshot> surveySetSnapshot) {

    //         if (!(surveySetsSnapshot.connectionState == ConnectionState.done)) {
    //           return Center(child: CircularProgressIndicator(),);
    //         }
    //         if (!surveySetSnapshot.hasData || surveySetSnapshot.data == null) {
    //           return Center(child: Text("No data available"),);
    //         }
    //         log("In SurveySetDetailsScreen surveySetSnapshot.data.data['surveys'][0]: ${surveySetSnapshot.data.data['surveys'][0]}");

    //         surveySetSnapshot.data.data['surveys'].forEach( (survey) {
    //           return Dismissible(
    //             key: ValueKey(1),
    //             child: Text("Survey id: ",)
    //           );
    //         });
    //         return Container();
    //       }
    //     ),
    //   ],
    // );
  }

  buildMetaDataList({surveySetsSnapshot}) {
    List<Widget> metaDataList = [
      Text(
        "Survey Set name: ${surveySetsSnapshot?.data['name']}",
        style: TextStyle(fontSize: Styles.drg_fontSizeMediumHeadline),
      ),
      Text("Survey Set description: ${surveySetsSnapshot.data['description']}",
          style: TextStyle(fontSize: Styles.drg_fontSizesubHeadline)),
      Text(
        "Granularity: ${surveySetsSnapshot.data['resolution']} \nCreated by User ID: ${surveySetsSnapshot.data['createdByUser']} \nUser displayName: TODO",
        style: TextStyle(fontSize: Styles.drg_fontSizeCopyText),
      ),
    ];
    return metaDataList;
  }
}
