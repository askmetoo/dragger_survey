import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dragger_survey/src/services/models.dart';
import 'package:dragger_survey/src/services/services.dart';
import 'package:flutter/material.dart';

class PrismSurveyBloc extends ChangeNotifier {
  DateTime _created = DateTime.now().toLocal();
  DateTime _edited = DateTime.now().toLocal();
  String _askedPerson = 'Anonymous';
  int _counter = 0;
  int _yValue = 0;
  int _xValue = 0;
  dynamic _users = [];

  PrismSurvey _currentPrismSurveyData = PrismSurvey();

  bool _formIsEmpty = true;

  _resetPrismSurveyData() {
    _created = DateTime.now().toLocal();
    _edited = DateTime.now().toLocal();
    _askedPerson = 'Anonymous';
    _counter = 0;
    _yValue = 0;
    _xValue = 0;
    _users = [];
  }

  PrismSurvey get currentPrismSurvey {
    _currentPrismSurveyData.created = _created;
    _currentPrismSurveyData.edited = _edited;
    _currentPrismSurveyData.askedPerson = _askedPerson;
    _currentPrismSurveyData.counter = _counter;
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

  Future<List<PrismSurvey>> getPrismSurveyDocuments() {
    return Collection<PrismSurvey>(path: 'surveys').getDocuments();
  }

  Future<DocumentSnapshot> getPrismSurveyById({@required id}) {
    Future<DocumentSnapshot> snapshot = Collection<PrismSurvey>(path: 'surveys')
        .getDocument(id)
        .catchError((err) {
      log("ERROR in PrismSurveyBloc getPrismSurveyById - error: $err");
      return null;
    });

    return snapshot;
  }

  Future<QuerySnapshot> getPrismSurveyQuery(
      {String fieldName, String fieldValue}) {
    return Collection<PrismSurvey>(path: 'surveys')
        .getDocumentsByQuery(fieldName: fieldName, fieldValue: fieldValue);
  }

  Future<QuerySnapshot> getPrismSurveyQueryOrderCreatedAsc(
      {String fieldName, String fieldValue}) {
    return Collection<PrismSurvey>(path: 'surveys')
        .getDocumentsByQuerySortByCreatedAsc(
            fieldName: fieldName, fieldValue: fieldValue);
  }

  Future<QuerySnapshot> getPrismSurveyQueryOrderCreatedDesc(
      {String fieldName, String fieldValue}) {
    return Collection<PrismSurvey>(path: 'surveys')
        .getDocumentsByQuerySortByCreatedDesc(
            fieldName: fieldName, fieldValue: fieldValue);
  }

  addPrismSurveyToDb({Map<String, dynamic> survey}) async {
    Collection(path: "surveys").createDocumentWithObject(object: survey);
    _resetPrismSurveyData();
    notifyListeners();
  }

  Future<DocumentSnapshot> deletePrismSurveyById({id}) {
    var returnValue =
        Collection<PrismSurveySet>(path: 'surveys').deleteById(id);
    notifyListeners();
    return returnValue;
  }
}
