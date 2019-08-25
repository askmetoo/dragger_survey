import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dragger_survey/src/screens/splash_screen.dart';
import 'package:dragger_survey/src/styles.dart';
import 'package:dragger_survey/src/widgets/survey_set_form.dart';
import 'package:flutter/material.dart';
import 'package:dragger_survey/src/blocs/blocs.dart';
import 'package:provider/provider.dart';
import 'package:date_format/date_format.dart';

class SurveySetsListScreen extends StatelessWidget {
  final String teamId;
  SurveySetsListScreen({Key key, this.teamId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final PrismSurveySetBloc surveySetsBloc =
        Provider.of<PrismSurveySetBloc>(context);
    final SignInBloc signInBloc = Provider.of<SignInBloc>(context);
    final TeamBloc teamBloc = Provider.of<TeamBloc>(context);

    if (signInBloc.signedInUser == null) {
      print("User is not signed in!");
      return SplashScreen();
    }

    return Scaffold(
      backgroundColor: Styles.drg_colorAppBackground,
      appBar: AppBar(
        title: Text("Survey Sets"),
      ),
      body: _buildSetsListView(
        surveySetsBloc: surveySetsBloc,
        signInBloc: signInBloc,
        teamBloc: teamBloc,
        context: context,
        id: teamId,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Styles.drg_colorSecondary,
        child: Icon(
          Icons.library_add,
          color: Styles.drg_colorDarkerGreen,
        ),
        tooltip: "Add new Survey Set",
        onPressed: () {
          print("Add new Survey Set button pressed");
          print("----------=======> Current Team id: $teamId");
          print("----------=======> Current Team: ${teamBloc.currentTeamId}");
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(3),
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                  ),
                  title: Text("New survey set"),
                  backgroundColor: Styles.drg_colorSecondary,
                  contentTextStyle: TextStyle(color: Styles.drg_colorText),
                  content: SurveySetForm(),
                );
              });
        },
      ),
    );
  }

  Widget _buildSetsListView(
      {PrismSurveySetBloc surveySetsBloc,
      SignInBloc signInBloc,
      TeamBloc teamBloc,
      BuildContext context,
      @required String id}) {
    return StreamBuilder<QuerySnapshot>(
      stream: surveySetsBloc
          .getPrismSurveySetQuery(
              fieldName: 'createdByTeam', fieldValue: teamId)
          .asStream(),
      builder: (BuildContext context,
          AsyncSnapshot<QuerySnapshot> surveySetSnapshot) {
        if (surveySetSnapshot.hasError) {
          return Center(
            child: Container(
              child: Text("Loading Set has erroro: ${surveySetSnapshot.error}"),
            ),
          );
        }

        

        switch (surveySetSnapshot.connectionState) {
          case ConnectionState.waiting:
            return Center(
              child: CircularProgressIndicator(),
            );
          case ConnectionState.active:
          case ConnectionState.done:
          default:

            if (surveySetSnapshot.data.documents.length <= 0 || surveySetSnapshot == null) {
              return Center(
                child: Container(
                  child: Text("This Team has no Survey Sets"),
                ),
              );
            }

            return ListView(
                scrollDirection: Axis.vertical,
                children: surveySetSnapshot.data.documents
                    .map((DocumentSnapshot snapshot) {
                  return Dismissible(
                    key: ValueKey(snapshot.data.hashCode),
                    direction: DismissDirection.endToStart,
                    onDismissed: (direction) => print(
                        '------>>> Item ${snapshot?.data['name']} is dismissed'),
                    child: ListTile(
                      onTap: () {
                        print(
                            "Before Navigator in ListTile of Teams - teamId: ${snapshot?.documentID}");
                        Navigator.pushNamed(context, '/surveysetscaffold',
                            arguments: {"id": "${snapshot?.documentID}"});
                      },
                      title: Text(
                        "Name: ${snapshot['name']}, id: ${snapshot.documentID}",
                        style: Styles.drg_textListTitle,
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
                        ])} by ${signInBloc.signedInUser?.displayName}",
                        style: Styles.drg_textListContent,
                      ),
                    ),
                  );
                }).toList());
        }
      },
    );
  }
}
