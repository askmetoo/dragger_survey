import 'package:dragger_survey/src/blocs/blocs.dart';
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
                if (this.formKey.currentState.validate()) {
                  Scaffold
                    .of(context)
                    .showSnackBar(SnackBar(
                      content: Text('Processing data \n${prismSurveyBloc.created} \n${prismSurveyBloc.rowIndex} \n${prismSurveyBloc.colIndex} \n${prismSurveyBloc.currentAskedPerson}'),
                    ),
                    );
                }
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
