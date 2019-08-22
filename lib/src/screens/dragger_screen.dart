import 'package:dragger_survey/src/blocs/blocs.dart';
import 'package:dragger_survey/src/blocs/draggable_item_bloc.dart';
import 'package:dragger_survey/src/blocs/prism_survey_bloc.dart';
import 'package:dragger_survey/src/screens/splash_screen.dart';
import 'package:dragger_survey/src/styles.dart';
import 'package:dragger_survey/src/widgets/dragger_board_button_row.dart';
import 'package:dragger_survey/src/widgets/matrix_board.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DraggerScreen extends StatefulWidget {
  @override
  _DraggerScreenState createState() => _DraggerScreenState();
}

class _DraggerScreenState extends State<DraggerScreen> {
  @override
  Widget build(BuildContext context) {
    final PrismSurveyBloc prismSurveyBloc =
        Provider.of<PrismSurveyBloc>(context);
    final SignInBloc signInBloc = Provider.of<SignInBloc>(context);
    
    if (signInBloc.signedInUser == null) {
      print("User is not signed in!");
      return SplashScreen();
    }

    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Padding(
        padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            buildBoard(context),
            Text(
                // TODO //
                "Stone set to row  ${prismSurveyBloc.rowIndex} and col  ${prismSurveyBloc.colIndex}"),
            DraggerBoardButtonRow(),
          ],
        ),
      ),
    );
  }

  Widget buildBoard(BuildContext context) {
    return Stack(
      children: <Widget>[
        matrixBoard(context),
        buildXLabel(),
        buildYLabel(),
      ],
    );
  }

  Widget buildYLabel() {
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10, bottom: 0, top: 0),
      height: 384,
      width: 388,
      child: Align(
        alignment: Alignment.centerRight,
        child: RotatedBox(
          quarterTurns: 3,
          child: Text(
            // TODO: Dynamic yName
            "YName auch etwas länger",
            // prismSurveySetBloc.yName,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.black54.withOpacity(.5),
                fontSize: 20,
                fontWeight: FontWeight.w600,
                letterSpacing: -.6,
                shadows: [
                  Shadow(
                      blurRadius: 4,
                      color: Colors.black12,
                      offset: Offset(1, 1)),
                ]),
          ),
        ),
      ),
    );
  }

  Widget buildXLabel() {
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10, bottom: 0, top: 0),
      height: 398,
      width: 354,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Text(
          // TODO: dynamic xName
          "XName etwasg kurz",
          // prismSurveySetBloc.xName,
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Colors.black54.withOpacity(.5),
              fontSize: 20,
              fontWeight: FontWeight.w600,
              letterSpacing: -.6,
              shadows: [
                Shadow(
                    blurRadius: 4,
                    color: Colors.black12,
                    offset: Offset(1, 1)),
              ]),
        ),
      ),
    );
  }
}
