import 'package:flutter/material.dart';

class GoalItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(image: AssetImage('assets/goals.png')),
        borderRadius: BorderRadius.circular(80.0),
        boxShadow: [
          BoxShadow(
              color: Colors.brown.shade800.withOpacity(.5),
              blurRadius: 4.5,
              offset: Offset(6.0, 6.0))
        ],
      ),
      width: 90,
      height: 90,
    );
  }
}
