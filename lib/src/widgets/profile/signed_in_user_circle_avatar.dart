import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dragger_survey/src/blocs/blocs.dart';
import 'package:dragger_survey/src/shared/shared.dart';
import 'package:dragger_survey/src/styles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignedInUserCircleAvatar extends StatefulWidget {
  final double radiusSmall;
  final bool letterPadding;
  final ImageProvider backgroundImage;
  final useSignedInUserPhoto;

  SignedInUserCircleAvatar({
    this.radiusSmall = 18,
    this.letterPadding = true,
    this.backgroundImage,
    this.useSignedInUserPhoto = true,
  }) : super();

  @override
  _SignedInUserCircleAvatarState createState() => _SignedInUserCircleAvatarState(backgroundImage, useSignedInUserPhoto);
}

class _SignedInUserCircleAvatarState extends State<SignedInUserCircleAvatar> {
  bool useSignedInUserPhoto = true;
  ImageProvider backgroundImage;
  _SignedInUserCircleAvatarState(this.backgroundImage, this.useSignedInUserPhoto) : super();

  @override
  Widget build(BuildContext context) {
    final SignInBloc signInBloc = Provider.of<SignInBloc>(context);

    return FutureBuilder<FirebaseUser>(
      future: signInBloc.currentUser,
      builder:
          (BuildContext context, AsyncSnapshot<FirebaseUser> signInSnapshot) {
        if (signInSnapshot.connectionState != ConnectionState.done) {
          return Loader();
        }
        try {
          backgroundImage = NetworkImage(signInSnapshot.data.photoUrl);
        } catch (err) {log("ERROR: $err");}
        double radiusBig = widget.radiusSmall + 2;

        return GestureDetector(
          onTap: () {
            Scaffold.of(context).openEndDrawer();
          },
          child: Container(
            padding: EdgeInsets.all(widget.letterPadding ? widget.radiusSmall / 3 : 0),
            child: CircleAvatar(
              backgroundColor: Styles.drg_colorSecondary,
              radius: radiusBig,
              child: useSignedInUserPhoto
                  ? CircleAvatar(
                      radius: widget.radiusSmall,
                      backgroundImage: backgroundImage,
                    )
                  : CircleAvatar(
                      radius: widget.radiusSmall,
                      backgroundColor: Styles.drg_colorContrast,
                    ),
            ),
          ),
        );
      },
    );
  }
}
