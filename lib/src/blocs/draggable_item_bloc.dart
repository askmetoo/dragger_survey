import 'package:flutter/material.dart';

class DraggableItemBloc extends ChangeNotifier {
  final Offset _initialPosition = Offset(35.0, 295.0);
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

  // setInitialDraggableItemPostion({Offset position}) {
  //   _initialPosition = position;
  //   // TODO: is this OK?
  //   // notifyListeners();
  // }

  setNewDraggableItemPositon({Offset position}) {
    _draggableItemPosition = position;
    notifyListeners();
  }

  resetDraggableItemPositon() {
    _draggableItemPosition = _initialPosition;
    notifyListeners();
  }
}
