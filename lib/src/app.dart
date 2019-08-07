import 'package:dragger_survey/src/blocs/prism_survey_bloc.dart';
import 'package:dragger_survey/src/screens/dragger_screen.dart';
import 'package:dragger_survey/src/screens/home_screen.dart';
import 'package:dragger_survey/src/screens/splash_screen.dart';
import 'package:dragger_survey/src/styles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:dragger_survey/src/blocs/fab_bloc.dart';
import 'package:dragger_survey/src/screens/login_screen.dart';
import 'package:dragger_survey/src/screens/profile_screen.dart';
import 'package:dragger_survey/src/screens/scaffold_sreen.dart';
import 'package:dragger_survey/src/services/auth.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

import 'blocs/draggable_item_bloc.dart';
import 'blocs/matrix_granularity_bloc.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<FirebaseUser>.value(
          value: AuthService().user,
        ),
        ChangeNotifierProvider<MatrixGranularityBloc>.value(
          value: MatrixGranularityBloc(),
        ),
        ChangeNotifierProvider<DraggableItemBloc>.value(
          value: DraggableItemBloc(),
        ),
        ChangeNotifierProvider<PrismSurveyBloc>.value(
          value: PrismSurveyBloc(),
        ),
        ChangeNotifierProvider<FabBloc>.value(
          value: FabBloc(),
        )
      ],
      child: MaterialApp(
        onGenerateRoute: (setttings) {
          switch (setttings.name) {
            case '/draggerboard':
              return PageTransition(
                duration: Duration(milliseconds: 400),
                child: DraggerScreen(),
                type: PageTransitionType.rightToLeftWithFade,
              );
              break;
            default:
              return null;
          }
        },
        // routes: {
        //   '/home': (context) => HomeScreen(),
        //   '/login': (context) => LoginScreen(),
        //   '/profile': (context) => ProfileScreen(),
        //   '/scaffold': (context) => ScaffoldScreen(),
        //   '/draggerboard': (context) => DraggerScreen(),
        // },
        theme: ThemeData(
          fontFamily: 'Nunito',
          bottomAppBarTheme: BottomAppBarTheme(color: Styles.greenColor),
          accentColor: Colors.orangeAccent[300],
          primaryColor: Colors.orange.shade700,
          textTheme: TextTheme(
            body1: TextStyle(fontSize: 18),
            body2: TextStyle(fontSize: 16),
            button: TextStyle(letterSpacing: 1.5, fontWeight: FontWeight.bold),
            headline: TextStyle(fontWeight: FontWeight.bold),
            subhead: TextStyle(color: Colors.grey),
          ),
          buttonTheme: ButtonThemeData(),
        ),

        home: SplashScreen(),
//        home: HomeScreen(),
//        home: LoginScreen(),
//        home: ScaffoldScreen(),
      ),
    );
  }
}
