import 'dart:developer';

import 'package:dragger_survey/src/blocs/blocs.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GoalItem extends StatelessWidget {
  final double rotateValue;
  GoalItem(this.rotateValue) : super();

  @override
  Widget build(BuildContext context) {
    final DraggableItemBloc draggableBloc =
        Provider.of<DraggableItemBloc>(context);


    return GestureDetector(
      onDoubleTap: () {
        draggableBloc.resetDraggableItemPositon();
      },
      child: Transform(
        alignment: Alignment.center,
        transform: Matrix4.rotationZ(rotateValue),
        child: Tooltip(
          message:
              "\nThe Goal - the tighter the dragger, \nthe higher the value. \n\nDouble click to reset draggable postion.\n",
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(image: AssetImage('assets/flag.png')),
              // image: DecorationImage(image: AssetImage('assets/goals.png')),
              borderRadius: BorderRadius.circular(80.0),
              // boxShadow: [
              //   BoxShadow(
              //       color: Colors.brown.shade800.withOpacity(.5),
              //       blurRadius: 4.5,
              //       offset: Offset(6.0, 6.0))
              // ],
            ),
            width: 100,
            height: 100,
          ),
        ),
      ),
    );
  }
}
