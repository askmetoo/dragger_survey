import 'package:dragger_survey/src/styles.dart';
import 'package:flutter/material.dart';

class SurveySetsListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Styles.appBackground,
      appBar: AppBar(
        title: Text("Survey Sets"),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: Text("Item 1", style: Styles.textListTitle,),
            subtitle: Text("Bal bla bla", style: Styles.textListContent,),
            onTap: () {
              Navigator.pushNamed(context, '/surveysetscaffold');
            },
          ),
          ListTile(
            title: Text("Item 2", style: Styles.textListTitle,),
            subtitle: Text("Bal bla bla", style: Styles.textListContent,),
            onTap: () {
              Navigator.pushNamed(context, '/surveysetscaffold');
            },
          ),
          ListTile(
            title: Text("Item 3", style: Styles.textListTitle,),
            subtitle: Text("Bal bla bla", style: Styles.textListContent,),
            onTap: () {
              Navigator.pushNamed(context, '/surveysetscaffold');
            },
          ),
          ListTile(
            title: Text("Item 4", style: Styles.textListTitle,),
            subtitle: Text("Bal bla bla", style: Styles.textListContent,),
            onTap: () {
              Navigator.pushNamed(context, '/surveysetscaffold');
            },
          ),
          ListTile(
            title: Text("Item 5", style: Styles.textListTitle,),
            subtitle: Text("Bal bla bla", style: Styles.textListContent,),
            onTap: () {
              Navigator.pushNamed(context, '/surveysetscaffold');
            },
          ),
          ListTile(
            title: Text("Item 6", style: Styles.textListTitle,),
            subtitle: Text("Bal bla bla", style: Styles.textListContent,),
            onTap: () {
              Navigator.pushNamed(context, '/surveysetscaffold');
            },
          ),
        ],
      ),
    );
  }
}
