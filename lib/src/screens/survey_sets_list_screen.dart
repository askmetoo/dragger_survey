import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dragger_survey/src/screens/splash_screen.dart';
import 'package:dragger_survey/src/styles.dart';
import 'package:dragger_survey/src/widgets/survey_set_form.dart';
import 'package:flutter/material.dart';
import 'package:dragger_survey/src/blocs/blocs.dart';
import 'package:provider/provider.dart';
import 'package:date_format/date_format.dart';

class SurveySetsListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final PrismSurveySetBloc surveySetsBloc =
        Provider.of<PrismSurveySetBloc>(context);
    final SignInBloc signInBloc = Provider.of<SignInBloc>(context);

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
        context: context,
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
      BuildContext context}) {
    return StreamBuilder<QuerySnapshot>(
      stream: surveySetsBloc.streamPrismSurveySets,
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

  // _confirmDismissed() async {
  //   print('Confirm item dismissed');
  //   return await showDialog(
  //       builder: (BuildContext context) {
  //         return AlertDialog(
  //           title: Text("Are yout sure you want to delete this item?"),
  //           actions: <Widget>[
  //             FlatButton(
  //               child: Text('Confirm'),
  //               onPressed: () {
  //                 Navigator.pop(context);
  //               },
  //             ),
  //             FlatButton(
  //               child: Text('Cancel'),
  //               onPressed: () {
  //                 Navigator.pop(context);
  //               },
  //             ),
  //           ],
  //         );
  //       });
  // }

  // _onDismissed(DocumentSnapshot snapshot) {
  //   print('Item ${snapshot?.data['name']} is dismissed');
  // }
}
