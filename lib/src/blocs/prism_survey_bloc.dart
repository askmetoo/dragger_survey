
import 'package:dragger_survey/src/services/models.dart';
import 'package:flutter/material.dart';


class PrismSurveyBloc extends ChangeNotifier {

  DateTime _created = DateTime.now().toLocal();
  DateTime _edited = DateTime.now().toLocal();
  String _askedPerson = 'Anonymous';
  int _yValue = 0;
  int _xValue = 0;
  dynamic _users = {};

  PrismSurvey _currentPrismSurveyData = PrismSurvey();

  bool _formIsEmpty = true;

  PrismSurvey get currentPrismSurvey {
    _currentPrismSurveyData.created = _created;
    _currentPrismSurveyData.edited = _edited;
    _currentPrismSurveyData.askedPerson = _askedPerson;
    _currentPrismSurveyData.yValue = _yValue;
    _currentPrismSurveyData.xValue = _xValue;
    _currentPrismSurveyData.users = _users;
    return _currentPrismSurveyData;
  }

  PrismSurvey gatherCurrentPrismSurvey() {
    _currentPrismSurveyData.created = _created;
    _currentPrismSurveyData.edited = _edited;
    _currentPrismSurveyData.askedPerson = _askedPerson;
    _currentPrismSurveyData.yValue = _yValue;
    _currentPrismSurveyData.xValue = _xValue;
    _currentPrismSurveyData.users = _users;
    return _currentPrismSurveyData;
  }

  set currentCreationDate(created) {
    _created = created;
    notifyListeners();
  }

  set currentEditedDate(edited) {
    _edited = edited;
    notifyListeners();
  }

  set currentAskedPerson(askedPerson) {
    _askedPerson = askedPerson;
    notifyListeners();
  }

  get currentCreationDate {
    return _created;
  }

  get currentEditedDate {
    return _edited;
  }

  get currentAskedPerson {
    return _askedPerson;
  }

  setCurrentCreationDate({@required created}) {
    _created = created;
    notifyListeners();
  }

  setCurrentEditedDate({@required edited}) {
    _edited = edited;
    notifyListeners();
  }

  setCurrentAskedPerson({@required askedPerson}) {
    _askedPerson = askedPerson;
    notifyListeners();
  }

  set rowIndex(int yIdx) {
    _yValue = yIdx;
    notifyListeners();
  }

  get rowIndex {
    return _yValue;
  }

  setRowIndex({@required int rowIndex}) {
    _yValue = rowIndex;
    notifyListeners();
  }

  set colIndex(int xIdx) {
    _xValue = xIdx;
    notifyListeners();
  }

  get colIndex {
    return _xValue;
  }

  setColIndex({@required int colIndex}) {
    _xValue = colIndex;
    notifyListeners();
  }

  set created(DateTime created) {
    _created = created;
    notifyListeners();
  }

  get created {
    return _created;
  }

  setCreated({@required DateTime created}) {
    _created = created;
    notifyListeners();
  }

  set edited(DateTime edited) {
    _edited = edited;
    notifyListeners();
  }

  get edited {
    return _edited;
  }

  setEdited({@required DateTime edited}) {
    _edited = edited;
    notifyListeners();
  }

  set formIsEmpty(bool value) {
    _formIsEmpty = value;
    notifyListeners();
  }

  get formIsEmpty {
    return _formIsEmpty;
  }

  setFormIsEmpty(bool value) {
    _formIsEmpty = value;
    notifyListeners();
  }

  PrismSurvey getCurrentPrismSurvey() {
    return _currentPrismSurveyData;
  }

}