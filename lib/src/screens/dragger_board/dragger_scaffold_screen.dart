import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dragger_survey/src/blocs/prism_survey_set_bloc.dart';
import 'package:dragger_survey/src/screens/screens.dart';
import 'package:dragger_survey/src/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../styles.dart';

class DraggerScaffoldScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final PrismSurveySetBloc surveySetBloc =
        Provider.of<PrismSurveySetBloc>(context);

    return FutureBuilder<DocumentSnapshot>(
        future: surveySetBloc.getPrismSurveySetById(
            id: surveySetBloc.currentPrismSurveySetId),
        builder: (BuildContext context,
            AsyncSnapshot<DocumentSnapshot> currentSurveySnapshot) {
          if (currentSurveySnapshot.connectionState != ConnectionState.done) {
            return Center(
              child: Container(
                constraints: BoxConstraints(maxWidth: 50),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: CircularProgressIndicator(
                    strokeWidth: 10,
                  ),
                ),
              ),
            );
          }
          return Scaffold(
            backgroundColor: Styles.color_AppBackground,
            appBar: AppBar(
              title: currentSurveySnapshot.data != null
                  ? Text("${currentSurveySnapshot?.data['name']}")
                  : Text(''),
            ),
            body: DraggerScreen(),
            endDrawer: UserDrawer(),
          );
        });
  }
}
