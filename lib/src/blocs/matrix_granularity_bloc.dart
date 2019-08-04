import 'package:flutter/material.dart';

class MatrixGranularityBloc with ChangeNotifier {
  int _granularity = 7;

  int get matrixGranularity {
    return _granularity;
  }

  set matrixGranularity(int value) {
    _granularity = value;
    notifyListeners();
  }

  setNewGranularity({int granularity}) {
    _granularity = granularity;
    notifyListeners(); // Don't forget!!!!
  }
}
