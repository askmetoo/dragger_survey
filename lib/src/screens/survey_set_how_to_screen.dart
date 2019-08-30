import 'package:dragger_survey/src/blocs/blocs.dart';
import 'package:dragger_survey/src/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SurveySetHowToScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final SignInBloc signInBloc = Provider.of<SignInBloc>(context);

    if (signInBloc.currentUserUID == null) {
      print("User is not signed in!");
      return SplashScreen();
    }

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Container(
        child: Text("Survey Set How-To screen"),
      ),
    );
  }
}
