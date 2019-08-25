import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dragger_survey/src/blocs/user_bloc.dart';
import 'package:dragger_survey/src/screens/splash_screen.dart';
import 'package:dragger_survey/src/styles.dart';
import 'package:dragger_survey/src/widgets/teams_form.dart';
import 'package:flutter/material.dart';
import 'package:dragger_survey/src/blocs/blocs.dart';
import 'package:provider/provider.dart';
import 'package:date_format/date_format.dart';

class TeamsListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final TeamBloc teamsBloc = Provider.of<TeamBloc>(context);
    final SignInBloc signInBloc = Provider.of<SignInBloc>(context);
    final UserBloc userBloc = Provider.of<UserBloc>(context);

    String _signedInUserPhotoUrl;

    // _getCurrentUserProvidersUID () async {
    //   String _signedInUser = signInBloc.signedInUser.uid;
    //   print("USER UID (in teams list) after Google SignIn: $_signedInUser (in SignInBloc)");
    //   var _currentUserList = await userBloc.getUsersQuery(fieldName: 'providersUID', fieldValue: _signedInUser);
    //   String uid = _currentUserList.documents[0]['providersUID'];
    //   return uid.toString();
    // }
    // _getCurrentUserProvidersUID();

    // print(
    //     "Current User Provider's UID: ${signInBloc.signedInUserProvidersUID}");
    // dynamic _currentSignedInUserPhotoUrl = '';

    _getPhotoUrlofCurrentUser() async {
      try {
        _signedInUserPhotoUrl = signInBloc.signedInUser.photoUrl;
        print("SignedIn User's photo URL: $_signedInUserPhotoUrl");
        // await userBloc.getUserById(id: signInBloc.signedInUserProvidersUID)
        //     .then((value) {
        //       List _data;
        //       if(value.data != null) {
        //         _data = value.data.keys.toList();
        //         _data.forEach((_data) => print("Value of TRY: $_data"));
        //       }
        //       print("Value of TRY: is empty");
        // });
        // _currentSignedInUserPhotoUrl = await _currentSignedInUser.data[0];
        // print("_currentSignedInUserPhotoUrl : $_currentSignedInUserPhotoUrl");
      } catch (err) {
        print("ERROR in _getPhotoUrlofCurrentUser of TeamsList.dart: $err");
      }
    }

    _getPhotoUrlofCurrentUser();
    // print("_currentSignedInUserPhotoUrl: $_currentSignedInUserPhotoUrl");

    if (signInBloc.signedInUser == null) {
      print("User is not signed in!");
      return SplashScreen();
    }

    return Scaffold(
      backgroundColor: Styles.drg_colorAppBackground,
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.all(0),
          children: <Widget>[
            DrawerHeader(
              child: Text('Drawer Header'),
              decoration: BoxDecoration(
                color: Styles.drg_colorSecondary,
              ),
            ),
            ListTile(
              title: Text('Item 1'),
              onTap: () {
                // WHAT TO DO?
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        leading: Builder(
          builder: (BuildContext context) {
            return GestureDetector(
              onTap: () {
                Scaffold.of(context).openDrawer();
              },
              child: Container(
                padding: EdgeInsets.all(8),
                child: CircleAvatar(
                  backgroundImage: NetworkImage(_signedInUserPhotoUrl),
                ),
              ),
            );
          },
        ),

        // leading: IconButton(
        //   icon: CircleAvatar(
        //     backgroundImage: NetworkImage(_signedInUserPhotoUrl),
        //   ),
        //   onPressed: () {

        //   },
        // ),
        title: Text("Your Teams"),
      ),
      body: _buildSetsListView(
        teamBloc: teamsBloc,
        signInBloc: signInBloc,
        context: context,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Styles.drg_colorSecondary,
        child: Icon(
          Icons.library_add,
          color: Styles.drg_colorDarkerGreen,
        ),
        tooltip: "Create new Team",
        onPressed: () {
          print("Add new Team button pressed");
          teamsBloc.updatingTeamData = false;
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text("Create new Team"),
                  content: TeamForm(),
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
              });
        },
      ),
    );
  }

  Widget _buildSetsListView(
      {TeamBloc teamBloc, SignInBloc signInBloc, BuildContext context}) {
    return StreamBuilder<QuerySnapshot>(
      stream: teamBloc.streamTeams,
      builder: (BuildContext context,
          AsyncSnapshot<QuerySnapshot> teamsListSnapshot) {
        if (teamsListSnapshot.hasError) {
          return Center(
            child: Container(
              child: Text("Loading Set has error: ${teamsListSnapshot.error}"),
            ),
          );
        }

        switch (teamsListSnapshot.connectionState) {
          case ConnectionState.waiting:
            return Center(
              child: CircularProgressIndicator(),
            );
          case ConnectionState.active:
          case ConnectionState.done:
          default:
            return ListView(
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
                        teamBloc.currentTeamId = snapshot?.documentID;
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
                          ]) : ''} \nby ${signInBloc.signedInUser?.displayName}",
                        style: Styles.drg_textListContent,
                      ),
                    ),
                  );
                }).toList());
        }
      },
    );
  }
}
