import 'package:dragger_survey/src/blocs/blocs.dart';
import 'package:dragger_survey/src/widgets/widgets.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class MatrixBoard extends StatefulWidget {
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
        buildMatrixBoard(
            gridLength: gridLength,
            aspectratioValue: aspectratioValue,
            grid: grid,
            position: position),
        buildGoalItem(),
        DraggableItem(),
      ],
    );
  }
}

// Widget matrixBoard(BuildContext context) {
//   final double aspectratioValue = .94;
//   final MatrixGranularityBloc granularitybloc =
//       Provider.of<MatrixGranularityBloc>(context);

//   final DraggableItemBloc draggableBloc =
//       Provider.of<DraggableItemBloc>(context);

//   final grid = List<List<List<int>>>.generate(
//     granularitybloc.matrixGranularity,
//     (column) {
//       return List<List<int>>.generate(
//           granularitybloc.matrixGranularity, (row) => [column, row].toList());
//     },
//   );

//   final gridLength = grid.length;

//   Offset position = draggableBloc.draggableItemPositon;

//   return Stack(
//     children: <Widget>[
//       buildMatrixBoard(
//           gridLength: gridLength,
//           aspectratioValue: aspectratioValue,
//           grid: grid,
//           position: position),
//       buildGoalItem(),
//       DraggableItem(),
//     ],
//   );
// }

Widget buildMatrixBoard(
    {int gridLength,
    double aspectratioValue,
    Offset position,
    List<List<List<int>>> grid}) {
  return SizedBox(
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
            crossAxisCount: gridLength),
        itemCount: gridLength * gridLength,
        itemBuilder: (BuildContext context, int index) {
//              final database = Provider.of<AppDatabase>(context);

          final DraggableItemBloc draggableItemBloc =
              Provider.of<DraggableItemBloc>(context);
          final PrismSurveyBloc prismSurveyBloc =
              Provider.of<PrismSurveyBloc>(context);

          return AspectRatio(
              aspectRatio: aspectratioValue,
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
  );
}

Widget buildGoalItem() {
  return Positioned(
    bottom: 19,
    right: 11,
    child: GoalItem(),
  );
}
