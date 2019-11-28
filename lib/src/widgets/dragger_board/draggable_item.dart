import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../blocs/draggable_item_bloc.dart';

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

  final double _draggableSize = 90.0;
  final double _draggableFeedbackSize = 100.0;
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

    log("In DraggableItem MQ - _mqOrientation = $_mqOrientation");
    log("In DraggableItem MQ - _mqWidth = $_mqWidth");

    return Positioned(
      left: draggableBloc.draggableItemPositon.dx,
      top: draggableBloc.draggableItemPositon.dy,
      child: Draggable<String>(
        data: _dragData,
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/feedback-chip--down.png')),
            borderRadius: BorderRadius.circular(80.0),
          ),
          width: _draggableSize,
          height: _draggableSize,
        ),
        childWhenDragging: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/feedback-chip--leftbehind.png')),
            borderRadius: BorderRadius.circular(80.0),
          ),
          width: _draggableSize,
          height: _draggableSize,
        ),
        feedback: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/feedback-chip--up.png'),
            ),
            borderRadius: BorderRadius.circular(120.0),
            // boxShadow: [
            //   BoxShadow(
            //       color: Colors.brown.shade400,
            //       blurRadius: 12.0,
            //       offset: Offset(20.0, 22.0))
            // ],
          ),
          width: _draggableFeedbackSize,
          height: _draggableFeedbackSize,
          child: Center(),
        ),
        onDragStarted: () {
          draggableBloc.setStartedDragging(true);
        },
        onDragCompleted: () {},
        onDragEnd: (drag) {
          if (_mqWidth >= 768.0 && _mqOrientation == Orientation.landscape) {
            log("xxxxxxxxxxxxx ------> 1) I am here <-------- xxxxxxxxxxx");

            draggableBloc.draggableItemPositon = Offset(
              drag.offset.dx,
              drag.offset.dy - (_draggableSize * .6) - 16,
            );
          } else if (_mqWidth >= 710.0 &&
              _mqOrientation == Orientation.portrait) {
            draggableBloc.draggableItemPositon = Offset(
              drag.offset.dx,
              drag.offset.dy - (_draggableSize * .6) - 16,
            );
          } else {
            draggableBloc.draggableItemPositon = Offset(
              drag.offset.dx,
              drag.offset.dy - (_draggableSize * 1.4) - 20,
            );
          }
        },
        onDraggableCanceled: (Velocity velocity, Offset offset) {
          if (_mqWidth >= 768.0 && _mqOrientation == Orientation.landscape) {
            draggableBloc.draggableItemPositon = Offset(
              offset.dx,
              offset.dy - (_draggableSize * .6) - 16,
            );
          } else if (_mqWidth >= 710.0 &&
              _mqOrientation == Orientation.portrait) {
            draggableBloc.draggableItemPositon = Offset(
              offset.dx,
              offset.dy - (_draggableSize * .6) - 16,
            );
          } else {
            draggableBloc.draggableItemPositon = Offset(
              offset.dx,
              offset.dy - (_draggableSize * 1.4) - 20,
            );
          }
        },
      ),
    );
  }
}
