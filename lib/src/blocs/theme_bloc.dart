import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:dragger_survey/src/theme.dart';

enum ThemeType { Standard, Team1 }

class ThemeBloc extends ChangeNotifier {

  // ThemeData currentTheme = team1Theme;
  ThemeData currentTheme = standardTheme;

  setColorTheme(ThemeType themeType) {

    if (themeType == ThemeType.Standard) {
      log("Standard selected");
      currentTheme = standardTheme;
      return notifyListeners();
    }

    if (themeType == ThemeType.Team1) {
      log("Standard team1");
      currentTheme = team1Theme;
      return notifyListeners();
    }

    log("In ThemeBloc - setColorTheme value of currentTheme: $currentTheme");
  }
}
