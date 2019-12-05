import 'package:dragger_survey/src/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ColorsBloc extends ChangeNotifier {
  setColorToTeam1Theme() {
    Styles.setColorsToTeam1();
    notifyListeners();
  }

  setColorToAppStandardTheme() {
    Styles.setColorsToAppStandard();
    notifyListeners();
  }
}
