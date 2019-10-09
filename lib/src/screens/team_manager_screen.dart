import 'dart:developer';
import 'package:flutter/services.dart';

import 'package:barcode_scan/barcode_scan.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dragger_survey/src/blocs/blocs.dart';
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

  String _scanedBarcode;

  initState() {
    super.initState();
  }

  Future scanBarcode({@required context}) async {
    try {
      String barcode = await BarcodeScanner.scan();
      setState(() => this._scanedBarcode = barcode);
      log("QRQRQRQRQRQR------> Scanned QR-Code/Barcode String: $_scanedBarcode");
      Scaffold.of(context).showSnackBar(SnackBar(content: Text("Code sucessfully scanned."), backgroundColor: Styles.drg_colorLighterGreen,));
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        Scaffold.of(context).showSnackBar(SnackBar(content: Text("You did not grant camera permission!"), backgroundColor: Styles.drg_colorAttention,));
        setState(() {
          this._scanedBarcode = null;
        });
      } else {
        Scaffold.of(context).showSnackBar(SnackBar(content: Text("An error occured: $e"), backgroundColor: Styles.drg_colorAttention,));
        setState(() => this._scanedBarcode = null);
      }
    } on FormatException {
      Scaffold.of(context).showSnackBar(SnackBar(content: Text("You aborted before the qr code could be scanned."), backgroundColor: Colors.black87,));
      setState(() => this._scanedBarcode = null);
    } catch (e) {
      Scaffold.of(context).showSnackBar(SnackBar(content: Text("Unknown error: $e."), backgroundColor: Styles.drg_colorAttention,));
      setState(() => this._scanedBarcode = null);
    }

    log("END OF BARCODE SCAN - Scanned QR-Code/Barcode String: $_scanedBarcode");
  }

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
            return SingleChildScrollView(
              child: Padding(
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
                        children: userIds.map((memberId) {
                          log("ooo------------> memberId: $memberId");
                          return Container(
                            color:
                                Styles.drg_colorAppBackground.withOpacity(.2),
                            margin: EdgeInsets.only(bottom: 1),
                            child: FutureBuilder<QuerySnapshot>(
                                future: userBloc.getUsersQuery(
                                    fieldName: 'providersUID',
                                    fieldValue: memberId),
                                // future: userBloc.getUserById(id: memberId),
                                builder: (context, userSnapshot) {
                                  if (userSnapshot.connectionState ==
                                      ConnectionState.done) {
                                    if (!userSnapshot.hasData) {
                                      return CircularProgressIndicator();
                                    }
                                    print("oooooo In TeamManager list of Team Members vvv");
                                    print("oooooo userSnapshot ----------> $userSnapshot");
                                    print(
                                        "oooooo hasData ----------> ${userSnapshot.hasData}");
                                    print(
                                        "oooooo data == null ----------> ${userSnapshot?.data == null}");
                                    print(
                                        "oooooo data.toString() ----------> ${userSnapshot?.data.toString()}");
                                    print(
                                        "oooooo first['displayName'] ----------> ${userSnapshot?.data?.documents?.first['displayName']}");
                                    String userName = userSnapshot
                                        ?.data?.documents?.first['displayName'];

                                    return Slidable(
                                      actionPane: SlidableBehindActionPane(),
                                      actionExtentRatio: 0.2,
                                      child: ListTile(
                                        leading: CircleAvatar(
                                            backgroundImage:
                                                CachedNetworkImageProvider(
                                                    userSnapshot
                                                        ?.data
                                                        ?.documents
                                                        ?.first['photoUrl'])),
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
                                }),
                          );
                        }).toList())
                  ],
                ),
              ),
            );
          }
          return Container();
        },
      ),
      floatingActionButton: FutureBuilder<DocumentSnapshot>(
        future: teamBloc.getTeamById(id: args['id']),
        builder: (context, teamSnapshotInFAB) {
          return FloatingActionButton.extended(
            label: Text("Add new member"),
            icon: Icon(Icons.person_add),
            onPressed: () async {
              await scanBarcode(context: context);
              if (_scanedBarcode == null) {
                Scaffold.of(context).showSnackBar(SnackBar(content: Text("No datat to save."), backgroundColor: Colors.black87,));
                return null;
              }
              try {
                teamBloc.updateTeamArrayFieldByIdWithFieldAndValue(id: teamSnapshotInFAB.data.documentID,field: 'users', value: _scanedBarcode);
              } catch (e) {
                log("ERROR in TeamManagerScreen FAB teamBloc.updateTeamArrayFieldByIdWithFieldAndValue(...), error: $e");
              }
            },
          );
        }
      ),
    );
  }
}
