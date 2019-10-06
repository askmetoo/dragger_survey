import 'dart:developer';

import 'package:dragger_survey/src/shared/utils.dart';
import 'package:dragger_survey/src/blocs/blocs.dart';
import 'package:dragger_survey/src/screens/screens.dart';
import 'package:dragger_survey/src/styles.dart';
import 'package:dragger_survey/src/widgets/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

class UserDrawer extends StatelessWidget {
  const UserDrawer({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final SignInBloc signInBloc = Provider.of<SignInBloc>(context);
    if (signInBloc.currentUser == null) {
      log("In user_drawer nol currentUser data");
      Navigator.pushReplacement(
          context,
          PageTransition(
            curve: Curves.easeIn,
            duration: Duration(milliseconds: 200),
            type: PageTransitionType.fade,
            child: SplashScreen(),
          ));
    }

    log("in UserDrawer - random string: ${Utils.createCryptoRandomString(4)}");

    return FutureBuilder<FirebaseUser>(
        future: signInBloc.currentUser,
        builder:
            (BuildContext context, AsyncSnapshot<FirebaseUser> signInSnapshot) {
          switch (signInSnapshot.connectionState) {
            case ConnectionState.none:
              log("In UserDrawer ConnectionState.none");
              break;
            case ConnectionState.waiting:
              log("In UserDrawer ConnectionState.waiting");
              break;
            case ConnectionState.active:
            case ConnectionState.done:
              return Drawer(
                child: ListView(
                  padding: EdgeInsets.all(0),
                  children: <Widget>[
                    DrawerHeader(
                      child: Container(
                        alignment: Alignment.topLeft,
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              flex: 2,
                              child: Column(
                                children: <Widget>[
                                  SignedInUserCircleAvatar(),
                                  Text(
                                    '${signInSnapshot.data.displayName}',
                                    textAlign: TextAlign.start,
                                  ),
                                  _buildSignoutButton(signInBloc),
                                ],
                              ),
                            ),
                            Expanded(
                              child: QrImage(
                                data: "${signInSnapshot.data.displayName}; ${Utils.createCryptoRandomString(2)}${signInSnapshot.data.uid}${Utils.createCryptoRandomString(2)}",
                              ),
                            ),
                          ],
                        ),
                      ),
                      decoration: BoxDecoration(
                        color: Styles.drg_colorSecondary,
                      ),
                    ),
                    ListTile(
                      title: Text('Manage Teams'),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, '/teams');
                      },
                    ),
                    ListTile(
                      title: Text('How-To'),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, '/howto');
                      },
                    ),
                    ListTile(
                      title: Text('Logout'),
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          PageTransition(
                            curve: Curves.easeIn,
                            duration: Duration(milliseconds: 200),
                            type: PageTransitionType.fade,
                            child: SplashScreen(),
                          ),
                        );
                        signInBloc.logoutUser();
                      },
                    ),
                  ],
                ),
              );
              break;
          }
          return Container();
        });
  }

  FlatButton _buildSignoutButton(SignInBloc signInBloc) {
    return FlatButton(
      splashColor: Styles.drg_colorSecondary,
      onPressed: () {
        signInBloc.logoutUser();
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Logout",
              style:
                  TextStyle(fontSize: 16, color: Styles.drg_colorDarkerGreen),
            )
          ],
        ),
      ),
    );
  }
}
