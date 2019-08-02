import 'package:dragger_survey/src/styles.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dragger Home"),
      ),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FlatButton(
              onPressed: () {
                Navigator.popAndPushNamed(
                  context,
                  '/login',
                );
              },
              child: Text('Push'),
              color: Styles.lighterGreenColor,
            ),
//            ),FlatButton(
//              onPressed: () {
//                Navigator.pushReplacementNamed(
//                  context,
//                  '/home',
//                );
//              },
//              child: Text('Push'),
//              color: Styles.lighterGreenColor,
//            ),
//            FlatButton(
//              onPressed: () {
//                Navigator.pop(context);
//              },
//              child: Text('Back'),
//              color: Styles.secondaryColor,
//            ),
          ],
        ),
      ),
      backgroundColor: Styles.appBackground,
    );
  }
}
