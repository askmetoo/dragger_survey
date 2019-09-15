import 'dart:developer';

import 'package:dragger_survey/src/screens/dragger_screen.dart';
import 'package:dragger_survey/src/screens/survey_set_details_screen.dart';
import 'package:dragger_survey/src/screens/survey_set_how_to_screen.dart';
import 'package:dragger_survey/src/styles.dart';
import 'package:flutter/material.dart';

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
  var _titleOptions = ["Survey Set Details", "Survey Title", "How-To Dragger"];

  @override
  Widget build(BuildContext context) {
    log("In SurveySetScaffoldScreen build - arg.keys: ${arg['id']}");
    return Scaffold(
      backgroundColor: Styles.drg_colorAppBackground,
      appBar: AppBar(
        title: Text("${_titleOptions.elementAt(_selectedIndex)}"),
      ),
      body: _widgetOptions(args: arg).elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Details'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            title: Text('Matrix'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            title: Text('How-To'),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: (index) {
          _onItemTapped(index);
        },
      ),
    );
  }

  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  List<Widget> _widgetOptions({args}) {
    return <Widget>[
      SurveySetDetailsScreen(
        surveyId: args['id'],
      ),
      DraggerScreen(),
      SurveySetHowToScreen()
    ];
  }
}
