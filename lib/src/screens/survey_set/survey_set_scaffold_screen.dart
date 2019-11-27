import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dragger_survey/src/blocs/blocs.dart';
import 'package:dragger_survey/src/screens/screens.dart';
import 'package:dragger_survey/src/styles.dart';
import 'package:dragger_survey/src/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SurveySetScaffoldScreen extends StatefulWidget {
  final Map<String, dynamic> arguments;
  SurveySetScaffoldScreen({Key key, this.arguments}) : super(key: key);
  @override
  _SurveySetScaffoldScreenState createState() =>
      _SurveySetScaffoldScreenState(arguments);
}

class _SurveySetScaffoldScreenState extends State<SurveySetScaffoldScreen> {
  int _selectedIndex = 0;
  Map<String, dynamic> arg;

  _SurveySetScaffoldScreenState(this.arg);
  List<String> _titleOptions = [
    "Survey Set Details",
    "Survey Results",
    "Survey Set Graphs"
  ];

  @override
  Widget build(BuildContext context) {
    final PrismSurveyBloc surveyBloc = Provider.of<PrismSurveyBloc>(context);
    final PrismSurveySetBloc surveySetBloc =
        Provider.of<PrismSurveySetBloc>(context);

    surveySetBloc.currentPrismSurveySet.then((val) =>
        print("ooooooo===============> val.data.length: ${val?.data?.length}"));

    return FutureBuilder<QuerySnapshot>(
        future: surveyBloc.getPrismSurveyQuery(
            fieldName: 'surveySet', fieldValue: arg['id']),
        builder: (context, surveyIDsSnapshot) {
          if (surveyIDsSnapshot.connectionState != ConnectionState.done) {
            return Center(
              child: Container(
                constraints: BoxConstraints(maxWidth: 50),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: CircularProgressIndicator(
                    strokeWidth: 10,
                  ),
                ),
              ),
            );
          } else if (!surveyIDsSnapshot.hasData) {
            return Container();
          }

          bool moreSurveyThanOne = surveyIDsSnapshot.data.documents.length > 1;

          return Scaffold(
              backgroundColor: Styles.color_AppBackground,
              endDrawer: UserDrawer(),
              appBar: AppBar(
                actions: <Widget>[
                  SignedInUserCircleAvatar(),
                ],
                title: Text("${_titleOptions.elementAt(_selectedIndex)}"),
              ),
              body:
                  _widgetOptions(context, args: arg).elementAt(_selectedIndex),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerFloat,
              floatingActionButton: FloatingActionButton.extended(
                backgroundColor: Styles.color_Secondary,
                label: Text(
                  "New Survey",
                  style: TextStyle(
                    color: Styles.color_Text.withOpacity(0.8),
                  ),
                ),
                icon: Icon(
                  Icons.group_add,
                  color: Styles.color_SecondaryDeepDark,
                ),
                tooltip: "Add new Survey",
                onPressed: () {
                  surveyBloc.currentAskedPerson = 'Anonymous';
                  surveySetBloc.setCurrentPrismSurveySetId(id: arg['id']);
                  Navigator.pushNamed(context, '/draggerscaffold');
                },
              ),
              bottomNavigationBar: !moreSurveyThanOne
                  ? null
                  : BottomNavigationBar(
                      // type: BottomNavigationBarType.fixed,
                      key: ValueKey(arg.hashCode),
                      items: <BottomNavigationBarItem>[
                        BottomNavigationBarItem(
                          title: Text('Details'),
                          icon: Icon(Icons.dvr),
                        ),
                        BottomNavigationBarItem(
                          icon: Icon(Icons.show_chart),
                          title: Text('Graphs'),
                        ),
                      ],
                      currentIndex: _selectedIndex,
                      backgroundColor: Styles.color_Secondary,
                      unselectedItemColor: Styles.color_AppBackground,
                      selectedItemColor: Styles.color_Contrast,
                      onTap: (int index) =>
                          setState(() => _selectedIndex = index),
                    ));
        });
  }

  List<Widget> _widgetOptions(context, {args}) {
    var _id = args['id'];
    log("In SurveySetScaffoldScreen _widgetOptions _id value: $_id");
    return <Widget>[
      SurveySetDetailsScreen(
        surveySetId: _id,
      ),
      SurveySetGraphsScreen(
        surveySetId: _id,
      ),
      DraggerScreen(),
    ];
  }
}
