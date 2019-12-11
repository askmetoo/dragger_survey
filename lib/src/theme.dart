import 'package:dragger_survey/src/styles.dart';
import 'package:flutter/material.dart';

ThemeData standardTheme = ThemeData(
  scaffoldBackgroundColor: Styles.color_Primary,
  accentColor: Styles.color_Complementary,
  primaryColor: Styles.color_Primary,
  primaryColorLight: Styles.color_AppBackgroundLight,
  primaryColorDark: Styles.color_AppBackgroundMedium,
  dialogBackgroundColor: Styles.color_Secondary,
  canvasColor: Styles.color_Secondary, // Dropdown color
  textSelectionColor: Styles.color_Primary,
  cursorColor: Styles.color_Text,
  bottomAppBarColor: Styles.color_Secondary,
  textTheme: TextTheme(
    title: TextStyle(color: Styles.color_Text),
    subtitle: TextStyle(color: Styles.color_Text),
    subhead: TextStyle(color: Styles.color_Text),
    body1: TextStyle(fontSize: 18, color: Styles.color_Text),
    body2: TextStyle(
        fontSize: 18, color: Styles.color_Text), // Drawer ListTile Text
    display1: TextStyle(color: Styles.color_Text),
    display2: TextStyle(color: Styles.color_SecondaryDeepDark.withOpacity(.8)),
  ),
);

ThemeData team1Theme = ThemeData(
    scaffoldBackgroundColor: Styles.tClr1_primary,
    accentColor: Styles.tClr1_primaryDark,
    primaryColor: Styles.tClr1_primary,
    primaryColorLight: Styles.color_AppBackgroundLight,
    primaryColorDark: Styles.color_AppBackgroundMedium,
    dialogBackgroundColor: Styles.tClr1_secondary,
    canvasColor: Styles.tClr1_primary,
    bottomAppBarColor: Styles.tClr1_secondary,
    textTheme: TextTheme(
      title: TextStyle(color: Styles.color_Text),
      subtitle: TextStyle(color: Styles.color_Text),
      subhead: TextStyle(color: Styles.color_Text),
      body1: TextStyle(fontSize: 18, color: Styles.color_Text),
      body2: TextStyle(
          fontSize: 18, color: Styles.color_Text), // Drawer ListTile Text
      display1: TextStyle(color: Styles.color_Secondary),
      display2:
          TextStyle(color: Styles.color_SecondaryDeepDark.withOpacity(.8)),
    ));
