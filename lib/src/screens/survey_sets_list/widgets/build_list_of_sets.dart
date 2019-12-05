import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:dragger_survey/src/blocs/blocs.dart';
import 'package:dragger_survey/src/shared/shared.dart';
import 'package:dragger_survey/src/styles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

class BuildListOfSets extends StatelessWidget {
  const BuildListOfSets({
    Key key,
    @required this.surveySetsBloc,
    @required this.surveySetSnapshot,
    @required this.user,
  }) : super(key: key);

  final FirebaseUser user;
  final SurveySetBloc surveySetsBloc;
  final AsyncSnapshot<QuerySnapshot> surveySetSnapshot;

  @override
  Widget build(BuildContext context) {
    final SurveyBloc surveyBloc = Provider.of<SurveyBloc>(context);
    final SurveySetBloc surveySetBloc =
        Provider.of<SurveySetBloc>(context);

    return ListView(
      scrollDirection: Axis.vertical,
      padding: EdgeInsets.only(bottom: 90),
      physics: BouncingScrollPhysics(),
      children: surveySetSnapshot.data.documents.map(
        (DocumentSnapshot surveySetDokumentSnapshot) {
          if (surveySetSnapshot.connectionState != ConnectionState.active) {
            return Loader();
          }

          if (!surveySetDokumentSnapshot.exists) {
            Text("surveySetDokumentSnapshot does not exist");
          }

          String _surveyId = surveySetDokumentSnapshot.documentID;
          ValueKey _valueKey = ValueKey(_surveyId);
          log("In BuildSurveySetsListView - FutureBuilder value of valueKey: $_valueKey");

          return FutureBuilder<QuerySnapshot>(
              key: ValueKey(_valueKey),
              future: surveyBloc.getPrismSurveyQuery(
                  fieldName: 'surveySet',
                  fieldValue: surveySetDokumentSnapshot.documentID),
              builder: (context, surveysSnapshot) {
                if (surveysSnapshot.connectionState != ConnectionState.done) {
                  return Center(
                    child: SizedBox(
                      height: .5,
                      child: Container(
                        width: double.infinity,
                        child: LinearProgressIndicator(
                          backgroundColor:
                              Styles.color_AppBackgroundMedium.withOpacity(.4),
                          valueColor: AlwaysStoppedAnimation<Color>(
                              Styles.color_AppBackgroundLight.withOpacity(.4)),
                        ),
                      ),
                    ),
                  );
                }

                String surveySetDisplayTime = DateTime.now().toString();
                DateTime now = DateTime.now();

                DateTime surveySetDateCreated =
                    surveySetDokumentSnapshot['created'].toDate();
                String suveySetDateCreatedString =
                    formatDate(surveySetDateCreated, [dd, '.', mm, '.', yyyy]);
                String differenceSurveySetTimeAgo = timeago.format(
                  DateTime.now().subtract(
                    DateTime.now().difference(
                      surveySetDateCreated,
                    ),
                  ),
                );
                int surveySetDiffenrenceInDays =
                    now.difference(surveySetDateCreated).inDays;

                surveySetDisplayTime = surveySetDiffenrenceInDays > 2
                    ? suveySetDateCreatedString
                    : differenceSurveySetTimeAgo;
                String surveyDisplayTime = DateTime.now().toString();
                DateTime surveyDateCreated = surveysSnapshot
                        .data.documents.isNotEmpty
                    ? surveysSnapshot.data.documents.last['created'].toDate()
                    : null;
                String suveyDateCreatedString = surveyDateCreated != null
                    ? formatDate(surveyDateCreated, [dd, '.', mm, '.', yyyy])
                    : '';
                String differenceSurveyTimeAgo = surveyDateCreated != null
                    ? timeago.format(
                        DateTime.now().subtract(
                          DateTime.now().difference(
                            surveyDateCreated,
                          ),
                        ),
                      )
                    : '';
                int surveyDiffenrenceInDays = surveyDateCreated == null
                    ? 0
                    : now.difference(surveyDateCreated).inDays;
                surveyDisplayTime = surveyDiffenrenceInDays > 2
                    ? suveyDateCreatedString
                    : differenceSurveyTimeAgo;

                return Slidable(
                  key: ValueKey(surveySetDokumentSnapshot.hashCode),
                  actionPane: SlidableBehindActionPane(),
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
                    //     log("In BuildSurveySesListView Slidable 'More..'");
                    //   },
                    // ),
                    IconSlideAction(
                      caption: 'Edit',
                      color: Styles.color_Success,
                      icon: Icons.edit,
                      onTap: () {
                        _buildSurveySetEditDialog(
                          context,
                          documentID: surveySetDokumentSnapshot.documentID,
                          surveySetBloc: surveySetBloc,
                          surveySetsSnapshot: surveySetDokumentSnapshot,
                          user: user,
                        );
                      },
                    ),
                    IconSlideAction(
                      caption: 'Delete',
                      color: Styles.color_Attention,
                      icon: Icons.delete,
                      onTap: () {
                        log("In BuildSurveySesListView ListView Dismissible Item name: ${surveySetDokumentSnapshot.data['name']}, id: ${surveySetDokumentSnapshot.documentID} is dismissed'");

                        surveySetsBloc.deleteAllSurveysFromSurveySetById(
                          surveySetId: surveySetDokumentSnapshot.documentID,
                        );
                        surveySetsBloc.deletePrismSurveySetById(
                            surveySetId: surveySetDokumentSnapshot.documentID);

                        Scaffold.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: Styles.color_Attention,
                            elevation: 20,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(40)),
                            content: Text(
                                "${surveySetDokumentSnapshot.data['name']} has been deleted."),
                          ),
                        );
                      },
                    ),
                  ],
                  // onDismissed: (direction) {
                  //   surveySetsBloc.deletePrismSurveySetById(
                  //       id: surveySetDokumentSnapshot.documentID);
                  // },
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
                          color: Styles.color_Secondary.withOpacity(.7),
                        ),
                        child: ListTile(
                          onTap: () {
                            surveySetsBloc.setCurrentPrismSurveySetById(
                                id: surveySetDokumentSnapshot.documentID);
                            Navigator.pushNamed(
                                context, '/surveysetscaffold', arguments: {
                              "id": "${surveySetDokumentSnapshot.documentID}"
                            });
                          },
                          title: Text(
                            "${surveySetDokumentSnapshot.data['name']} ",
                            style: TextStyle(
                              color: Styles.color_Text.withOpacity(0.8),
                              fontFamily: 'Bitter',
                              fontSize: Styles.fontSize_MediumHeadline,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          subtitle: Text(
                            surveysSnapshot.data.documents.length > 0
                                ? "Surveys: ${surveysSnapshot.data.documents.length}, Resolution: ${surveySetDokumentSnapshot.data['resolution']}, \nCreation: $surveySetDisplayTime, last Survey: $surveyDisplayTime"
                                : "Surveys: ${surveysSnapshot.data.documents.length}, Resolution: ${surveySetDokumentSnapshot.data['resolution']}, \nCreation: $surveySetDisplayTime, No Surveys, yet.",
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              });
        },
      ).toList(),
    );
  }

  void _buildSurveySetEditDialog(
    BuildContext context, {
    @required String documentID,
    @required SurveySetBloc surveySetBloc,
    @required DocumentSnapshot surveySetsSnapshot,
    @required FirebaseUser user,
  }) async {
    log("In BuildSurveySetListView - _buildSurveyEditDialog 'Edit': $documentID");

    final GlobalKey<FormBuilderState> _formSurveySetEditKey =
        GlobalKey<FormBuilderState>();

    FocusNode firstFocus;
    FocusNode secondFocus;
    FocusNode thirdFocus;
    FocusNode fourthFocus;

    if (surveySetsSnapshot.data == null) {
      log("In BuildSurveySetListView - no data in surveySetsSnapshot.data, value: ${surveySetsSnapshot.data}");
    }

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
              "Edit Survey Set Metadata",
              style: TextStyle(
                fontFamily: 'Bitter',
                color: Styles.color_Secondary,
              ),
            ),
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: FormBuilder(
                  autovalidate: true,
                  key: _formSurveySetEditKey,
                  initialValue: {
                    'name': surveySetsSnapshot.data['name'],
                    'xName': surveySetsSnapshot.data['xName'],
                    'yName': surveySetsSnapshot.data['yName'],
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      FormBuilderTextField(
                        autofocus: true,
                        focusNode: firstFocus,
                        onEditingComplete: () =>
                            FocusScope.of(context).requestFocus(secondFocus),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.text,
                        style: TextStyle(
                            color: Styles.color_Secondary,
                            fontWeight: FontWeight.w600),
                        attribute: "name",
                        decoration: InputDecoration(
                          labelText: "Team name",
                          labelStyle: TextStyle(
                              color: Styles.color_AppBackgroundMedium),
                        ),
                        validators: [
                          FormBuilderValidators.max(32),
                          FormBuilderValidators.min(3),
                        ],
                      ),
                      FormBuilderTextField(
                        autofocus: true,
                        focusNode: secondFocus,
                        onEditingComplete: () =>
                            FocusScope.of(context).requestFocus(thirdFocus),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.text,
                        style: TextStyle(
                            color: Styles.color_Secondary,
                            fontWeight: FontWeight.w600),
                        attribute: "xName",
                        decoration: InputDecoration(
                          labelText: "Label for x axis",
                          labelStyle: TextStyle(
                              color: Styles.color_AppBackgroundMedium),
                        ),
                        validators: [
                          FormBuilderValidators.max(32),
                          FormBuilderValidators.min(3),
                        ],
                      ),
                      FormBuilderTextField(
                        autofocus: true,
                        focusNode: thirdFocus,
                        onEditingComplete: () =>
                            FocusScope.of(context).requestFocus(fourthFocus),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.text,
                        style: TextStyle(
                            color: Styles.color_Secondary,
                            fontWeight: FontWeight.w600),
                        attribute: "yName",
                        decoration: InputDecoration(
                          labelText: "Label for y axis",
                          labelStyle: TextStyle(
                              color: Styles.color_AppBackgroundMedium),
                        ),
                        validators: [
                          FormBuilderValidators.max(32),
                          FormBuilderValidators.min(3),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 12.0),
                        child: FlatButton(
                          child: Text("Speichern"),
                          color: Styles.color_Secondary,
                          onPressed: () {
                            log("In _buildSurveySetEditDialog - onPressed 'Speichern'");
                            if (_formSurveySetEditKey.currentState
                                .saveAndValidate()) {
                              log("In _buildSurveySetEditDialog - after saveAndValidate()");
                              log("_formSurveySetEditKey.text: ${_formSurveySetEditKey.currentState.value['name']}");
                              surveySetBloc.updatePrismSurveySetById(
                                field: 'name',
                                id: documentID,
                                value: _formSurveySetEditKey
                                    .currentState.value['name'],
                              );
                              surveySetBloc.updatePrismSurveySetById(
                                field: 'xName',
                                id: documentID,
                                value: _formSurveySetEditKey
                                    .currentState.value['xName'],
                              );
                              surveySetBloc.updatePrismSurveySetById(
                                field: 'yName',
                                id: documentID,
                                value: _formSurveySetEditKey
                                    .currentState.value['yName'],
                              );
                              surveySetBloc.updatePrismSurveySetById(
                                field: 'lastEditedByUser',
                                id: documentID,
                                value: DateTime.now().toUtc(),
                              );
                              surveySetBloc.updatePrismSurveySetById(
                                field: 'lastEditedByUserName',
                                id: documentID,
                                value: user.displayName,
                              );
                            }
                            Navigator.pop(context);
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          );
        });
  }
}
