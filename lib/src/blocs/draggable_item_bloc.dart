import 'package:flutter/material.dart';

class DraggableItemBloc extends ChangeNotifier {
  Offset _initialPosition = Offset(135.0, 195.0);
  // Offset _initialPosition = Offset(35.0, 295.0);
  Offset _draggableItemPosition;

  void initState() {
    _draggableItemPosition = _initialPosition;
    notifyListeners();
  }

  DraggableItemBloc() {
    _draggableItemPosition = _initialPosition;
    notifyListeners();
  }

  Offset get draggableItemPositon {
    return _draggableItemPosition;
  }

  Offset get initialPosition {
    return _initialPosition;
  }

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
