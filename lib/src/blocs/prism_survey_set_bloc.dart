import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dragger_survey/src/services/services.dart';
import 'package:flutter/material.dart';

class PrismSurveySetBloc extends ChangeNotifier{

  bool _formIsEmpty = true;

  Future<List<PrismSurveySet>> get collectionPrismSurveySets {
    return Collection<PrismSurveySet>(path: 'surveySets')
    .getData();  
  }

  Future<PrismSurveySet> get documentPrismSurveySets {
    return Document<PrismSurveySet>(path: 'surveySets')
    .getData();  
  }

  Future get prismSurveySetsDocuments {
    return Collection<PrismSurveySet>(path: 'surveySets').getDocuments();
  }

  Future<QuerySnapshot> getPrismSurveySetQuery({String fieldName, String fieldValue}) {
    return Collection<PrismSurveySet>(path: 'surveySets').getDocumentsByQuery(fieldName: fieldName, fieldValue: fieldValue);
  }

  Future<DocumentSnapshot> getPrismSurveySetById({id}) {
    return Collection<PrismSurveySet>(path: 'surveySets').getDocument(id);
  }
  
  Future<PrismSurveySet> getPrismSurveySetByUser({userId}) {
    return null;
  }

  Stream<QuerySnapshot> get streamPrismSurveySets {
    return Collection<PrismSurveySet>(path: 'surveySets').streamDocuments();
  }

  addPrismSurveySetToDb({Map<String, dynamic> surveySet}) {
    Collection(path: "surveySets").createDocumentWithObject(object: surveySet);
    print("2) ----> Form values have been sent to data base");
  }

}