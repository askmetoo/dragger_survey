import 'package:dragger_survey/src/blocs/blocs.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SigendInUserCircleAvatar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final SignInBloc signInBloc = Provider.of<SignInBloc>(context);
    return Builder(
      builder: (BuildContext context) {
        return GestureDetector(
          onTap: () {
            Scaffold.of(context).openDrawer();
          },
          child: Container(
            padding: EdgeInsets.all(8),
            child: CircleAvatar(
              backgroundImage: NetworkImage(
                  signInBloc.signedInUser.photoUrl.isNotEmpty
                      ? signInBloc.signedInUser.photoUrl
                      : null),
            ),
          ),
        );
      },
    );
  }
}
