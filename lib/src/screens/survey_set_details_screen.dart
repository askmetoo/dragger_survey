import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dragger_survey/src/blocs/blocs.dart';
import 'package:dragger_survey/src/screens/splash_screen.dart';
import 'package:dragger_survey/src/styles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SurveySetDetailsScreen extends StatelessWidget {
  final String id;
  SurveySetDetailsScreen({Key key, this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final PrismSurveySetBloc surveySetsBloc =
        Provider.of<PrismSurveySetBloc>(context);

    String _id = id;

    final SignInBloc signInBloc = Provider.of<SignInBloc>(context);

    // if (signInBloc.signedInUser == null) {
    //   print("User is not signed in!!!");
    //   return SplashScreen();
    // }
    if (signInBloc.currentUserUID == null) {
      print(
          "User is not signed in! signInBloc.currentUserUID: ${signInBloc.currentUserUID}");
      return SplashScreen();
    }

    return FutureBuilder<FirebaseUser>(
        future: signInBloc.currentUser,
        builder: (context, signInSnapshot) {
          return FutureBuilder<DocumentSnapshot>(
              future: surveySetsBloc.getPrismSurveySetById(id: _id),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                    return Text("ConnectionState.none");
                    break;
                  case ConnectionState.waiting:
                    return Text("Survey is waiting");
                    break;
                  case ConnectionState.active:
                    return Text("Survey is active");
                    break;
                  case ConnectionState.done:
                    if (snapshot?.data == null) {
                      print(
                          "In survey_set_details_screen - Snapshot has no data.");
                      return Container();
                    }
                    return Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "Survey name: ${snapshot.data['name']}",
                              style: TextStyle(
                                  fontSize: Styles.drg_fontSizeMediumHeadline),
                            ),
                            Text(
                                "Survey description: ${snapshot.data['description']}",
                                style: TextStyle(
                                    fontSize: Styles.drg_fontSizesubHeadline)),
                            Text(
                              "Granularity: ${snapshot.data['resolution']} \nUser ID: ${snapshot.data['createdByUser']} \nUser name: ${signInSnapshot.data.displayName} //TODO!",
                              style: TextStyle(
                                  fontSize: Styles.drg_fontSizeCopyText),
                            ),
                          ],
                        ),
                      ),
                    );
                    break;
                }
                return Text("Nothing here");
              });
        });
  }
}
