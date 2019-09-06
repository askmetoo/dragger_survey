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
            fieldName: 'users', arrayValue: signInSnapshot.data.uid),
        builder:
            (BuildContext context, AsyncSnapshot<QuerySnapshot> teamsListSnapshot) {
          if (teamsListSnapshot.hasError) {
            return Center(
              child: Container(
                child: Text("Loading Set has error: ${teamsListSnapshot.error}"),
              ),
            );
          }

          switch (teamsListSnapshot.connectionState) {
            case ConnectionState.none:
              log("In build_teams_list_view.dart - ConnectionState is NONE!");
              break;
            case ConnectionState.waiting:
              log("In build_teams_list_view.dart - ConnectionState is WAITING!");
              return Center(
                child: CircularProgressIndicator(),
              );
            case ConnectionState.active:
              log("In build_teams_list_view.dart - ConnectionState is ACTIVE!");
              break;
            case ConnectionState.done:
            default:
              return ListView(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  children: teamsListSnapshot.data.documents
                      .map((DocumentSnapshot snapshot) {
                    return Dismissible(
                      key: ValueKey(snapshot.data.hashCode),
                      direction: DismissDirection.endToStart,
                      onDismissed: (direction) {
                        print(
                            '------>>> Item ${snapshot?.data['name']}, ${snapshot?.documentID} is dismissed');
                        teamBloc.deleteTeamById(id: snapshot.documentID);
                      },
                      child: ListTile(
                        trailing: IconButton(
                          key: Key(snapshot?.documentID),
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            teamBloc.currentTeamId = snapshot?.documentID;
                            print("Edit button pressed in teams");
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text("Edit Team"),
                                  content: TeamForm(
                                    id: snapshot?.documentID,
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
                          // teamBloc.currentTeamId = snapshot?.documentID;
                          print(
                              "Before Navigator in ListTile of Teams - id: ${snapshot?.documentID}");
                          Navigator.pushNamed(context, '/surveysetslist',
                              arguments: "${snapshot?.documentID}");
                        },
                        title: Text(
                          "${snapshot['name']}",
                          style: Styles.drg_textListTitle,
                        ),
                        subtitle: Text(
                          "id: ${snapshot.documentID} \nCreated: ${formatDate(snapshot['created'].toDate(), [
                            dd,
                            '. ',
                            MM,
                            ' ',
                            yyyy,
                            ', ',
                            HH,
                            ':',
                            nn
                          ])} \nLast edited: ${snapshot['edited'] != null ? formatDate(snapshot['edited'].toDate(), [
                              dd,
                              '. ',
                              MM,
                              ' ',
                              yyyy,
                              ', ',
                              HH,
                              ':',
                              nn
                            ]) : ''} \nby ${signInSnapshot.data.displayName}",
                          style: Styles.drg_textListContent,
                        ),
                      ),
                    );
                  }).toList());
          }
        },
      );
    }
  );
}
