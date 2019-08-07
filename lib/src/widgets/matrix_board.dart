import 'package:dragger_survey/src/blocs/draggable_item_bloc.dart';
import 'package:dragger_survey/src/blocs/matrix_granularity_bloc.dart';
import 'package:dragger_survey/src/blocs/prism_survey_bloc.dart';
import 'package:dragger_survey/src/widgets/goal_itemr.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'draggable_item.dart';
import 'drag_target.dart';

Widget matrixBoard(BuildContext context) {
  final double paddingValue = 0;
  final double marginValue = 20;
  final double aspectrationValue = 1;
  final MatrixGranularityBloc granularitybloc =
      Provider.of<MatrixGranularityBloc>(context);

  final DraggableItemBloc draggableBloc =
      Provider.of<DraggableItemBloc>(context);

  final grid = List<List<List<int>>>.generate(
    granularitybloc.matrixGranularity,
    (column) {
      return List<List<int>>.generate(
          granularitybloc.matrixGranularity, (row) => [column, row].toList());
    },
  );

  final gridLength = grid.length;

  Offset position = draggableBloc.draggableItemPositon;

  return Stack(
    children: <Widget>[
      AspectRatio(
        aspectRatio: 0.87,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              bottomLeft: Radius.circular(20),
              topRight: Radius.circular(20),
              bottomRight: Radius.circular(60),
            ),
            boxShadow: [
              BoxShadow(
                  blurRadius: 8,
                  offset: Offset(4, 4),
                  color: Colors.brown.shade900.withOpacity(.3))
            ],
            color: Colors.orange.shade200,
          ),
          padding: EdgeInsets.all(paddingValue),
          margin: EdgeInsets.only(
            top: marginValue,
            left: marginValue,
            right: marginValue,
            bottom: 90,
          ),
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: gridLength),
            itemCount: gridLength * gridLength,
            itemBuilder: (BuildContext context, int index) {
//              final database = Provider.of<AppDatabase>(context);

              final DraggableItemBloc draggableItemBloc =
                  Provider.of<DraggableItemBloc>(context);
                  final PrismSurveyBloc prismSurveyBloc = Provider.of<PrismSurveyBloc>(context);

              return AspectRatio(
                  aspectRatio: aspectrationValue,
                  child: Container(
                    child: dragTarget(
                        index: index,
                        position: position,
                        grid: grid,
                        draggableItemBloc: draggableItemBloc,
                        prismSurveyBloc: prismSurveyBloc),
                  ));
            },
          ),
        ),
      ),
      Positioned(
        bottom: 89,
        right: 17,
        child: GoalItem(),
      ),
      DraggableItem(),
    ],
  );
}
