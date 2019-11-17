import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:dragger_survey/src/blocs/blocs.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

import '../../styles.dart';

Widget buildTeamsListView({BuildContext context}) {
  final TeamBloc teamBloc = Provider.of<TeamBloc>(context);
  final SignInBloc signInBloc = Provider.of<SignInBloc>(context);

  return FutureBuilder<FirebaseUser>(
    future: signInBloc.currentUser,
    builder: (context, signInSnapshot) {
      return FutureBuilder<QuerySnapshot>(
          future: teamBloc.getTeamsQueryByArray(
            fieldName: 'users',
            arrayValue: signInSnapshot?.data?.uid,
          ),
          builder: (BuildContext context,
              AsyncSnapshot<QuerySnapshot> teamsListSnapshot) {
            if (teamsListSnapshot.connectionState != ConnectionState.done ||
                !teamsListSnapshot.hasData) {
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

            return ListView(
                padding: EdgeInsets.only(top: 16, bottom: 90),
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                children: teamsListSnapshot.data.documents
                    .map((teamDocumentSnapshot) {
                  String teamId = teamDocumentSnapshot.documentID;

                  if(teamDocumentSnapshot.data == null) {
                    return Container();
                  }
                  return Slidable(
                    key: ValueKey(teamDocumentSnapshot.hashCode),
                    actionPane: SlidableDrawerActionPane(),
                    actionExtentRatio: .20,
                    // actions: <Widget>[
                    //   IconSlideAction(
                    //     caption: 'Archive',
                    //     color: Colors.blue,
                    //     icon: Icons.archive,
                    //     onTap: () {},
                    //   ),
                    // ],
                    secondaryActions: <Widget>[
                      // IconSlideAction(
                      //   caption: 'More',
                      //   color: Styles.drg_colorSecondaryDeepDark,
                      //   icon: Icons.more_horiz,
                      //   onTap: () {
                      //     log("In SurveySetDetailsScreen Slidable 'More..'");
                      //   },
                      // ),
                      IconSlideAction(
                        caption: 'Delete',
                        color: Styles.drg_colorAttention,
                        icon: Icons.delete,
                        onTap: () async {
                          bool teamDeleted = false;
                          log("In BuildTeamListView ListView Dismissible Item name: ${teamDocumentSnapshot.data['name']}, id: ${teamDocumentSnapshot.documentID} is dismissed'");
                          teamDeleted = await teamBloc.deleteTeamByIdOnlyIfUserIsOwner(
                            id: teamDocumentSnapshot.documentID,
                            currentUserId: signInSnapshot.data.uid,
                          );

                          Scaffold.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: teamDeleted ? Styles.drg_colorSuccess : Styles.drg_colorAttention,
                              elevation: 20,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(40)),
                              content: teamDeleted 
                                        ? Text("${teamDocumentSnapshot.data['name']} has been deleted!") 
                                        : Text("You cannot delete the team, you aren't the owner!"),
                            ),
                          );
                        },
                      ),
                    ],
                    child: Container(
                      margin: EdgeInsets.only(left: 14, bottom: 1, top: 1),
                      color: Styles.drg_colorSecondary.withOpacity(0),
                      child: ClipRRect(
                        clipBehavior: Clip.antiAlias,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(65),
                          bottomLeft: Radius.circular(65),
                        ),
                        child: Container(
                          padding: EdgeInsets.only(left: 24, bottom: 4),
                          decoration: BoxDecoration(
                            color: Styles.drg_colorSecondary.withOpacity(.7),
                          ),
                          child: ListTile(
                            isThreeLine: false,
                            dense: true,
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            trailing: IconButton(
                              key: Key(teamId),
                              icon: Icon(Icons.edit),
                              onPressed: () async {
                                teamBloc.currentSelectedTeamId = teamId;

                                print("Edit button pressed in teams, teamId: $teamId");

                                Navigator.pushNamed(
                                  context,
                                  '/teammanager',
                                  arguments: {"id": "$teamId"},
                                );
                              },
                            ),
                            onTap: () {
                              log("In BuildTeamListView ListTile onTap - teamId: $teamId");
                              Navigator.pushNamed(context, '/surveysetslist',
                                  arguments: "$teamId");
                            },
                            title: Text(
                              "${teamDocumentSnapshot['name']}",
                              style: Styles.drg_textListTitle,
                            ),
                            subtitle: Text(
                              """Created: ${teamDocumentSnapshot['created'] != null ? formatDate(teamDocumentSnapshot['created'].toDate(), [
                                dd,
                                '. ',
                                MM,
                                ' ',
                                yyyy,
                                ', ',
                                HH,
                                ':',
                                nn
                              ]) : ''} \nLast edited: ${teamDocumentSnapshot['edited'] != null ? formatDate(teamDocumentSnapshot['edited'].toDate(), [
                                  dd,
                                  '. ',
                                  MM,
                                  ' ',
                                  yyyy,
                                  ', ',
                                  HH,
                                  ':',
                                  nn
                                ]) : ''} \nby ${signInSnapshot.data.displayName}""",
                              style: Styles.drg_textListContent,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList());
          });
    },
  );
}
