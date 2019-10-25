import 'package:dragger_survey/src/blocs/blocs.dart';
import 'package:dragger_survey/src/styles.dart';
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
  final double aspectratioValue = 1;
  // final double aspectratioValue = .98;
  int gridLength;

  // *** Part of getting board position on the screen *** //
  GlobalKey _matrixBoardKey = GlobalKey();
  // Size _matrixBoardSize = Size(0, 0);
  Offset _matrixBoardPosition = Offset(0, 0);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(_onBuildCompleted);
  }

  _onBuildCompleted(_) {
    // _getMatrixBoardSize();
    _getMatrixBoardPosition();
  }

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
    Offset draggableItemPositon = draggableBloc.draggableItemPositon;
    setState(() {
      gridLength = grid.length;
    });

    return Column(
      children: <Widget>[
        Stack(
          children: <Widget>[
            Container(
              key: _matrixBoardKey,
              child: BuildMatrixBoard(
                gridLength: gridLength,
                aspectratioValue: aspectratioValue,
                grid: grid,
                draggableItemPositon: draggableItemPositon,
              ),
            ),
            BuildXLabel(
              xLabel: widget.xLabel,
            ),
            BuildYLabel(
              yLabel: widget.yLabel,
            ),
            // BuildGoalItem(),
            DraggableItem(
              matrixBoardPositon: _matrixBoardPosition,
            ),
          ],
        ),
        // Text(
        //     "MatrixBoard size: ${_matrixBoardSize.width} x ${_matrixBoardSize.height} (h x w)"),
        // Text(
        //     "MatrixBoard position: ${_matrixBoardPosition.dx} / ${_matrixBoardPosition.dy} (x / y)"),
      ],
    );
  }

  // *** Get position of board on the screen *** //
  // _getMatrixBoardSize() {
  //   final RenderBox matrixBoardRenderBox =
  //       _matrixBoardKey.currentContext.findRenderObject();
  //   final matrixBoardSize = matrixBoardRenderBox.size;
  //   setState(() {
  //     _matrixBoardSize = matrixBoardSize;
  //   });
  // }

  _getMatrixBoardPosition() {
    final RenderBox matrixBoardRenderBox =
        _matrixBoardKey.currentContext.findRenderObject();
    final matrixBoardPosition = matrixBoardRenderBox.localToGlobal(Offset.zero);

    setState(() {
      _matrixBoardPosition = matrixBoardPosition;
    });
  }
  // *** =============================================== *** //
}

class BuildMatrixBoard extends StatefulWidget {
  final int gridLength;
  final double aspectratioValue;
  final Offset draggableItemPositon;
  final List<List<List<int>>> grid;

  BuildMatrixBoard({
    this.gridLength,
    this.aspectratioValue,
    this.draggableItemPositon,
    this.grid,
  }) : super();

  @override
  _BuildMatrixBoardState createState() => _BuildMatrixBoardState();
}

class _BuildMatrixBoardState extends State<BuildMatrixBoard> {
  @override
  Widget build(BuildContext context) {
    final DraggableItemBloc draggableBloc =
        Provider.of<DraggableItemBloc>(context);

    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: RotatedBox(
        quarterTurns: 3,
        child: AspectRatio(
          aspectRatio: widget.aspectratioValue,
          child: GestureDetector(
            onDoubleTap: () {
              draggableBloc.resetDraggableItemPositon();
            },
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/matrix_backgr_with_flag.png'),
                  alignment: Alignment.topRight,
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(60),
                  bottomLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                      blurRadius: 8,
                      offset: Offset(4, 4),
                      color: Colors.brown.shade900.withOpacity(.3))
                ],
                color: Styles.drg_colorAppBackgroundLight,
                // color: Colors.orange.shade200,
              ),
              margin: EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 20,
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

                  return Container(
                    child: DraggerTaget(
                        index: index,
                        position: widget.draggableItemPositon,
                        grid: widget.grid,
                        draggableItemBloc: draggableItemBloc,
                        prismSurveyBloc: prismSurveyBloc),
                  );
                },
              ),
            ),
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
      bottom: 302,
      left: 290,
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
      padding: EdgeInsets.only(left: 55, bottom: 10),
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
      padding: EdgeInsets.only(left: 25),
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
