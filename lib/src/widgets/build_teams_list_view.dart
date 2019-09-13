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
        future: teamBloc
                    .getTeamsQueryByArray(
                  fieldName: 'users',
                  arrayValue: signInSnapshot?.data?.uid,
                ),
        builder:
            (BuildContext context, AsyncSnapshot<QuerySnapshot> teamsListSnapshot) {

            if (
              teamsListSnapshot.connectionState == ConnectionState.none ||
              teamsListSnapshot.connectionState == ConnectionState.waiting ||
              teamsListSnapshot.connectionState == ConnectionState.active
              ) log("In build_teams_list_view.dart - teamsListSnapshot: ${teamsListSnapshot.connectionState}");

            if (teamsListSnapshot.connectionState == ConnectionState.done) {

              if(!teamsListSnapshot.hasData) CircularProgressIndicator();
              if(!signInSnapshot.hasData) CircularProgressIndicator();
              
              return ListView(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  children: teamsListSnapshot.data.documents
                      .map((singleTeamSnapshot) {
                    return Dismissible(
                      key: ValueKey(singleTeamSnapshot.hashCode),
                      direction: DismissDirection.endToStart,
                      onDismissed: (direction) {
                        print(
                            '------>>> Item ${singleTeamSnapshot['name']}, ${singleTeamSnapshot['id']} is dismissed');
                        teamBloc.deleteTeamById(id: singleTeamSnapshot['id']);
                      },
                      child: ListTile(
                        trailing: IconButton(
                          key: Key(singleTeamSnapshot['id']),
                          icon: Icon(Icons.edit),
                          onPressed: () async {
                            teamBloc.currentSelectedTeamId = singleTeamSnapshot['id'] as Future<String>;
                            print("Edit button pressed in teams");
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text("Edit Team"),
                                  content: TeamForm(
                                    id: singleTeamSnapshot['id'],
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
                              "Before Navigator in ListTile of Teams - id: ${singleTeamSnapshot['id']}");
                          Navigator.pushNamed(context, '/surveysetslist',
                              arguments: "${singleTeamSnapshot['id']}");
                        },
                        title: Text(
                          "${singleTeamSnapshot['name']}",
                          style: Styles.drg_textListTitle,
                        ),
                        subtitle: Text(
                          """id: ${singleTeamSnapshot['id']} 
                          \nCreated: ${formatDate( singleTeamSnapshot['created'].toDate(),
                          [
                            dd,
                            '. ',
                            MM,
                            ' ',
                            yyyy,
                            ', ',
                            HH,
                            ':',
                            nn
                          ])} \nLast edited: ${singleTeamSnapshot['edited'] != null ? formatDate( singleTeamSnapshot['edited'].toDate(), [
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
          return Text("In build_teams_list_view.dart - teamsListSnapshot: ${teamsListSnapshot.connectionState}");
        },
      );
    }
  );
}
