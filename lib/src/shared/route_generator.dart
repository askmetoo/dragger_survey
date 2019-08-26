import 'package:dragger_survey/src/blocs/blocs.dart';
import 'package:dragger_survey/src/screens/screens.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class RouteGenerator {

  static Route<dynamic> generateRoute(RouteSettings settings) {


    switch (settings.name) {
            case '/draggerboard':
              return PageTransition(
                duration: Duration(milliseconds: 200),
                child: DraggerScreen(),
                type: PageTransitionType.downToUp,
              );
              break;
            case '/surveysetslist':
              var _teamId = settings.arguments;
              return PageTransition(
                duration: Duration(milliseconds: 200),
                child: SurveySetsListScreen(teamId: _teamId),
                type: PageTransitionType.fade,
              );
              break;
            case '/surveysetdetails':
              var _id = settings.arguments;
              return PageTransition(
                duration: Duration(milliseconds: 200),
                type: PageTransitionType.fade,
                child: SurveySetDetailsScreen(id: _id,),
              );
              break;
            case '/surveysetscaffold':
              var _id = settings.arguments;
              return PageTransition(
                duration: Duration(milliseconds: 200),
                child: SurveySetScaffoldScreen(argument: _id,),
                type: PageTransitionType.fade,
              );
              break;
            case '/teams':
              return PageTransition(
                duration: Duration(milliseconds: 200),
                child: TeamsListScreen(),
                type: PageTransitionType.fade,
              );
              break;
            case '/login':
              return PageTransition(
                duration: Duration(milliseconds: 200),
                child: LoginScreen(),
                type: PageTransitionType.fade,
              );
              break;
            case '/profile':
              return PageTransition(
                duration: Duration(milliseconds: 200),
                child: ProfileScreen(),
                type: PageTransitionType.fade,
              );
              break;
            
            case '/draggerboard':
              return PageTransition(
                duration: Duration(milliseconds: 200),
                child: DraggerScreen(),
                type: PageTransitionType.fade,
              );
              break;
            case '/surveysethowtoscreen':

              return PageTransition(
                duration: Duration(milliseconds: 200),
                child: DraggerScreen(),
                type: PageTransitionType.fade,
              );
              break;
            default:
              return PageTransition(
                duration: Duration(microseconds: 200),
                child: ErrorScreen(),
                type: PageTransitionType.downToUp,
              );
          }

  }
}