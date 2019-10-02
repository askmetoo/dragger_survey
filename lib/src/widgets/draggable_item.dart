import 'dart:developer';

import 'package:dragger_survey/src/styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../blocs/draggable_item_bloc.dart';

class DraggableItem extends StatefulWidget {
  final Offset initialPosition = Offset(20, 60);
  final Offset matrixBoardPositon;
  DraggableItem({this.matrixBoardPositon}) : super();

  @override
  _DraggableItemState createState() => _DraggableItemState();
}

class _DraggableItemState extends State<DraggableItem> {
  int rowIdx;
  int colIdx;
  double _top;
  double _left;

  final String _dragData = "Meine Meinung";
  final double _draggableSize = 70.0;
  final double _draggableFeedbackSize = 80.0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final DraggableItemBloc draggableBloc =
        Provider.of<DraggableItemBloc>(context);
    draggableBloc.setInitialDraggableItemPostion(
        position: widget.initialPosition);
  }

  @override
  Widget build(BuildContext context) {
    final DraggableItemBloc draggableBloc =
        Provider.of<DraggableItemBloc>(context);

    log("draggableItemPositon.dx: ${draggableBloc.draggableItemPositon.dx}");
    log("draggableItemPositon.dy: ${draggableBloc.draggableItemPositon.dy}");
    log("draggableItemPositon.dx + widget.matrixBoardPositon.dx: ${draggableBloc.draggableItemPositon.dx + widget.matrixBoardPositon.dx}");
    log("draggableItemPositon.dy + widget.matrixBoardPositon.dy: ${draggableBloc.draggableItemPositon.dy + widget.matrixBoardPositon.dy}");

    return Positioned(
      left: draggableBloc.draggableItemPositon.dx,
      top: draggableBloc.draggableItemPositon.dy,
      // left: draggableBloc.draggableItemPositon.dx - 10,
      // top: draggableBloc.draggableItemPositon.dy + 220,
      // left: draggableBloc.draggableItemPositon.dx - 10,
      // top: draggableBloc.draggableItemPositon.dy - _draggableSize - 10,
      child: Draggable<String>(
        data: _dragData,
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(image: AssetImage('assets/hat.png')),
            borderRadius: BorderRadius.circular(80.0),
            boxShadow: [
              BoxShadow(
                  color: Colors.brown.shade700,
                  blurRadius: 1.5,
                  offset: Offset(1.0, 2.0))
            ],
          ),
          width: _draggableSize,
          height: _draggableSize,
        ),
        childWhenDragging: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(80.0),
            border: Border.all(
              width: 3,
              color: Styles.drg_colorAppBackgroundMedium.withOpacity(.7),
            ),
            boxShadow: [
              BoxShadow(
                  color: Styles.drg_colorAppBackground.withOpacity(.20),
                  blurRadius: 3,
                  offset: Offset(1.0, 2.0))
            ],
          ),
          width: _draggableSize,
          height: _draggableSize,
        ),
        feedback: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/hat.png'),
            ),
            borderRadius: BorderRadius.circular(120.0),
            boxShadow: [
              BoxShadow(
                  color: Colors.brown.shade400,
                  blurRadius: 12.0,
                  offset: Offset(20.0, 22.0))
            ],
          ),
          width: _draggableFeedbackSize,
          height: _draggableFeedbackSize,
          child: Center(),
        ),
        onDragStarted: () {},
        onDragCompleted: () {},
        onDragEnd: (drag) {
          draggableBloc.setNewDraggableItemPositon(
            position: Offset(
              drag.offset.dx +
                  widget.matrixBoardPositon.dx -
                  (_draggableSize / 2.98) +
                  10,
              drag.offset.dy +
                  widget.matrixBoardPositon.dy -
                  (_draggableSize / .219) +
                  10,
            ),
          );
        },
        onDraggableCanceled: (Velocity velocity, Offset offset) {
          draggableBloc.setNewDraggableItemPositon(position: offset);
        },
      ),
    );
  }
}
