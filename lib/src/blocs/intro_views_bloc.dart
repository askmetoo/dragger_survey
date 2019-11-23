import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class IntroViewsBloc extends ChangeNotifier {
  bool _showIntroViews = true;

  get showIntroViews {
    return _showIntroViews;
  }

  setShowIntroViews(bool value) {
    _showIntroViews = value;
    notifyListeners();
  }
}
