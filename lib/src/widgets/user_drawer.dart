import 'package:dragger_survey/src/blocs/blocs.dart';
import 'package:dragger_survey/src/styles.dart';
import 'package:dragger_survey/src/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserDrawer extends StatelessWidget {
  const UserDrawer({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final SignInBloc signInBloc = Provider.of<SignInBloc>(context);
    if (signInBloc.signedInUser == null) {
      return Container();
    }
    return Drawer(
      child: ListView(
        padding: EdgeInsets.all(0),
        children: <Widget>[
          DrawerHeader(
            child: Column(
              children: <Widget>[
                SigendInUserCircleAvatar(),
                Text('${signInBloc.signedInUser.displayName}'),
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
              // WHAT TO DO?
              Navigator.pop(context);
              Navigator.pushNamed(context, '/teams');
              // Navigate to where?
            },
          ),
          ListTile(
            title: Text('Logout'),
            onTap: () {
              // WHAT TO DO?
              Navigator.pop(context);
              signInBloc.signOut();
              // Navigate to where?
            },
          ),
        ],
      ),
    );
  }

  FlatButton _buildSignoutButton(SignInBloc signInBloc) {
    return FlatButton(
                splashColor: Styles.drg_colorSecondary,
                onPressed: () {
                  signInBloc.signOut();
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40)),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Sign-Out",
                        style: TextStyle(
                            fontSize: 16, color: Styles.drg_colorDarkerGreen),
                      )
                    ],
                  ),
                ),
              );
  }
}
