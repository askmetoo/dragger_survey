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

    if (user != null) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Styles.appBackground,
          title: Text("Profile Screen for: ${user?.displayName ?? 'Guest'}"),
        ),
        body: FlatButton(
          onPressed: () async {
            await auth.signOut();
            Navigator.of(context)
                .pushNamedAndRemoveUntil('/', (route) => false);
          },
          color: Styles.attentionColor,
          child: Text("Logout"),
        ),
      );
    } else {
      return LoadingScreen();
    }
  }
}
