import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dragger_survey/src/services/shared_preferences.dart';

class IntroViewsBloc extends ChangeNotifier {
  bool _showIntroViews = true;

  get showIntroViews {
    return _showIntroViews;
  }

  getShowIntroViewsValue() async {
    return getShowIntroViewsSavedPreference();
  }

  setShowIntroViews(bool value) {
    _showIntroViews = value;
    writeShowIntroToPreferences(value);
    notifyListeners();
  }
}
