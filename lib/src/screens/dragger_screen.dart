import 'package:dragger_survey/src/blocs/draggable_item_bloc.dart';
import 'package:dragger_survey/src/blocs/prism_survey_bloc.dart';
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
    final DraggableItemBloc draggableBloc =
        Provider.of<DraggableItemBloc>(context);
    final PrismSurveyBloc prismSurveyBloc =
        Provider.of<PrismSurveyBloc>(context);

    return Scaffold(
      backgroundColor: Styles.appBackground,
      appBar: AppBar(title: Text("Dragger Board", style: Styles.cardTitleText,),),
          body: ListView(
        children: <Widget>[
          Stack(
            children: <Widget>[
              Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(
                    // TODO //
                    "Hier Steht der Survey Name",
                    style: Styles.detailsTitleText,
                    // style: TextStyle(fontSize: 24),
                  ),
                  Stack(
                    children: [
                      matrixBoard(context),
                    ],
                  ),
                  Text(
                      // TODO //
                      "Stone set to row  ${prismSurveyBloc.rowIndex} and col  ${prismSurveyBloc.colIndex}"),
                  // "Stone set to row ${draggableBloc.draggableItemPositon.dy} and col ${draggableBloc.draggableItemPositon.dx}"),
                  DraggerBoardButtonRow(),
                ],
              ),
              Positioned.fill(
                top: 45,
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Text(
                    // TODO //
                    "XName",
                    // prismSurveySetBloc.xName,
                    style: TextStyle(
                        color: Colors.black54.withOpacity(.7),
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        shadows: [
                          Shadow(
                              blurRadius: 4,
                              color: Colors.black12,
                              offset: Offset(1, 1)),
                        ]),
                  ),
                ),
              ),
              Positioned.fill(
                left: 5,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: RotatedBox(
                    quarterTurns: 3,
                    child: Text(
                      // TODO //
                      "YName",
                      // prismSurveySetBloc.yName,
                      style: TextStyle(
                          color: Colors.black54.withOpacity(.7),
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                          shadows: [
                            Shadow(
                                blurRadius: 4,
                                color: Colors.black12,
                                offset: Offset(1, 1)),
                          ]),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}