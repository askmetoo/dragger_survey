import 'dart:developer';

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
    final SignInBloc signInBloc = Provider.of<SignInBloc>(context);

    return FutureBuilder<FirebaseUser>(
        future: signInBloc.currentUser,
        builder:
            (BuildContext context, AsyncSnapshot<FirebaseUser> signInSnapshot) {
          if (signInSnapshot.connectionState == ConnectionState.none ||
              signInSnapshot.connectionState == ConnectionState.waiting ||
              signInSnapshot.connectionState ==
                  ConnectionState.active) if (signInSnapshot.connectionState ==
              ConnectionState.done) {
            if (!signInSnapshot.hasData) CircularProgressIndicator();

            if (signInSnapshot.data.uid == null) {
              return SplashScreen();
            }

            return FutureBuilder<DocumentSnapshot>(
                future: surveySetsBloc.getPrismSurveySetById(
                    id: signInSnapshot.data.uid),
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> surveySetsSnapshot) {
                  if (surveySetsSnapshot.connectionState ==
                          ConnectionState.none ||
                      surveySetsSnapshot.connectionState ==
                          ConnectionState.waiting ||
                      surveySetsSnapshot.connectionState ==
                          ConnectionState.active)
                    log("In SurveySetDetailsScreen - ${surveySetsSnapshot.connectionState}");

                  if (surveySetsSnapshot.connectionState ==
                      ConnectionState.done) {
                    if (surveySetsSnapshot?.data == null) {
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
                              "Survey name: ${surveySetsSnapshot.data['name']}",
                              style: TextStyle(
                                  fontSize: Styles.drg_fontSizeMediumHeadline),
                            ),
                            Text(
                                "Survey description: ${surveySetsSnapshot.data['description']}",
                                style: TextStyle(
                                    fontSize: Styles.drg_fontSizesubHeadline)),
                            Text(
                              "Granularity: ${surveySetsSnapshot.data['resolution']} \nCreated by User ID: ${surveySetsSnapshot.data['createdByUser']} \nUser displayName: ${signInSnapshot.data.displayName}",
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
          return Container();
        });
  }
}
