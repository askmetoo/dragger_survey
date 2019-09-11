import 'dart:developer';

import 'package:dragger_survey/src/blocs/blocs.dart';
import 'package:dragger_survey/src/styles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SigendInUserCircleAvatar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final SignInBloc signInBloc = Provider.of<SignInBloc>(context);
    return FutureBuilder<FirebaseUser>(
      future: signInBloc.currentUser,
      builder: (BuildContext context, AsyncSnapshot<FirebaseUser> snapshot) {
        if (snapshot.connectionState == ConnectionState.none ||
            snapshot.connectionState == ConnectionState.waiting ||
            snapshot.connectionState == ConnectionState.active) {
          log("In SignInUserCircleAvatar - ${snapshot.connectionState}");

          if (snapshot.connectionState == ConnectionState.done) {
            return GestureDetector(
                onTap: () {
                  Scaffold.of(context).openEndDrawer();
                },
                child: Container(
                  padding: EdgeInsets.all(8),
                  child: CircleAvatar(
                    backgroundColor: Styles.drg_colorDarkerGreen,
                    backgroundImage: snapshot.data?.uid != null
                        ? NetworkImage(snapshot.data.photoUrl)
                        : null,
                  ),
                ));
          }
          return Container();
        }
        return Container();
      },
    );
  }
}
