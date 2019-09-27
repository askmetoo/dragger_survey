import 'package:dragger_survey/src/blocs/blocs.dart';
import 'package:dragger_survey/src/services/models.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DraggerBoardButtonRow extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  const DraggerBoardButtonRow({
    this.formKey,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final PrismSurveyBloc prismSurveyBloc =
        Provider.of<PrismSurveyBloc>(context);
    final TeamBloc teamBloc =
        Provider.of<TeamBloc>(context);
    FirebaseUser user = Provider.of<FirebaseUser>(context);

    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          SizedBox(
            width: double.infinity,
            child: FlatButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              color: Colors.orangeAccent,
              textColor: Color(0xff662d00),
              child: Text("Ergebnis speichern"),
              onPressed: () {
                Scaffold.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                        'Processing data \n${prismSurveyBloc.created} \n${prismSurveyBloc.rowIndex} \n${prismSurveyBloc.colIndex} \n${prismSurveyBloc.currentAskedPerson}'),
                  ),
                );
                Map<String, dynamic> survey = {
                  "created": prismSurveyBloc.created,
                  "askedPerson": prismSurveyBloc.currentAskedPerson,
                  "team": teamBloc.currentSelectedTeam?.documentID,
                  "edited": DateTime.now(),
                  "users": user.uid,
                  "xValue": prismSurveyBloc.colIndex,
                  "yValue": prismSurveyBloc.rowIndex,
                };
                prismSurveyBloc.addPrismSurveyToDb(survey: survey);
              },
            ),
          ),
          Container(
            height: 30,
          ),
        ],
      ),
    );
  }
}
