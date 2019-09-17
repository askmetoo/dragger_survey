import 'dart:developer';

import 'package:dragger_survey/src/styles.dart';
import 'package:dragger_survey/src/widgets/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:dragger_survey/src/blocs/blocs.dart';
import 'package:provider/provider.dart';

class SurveySetsListScreen extends StatefulWidget {
  final String teamId;
  SurveySetsListScreen({Key key, this.teamId}) : super(key: key);

  @override
  _SurveySetsListScreenState createState() => _SurveySetsListScreenState();
}

class _SurveySetsListScreenState extends State<SurveySetsListScreen> {
  // String currentUser = '';

  @override
  Widget build(BuildContext context) {
    Provider.of<PrismSurveySetBloc>(context);

    FirebaseUser user = Provider.of<FirebaseUser>(context);
    bool loggedIn = user != null;
    if (!loggedIn) {
      log("In SurveySetsListScreen - User is not signed in!");
      // return SplashScreen();
    }
    return Scaffold(
      backgroundColor: Styles.drg_colorAppBackground,
      endDrawer: UserDrawer(),
      appBar: AppBar(
        actions: <Widget>[
          SigendInUserCircleAvatar(),
        ],
        title: Text("Survey Sets"),
      ),
      body: Column(
        children: <Widget>[
          BuildTeamsDropdownButton(),
          Expanded(
            child: BuildSurveySetsListView(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Styles.drg_colorSecondary,
        child: Icon(
          Icons.library_add,
          color: Styles.drg_colorDarkerGreen,
        ),
        tooltip: "Add new Survey Set",
        onPressed: () {
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
}
