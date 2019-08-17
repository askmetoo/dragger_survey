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

  Future<PrismSurveySet> getPrismSurveySetByUid({uid}) {
    return null;
  }

  Stream<QuerySnapshot> get streamPrismSurveySets {
    return Collection<PrismSurveySet>(path: 'surveySets').streamDocuments();
  }

  addPrismSurveySetToDb({PrismSurveySet surveySet}) {
    Collection().createDocumentWithObject(path: 'surveySet', object: surveySet );
    print("2) ----> Form values have been sent to data base");
  }

}