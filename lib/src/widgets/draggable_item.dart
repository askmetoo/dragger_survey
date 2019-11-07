import 'dart:developer';

import 'package:dragger_survey/src/styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../blocs/draggable_item_bloc.dart';

class DraggableItem extends StatefulWidget {
  final Offset matrixBoardPositon;

  DraggableItem({this.matrixBoardPositon}) : super();

  @override
  _DraggableItemState createState() => _DraggableItemState();
}

class _DraggableItemState extends State<DraggableItem> {
  int rowIdx;
  int colIdx;
  // ignore: unused_field
  double _top;
  // ignore: unused_field
  double _left;

  final String _dragData = "Meine Meinung";
  final double _draggableSize = 70.0;
  final double _draggableFeedbackSize = 80.0;
  double _mqWidth;
  Orientation _mqOrientation;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final DraggableItemBloc draggableBloc =
        Provider.of<DraggableItemBloc>(context);

    _mqWidth = MediaQuery.of(context).size.width;
    _mqOrientation = MediaQuery.of(context).orientation;

    return Positioned(
      left: draggableBloc.draggableItemPositon.dx,
      top: draggableBloc.draggableItemPositon.dy,
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
          if (_mqWidth >= 768.0 && _mqOrientation == Orientation.landscape) {
            draggableBloc.setNewDraggableItemPositon(
              position: Offset(
                  drag.offset.dx +
                      widget.matrixBoardPositon.dx -
                      (_draggableSize / 3) +
                      10,
                  drag.offset.dy - (_draggableSize / .87)),
            );
          } else if (_mqWidth >= 710.0 &&
              _mqOrientation == Orientation.portrait) {
            draggableBloc.setNewDraggableItemPositon(
              position: Offset(
                  drag.offset.dx +
                      widget.matrixBoardPositon.dx -
                      (_draggableSize / 7) +
                      10,
                  drag.offset.dy - (_draggableSize / .5)),
            );
          } else {
            draggableBloc.setNewDraggableItemPositon(
              position: Offset(
                  drag.offset.dx +
                      widget.matrixBoardPositon.dx -
                      (_draggableSize / 7) +
                      10,
                  drag.offset.dy - (_draggableSize / .5)),
            );
          }
        },
        onDraggableCanceled: (Velocity velocity, Offset offset) {
          draggableBloc.setNewDraggableItemPositon(position: offset);
        },
      ),
    );
  }
}
