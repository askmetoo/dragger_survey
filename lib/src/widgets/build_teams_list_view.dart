import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:dragger_survey/src/blocs/blocs.dart';
import 'package:dragger_survey/src/widgets/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../styles.dart';

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
            if (teamsListSnapshot.connectionState == ConnectionState.done) {
              if (!teamsListSnapshot.hasData) CircularProgressIndicator();
              if (!signInSnapshot.hasData) CircularProgressIndicator();

              log("In BuildTeamListView value of teamsListSnapshot: ${teamsListSnapshot.data.documents}");
              teamsListSnapshot.data.documents
                  .forEach((doc) => log("---> ${doc.documentID}"));

              return ListView(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  children: teamsListSnapshot.data.documents
                      .map((teamDocumentSnapshot) {
                    log("----> In BuildTeamListView ListView value of documentSnapshot.documentID: ${teamDocumentSnapshot.documentID}");
                    String teamId = teamDocumentSnapshot.documentID;
                    return Dismissible(
                      key: ValueKey(teamDocumentSnapshot.hashCode),
                      direction: DismissDirection.endToStart,
                      onDismissed: (direction) {
                        log("In BuildTeamListView ListView Dismissible Item ${teamDocumentSnapshot.data['name']}, ${teamDocumentSnapshot.data} is dismissed'");
                        // teamBloc.deleteTeamById(id: singleTeamSnapshot['id']);
                      },
                      child: ListTile(
                        isThreeLine: false,
                        dense: true,
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        trailing: IconButton(
                          key: Key(teamId),
                          icon: Icon(Icons.edit),
                          onPressed: () async {
                            teamBloc.currentSelectedTeamId =
                                Future.value(teamId);

                            print("Edit button pressed in teams");
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                log("In BuildTeamsListView showDialog value of documentSnapshot.documentID: $teamId");
                                return AlertDialog(
                                  title: Text("Edit Team"),
                                  content: TeamForm(
                                    id: teamId,
                                  ),
                                  elevation: 10,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      topRight: Radius.circular(3),
                                      bottomLeft: Radius.circular(20),
                                      bottomRight: Radius.circular(20),
                                    ),
                                  ),
                                  backgroundColor: Styles.drg_colorSecondary,
                                  contentTextStyle:
                                      TextStyle(color: Styles.drg_colorText),
                                );
                              },
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
                          """id: $teamId \nCreated: ${formatDate(teamDocumentSnapshot['created'].toDate(), [
                            dd,
                            '. ',
                            MM,
                            ' ',
                            yyyy,
                            ', ',
                            HH,
                            ':',
                            nn
                          ])} \nLast edited: ${teamDocumentSnapshot['edited'] != null ? formatDate(teamDocumentSnapshot['edited'].toDate(), [
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
                    );
                  }).toList());
            }
            return Text(
                "In build_teams_list_view.dart - teamsListSnapshot: ${teamsListSnapshot.connectionState}");
          },
        );
      });
}
