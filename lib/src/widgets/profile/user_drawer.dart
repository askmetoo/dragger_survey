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

class UserDrawer extends StatefulWidget {
  const UserDrawer({
    Key key,
  }) : super(key: key);

  @override
  _UserDrawerState createState() => _UserDrawerState();
}

class _UserDrawerState extends State<UserDrawer> {
  @override
  Widget build(BuildContext context) {
    final SignInBloc signInBloc = Provider.of<SignInBloc>(context);
    if (signInBloc.currentUser == null) {
      log("In user_drawer not currentUser data");
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
        if (signInSnapshot.connectionState != ConnectionState.done) {
          return Center(
            child: Container(
              constraints: BoxConstraints(maxWidth: 50),
              child: AspectRatio(
                aspectRatio: 1,
                child: CircularProgressIndicator(
                  strokeWidth: 10,
                ),
              ),
            ),
          );
        }
        return Drawer(
          child: ListView(
            padding: EdgeInsets.all(0),
            children: <Widget>[
              SizedBox(
                height: 160,
                child: DrawerHeader(
                  padding:
                      EdgeInsets.only(top: 8, left: 16, right: 10, bottom: 0),
                  child: Container(
                    alignment: Alignment.topLeft,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          flex: 5,
                          child: Column(
                            children: <Widget>[
                              SignedInUserCircleAvatar(),
                              Text(
                                '${signInSnapshot.data.displayName}',
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                        Spacer(
                          flex: 1,
                        ),
                        Expanded(
                          flex: 3,
                          child: QrImage(
                            data:
                                "${signInSnapshot.data.displayName}; ${Utils.createCryptoRandomString(2)}${signInSnapshot.data.uid}${Utils.createCryptoRandomString(2)}",
                          ),
                        ),
                      ],
                    ),
                  ),
                  decoration: BoxDecoration(
                    color: Styles.drg_colorPrimary.withAlpha(100),
                  ),
                ),
              ),
              ListTile(
                leading: Icon(Icons.people),
                title: Text('Manage Teams'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/teams');
                },
              ),
              ListTile(
                leading: Icon(Icons.description),
                title: Text('How-To'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/howto');
                },
              ),
              ListTile(
                leading: Icon(Icons.cancel),
                title: Text('Sign-Out'),
                onTap: () {
                  Navigator.pop(context, true);
                  Navigator.pushNamed(context, '/login');
                  signInBloc.logoutUser();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
