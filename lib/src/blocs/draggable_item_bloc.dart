import 'package:flutter/material.dart';

class DraggableItemBloc extends ChangeNotifier {
  Offset _initialPosition = Offset(135.0, 195.0);
  // Offset _initialPosition = Offset(35.0, 295.0);
  Offset _draggableItemPosition;
  bool _startedDragging = false;

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

  bool get startedDragging {
    return _startedDragging;
  }

  setStartedDragging(bool newValue) {
    _startedDragging = newValue;
    notifyListeners();
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
