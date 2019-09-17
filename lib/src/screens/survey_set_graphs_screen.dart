import 'package:dragger_survey/src/blocs/blocs.dart';
import 'package:dragger_survey/src/screens/splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SurveySetGraphsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final SignInBloc signInBloc = Provider.of<SignInBloc>(context);

    return FutureBuilder<FirebaseUser>(
      future: signInBloc.currentUser,
      builder: (context, AsyncSnapshot<FirebaseUser> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if(snapshot.data.uid == null) {
              print("In SurveySetHowToScreen - User is not signed in!");
              return SplashScreen();
            }
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                child: Text("Survey Set Graphs screen"),
              ),
            );
        }
        return Container();
      }
    );
  }
}
