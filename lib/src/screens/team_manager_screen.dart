import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dragger_survey/src/blocs/blocs.dart';
import 'package:dragger_survey/src/services/models.dart';
import 'package:dragger_survey/src/styles.dart';
import 'package:dragger_survey/src/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

class TeamManagerScreen extends StatefulWidget {
  final Map<String, dynamic> arguments;
  const TeamManagerScreen({Key key, this.arguments}) : super(key: key);

  @override
  _TeamManagerScreenState createState() =>
      _TeamManagerScreenState(args: arguments);
}

class _TeamManagerScreenState extends State<TeamManagerScreen> {
  Map<String, dynamic> args;

  _TeamManagerScreenState({this.args});

  @override
  Widget build(BuildContext context) {
    final TeamBloc teamBloc = Provider.of<TeamBloc>(context);
    final UserBloc userBloc = Provider.of<UserBloc>(context);

    return Scaffold(
      backgroundColor: Styles.drg_colorSecondary,
      appBar: AppBar(
        title: Text("Team Details"),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: teamBloc.getTeamById(id: args['id']),
        builder: (context, AsyncSnapshot<DocumentSnapshot> teamSnapshot) {
          if (teamSnapshot.connectionState == ConnectionState.done) {
            List userIds = teamSnapshot.data.data['users'];
            return Padding(
              padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // Text("Team Manager args: $args"),
                  TeamForm(
                    id: args['id'],
                  ),
                  Divider(
                    color: Styles.drg_colorAppBackground,
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 12.0),
                    child: Text("Team members:"),
                  ),
                  ListView(
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    children: userIds.map(
                      (memberId) {
                        log("ooo------------> memberId: $memberId");
                        return Container(
                          color: Styles.drg_colorAppBackground.withOpacity(.2),
                          margin: EdgeInsets.only(bottom: 1),
                          child: FutureBuilder<QuerySnapshot>(
                            future: userBloc.getUsersQuery(fieldName: 'providersUID', fieldValue: memberId),
                            // future: userBloc.getUserById(id: memberId),
                            builder: (context, userSnapshot) {

                              if ( userSnapshot.connectionState == ConnectionState.done) {
                                if ( !userSnapshot.hasData) {
                                  return CircularProgressIndicator();
                                }
                                print("oooooo ----------> $userSnapshot");
                                print("oooooo ----------> ${userSnapshot.hasData}");
                                print("oooooo ----------> ${userSnapshot?.data == null}");
                                print("oooooo ----------> ${userSnapshot?.data.toString()}");
                                print("oooooo ----------> ${userSnapshot?.data?.documents?.first['displayName']}");
                                String userName = userSnapshot?.data?.documents?.first['displayName'];

                                return Slidable(
                                  actionPane: SlidableBehindActionPane(),
                                  actionExtentRatio: 0.2,
                                  child: ListTile(
                                    leading: CircleAvatar(backgroundImage: CachedNetworkImageProvider(userSnapshot?.data?.documents?.first['photoUrl'])),
                                    dense: true,
                                    title: Text(userName),
                                    // title: Text("Member: " + memberId.toString()),
                                  ),
                                  secondaryActions: <Widget>[
                                    IconSlideAction(
                                      caption: 'Delete',
                                      icon: Icons.delete,
                                      color: Styles.drg_colorAttention,
                                      onTap: () {},
                                    )
                                  ],
                                );

                              }
                              return Container();
                            }
                          ),
                        );
                      }
                    ).toList()
                  )
                ],
              ),
            );
          }
          return Container();
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: Text("Add new member"),
        icon: Icon(Icons.person_add),
        onPressed: () {},
      ),
    );
  }
}
