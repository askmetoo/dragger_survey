import 'package:dragger_survey/src/styles.dart';
import 'package:flutter/material.dart';

Future<bool> buildAlertDialog(
  context, {
  @required String title,
  @required String confirmText,
  @required String declinedText,
}) async {
  return await showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("$title"),
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: Text("$declinedText"),
          ),
          FlatButton(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(4),
                    bottomRight: Radius.circular(12),
                    bottomLeft: Radius.circular(12))),
            color: Styles.color_Attention,
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: Text("$confirmText"),
          ),
        ],
        elevation: 10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(3),
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
        backgroundColor: Styles.color_Secondary,
        contentTextStyle: TextStyle(color: Styles.color_Text),
      );
    },
  );
}
