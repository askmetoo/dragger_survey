import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dragger_survey/src/styles.dart';
import 'package:flutter/material.dart';
import 'package:dragger_survey/src/blocs/blocs.dart';
import 'package:provider/provider.dart';
import 'package:date_format/date_format.dart';

class SurveySetsListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final PrismSurveySetBloc surveySetsBloc =
        Provider.of<PrismSurveySetBloc>(context);

    return Scaffold(
      backgroundColor: Styles.appBackground,
      appBar: AppBar(
        title: Text("Survey Sets"),
      ),
      body: _buildSetsListView(surveySetsBloc, context),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Styles.colorSecondary,
        child: Icon(
          Icons.library_add,
          color: Styles.colorDarkerGreen,
        ),
        tooltip: "Add new Survey Set",
        onPressed: () {
          print("Add new Survey Set button pressed");
        },
      ),
    );
  }

  Widget _buildSetsListView(PrismSurveySetBloc bloc, BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: bloc.streamPrismSurveySets,
      builder: (BuildContext context,
          AsyncSnapshot<QuerySnapshot> surveySetSnapshot) {
        if (surveySetSnapshot.hasError) {
          return Text("Loading Set has erroro: ${surveySetSnapshot.error}");
        }

        switch (surveySetSnapshot.connectionState) {
          case ConnectionState.waiting:
            return Center(
              child: CircularProgressIndicator(),
            );
          case ConnectionState.active:
          case ConnectionState.done:
          default:
            return ListView(
                children: surveySetSnapshot.data.documents
                    .map((DocumentSnapshot snapshot) {
              return ListTile(
                title: Text(
                  "Name: ${snapshot['name']}, id: ${snapshot.documentID}",
                  style: Styles.textListTitle,
                ),
                subtitle: Text(
                  "Created: ${formatDate(snapshot['created'].toDate(), [
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
                  style: Styles.textListContent,
                ),
              );
            }).toList());
        }
      },
    );
  }
}
