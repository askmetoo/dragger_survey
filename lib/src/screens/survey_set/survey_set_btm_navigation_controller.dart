import 'dart:developer';

import 'package:dragger_survey/src/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:dragger_survey/src/screens/screens.dart';

import '../../styles.dart';

class SurveySetBtmNavigationController extends StatefulWidget {
  final Map<String, dynamic> arguments;
  SurveySetBtmNavigationController({Key key, this.arguments}) : super(key: key);

  @override
  _SurveySetBtmNavigationControllerState createState() =>
      _SurveySetBtmNavigationControllerState(arguments);
}

class _SurveySetBtmNavigationControllerState
    extends State<SurveySetBtmNavigationController> {
  Map<String, dynamic> args;
  static String _id;

  _SurveySetBtmNavigationControllerState(this.args);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setState(() {
      _id = args['id'];
    });
  }

  final List<Widget> pages = [
    SurveySetDetailsScreen(
      key: PageStorageKey('SurveySetDetailsScreen'),
      surveySetId: _id,
    ),
    DraggerScreen(key: PageStorageKey('DraggerScreen')),
    SurveySetGraphsScreen(
      key: PageStorageKey('SurveySetGraphsScreen'),
    )
  ];

  final PageStorageBucket bucket = PageStorageBucket();

  int _selectedIndex = 0;

  List<String> _titleOptions = [
    "Survey Set Details",
    "Survey Title",
    "Survey Set Graphs"
  ];

  Widget _bottomNavigationBar(int selectedIndex) {
    log("-----> In SurveySetBtmNavigationController _bottomNavigationBar");
    return BottomNavigationBar(
      backgroundColor: Styles.color_Secondary,
      unselectedItemColor: Styles.drg_colorAppBackground,
      selectedItemColor: Styles.color_Contrast,
      onTap: (int index) => setState(() => _selectedIndex = index),
      currentIndex: selectedIndex,
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: UserDrawer(),
      appBar: AppBar(
        actions: <Widget>[
          SignedInUserCircleAvatar(),
        ],
        title: Text("${_titleOptions.elementAt(_selectedIndex)}"),
      ),
      body: PageStorage(
        child: pages[_selectedIndex],
        bucket: bucket,
      ),
      bottomNavigationBar: _bottomNavigationBar(_selectedIndex),
    );
  }
}
