import 'package:dragger_survey/src/screens/screens.dart';
import 'package:dragger_survey/src/styles.dart';
import 'package:dragger_survey/src/widgets/widgets.dart';
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
  List<String> _titleOptions = [
    "Survey Set Details",
    "Survey Title",
    "Survey Set Graphs"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Styles.drg_colorAppBackground,
      endDrawer: UserDrawer(),
      appBar: AppBar(
        actions: <Widget>[
          SigendInUserCircleAvatar(),
        ],
        title: Text("${_titleOptions.elementAt(_selectedIndex)}"),
      ),
      body: _widgetOptions(args: arg).elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            title: Text('Details'),
            icon: Icon(Icons.dvr),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.apps),
            title: Text('Dragger Board'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.show_chart),
            title: Text('Graphs'),
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
        surveySetId: args['id'],
      ),
      DraggerScreen(
        surveySetId: args['id'],
      ),
      SurveySetGraphsScreen()
    ];
  }
}
