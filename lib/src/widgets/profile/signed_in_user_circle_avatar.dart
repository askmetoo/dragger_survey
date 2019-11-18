import 'package:dragger_survey/src/blocs/blocs.dart';
import 'package:dragger_survey/src/shared/shared.dart';
import 'package:dragger_survey/src/styles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignedInUserCircleAvatar extends StatelessWidget {
  final double radiusSmall;

  SignedInUserCircleAvatar({this.radiusSmall = 18}) : super();

  @override
  Widget build(BuildContext context) {
    final SignInBloc signInBloc = Provider.of<SignInBloc>(context);
    return FutureBuilder<FirebaseUser>(
      future: signInBloc.currentUser,
      builder: (BuildContext context, AsyncSnapshot<FirebaseUser> snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Loader();
        }
        double radiusBig = radiusSmall + 2;
          return GestureDetector(
            onTap: () {
              Scaffold.of(context).openEndDrawer();
            },
            child: Container(
              padding: EdgeInsets.all(7),
              child: CircleAvatar(
                backgroundColor: Styles.drg_colorSecondary,
                radius: radiusBig,
                child: CircleAvatar(
                  radius: radiusSmall,
                  backgroundImage: NetworkImage(snapshot.data.photoUrl),
                ),
              ),
            ),
          );
      },
    );
  }
}
