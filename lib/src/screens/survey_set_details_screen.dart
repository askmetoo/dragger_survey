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
    final SignInBloc signInBloc =
        Provider.of<SignInBloc>(context);


    return FutureBuilder<FirebaseUser>(
        future: signInBloc.currentUser,
        builder: (BuildContext context, AsyncSnapshot<FirebaseUser> signInSnapshot) {
          switch (signInSnapshot.connectionState) {
            case ConnectionState.none:
              log("In SurveySetDetailsScreen - ConnectionState.none");
              break;
            case ConnectionState.waiting:
              log("In SurveySetDetailsScreen - ConnectionState.waiting");
              break;
            case ConnectionState.active:
              log("In SurveySetDetailsScreen - ConnectionState.active");
              break;
            case ConnectionState.done:
              log("In SurveySetDetailsScreen - ConnectionState.done");

              if(signInSnapshot.data.uid == null) {
                log("In SurveySetDetailsScreen - User is not signed in - signInSnapshot.data.uid: ${signInSnapshot.data.uid}");
                return SplashScreen();
              }

              return FutureBuilder<DocumentSnapshot>(
                  future: surveySetsBloc.getPrismSurveySetById(id: signInSnapshot.data.uid),
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
                                      fontSize:
                                          Styles.drg_fontSizeMediumHeadline),
                                ),
                                Text(
                                    "Survey description: ${snapshot.data['description']}",
                                    style: TextStyle(
                                        fontSize:
                                            Styles.drg_fontSizesubHeadline)),
                                Text(
                                  "Granularity: ${snapshot.data['resolution']} \nUser ID: ${snapshot.data['createdByUser']} \nUser displayName: ${signInSnapshot.data.displayName} //TODO!",
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
              break;
          }
          return Container();
        });
  }
}
