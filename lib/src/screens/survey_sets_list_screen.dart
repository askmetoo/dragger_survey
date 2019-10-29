import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dragger_survey/src/styles.dart';
import 'package:dragger_survey/src/widgets/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:dragger_survey/src/blocs/blocs.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

class SurveySetsListScreen extends StatefulWidget {
  final String teamId;
  SurveySetsListScreen({Key key, this.teamId}) : super(key: key);

  @override
  _SurveySetsListScreenState createState() => _SurveySetsListScreenState();
}

class _SurveySetsListScreenState extends State<SurveySetsListScreen> {
  Future<QuerySnapshot> queryTeamsForUser(
      {TeamBloc teamBloc, FirebaseUser user}) async {
    QuerySnapshot teamsQuery = await teamBloc
        .getTeamsQueryByArray(
          fieldName: 'users',
          arrayValue: user?.uid,
        )
        .catchError((err) => log(
            "ERROR in BuildTeamsDropdownButton getTeamsQueryByArray: $err"));
    return teamsQuery;
  }

  @override
  Widget build(BuildContext context) {
    final TeamBloc teamBloc = Provider.of<TeamBloc>(context);
    FirebaseUser user = Provider.of<FirebaseUser>(context);

    bool loggedIn = user != null;
    if (!loggedIn) {
      log("In SurveySetsListScreen - User is not signed in!");
    }

    return FutureBuilder<QuerySnapshot>(
        future: queryTeamsForUser(teamBloc: teamBloc, user: user),
        builder:
            (BuildContext context, AsyncSnapshot<QuerySnapshot> teamsSnapshot) {
          if (teamsSnapshot.connectionState != ConnectionState.done) {
            return Center(
              child: Container(
                constraints: BoxConstraints(maxWidth: 100),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: CircularProgressIndicator(),
                ),
              ),
            );
          } else if (!teamsSnapshot.hasData) {
            return Center(
              child: Container(
                constraints: BoxConstraints(maxWidth: 100),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: CircularProgressIndicator(),
                ),
              ),
            );
          }

          return Scaffold(
            backgroundColor: Styles.drg_colorAppBackground,
            endDrawer: UserDrawer(),
            appBar: AppBar(
              actions: <Widget>[
                SignedInUserCircleAvatar(),
              ],
              title: Text("Survey Sets"),
            ),
            body: Column(
              children: <Widget>[
                BuildTeamsDropdownButton(),
                BuildFilterSort(),
                Expanded(
                  child: BuildSurveySetsListView(),
                ),
              ],
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton:
                (teamBloc?.currentSelectedTeam?.documentID == null &&
                        teamsSnapshot.data.documents.length < 1)
                    ? teamsSnapshot.data.documents.isEmpty
                        ? FloatingActionButton.extended(
                            backgroundColor: Styles.drg_colorSecondary,
                            icon: Icon(
                              Icons.people,
                              color: Styles.drg_colorText.withOpacity(.8),
                            ),
                            label: Text(
                              'Create new Team',
                              style: TextStyle(
                                color: Styles.drg_colorText.withOpacity(0.8),
                              ),
                            ),
                            onPressed: () {
                              print(
                                  "In SurveySetsListScreen 'Create new Team' button pressed");
                              teamBloc.updatingTeamData = false;
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text("Create new Team"),
                                    content: CreateTeamForm(),
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
                          )
                        : null
                    : FloatingActionButton.extended(
                        elevation: 12,
                        backgroundColor: Styles.drg_colorSecondary,
                        label: Text(
                          "Create new survey set",
                          style: TextStyle(
                            color: Styles.drg_colorText.withOpacity(0.8),
                          ),
                        ),
                        icon: Icon(
                          Icons.library_add,
                          color: Styles.drg_colorDarkerGreen,
                        ),
                        tooltip: "Add new Survey Set",
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  elevation: 10,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      topRight: Radius.circular(3),
                                      bottomLeft: Radius.circular(20),
                                      bottomRight: Radius.circular(20),
                                    ),
                                  ),
                                  title: Text("New survey set"),
                                  backgroundColor: Styles.drg_colorSecondary,
                                  contentTextStyle:
                                      TextStyle(color: Styles.drg_colorText),
                                  content: SurveySetForm(),
                                );
                              });
                        },
                      ),
          );
        });
  }

  // Widget buildFilterSort({BuildContext context}) {
  //   // ignore: unused_local_variable
  //   String _selectedTeamId;
  //   bool _sortByDate = true;

  //   final TeamBloc teamBloc = Provider.of<TeamBloc>(context);
  //   FirebaseUser _user = Provider.of<FirebaseUser>(context);

  //   Future<QuerySnapshot> teamsQuery = teamBloc
  //       .getTeamsQueryByArray(
  //         fieldName: 'users',
  //         arrayValue: _user?.uid,
  //       )
  //       .catchError((err) => log(
  //           "ERROR in BuildTeamsDropdownButton getTeamsQueryByArray: $err"));

  //   if (teamsQuery == null) {
  //     return Text("No Team Snapshot");
  //   }

  //   return FutureBuilder<QuerySnapshot>(
  //       future: teamsQuery,
  //       builder: (BuildContext context,
  //           AsyncSnapshot<QuerySnapshot> teamsListSnapshot) {
  //         if (teamsListSnapshot.connectionState != ConnectionState.done ||
  //             !teamsListSnapshot.hasData) {
  //           return Center(
  //             child: Container(
  //               constraints: BoxConstraints(maxWidth: 100),
  //               child: AspectRatio(
  //                 aspectRatio: 1,
  //                 child: CircularProgressIndicator(),
  //               ),
  //             ),
  //           );
  //         } else if (teamsListSnapshot.data.documents.isEmpty) {
  //           return Container();
  //         }

  //         return SingleChildScrollView(
  //           scrollDirection: Axis.vertical,
  //           child: Padding(
  //             padding: const EdgeInsets.symmetric(horizontal: 16),
  //             child: Container(
  //               child: SizedBox(
  //                 height: 40,
  //                 child: Row(
  //                   crossAxisAlignment: CrossAxisAlignment.center,
  //                   children: <Widget>[
  //                     Text(
  //                       "## Survey Sets ",
  //                       style: TextStyle(fontSize: Styles.drg_fontSizeHintText),
  //                     ),
  //                     Spacer(
  //                       flex: 1,
  //                     ),
  //                     DropdownButton(
  //                       icon: Icon(
  //                         Icons.sort,
  //                         size: 18,
  //                       ),
  //                       // hint: Text(
  //                       //   _sortByDate ? 'By Date ' : 'By Name ',
  //                       //   style:
  //                       //       TextStyle(fontSize: Styles.drg_fontSizeHintText),
  //                       // ),
  //                       isDense: true,
  //                       isExpanded: false,
  //                       value: _sortByDate,
  //                       onChanged: (bool newValue) {
  //                         log("In SurveySetsListScreen newValue: $newValue");
  //                         bool _newSortByDateValue = newValue;
  //                         _sortByDate = newValue;
  //                         // setState(() {
  //                         //   _sortByDate = _newSortByDateValue;
  //                         // });
  //                       },
  //                       items: [
  //                         DropdownMenuItem(
  //                           value: true,
  //                           child: Text('By Date'),
  //                         ),
  //                         DropdownMenuItem(
  //                           value: false,
  //                           child: Text('By Name'),
  //                         ),
  //                       ],
  //                     ),
  //                     Spacer(
  //                       flex: 8,
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             ),
  //           ),
  //         );
  //       });
  // }
}

class BuildFilterSort extends StatefulWidget {
  @override
  _BuildFilterSortState createState() => _BuildFilterSortState();
}

class _BuildFilterSortState extends State<BuildFilterSort> {
  String _selectedTeamId;
  bool _sortByDate = true;

  @override
  Widget build(BuildContext context) {
    final TeamBloc teamBloc = Provider.of<TeamBloc>(context);
    FirebaseUser _user = Provider.of<FirebaseUser>(context);

    return FutureBuilder<QuerySnapshot>(
        future: teamBloc
            .getTeamsQueryByArray(
              fieldName: 'users',
              arrayValue: _user?.uid,
            )
            .catchError((err) => log(
                "ERROR in BuildTeamsDropdownButton getTeamsQueryByArray: $err")),
        builder: (BuildContext context,
            AsyncSnapshot<QuerySnapshot> teamsListSnapshot) {
          if (teamsListSnapshot.connectionState != ConnectionState.done) {
            return Center(
              child: Container(
                constraints: BoxConstraints(maxWidth: 100),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: CircularProgressIndicator(),
                ),
              ),
            );
          }
          if (!teamsListSnapshot.hasData) {
            return Text("No Team Snapshot");
          } else if (teamsListSnapshot.data.documents.isEmpty) {
            return Container();
          }
          //TODO: implement sorting logic.
          return SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                child: SizedBox(
                  height: 40,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "## Survey Sets ",
                        style: TextStyle(fontSize: Styles.drg_fontSizeHintText),
                      ),
                      Spacer(
                        flex: 1,
                      ),
                      DropdownButton(
                        icon: Icon(
                          Icons.sort,
                          size: 18,
                        ),
                        // hint: Text(
                        //   _sortByDate ? 'By Date ' : 'By Name ',
                        //   style:
                        //       TextStyle(fontSize: Styles.drg_fontSizeHintText),
                        // ),
                        isDense: true,
                        isExpanded: false,
                        value: _sortByDate,
                        onChanged: (bool newValue) {
                          log("In BuildFilterSort newValue: $newValue");
                          setState(() {
                            _sortByDate = newValue;
                          });
                        },
                        items: [
                          DropdownMenuItem(
                            value: true,
                            child: Text('By Date'),
                          ),
                          DropdownMenuItem(
                            value: false,
                            child: Text('By Name'),
                          ),
                        ],
                      ),
                      Spacer(
                        flex: 8,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}
