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
        StreamProvider<FirebaseUser>.value(value: FirebaseAuth.instance.onAuthStateChanged),
        StreamProvider<ConnectivityStatus>(
          builder: (context) => ConnectivityService().connectionStatusController.stream,
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
        )
      ],
      child: MaterialApp(
        title: 'Dragger Survey',
        navigatorKey: navigatorKey,
        onGenerateRoute: RouteGenerator.generateRoute,
        theme: ThemeData(
          fontFamily: 'Barlow',
          bottomAppBarTheme: BottomAppBarTheme(color: Styles.drg_colorGreen),
          accentColor: Colors.orangeAccent[300],
          primaryColor: Colors.orange.shade700,
          textTheme: TextTheme(
            body1: TextStyle(fontSize: 18, color: Styles.drg_colorText),
            body2: TextStyle(fontSize: 16),
            button: TextStyle(letterSpacing: 1.5, fontWeight: FontWeight.bold),
            headline: TextStyle(fontWeight: FontWeight.bold),
            subhead: TextStyle(color: Styles.drg_colorText),
            overline: TextStyle(color: Styles.drg_colorText),
            subtitle: TextStyle(color: Styles.drg_colorText),
            caption: TextStyle(color: Styles.drg_colorText),
            display1: TextStyle(color: Styles.drg_colorText),
            display2: TextStyle(color: Styles.drg_colorText),
            display3: TextStyle(color: Styles.drg_colorText),
            display4: TextStyle(color: Styles.drg_colorText),
          ),
          buttonTheme: ButtonThemeData(),
        ),
        home: SplashScreen(),
      ),
    );
  }
}
