import 'package:dragger_survey/src/blocs/blocs.dart';
import 'package:dragger_survey/src/shared/loader.dart';
import 'package:flutter/material.dart';
import 'package:dragger_survey/src/services/services.dart';
import 'package:dragger_survey/src/styles.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileScreen extends StatelessWidget {
  final AuthService auth = AuthService();
  @override
  Widget build(BuildContext context) {
    FirebaseUser user = Provider.of<FirebaseUser>(context);
    final SignInBloc signInBloc = Provider.of<SignInBloc>(context);

    // TODO: reactive if statement
    // if (user != null) {
    if (true) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Styles.drg_colorAppBackground,
          title: Text("Profile Screen for: ${user?.displayName ?? 'Guest'}"),
        ),
        body: FlatButton(
          onPressed: () async {
            await signInBloc.logoutUser();
            Navigator.of(context)
                .pushNamedAndRemoveUntil('/', (route) => false);
          },
          color: Styles.drg_colorAttention,
          child: Text("Logout"),
        ),
      );
    } else {
      return LoadingScreen();
    }
  }
}
