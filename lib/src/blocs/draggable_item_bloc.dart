import 'package:flutter/material.dart';

class DraggableItemBloc extends ChangeNotifier {
  Offset _initialPosition = Offset(25.0, 95.0);
  Offset _draggableItemPosition;

  void initState() {
    _draggableItemPosition = _initialPosition;
  }

  DraggableItemBloc() {
    _draggableItemPosition = _initialPosition;
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
    print("In resetDraggableItemPositon");
    _draggableItemPosition = _initialPosition;
    print(
        "In resetDraggableItemPositon - _draggableItemPosition: $_draggableItemPosition");
    notifyListeners();
  }
}
