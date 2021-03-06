import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:dragger_survey/src/blocs/blocs.dart';
import 'package:dragger_survey/src/screens/team/widgets/widgets.dart';
import 'package:dragger_survey/src/shared/shared.dart';
import 'package:dragger_survey/src/styles.dart';
import 'package:dragger_survey/src/widgets/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:rounded_letter/rounded_letter.dart';
import 'package:rounded_letter/shape_type.dart';

Widget buildTeamsListView({BuildContext context}) {
  final TeamBloc teamBloc = Provider.of<TeamBloc>(context);
  final UserBloc userBloc = Provider.of<UserBloc>(context);
  final SignInBloc signInBloc = Provider.of<SignInBloc>(context);

  return FutureBuilder<FirebaseUser>(
    future: signInBloc.currentUser,
    builder: (context, signInSnapshot) {
      return StreamBuilder<QuerySnapshot>(
          stream: teamBloc.streamTeamsQueryByArray(
            fieldName: 'users',
            arrayValue: signInSnapshot?.data?.uid,
          ),
          builder: (BuildContext context,
              AsyncSnapshot<QuerySnapshot> teamsListSnapshot) {
            if (teamsListSnapshot.connectionState != ConnectionState.active ||
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
                  String _teamId = teamDocumentSnapshot.documentID;
                  String _teamOwner = teamDocumentSnapshot['createdByUser'];
                  String _currentUser = signInSnapshot?.data?.uid;
                  ValueKey _valueKey = ValueKey(_teamId);

                  log("In BuildTeamsListView - ListView value of valueKey: $_valueKey ");

                  if (teamDocumentSnapshot.data == null) {
                    return Container();
                  }
                  return Slidable(
                    key: _valueKey,
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
                      if (_teamOwner == _currentUser)
                        IconSlideAction(
                          caption: 'Delete',
                          color: Styles.color_Attention,
                          icon: Icons.delete,
                          onTap: () async {
                            bool teamDeleted = false;
                            bool deleteTeam = await buildAlertDialog(
                              context,
                              title:
                                  "Do you really want to quit your memberschip?",
                              confirmText: "Yes",
                              declinedText: "No",
                            );

                            if (deleteTeam && _teamOwner == _currentUser) {
                              teamDeleted = await teamBloc
                                  .deleteTeamByIdOnlyIfUserIsOwner(
                                id: teamDocumentSnapshot.documentID,
                                currentUserId: signInSnapshot.data.uid,
                              );
                            } else {
                              log("!!!!-----> In BuildTeamsListView - You are not meber of ${teamDocumentSnapshot.data['name']} and not alowed to delete this team!");
                            }

                            Scaffold.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: teamDeleted
                                    ? Styles.color_Success
                                    : Styles.color_Attention,
                                elevation: 20,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(40)),
                                content: teamDeleted
                                    ? Text(
                                        "${teamDocumentSnapshot.data['name']} has been deleted!")
                                    : Text(
                                        "You cannot delete the team, you aren't the owner!"),
                              ),
                            );
                          },
                        ),
                      if (_teamOwner != _currentUser)
                        IconSlideAction(
                          caption: 'Quit',
                          color: Styles.color_SecondaryDeepDark.withOpacity(.2),
                          icon: FontAwesomeIcons.walking,
                          onTap: () async {
                            List<dynamic> userList;
                            bool membershipQuitted = false;
                            bool quitMembership = await buildAlertDialog(
                                context,
                                title:
                                    "Do you really want to quit your memberschip?",
                                confirmText: "Yes",
                                declinedText: "No");
                            DocumentSnapshot team = teamDocumentSnapshot;
                            userList =
                                teamDocumentSnapshot.data['users'].toList();
                            userList.removeWhere(
                                (user) => user.toString() == _currentUser);
                            team.data['users'] = userList;

                            if (quitMembership) {
                              teamBloc.updateTeamByIdWithFieldAndValue(
                                id: teamDocumentSnapshot.documentID,
                                field: 'users',
                                value: userList,
                              );
                              membershipQuitted = true;
                            } else {
                              log("XXXXX-----> In BuildTeamsListView - DECLINED TO QUIT MEMBERSHIP of ${teamDocumentSnapshot.data['name']}.");
                            }

                            Scaffold.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: membershipQuitted
                                    ? Styles.color_Success
                                    : Styles.color_Attention,
                                elevation: 20,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(40)),
                                content: membershipQuitted
                                    ? Text(
                                        "Your membership in ${teamDocumentSnapshot.data['name']} has been removed!")
                                    : Text(
                                        "You cannot quit, because, you're not a member of team ${teamDocumentSnapshot.data['name']}"),
                              ),
                            );
                          },
                        )
                    ],
                    child: Container(
                      margin: EdgeInsets.only(left: 16, bottom: 1, top: 1),
                      color: Theme.of(context).dialogBackgroundColor.withOpacity(0),
                      // color: Styles.color_Secondary.withOpacity(0),
                      child: ClipRRect(
                        clipBehavior: Clip.antiAlias,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(65),
                          bottomLeft: Radius.circular(65),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).dialogBackgroundColor.withOpacity(.7),
                            // color: Styles.color_Secondary.withOpacity(.7),
                          ),
                          child: FutureBuilder<QuerySnapshot>(
                              future: userBloc.getUsersQuery(
                                fieldName: 'providersUID',
                                fieldValue: _teamOwner,
                              ),
                              builder: (context, userSnapshot) {
                                if (userSnapshot.connectionState !=
                                    ConnectionState.done) {
                                  return Loader();
                                }

                                return Tooltip(
                                  message: teamDocumentSnapshot['users']
                                              .length >
                                          1
                                      ? "The team '${teamDocumentSnapshot['name']}' has ${teamDocumentSnapshot['users'].length} members"
                                      : "The team '${teamDocumentSnapshot['name']}' has one member",
                                  child: ListTile(
                                    isThreeLine: false,
                                    dense: true,
                                    contentPadding: EdgeInsets.only(
                                        left: 10, right: 10, bottom: 2),
                                    trailing: IconButton(
                                      key: Key(_teamId),
                                      icon: Icon(Icons.edit),
                                      onPressed: () async {
                                        teamBloc.currentSelectedTeamId =
                                            _teamId;

                                        Navigator.pushNamed(
                                          context,
                                          '/teammanager',
                                          arguments: {"id": "$_teamId"},
                                        );
                                      },
                                    ),
                                    onTap: () {
                                      teamBloc.currentSelectedTeamId = _teamId;
                                      log("In BuildTeamsListView onTap - value of teamId: $_teamId");
                                      Navigator.of(context).pop();
                                    },
                                    leading: GestureDetector(
                                      onTapDown:
                                          (TapDownDetails tapDowndetails) {
                                        openColorChooser(
                                            context: context,
                                            teamDocSnapshot:
                                                teamDocumentSnapshot);
                                      },
                                      child: Padding(
                                        padding: EdgeInsets.only(right: 12.0),
                                        child: Tooltip(
                                          message:
                                              "Team owner: ${userSnapshot.data.documents[0]['displayName']}",
                                          child: AvatarWithBadge(
                                            avatar: RoundedLetter(
                                              text: buildInitials(
                                                  name: teamDocumentSnapshot[
                                                      'name']),
                                              fontColor: Styles.color_Secondary,
                                              shapeType: ShapeType.circle,
                                              shapeColor: Styles.color_Primary,
                                              borderColor:
                                                  Styles.color_Secondary,
                                              shapeSize: 44,
                                              fontSize: 22,
                                              borderWidth: 4,
                                            ),
                                            avatarSize: 56,
                                            badge: SignedInUserCircleAvatar(
                                              radiusSmall: 12,
                                              letterPadding: false,
                                              photoUrl: userSnapshot.data
                                                  .documents[0]['photoUrl'],
                                              // useSignedInUserPhoto: false,
                                            ),
                                            avatarBorderWidht: 2,
                                            badgeBorderWidht: 2,
                                          ),
                                        ),
                                        // child: RoundedLetter(
                                        //   text: buildInitials(
                                        //       name: teamDocumentSnapshot['name']),
                                        //   fontColor: Styles.drg_colorSecondary,
                                        //   shapeType: ShapeType.circle,
                                        //   shapeColor: Styles.drg_colorPrimary,
                                        //   borderColor: Styles.drg_colorSecondary,
                                        //   shapeSize: 44,
                                        //   fontSize: 22,
                                        //   borderWidth: 4,
                                        // ),
                                      ),
                                    ),
                                    title: RichText(
                                      text: TextSpan(
                                          text:
                                              "${teamDocumentSnapshot['name']} ",
                                          style: TextStyle(
                                            color: Styles.color_Text,
                                            fontFamily: 'Bitter',
                                            fontSize:
                                                Styles.fontSize_MediumHeadline,
                                            fontStyle: FontStyle.normal,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          children: [
                                            TextSpan(
                                                text:
                                                    "(${teamDocumentSnapshot['users'].length})",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 14)),
                                          ]),
                                    ),
                                    subtitle: Text(
                                      """Created: ${teamDocumentSnapshot['created'] != null ? formatDate(teamDocumentSnapshot['created'].toDate(), [dd, '. ', MM, ' ', yyyy]) : ''} \nEdited: ${teamDocumentSnapshot['edited'] != null ? formatDate(teamDocumentSnapshot['edited'].toDate(), [
                                          dd,
                                          '. ',
                                          MM,
                                          ' ',
                                          yyyy,
                                        ]) : 'Not yet.'} \nOwner: ${signInSnapshot.data.displayName}""",
                                      style: TextStyle(
                                        color: Color.fromRGBO(0, 0, 0, 0.8),
                                        fontFamily: 'Barlow',
                                        fontSize: Styles.fontSize_CopyText,
                                        fontStyle: FontStyle.normal,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                );
                              }),
                        ),
                      ),
                    ),
                  );
                }).toList());
          });
    },
  );
}
