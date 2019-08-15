import 'package:dragger_survey/src/services/services.dart';
import 'package:flutter/material.dart';

class PrismSurveySetBloc extends ChangeNotifier{

  Future<List<PrismSurveySet>> get allPrismSurveySets {

    print("OOOOO===> In PrismSurveySetBloc - get allPrismSurveySets");
    return Collection<PrismSurveySet>(path: 'surveySets')
    .getData();  
  }

  Future<PrismSurveySet> getPrismSurveySetByUid({uid}) {
    print("In PrismSurveySetBloc - getPrismSurveySetByUid - uid: $uid");
    return null;
  }
}