import 'package:dragger_survey/src/screens/dragger_screen.dart';
import 'package:dragger_survey/src/screens/survey_set_details_screen.dart';
import 'package:dragger_survey/src/screens/survey_set_how_to_screen.dart';
import 'package:dragger_survey/src/screens/survey_sets_list_screen.dart';
import 'package:dragger_survey/src/styles.dart';
import 'package:flutter/material.dart';

class SurveySetScaffoldScreen extends StatefulWidget {
  @override
  _SurveySetScaffoldScreenState createState() =>
      _SurveySetScaffoldScreenState();
}

class _SurveySetScaffoldScreenState extends State<SurveySetScaffoldScreen> {
  int _selectedIndex = 0;

  // TODO: dynymic title for Surve Name
  var _titleOptions = ["Survey Set Details", "Survey Title", "How-To Dragger"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Styles.appBackground,
      appBar: AppBar(
        title: Text("${_titleOptions.elementAt(_selectedIndex)}"),
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
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

  static List<Widget> _widgetOptions = <Widget>[
    SurveySetDetailsScreen(),
    DraggerScreen(),
    SurveySetHowToScreen()
  ];
}
