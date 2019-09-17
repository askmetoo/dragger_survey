import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dragger_survey/src/services/services.dart';
import 'package:flutter/material.dart';

class PrismSurveySetBloc extends ChangeNotifier {
  Future<DocumentSnapshot> _currentPrismSurveySet;
  String _currentPrismSurveySetId;

  Future<DocumentSnapshot> get currentPrismSurveySet async {
    if (_currentPrismSurveySet == null) {
      log("In PrismSurveySetBloc get currentPrismSurveySet value is $_currentPrismSurveySet");
      return null;
    }
    return _currentPrismSurveySet;
  }

  String get currentPrismSurveySetId {
    if (_currentPrismSurveySet == null) {
      log("In PrismSurveySetBloc get currentPrismSurveySet value is $_currentPrismSurveySetId");
      return null;
    }
    return _currentPrismSurveySetId;
  }

  String setCurrentPrismSurveySetId({@required id}) {
    _currentPrismSurveySetId = id;
    notifyListeners();
    return _currentPrismSurveySetId;
  }

  Future<DocumentSnapshot> setCurrentPrismSurveySetById({@required id}) async {
    _currentPrismSurveySet = getPrismSurveySetById(id: id);
    log("In PrismSurveySetBloc setCurrentPrismSurveySetById returned _currentPrismSurveySet is ${_currentPrismSurveySet.then((val) => val.documentID)}");
    notifyListeners();
    return _currentPrismSurveySet;
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

  Future<DocumentSnapshot> getPrismSurveySetById({id}) async {
    DocumentSnapshot returnValue;
    returnValue =
        await Collection<PrismSurveySet>(path: 'surveySets').getDocument(id);
    // notifyListeners();
    return returnValue;
  }

  Future<DocumentSnapshot> deletePrismSurveySetById({id}) {
    var returnValue =
        Collection<PrismSurveySet>(path: 'surveySets').deleteById(id);
    notifyListeners();
    return returnValue;
  }

  Future<PrismSurveySet> getPrismSurveySetByUser({userId}) {
    return null;
  }

  Stream<QuerySnapshot> get streamPrismSurveySets {
    return Collection<PrismSurveySet>(path: 'surveySets').streamDocuments();
  }

  addPrismSurveySetToDb({Map<String, dynamic> surveySet}) {
    Collection(path: "surveySets").createDocumentWithObject(object: surveySet);
    notifyListeners();
  }
}
