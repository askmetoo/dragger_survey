import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:dragger_survey/src/blocs/blocs.dart';
import 'package:dragger_survey/src/shared/shared.dart';
import 'package:dragger_survey/src/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter_slidable/flutter_slidable.dart';

class SurveySetDetailsScreen extends StatelessWidget {
  final String surveySetId;
  SurveySetDetailsScreen({Key key, this.surveySetId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final SurveySetBloc surveySetsBloc =
        Provider.of<SurveySetBloc>(context);

    return FutureBuilder<DocumentSnapshot>(
        future: surveySetsBloc.getPrismSurveySetById(id: surveySetId),
        builder: (BuildContext context,
            AsyncSnapshot<DocumentSnapshot> surveySetsSnapshot) {
          if (surveySetsSnapshot.connectionState != ConnectionState.done) {
            return Loader();
          }
          if (surveySetsSnapshot.data.documentID == null) {
            log("In survey_set_details_screen - Snapshot has no data.");
            return Center(
              child: Container(
                child: Text("No Content"),
              ),
            );
          }
          return Padding(
            padding: EdgeInsets.only(top: 20.0),
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  buildMetaHeader(
                      context: context, surveySetsSnapshot: surveySetsSnapshot),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    child: Text("Surveys made:"),
                  ),
                  buildSurveyList(
                      context: context, surveySetsSnapshot: surveySetsSnapshot)
                ],
              ),
            ),
          );
        });
  }

  buildSurveyList({
    BuildContext context,
    AsyncSnapshot<DocumentSnapshot> surveySetsSnapshot,
  }) {
    final SurveyBloc surveyBloc = Provider.of<SurveyBloc>(context);
    final SurveySetBloc surveySetBloc =
        Provider.of<SurveySetBloc>(context);
    Stream<QuerySnapshot> _surveyList;

    if (surveySetsSnapshot.connectionState == ConnectionState.done) {
      if (!surveySetsSnapshot.hasData) {
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

      try {
        surveySetBloc.setCurrentPrismSurveySetId(
            id: surveySetsSnapshot?.data?.documentID);
        surveySetBloc.setCurrentPrismSurveySetById(
            id: surveySetsSnapshot?.data?.documentID);
        _surveyList = surveyBloc.streamPrismSurveyQueryOrderCreatedDesc(
            fieldName: 'surveySet',
            fieldValue: surveySetsSnapshot.data.documentID);
      } catch (e) {
        log("ERROR in SurveySetDetailsScreen try surveysArray: $e");
      }

      return StreamBuilder<QuerySnapshot>(
          stream: _surveyList,
          builder: (context, AsyncSnapshot<QuerySnapshot> surveySnapshot) {
            if (surveySnapshot.connectionState == ConnectionState.active) {
              if (surveySnapshot.data.documents == null) {
                return Text(">>> No Surveys yet! <<<");
              }
              return Expanded(
                  child: ListView.builder(
                itemCount: surveySnapshot.data.documents.length,
                scrollDirection: Axis.vertical,
                itemBuilder: (BuildContext context, int index) {
                  log("-----> In SurveySetDetailsScreen ListView index: $index");
                  DocumentSnapshot document =
                      surveySnapshot.data.documents[index];

                  String displayTime = DateTime.now().toString();
                  DateTime dateCreated = document.data['created'].toDate();
                  DateTime now = DateTime.now();
                  String dateCreatedString =
                      formatDate(dateCreated, [dd, '.', mm, '.', yyyy]);
                  String differenceTimeAgo = timeago.format(
                    DateTime.now().subtract(
                      DateTime.now().difference(
                        dateCreated,
                      ),
                    ),
                  );
                  int diffenrenceInDays = now.difference(dateCreated).inDays;
                  displayTime = diffenrenceInDays > 2
                      ? dateCreatedString
                      : differenceTimeAgo;

                  return Padding(
                    padding: const EdgeInsets.only(left: 14.0),
                    child: Slidable(
                      key: ValueKey(index),
                      actionPane: SlidableDrawerActionPane(),
                      actionExtentRatio: 0.25,
                      secondaryActions: <Widget>[
                        IconSlideAction(
                          caption: 'Edit',
                          color: Styles.color_Success,
                          icon: Icons.edit,
                          onTap: () {
                            _buildSurveyEditDialog(
                              context,
                              documentID: document.documentID,
                              surveyBloc: surveyBloc,
                              askedPerson: document.data['askedPerson'],
                            );
                          },
                        ),
                        IconSlideAction(
                          caption: 'Delete',
                          color: Styles.color_Attention,
                          icon: Icons.delete,
                          onTap: () {
                            surveyBloc.deletePrismSurveyById(
                                id: document.documentID);
                            surveyBloc.currentAskedPerson = null;
                          },
                        ),
                      ],
                      child: Container(
                        margin: EdgeInsets.only(left: 14, bottom: 1, top: 1),
                        color: Styles.color_Secondary.withOpacity(0),
                        child: ClipRRect(
                          clipBehavior: Clip.antiAlias,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(65),
                            bottomLeft: Radius.circular(65),
                          ),
                          child: Container(
                            padding: EdgeInsets.only(left: 16, bottom: 4),
                            decoration: BoxDecoration(
                              color: Styles.color_Secondary.withOpacity(.4),
                            ),
                            child: ListTile(
                              dense: true,
                              leading: Icon(
                                Icons.person,
                                color: Styles.color_Secondary,
                                size: 36,
                              ),
                              title: RichText(
                                text: TextSpan(
                                  text: ("${document.data['askedPerson']} ")
                                      .toUpperCase(),
                                  style: TextStyle(
                                    color: Styles.color_Text,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: .7,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: "was asked ",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    TextSpan(
                                      text: displayTime,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ));
            }
            return Container();
          });
    }
  }

  buildMetaHeader({context, surveySetsSnapshot}) {
    final UserBloc userBloc = Provider.of<UserBloc>(context);

    return FutureBuilder<QuerySnapshot>(
        future: userBloc.getUsersQuery(
            fieldName: 'providersUID',
            fieldValue: surveySetsSnapshot?.data['createdByUser']),
        builder: (context, userSnapshot) {
          if (userSnapshot.connectionState != ConnectionState.done) {
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
          if (!userSnapshot.hasData) {
            log("In SurveySetDetailsScreen - userSnapshot has no data");
            return Container();
          }
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: <Widget>[
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "${surveySetsSnapshot?.data['name']}",
                    style: TextStyle(
                        fontSize: Styles.fontSize_MediumHeadline,
                        fontFamily: 'Bitter',
                        fontWeight: FontWeight.w700),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text("${surveySetsSnapshot.data['description']}",
                      style: TextStyle(
                          fontSize: Styles.fontSize_SubHeadline,
                          fontWeight: FontWeight.w500)),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Granularity: ${surveySetsSnapshot.data['resolution']} \nThis set was created by ${userSnapshot?.data?.documents[0].data['displayName']}",
                    style: TextStyle(fontSize: Styles.fontSize_CopyText),
                  ),
                ),
              ],
            ),
          );
        });
  }

  void _buildSurveyEditDialog(
    context, {
    @required documentID,
    @required SurveyBloc surveyBloc,
    @required String askedPerson,
  }) async {
    log("In SurveySetDetailsScreen _buildSurveyEditDialog 'Edit': $documentID");
    final GlobalKey<FormBuilderState> _formSurveyEditKey =
        GlobalKey<FormBuilderState>();

    await showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(3),
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            backgroundColor: Styles.color_SecondaryDeepDark,
            title: Text(
              "Edit Survey Metadata",
              style: TextStyle(
                fontFamily: 'Bitter',
                color: Styles.color_Secondary,
              ),
            ),
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: FormBuilder(
                  key: _formSurveyEditKey,
                  initialValue: {'askedPerson': askedPerson ?? 'Anonymous'},
                  autovalidate: true,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      FormBuilderTextField(
                        autofocus: true,
                        style: TextStyle(
                          color: Styles.color_Secondary,
                        ),
                        attribute: "askedPerson",
                        decoration: InputDecoration(
                          labelText: "Asked Person",
                        ),
                        validators: [
                          FormBuilderValidators.max(45),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 12.0),
                        child: FlatButton(
                          child: Text("Speichern"),
                          color: Styles.color_Secondary,
                          onPressed: () {
                            if (_formSurveyEditKey.currentState
                                .saveAndValidate()) {
                              log("_askedPersonController.text: ${_formSurveyEditKey.currentState.value['askedPerson']}");
                              surveyBloc.currentAskedPerson = _formSurveyEditKey
                                  .currentState.value['askedPerson'];
                              surveyBloc.updatePrismSurveyById(
                                field: 'askedPerson',
                                id: documentID,
                                value: _formSurveyEditKey
                                    .currentState.value['askedPerson'],
                              );
                            }
                            Navigator.pop(context);
                          },
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          );
        });
  }
}
