import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:dragger_survey/src/blocs/blocs.dart';
import 'package:dragger_survey/src/shared/shared.dart';
import 'package:dragger_survey/src/widgets/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:rounded_letter/rounded_letter.dart';
import 'package:rounded_letter/shape_type.dart';

import '../../styles.dart';

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
                  String teamId = teamDocumentSnapshot.documentID;
                  String teamOwner = teamDocumentSnapshot['createdByUser'];
                  String currentUser = signInSnapshot?.data?.uid;

                  if (teamDocumentSnapshot.data == null) {
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
                      if (teamOwner == currentUser)
                        IconSlideAction(
                          caption: 'Delete',
                          color: Styles.drg_colorAttention,
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

                            if (deleteTeam && teamOwner == currentUser) {
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
                                    ? Styles.drg_colorSuccess
                                    : Styles.drg_colorAttention,
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
                      if (teamOwner != currentUser)
                        IconSlideAction(
                          caption: 'Quit',
                          color:
                              Styles.drg_colorSecondaryDeepDark.withOpacity(.2),
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
                                (user) => user.toString() == currentUser);
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
                                    ? Styles.drg_colorSuccess
                                    : Styles.drg_colorAttention,
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
                      color: Styles.drg_colorSecondary.withOpacity(0),
                      child: ClipRRect(
                        clipBehavior: Clip.antiAlias,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(65),
                          bottomLeft: Radius.circular(65),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Styles.drg_colorSecondary.withOpacity(.7),
                          ),
                          child: FutureBuilder<QuerySnapshot>(
                              future: userBloc.getUsersQuery(
                                fieldName: 'providersUID',
                                fieldValue: teamOwner,
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
                                      key: Key(teamId),
                                      icon: Icon(Icons.edit),
                                      onPressed: () async {
                                        teamBloc.currentSelectedTeamId = teamId;

                                        Navigator.pushNamed(
                                          context,
                                          '/teammanager',
                                          arguments: {"id": "$teamId"},
                                        );
                                      },
                                    ),
                                    onTap: () {
                                      teamBloc.setCurrentSelectedTeamId(teamId);
                                      Navigator.pushNamed(
                                        context,
                                        '/surveysetslist',
                                        arguments: "$teamId",
                                      );
                                    },
                                    leading: GestureDetector(
                                      onTapDown:
                                          (TapDownDetails tapDowndetails) {
                                        openColorChooser(context: context, teamDocSnapshot: teamDocumentSnapshot);
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
                                              fontColor:
                                                  Styles.drg_colorSecondary,
                                              shapeType: ShapeType.circle,
                                              shapeColor:
                                                  Styles.drg_colorPrimary,
                                              borderColor:
                                                  Styles.drg_colorSecondary,
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
                                          style: Styles.drg_textListTitle,
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
                                      style: Styles.drg_textListContent,
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

openColorChooser({@required context, @required teamDocSnapshot}) {
  log("On Avatar tapped");
  showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.fromLTRB(16, 12, 16, 24),
          height: 200,
          child: Text("Choose your color \nfor team ${teamDocSnapshot['name']}"),
        );
      });
}

Future<bool> buildAlertDialog(
  context, {
  @required String title,
  @required String confirmText,
  @required String declinedText,
}) async {
  return await showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("$title"),
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: Text("$declinedText"),
          ),
          FlatButton(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(4),
                    bottomRight: Radius.circular(12),
                    bottomLeft: Radius.circular(12))),
            color: Styles.drg_colorAttention,
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: Text("$confirmText"),
          ),
        ],
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
        contentTextStyle: TextStyle(color: Styles.drg_colorText),
      );
    },
  );
}

class AvatarWithBadge extends StatelessWidget {
  final Widget badge;
  final Widget avatar;
  final double badgeSize;
  final double badgeBorderWidht;
  final double avatarSize;
  final double avatarBorderWidht;

  AvatarWithBadge({
    this.badge,
    this.avatar,
    this.badgeSize = 30,
    this.badgeBorderWidht = 2,
    this.avatarSize = 52,
    this.avatarBorderWidht = 2,
  }) : super();

  @override
  Widget build(BuildContext context) {
    Widget defaultBadge = SizedBox(
      child: RoundedLetter(
        text: buildInitials(name: "John Doe"),
        fontColor: Styles.drg_colorPrimary,
        shapeType: ShapeType.circle,
        shapeColor: Styles.drg_colorSecondary,
        borderColor: Styles.drg_colorPrimary,
        shapeSize: badgeSize - (badgeBorderWidht * 2),
        fontSize: (badgeSize / 2) - badgeBorderWidht,
        borderWidth: badgeBorderWidht,
      ),
    );

    Widget defaultAvatar = SizedBox(
      child: RoundedLetter(
        text: buildInitials(name: "Dragger"),
        fontColor: Styles.drg_colorPrimary,
        shapeType: ShapeType.circle,
        shapeColor: Styles.drg_colorSecondary,
        borderColor: Styles.drg_colorPrimary,
        shapeSize: avatarSize - (avatarBorderWidht * 2),
        fontSize: (avatarSize / 2) - avatarBorderWidht,
        borderWidth: avatarBorderWidht,
      ),
    );

    return Container(
      child: SizedBox(
        width: avatarSize + (badgeSize / 4),
        height: avatarSize,
        child: Stack(
          children: <Widget>[
            Positioned(
              top: 0,
              left: 0,
              child: avatar != null ? avatar : defaultAvatar,
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: badge != null ? badge : defaultBadge,
            ),
          ],
        ),
      ),
    );
  }
}
