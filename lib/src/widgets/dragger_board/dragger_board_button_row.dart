import 'package:dragger_survey/src/blocs/blocs.dart';
import 'package:dragger_survey/src/styles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DraggerBoardButtons extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final String currentSurveySet;
  // final String xLabel;
  // final String yLabel;
  const DraggerBoardButtons({
    this.formKey,
    @required this.currentSurveySet,
    // @required this.xLabel,
    // @required this.yLabel,
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
              color: Styles.color_Secondary,
              textColor: Styles.color_Primary,
              child: Text("Save result"),
              disabledColor: Styles.color_AppBackgroundMedium.withOpacity(.4),
              disabledTextColor: Styles.color_Primary,
              onPressed: draggableItemBloc.startedDragging ? () async {
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
                        backgroundColor: Styles.color_Success,
                      ),
                  );
                await Future.delayed(const Duration(milliseconds: 800), () {});
                Navigator.of(context).pop();
                Future.delayed(const Duration(milliseconds: 800), () {
                  draggableItemBloc.resetDraggableItemPositon();
                });
              } : null,
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: FlatButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              textColor: Styles.color_SecondaryDeepDark.withOpacity(.8),
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
        ],
      ),
    );
  }
}
