import 'package:dragger_survey/src/styles.dart';
import 'package:flutter/material.dart';

class UserDrawer extends StatelessWidget {
  const UserDrawer({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.all(0),
        children: <Widget>[
          DrawerHeader(
            child: Text('Drawer Header'),
            decoration: BoxDecoration(
              color: Styles.drg_colorSecondary,
            ),
          ),
          ListTile(
            title: Text('Item 1'),
            onTap: () {
              // WHAT TO DO?
              Navigator.pop(context);
              // Navigate to where?
            },
          ),
        ],
      ),
    );
  }
}