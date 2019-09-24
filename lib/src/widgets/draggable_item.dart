import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../blocs/draggable_item_bloc.dart';

class DraggableItem extends StatefulWidget {
  final Offset initialPosition = Offset(20, 60);
  @override
  _DraggableItemState createState() => _DraggableItemState();
}

class _DraggableItemState extends State<DraggableItem> {
  int rowIdx;
  int colIdx;
  double top;
  double left;

  final String _dragData = "Meine Meinung";
  final double _draggableSize = 70.0;
  final double _draggableFeedbackSize = 80.0;

  @override
  Widget build(BuildContext context) {
    final DraggableItemBloc draggableBloc =
        Provider.of<DraggableItemBloc>(context);

    return Positioned(
      left: draggableBloc.draggableItemPositon.dx - 10,
      top: draggableBloc.draggableItemPositon.dy - _draggableSize - 10,
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
            boxShadow: [
              BoxShadow(
                  color: Colors.brown.shade400.withOpacity(.27),
                  blurRadius: 5.5,
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
            borderRadius: BorderRadius.circular(100.0),
            boxShadow: [
              BoxShadow(
                  color: Colors.brown.shade400,
                  blurRadius: 12.0,
                  offset: Offset(4.0, 6.0))
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
              position:
                  Offset(drag.offset.dx, drag.offset.dy - (_draggableSize / 0.53)));
        },
        onDraggableCanceled: (Velocity velocity, Offset offset) {
          draggableBloc.setNewDraggableItemPositon(position: offset);
        },
      ),
    );
  }
}
