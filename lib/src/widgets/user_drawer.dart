import 'package:dragger_survey/src/blocs/blocs.dart';
import 'package:dragger_survey/src/screens/screens.dart';
import 'package:dragger_survey/src/styles.dart';
import 'package:dragger_survey/src/widgets/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class UserDrawer extends StatelessWidget {
  const UserDrawer({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final SignInBloc signInBloc = Provider.of<SignInBloc>(context);
    if (signInBloc.currentUser == null) {
      Navigator.pushReplacement(
          context,
          PageTransition(
            curve: Curves.easeIn,
            duration: Duration(milliseconds: 200),
            type: PageTransitionType.fade,
            child: SplashScreen(),
          ));
    }
    return FutureBuilder<FirebaseUser>(
        future: signInBloc.currentUser,
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return Text("No snapshot data");
          } else if (snapshot.data.displayName.isEmpty) {
            return Text("No logged-in user");
          } else if (signInBloc.currentUserUID.isEmpty) {
            return Text(
                "No currentUserUID: ${signInBloc.currentUserUID.isEmpty}");
          }
          return Drawer(
            child: ListView(
              padding: EdgeInsets.all(0),
              children: <Widget>[
                DrawerHeader(
                  child: Column(
                    children: <Widget>[
                      SigendInUserCircleAvatar(),
                      Text('${snapshot.data.displayName}'),
                      _buildSignoutButton(signInBloc),
                    ],
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
                    // Navigate to where?
                  },
                ),
                ListTile(
                  title: Text('Logout'),
                  onTap: () {
                    // Navigator.pop(context);

                    Navigator.pushReplacement(
                      context,
                      PageTransition(
                        curve: Curves.easeIn,
                        duration: Duration(milliseconds: 200),
                        type: PageTransitionType.fade,
                        child: SplashScreen(),
                      ),
                    );
                    signInBloc.signOut();
                  },
                ),
              ],
            ),
          );
        });
  }

  FlatButton _buildSignoutButton(SignInBloc signInBloc) {
    return FlatButton(
      splashColor: Styles.drg_colorSecondary,
      onPressed: () {
        signInBloc.signOut();
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Sign-Out",
              style:
                  TextStyle(fontSize: 16, color: Styles.drg_colorDarkerGreen),
            )
          ],
        ),
      ),
    );
  }
}
