import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dragger_survey/src/services/services.dart';
import 'package:flutter/material.dart';

class SurveySetBloc extends ChangeNotifier {
  Future<DocumentSnapshot> _currentPrismSurveySetFuture;
  String _description = '';
  String _xDescription = '';
  String _yDescription = '';
  String _currentPrismSurveySetId;
  String _orderField = 'created';
  bool _descendingOrder = true;

  get orderField => _orderField;
  get descendingOrder => _descendingOrder;
  get description => _description;
  get xDescription => _xDescription;
  get yDescription => _yDescription;

  set orderField(orderField) {
    _orderField = orderField;
    notifyListeners();
  }

  set descendingOrder(descendingOrder) {
    _descendingOrder = descendingOrder;
    notifyListeners();
  }

  setDescription(description) {
    log("In PrismSurveySetBloc - setDescription: $description");
    _description = description;
    notifyListeners();
  }

  setXDescription(xDescription) {
    log("In PrismSurveySetBloc - setXDescription: $xDescription");
    _xDescription = xDescription;
    notifyListeners();
  }

  setYDescription(yDescription) {
    log("In PrismSurveySetBloc - setYDescription: $yDescription");
    _yDescription = yDescription;
    notifyListeners();
  }

  Future<DocumentSnapshot> get currentPrismSurveySet async {
    if (_currentPrismSurveySetFuture == null) {
      log("In PrismSurveySetBloc get currentPrismSurveySet value is $_currentPrismSurveySetFuture");
      return null;
    }
    return _currentPrismSurveySetFuture;
  }

  String get currentPrismSurveySetId {
    if (_currentPrismSurveySetFuture == null) {
      log("In PrismSurveySetBloc get currentPrismSurveySetId value is $_currentPrismSurveySetId");
      return null;
    }
    return _currentPrismSurveySetId;
  }

  String setCurrentPrismSurveySetId({@required id}) {
    _currentPrismSurveySetId = id;
    // notifyListeners();
    return _currentPrismSurveySetId;
  }

  Future<DocumentSnapshot> setCurrentPrismSurveySetById({@required id}) async {
    _currentPrismSurveySetFuture = getPrismSurveySetById(id: id);
    log("In PrismSurveySetBloc setCurrentPrismSurveySetById returned _currentPrismSurveySet is ${_currentPrismSurveySetFuture.then((val) => val.documentID)}");
    // notifyListeners();
    return _currentPrismSurveySetFuture;
  }

  Future<List<PrismSurveySet>> get collectionPrismSurveySets {
    return Collection<PrismSurveySet>(path: 'surveySets').getData();
  }

  Future<PrismSurveySet> get documentPrismSurveySets {
    return Document<PrismSurveySet>(path: 'surveySets').getData();
  }

  Future get prismSurveySetsDocuments {
    return Collection<PrismSurveySet>(path: 'surveySets').getDocuments();
  }

  Future<QuerySnapshot> getPrismSurveySetQuery(
      {String fieldName, String fieldValue}) {
    return Collection<PrismSurveySet>(path: 'surveySets')
        .getDocumentsByQuery(fieldName: fieldName, fieldValue: fieldValue);
  }

  Future<QuerySnapshot> getPrismSurveySetQueryOrderByField(
      {@required String fieldName,
      @required String fieldValue,
      @required String orderField,
      bool descending = false}) {
    return Collection<PrismSurveySet>(path: 'surveySets')
        .getDocumentsByQueryOrderByField(
            fieldName: fieldName,
            fieldValue: fieldValue,
            orderField: orderField,
            descending: descending);
  }

  Stream<QuerySnapshot> streamPrismSurveySetQueryOrderByField(
      {@required String fieldName,
      @required String fieldValue,
      @required String orderField,
      bool descending = false}) {
    return Collection<PrismSurveySet>(path: 'surveySets')
        .streamDocumentsByQueryOrderByField(
      fieldName: fieldName,
      fieldValue: fieldValue,
      orderField: orderField,
      descending: descending,
    );
  }

  Future<DocumentSnapshot> getPrismSurveySetById({id}) async {
    DocumentSnapshot returnValue;
    returnValue =
        await Collection<PrismSurveySet>(path: 'surveySets').getDocument(id);
    // notifyListeners();
    return returnValue;
  }

  Stream<QuerySnapshot> get streamPrismSurveySets {
    return Collection<PrismSurveySet>(path: 'surveySets').streamDocuments();
  }

  updatePrismSurveySetById({id, field, value}) async {
    try {
      await Collection(path: "surveySets").updateDocumentByIdWithFieldAndValue(
          id: id, field: field, value: value);
      notifyListeners();
    } catch (err) {
      log("ERROR in PrismSurveySetBloc - updatePrismSurveySetById, error: $err");
    }
  }

  addPrismSurveySetToDb({Map<String, dynamic> surveySet}) {
    Collection(path: "surveySets").createDocumentWithObject(object: surveySet);
    notifyListeners();
  }

  Future<DocumentSnapshot> deletePrismSurveySetById({surveySetId}) {
    var returnValue =
        Collection<PrismSurveySet>(path: 'surveySets').deleteById(surveySetId);
    notifyListeners();
    return returnValue;
  }

  Future<QuerySnapshot> deleteAllSurveysFromSurveySetById({surveySetId}) async {
    QuerySnapshot returnedValue = await Collection<PrismSurvey>(path: 'surveys')
        .deleteDocumentsChildrenByQuery(
            fieldName: 'surveySet', fieldValue: surveySetId);
    notifyListeners();
    return returnedValue;
  }
}
