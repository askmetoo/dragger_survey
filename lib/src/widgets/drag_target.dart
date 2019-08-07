import 'package:dragger_survey/src/blocs/prism_survey_bloc.dart';
import 'package:flutter/material.dart';
import '../blocs/draggable_item_bloc.dart';

Widget dragTarget(
    {int index,
    double top,
    double left,
    Offset position,
    List<List<List<int>>> grid,
    DraggableItemBloc draggableItemBloc,
    PrismSurveyBloc prismSurveyBloc}) {
  int rowIdx() => (index / grid.length).floor();
  int colIdx() => (index % grid.length);

  return DragTarget<String>(
    key: Key(index.toString()),
    builder: (context, List<dynamic> candidateData, List rejectedData) {
      return Container(
        child: Center(),
      );
    },
    onWillAccept: (data) {
      return true;
    },
    onAccept: (data) {
      print("On accept - row: ${rowIdx()}, col: ${colIdx()}");
      position = Offset(rowIdx().toDouble(), colIdx().toDouble());
      draggableItemBloc.setNewDraggableItemPositon(position: position);
      prismSurveyBloc.setRowIndex(rowIndex: rowIdx().toInt());
      prismSurveyBloc.setColIndex(colIndex: colIdx().toInt());
    },
    onLeave: (data) {},
  );
}
