import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dragger_survey/src/blocs/blocs.dart';
import 'package:dragger_survey/src/screens/screens.dart';
import 'package:dragger_survey/src/widgets/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DraggerScreen extends StatefulWidget {
  DraggerScreen({Key key}) : super(key: key);
  @override
  _DraggerScreenState createState() => _DraggerScreenState();
}

class _DraggerScreenState extends State<DraggerScreen> {
  DocumentSnapshot _currentSurveySet;
  String _xName = '';
  String _yName = '';

  @override
  Widget build(BuildContext context) {
    final PrismSurveyBloc prismSurveyBloc =
        Provider.of<PrismSurveyBloc>(context);
    final PrismSurveySetBloc prismSurveySetBloc =
        Provider.of<PrismSurveySetBloc>(context);
    final SignInBloc signInBloc = Provider.of<SignInBloc>(context);

    Future getCurrentSurveySet() async {
      log("------> In getCurrentSurveySet");
      _currentSurveySet = await prismSurveySetBloc?.currentPrismSurveySet;
      try {
        _xName = _currentSurveySet?.data['xName'];
        _yName = _currentSurveySet?.data['yName'];
      } catch (e) {
        log("ERROR in DraggerScreen getCurrentSurveySet(): $e");
      }
    }

    if (signInBloc.currentUser == null) {
      print("User is not signed in!");
      return SplashScreen();
    } else {
      getCurrentSurveySet();
    }

    if (prismSurveySetBloc.currentPrismSurveySet == null) {
      log("In Dragger Screen prismSurveySetBloc.currentPrismSurveySet == null: ${prismSurveySetBloc.currentPrismSurveySet == null}");
    }

    return FutureBuilder<FirebaseUser>(
        future: signInBloc.currentUser,
        builder: (BuildContext context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Padding(
                padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    BuildBoard(xLabel: _xName, yLabel: _yName),
                    Text(
                        """Stone is dragged to \n$_xName: ${prismSurveyBloc.rowIndex} \n$_xName:  ${prismSurveyBloc.colIndex}"""),
                    DraggerBoardButtonRow(),
                  ],
                ),
              ),
            );
          }
          return Container();
        });
  }
}

class BuildBoard extends StatelessWidget {
  final String xLabel;
  final String yLabel;
  BuildBoard({this.xLabel, this.yLabel});
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        MatrixBoard(),
        BuildXLabel(
          xLabel: xLabel,
        ),
        BuildYLabel(
          yLabel: yLabel,
        ),
      ],
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
      margin: EdgeInsets.only(left: 10, right: 10, bottom: 0, top: 0),
      height: 389,
      width: 354,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Text(
          "${widget.xLabel}",
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Colors.black54.withOpacity(.5),
              fontSize: 20,
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
      margin: EdgeInsets.only(left: 10, right: 10, bottom: 0, top: 0),
      height: 384,
      width: 388,
      child: Align(
        alignment: Alignment.centerRight,
        child: RotatedBox(
          quarterTurns: 3,
          child: Text(
            "${widget.yLabel}",
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.black54.withOpacity(.5),
                fontSize: 20,
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
