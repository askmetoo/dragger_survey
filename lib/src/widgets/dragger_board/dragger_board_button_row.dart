import 'package:dragger_survey/src/blocs/blocs.dart';
import 'package:dragger_survey/src/styles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DraggerBoardButtonRow extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final String currentSurveySet;
  final String xLabel;
  final String yLabel;
  const DraggerBoardButtonRow({
    this.formKey,
    @required this.currentSurveySet,
    @required this.xLabel,
    @required this.yLabel,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final PrismSurveyBloc prismSurveyBloc =
        Provider.of<PrismSurveyBloc>(context);
    final TeamBloc teamBloc = Provider.of<TeamBloc>(context);
    final DraggableItemBloc draggableItemBloc =
        Provider.of<DraggableItemBloc>(context);
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
              onPressed: () async {
                // Scaffold.of(context).showSnackBar(
                //   SnackBar(
                //     content: Text(
                //       'Processing data \n${prismSurveyBloc.created} \n${prismSurveyBloc.rowIndex} \n${prismSurveyBloc.colIndex} \n${prismSurveyBloc.currentAskedPerson}',
                //     ),
                //   ),
                // );
                Map<String, dynamic> survey = {
                  "created": prismSurveyBloc.created,
                  "askedPerson": prismSurveyBloc.currentAskedPerson,
                  "team": teamBloc.currentSelectedTeam?.documentID,
                  "surveySet": currentSurveySet,
                  "edited": DateTime.now(),
                  "users": user.uid,
                  "xValue": prismSurveyBloc.rowIndex,
                  "yValue": prismSurveyBloc.colIndex,
                };
                prismSurveyBloc.addPrismSurveyToDb(survey: survey);
                  Scaffold.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Your answer has been sucessfully saved:'),
                        backgroundColor: Styles.drg_colorSuccess,
                      ),
                  );
                await Future.delayed(const Duration(milliseconds: 1200), () {});
                Navigator.of(context).pop();
                Future.delayed(const Duration(milliseconds: 1200), () {
                  draggableItemBloc.resetDraggableItemPositon();
                });
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
