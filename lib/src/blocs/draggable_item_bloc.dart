import 'dart:developer';

import 'package:flutter/material.dart';

class DraggableItemBloc extends ChangeNotifier {
  Offset _initialPosition = Offset(35.0, 295.0);
  Offset _draggableItemPosition;
  // double _mqWidth = 764;
  // Orientation _mqOrientation = Orientation.portrait;

  void initState() {
    // initBoard();
    _draggableItemPosition = _initialPosition;
    notifyListeners();
  }

  // initBoard() {
  //   log("----- > mqWidth: $_mqWidth");
  //   log("----- > mqOrientation: $_mqOrientation");

  //   if (_mqWidth >= 768.0 && _mqOrientation == Orientation.landscape) {
  //     _initialPosition = Offset(550.0, 510.0);
  //   } else if (_mqWidth >= 710.0 && _mqOrientation == Orientation.portrait) {
  //     _initialPosition = Offset(35.0, 600.0);
  //   } else {
  //     _initialPosition = Offset(35.0, 295.0);
  //   }
  //   _draggableItemPosition = _initialPosition;
  //   notifyListeners();
  // }

  DraggableItemBloc() {
    _draggableItemPosition = _initialPosition;
    notifyListeners();
  }

  Offset get draggableItemPositon {
    return _draggableItemPosition;
  }

  // set mqWidth(double width) {
  //   _mqWidth = width;
  //   notifyListeners();
  // }

  // set mqOrientation(Orientation orientation) {
  //   _mqOrientation = orientation;
  //   notifyListeners();
  // }

  set initialPosition(Offset position) {
    _initialPosition = position;
    notifyListeners();
  }

  set draggableItemPositon(Offset position) {
    _draggableItemPosition = position;
    notifyListeners();
  }

  getInitialDraggableItemPositon({Offset position}) {
    _draggableItemPosition = _initialPosition;
    notifyListeners();
  }

  setNewDraggableItemPositon({Offset position}) {
    _draggableItemPosition = position;
    notifyListeners();
  }

  resetDraggableItemPositon() {
    _draggableItemPosition = _initialPosition;
    notifyListeners();
  }
}
