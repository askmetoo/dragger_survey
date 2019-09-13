import 'package:flutter/material.dart';

class DraggableItemBloc extends ChangeNotifier {
  Offset _initialPosition = Offset(25.0, 95.0);
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
