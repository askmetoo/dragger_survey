import 'package:flutter/material.dart';
import 'package:dragger_survey/src/styles.dart';

class BuildCancelButton extends StatelessWidget {
  const BuildCancelButton({
    Key key,
    @required this.context,
  }) : super(key: key);

  final context;

  @override
  Widget build(BuildContext context) {

    return SizedBox(
      width: double.infinity,
      child: FlatButton(
        textColor: Styles.color_Primary,
        onPressed: () {
          print("Cancel button presssed");
          Navigator.of(context).pop();
        },
        child: Text('Cancel'),
      ),
    );
  }
}