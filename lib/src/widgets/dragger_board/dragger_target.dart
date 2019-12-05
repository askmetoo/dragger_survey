import 'package:dragger_survey/src/blocs/blocs.dart';
import 'package:flutter/material.dart';

class DraggerTaget extends StatefulWidget {
  final int index;
  final double top;
  final double left;
  final Offset position;
  final List<List<List<int>>> grid;
  final DraggableItemBloc draggableItemBloc;
  final SurveyBloc prismSurveyBloc;

  DraggerTaget({
    this.index,
    this.top,
    this.left,
    this.position,
    this.grid,
    this.draggableItemBloc,
    this.prismSurveyBloc,
  }) : super();

  @override
  _DraggerTagetState createState() => _DraggerTagetState(position);
}

class _DraggerTagetState extends State<DraggerTaget> {
  Offset position;
  int rowIdx() => (widget.index / widget.grid.length).floor();
  int colIdx() => (widget.index % widget.grid.length);

  _DraggerTagetState(this.position) : super();

  @override
  Widget build(BuildContext context) {
    return DragTarget<String>(
      key: Key(widget.index.toString()),
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
        setState(() {
          position = Offset(rowIdx().toDouble(), colIdx().toDouble());
        });
        widget.draggableItemBloc.draggableItemPositon = widget.position;
        widget.prismSurveyBloc.setRowIndex(rowIndex: rowIdx().toInt());
        widget.prismSurveyBloc.setColIndex(colIndex: colIdx().toInt());
      },
      onLeave: (data) {},
    );
  }
}
