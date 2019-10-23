import 'dart:developer';

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
    return Scaffold(
      backgroundColor: Styles.drg_colorAppBackground,
      endDrawer: UserDrawer(),
      appBar: AppBar(
        actions: <Widget>[
          SignedInUserCircleAvatar(),
        ],
        title: Text("${_titleOptions.elementAt(_selectedIndex)}"),
      ),
      body: _widgetOptions(context, args: arg).elementAt(_selectedIndex),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Styles.drg_colorSecondary,
        label: Text(
          "New Survey",
          style: TextStyle(
            color: Styles.drg_colorText.withOpacity(0.8),
          ),
        ),
        icon: Icon(
          Icons.group_add,
          color: Styles.drg_colorDarkerGreen,
        ),
        tooltip: "Add new Survey",
        onPressed: () {
          surveyBloc.currentAskedPerson = 'Anonymous';
          Navigator.pushNamed(context, '/draggerscaffold');
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        key: ValueKey(arg.hashCode),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            title: Text('Details'),
            icon: Icon(Icons.dvr),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.show_chart),
            title: Text('Graphs'),
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.apps),
          //   title: Text('Dragger Board'),
          // ),
        ],
        currentIndex: _selectedIndex,
        backgroundColor: Styles.drg_colorSecondary,
        unselectedItemColor: Styles.drg_colorAppBackground,
        selectedItemColor: Styles.drg_colorContrast,
        onTap: (int index) => setState(() => _selectedIndex = index),
      ),
    );
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
