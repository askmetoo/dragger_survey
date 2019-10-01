import 'dart:math';

import 'package:dragger_survey/src/blocs/blocs.dart';
import 'package:dragger_survey/src/widgets/widgets.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class MatrixBoard extends StatefulWidget {
  final String xLabel;
  final String yLabel;
  MatrixBoard({this.xLabel, this.yLabel});

  @override
  _MatrixBoardState createState() => _MatrixBoardState();
}

class _MatrixBoardState extends State<MatrixBoard> {
  final double aspectratioValue = .94;
  int gridLength;

  @override
  Widget build(BuildContext context) {
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
    Offset position = draggableBloc.draggableItemPositon;
    setState(() {
      gridLength = grid.length;
    });

    return Stack(
      children: <Widget>[
        BuildMatrixBoard(
            gridLength: gridLength,
            aspectratioValue: aspectratioValue,
            grid: grid,
            position: position),
        BuildXLabel(
          xLabel: widget.xLabel,
        ),
        BuildYLabel(
          yLabel: widget.yLabel,
        ),
        BuildGoalItem(),
        DraggableItem(),
      ],
    );
  }
}

class BuildMatrixBoard extends StatefulWidget {
  final int gridLength;
  final double aspectratioValue;
  final Offset position;
  final List<List<List<int>>> grid;

  BuildMatrixBoard({
    this.gridLength,
    this.aspectratioValue,
    this.position,
    this.grid,
  }) : super();

  @override
  _BuildMatrixBoardState createState() => _BuildMatrixBoardState();
}

class _BuildMatrixBoardState extends State<BuildMatrixBoard> {
  @override
  Widget build(BuildContext context) {
    return RotatedBox(
      quarterTurns: 3,
      child: SizedBox(
        width: 420,
        height: 420,
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
          padding: EdgeInsets.all(10),
          margin: EdgeInsets.only(
            top: 10,
            left: 10,
            right: 10,
            bottom: 20,
          ),
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: widget.gridLength),
            itemCount: widget.gridLength * widget.gridLength,
            itemBuilder: (BuildContext context, int index) {
              final DraggableItemBloc draggableItemBloc =
                  Provider.of<DraggableItemBloc>(context);
              final PrismSurveyBloc prismSurveyBloc =
                  Provider.of<PrismSurveyBloc>(context);

              return AspectRatio(
                  aspectRatio: widget.aspectratioValue,
                  child: Container(
                    child: DraggerTaget(
                        index: index,
                        position: widget.position,
                        grid: widget.grid,
                        draggableItemBloc: draggableItemBloc,
                        prismSurveyBloc: prismSurveyBloc),
                  ));
            },
          ),
        ),
      ),
    );
  }
}

class BuildGoalItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 30,
      right: 0,
      child: GoalItem(),
    );
  }
}

class BuildXLabel extends StatefulWidget {
  final String xLabel;
  BuildXLabel({this.xLabel}) : super();
  @override
  _BuildXLabelState createState() => _BuildXLabelState();
}

class _BuildXLabelState extends State<BuildXLabel> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 25, bottom: 35),
      height: 389,
      width: 354,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Text(
          "${widget.xLabel}",
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Colors.black54.withOpacity(.5),
              fontSize: 16,
              fontWeight: FontWeight.w600,
              letterSpacing: -.6,
              shadows: [
                Shadow(
                    blurRadius: 4, color: Colors.black12, offset: Offset(1, 1)),
              ]),
        ),
      ),
    );
  }
}

class BuildYLabel extends StatefulWidget {
  final String yLabel;
  BuildYLabel({this.yLabel}) : super();
  @override
  _BuildYLabelState createState() => _BuildYLabelState();
}

class _BuildYLabelState extends State<BuildYLabel> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 384,
      width: 388,
      child: Align(
        alignment: Alignment.centerLeft,
        child: RotatedBox(
          quarterTurns: 3,
          child: Text(
            "${widget.yLabel}",
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.black54.withOpacity(.5),
                fontSize: 16,
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
}
