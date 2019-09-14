import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dragger_survey/src/services/services.dart';
import 'package:flutter/material.dart';

class PrismSurveySetBloc extends ChangeNotifier {
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

  Future<DocumentSnapshot> getPrismSurveySetById({id}) {
    return Collection<PrismSurveySet>(path: 'surveySets').getDocument(id);
  }
  Future<DocumentSnapshot> deletePrismSurveySetById({id}) {
    var returnValue = Collection<PrismSurveySet>(path: 'surveySets').deleteById(id);
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
