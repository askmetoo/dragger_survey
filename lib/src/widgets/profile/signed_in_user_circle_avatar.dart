import 'package:dragger_survey/src/blocs/blocs.dart';
import 'package:dragger_survey/src/shared/shared.dart';
import 'package:dragger_survey/src/styles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignedInUserCircleAvatar extends StatefulWidget {
  final double radiusSmall;
  final bool letterPadding;
  final String photoUrl;
  final bool useSignedInUserPhoto;

  SignedInUserCircleAvatar({
    this.radiusSmall = 18,
    this.letterPadding = true,
    this.photoUrl = '',
    this.useSignedInUserPhoto = true,
  }) : super();

  @override
  _SignedInUserCircleAvatarState createState() =>
      _SignedInUserCircleAvatarState(useSignedInUserPhoto);
}

class _SignedInUserCircleAvatarState extends State<SignedInUserCircleAvatar> {
  bool useSignedInUserPhoto = true;
  _SignedInUserCircleAvatarState(this.useSignedInUserPhoto) : super();

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
        double radiusBig = widget.radiusSmall + 2;
        // print(
        //     "----> InSignedInUserCircleAvatar - value of backgroundImage: $photoUrl");

        return GestureDetector(
          onTap: () {
            Scaffold.of(context).openEndDrawer();
          },
          child: Container(
            padding: EdgeInsets.all(
                widget.letterPadding ? widget.radiusSmall / 3 : 0),
            child: CircleAvatar(
              backgroundColor: Styles.drg_colorSecondary,
              radius: radiusBig,
              child: useSignedInUserPhoto
                  ? CircleAvatar(
                      radius: widget.radiusSmall,
                      backgroundImage: widget.photoUrl != ''
                          ? NetworkImage(widget.photoUrl)
                          : NetworkImage(signInSnapshot.data.photoUrl),
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
