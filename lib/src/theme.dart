import 'package:dragger_survey/src/styles.dart';
import 'package:flutter/material.dart';

ThemeData standardTheme = ThemeData.light().copyWith(
  accentColor: Styles.color_Contrast,
  primaryColor: Styles.color_Primary,
  primaryColorLight: Styles.color_AppBackgroundLight,
  primaryColorDark: Styles.color_AppBackgroundMedium,
  canvasColor: Styles.color_Secondary,
  textTheme: TextTheme(
    title: TextStyle(color: Styles.color_Text),
    subtitle: TextStyle(color: Styles.color_Text),
    subhead: TextStyle(color: Styles.color_Text),
    body1: TextStyle(fontSize: 18, color: Styles.color_Text),
    // overline: TextStyle(color: Styles.color_Text),
    // caption: TextStyle(color: Styles.color_Text),
    display1: TextStyle(color: Styles.color_Text),
    display2: TextStyle(color: Styles.color_SecondaryDeepDark.withOpacity(.8)),
    // display3: TextStyle(color: Styles.color_Text),
    // display4: TextStyle(color: Styles.color_Text),
  ),
  
);

ThemeData team1Theme = ThemeData.dark().copyWith(
    accentColor: Styles.color_Contrast,
    primaryColor: Styles.tClr1_primary,
    primaryColorLight: Styles.color_AppBackgroundLight,
    primaryColorDark: Styles.color_AppBackgroundMedium,
    canvasColor: Styles.color_Secondary,
    textTheme: TextTheme(
      title: TextStyle(color: Styles.color_Text),
      subtitle: TextStyle(color: Styles.color_Text),
      subhead: TextStyle(color: Styles.color_Text),
      body1: TextStyle(fontSize: 18, color: Styles.color_Text),
      display1: TextStyle(color: Styles.color_Secondary),
      display2:
          TextStyle(color: Styles.color_SecondaryDeepDark.withOpacity(.8)),
    ));
