import 'package:dragger_survey/src/enums/connectivity_status.dart';
import 'package:dragger_survey/src/services/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dragger_survey/src/styles.dart';
import 'package:dragger_survey/src/shared/shared.dart';
import 'package:dragger_survey/src/blocs/blocs.dart';

import 'screens/screens.dart';

class App extends StatelessWidget {
  final navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<FirebaseUser>.value(
            value: FirebaseAuth.instance.onAuthStateChanged),
        StreamProvider<ConnectivityStatus>(
          builder: (context) =>
              ConnectivityService().connectionStatusController.stream,
        ),
        ChangeNotifierProvider<SignInBloc>.value(
          value: SignInBloc(),
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
        ChangeNotifierProvider<PrismSurveySetBloc>.value(
          value: PrismSurveySetBloc(),
        ),
        ChangeNotifierProvider<TeamBloc>.value(
          value: TeamBloc(),
        ),
        ChangeNotifierProvider<UserBloc>.value(
          value: UserBloc(),
        ),
        ChangeNotifierProvider<FabBloc>.value(
          value: FabBloc(),
        ),
        ChangeNotifierProvider<IntroViewsBloc>.value(
          value: IntroViewsBloc(),
        ),
      ],
      child: MaterialApp(
        title: 'Dragger Survey',
        navigatorKey: navigatorKey,
        onGenerateRoute: RouteGenerator.generateRoute,
        theme: ThemeData(
          canvasColor: Styles.color_Secondary,
          fontFamily: 'Barlow',
          bottomAppBarTheme: BottomAppBarTheme(color: Styles.drg_colorGreen),
          accentColor: Styles.color_Contrast,
          primaryColor: Styles.color_Primary,
          primaryColorLight: Styles.drg_colorAppBackgroundLight,
          primaryColorDark: Styles.drg_colorAppBackgroundMedium,
          textTheme: TextTheme(
            body1: TextStyle(fontSize: 18, color: Styles.color_Text),
            body2: TextStyle(fontSize: 16),
            button: TextStyle(letterSpacing: 1.5, fontWeight: FontWeight.bold),
            headline: TextStyle(fontWeight: FontWeight.bold),
            subhead: TextStyle(color: Styles.color_Text),
            overline: TextStyle(color: Styles.color_Text),
            subtitle: TextStyle(color: Styles.color_Text),
            caption: TextStyle(color: Styles.color_Text),
            display1: TextStyle(color: Styles.color_Text),
            display2: TextStyle(color: Styles.color_Text),
            display3: TextStyle(color: Styles.color_Text),
            display4: TextStyle(color: Styles.color_Text),
          ),
          buttonTheme: ButtonThemeData(),
        ),
        home: SplashScreen(),
      ),
    );
  }
}
