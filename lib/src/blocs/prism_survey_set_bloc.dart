import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dragger_survey/src/services/services.dart';
import 'package:flutter/material.dart';

class PrismSurveySetBloc extends ChangeNotifier{

  Future<List<PrismSurveySet>> get collectionPrismSurveySets {

    print("OOOOO===> In PrismSurveySetBloc - get allPrismSurveySets");
    return Collection<PrismSurveySet>(path: 'surveySets')
    .getData();  
  }

  Future<PrismSurveySet> get documentPrismSurveySets {
    print("OOOOO===> In PrismSurveySetBloc - get allPrismSurveySets");
    return Document<PrismSurveySet>(path: 'surveySets')
    .getData();  
  }

  Future get prismSurveySetsDocuments {
    return Collection<PrismSurveySet>(path: 'surveySets').getDocuments();
  }

  Future<PrismSurveySet> getPrismSurveySetByUid({uid}) {
    print("In PrismSurveySetBloc - getPrismSurveySetByUid - uid: $uid");
    return null;
  }

  Stream<QuerySnapshot> get streamPrismSurveySets {
    return Collection<PrismSurveySet>(path: 'surveySets').streamDocuments();
  }
}