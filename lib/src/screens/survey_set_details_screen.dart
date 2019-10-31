import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dragger_survey/src/blocs/blocs.dart';
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
    final PrismSurveySetBloc surveySetsBloc =
        Provider.of<PrismSurveySetBloc>(context);

    log("In SurveySetDetailsScreen - id: $surveySetId");

    return FutureBuilder<DocumentSnapshot>(
      future: surveySetsBloc.getPrismSurveySetById(id: surveySetId),
      builder: (BuildContext context,
          AsyncSnapshot<DocumentSnapshot> surveySetsSnapshot) {
        if (surveySetsSnapshot.connectionState == ConnectionState.done) {
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
                  buildMetaHeader(surveySetsSnapshot: surveySetsSnapshot),
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
        }
        return Text("Nothing here");
      },
    );
  }

  buildSurveyList({
    BuildContext context,
    AsyncSnapshot<DocumentSnapshot> surveySetsSnapshot,
  }) {
    final PrismSurveyBloc surveyBloc = Provider.of<PrismSurveyBloc>(context);
    final PrismSurveySetBloc surveySetBloc =
        Provider.of<PrismSurveySetBloc>(context);
    Future<QuerySnapshot> _surveyList;

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
        _surveyList = surveyBloc.getPrismSurveyQueryOrderCreatedDesc(
            fieldName: 'surveySet',
            fieldValue: surveySetsSnapshot.data.documentID);
      } catch (e) {
        log("ERROR in SurveySetDetailsScreen try surveysArray: $e");
      }

      return FutureBuilder<QuerySnapshot>(
          future: _surveyList,
          builder: (context, AsyncSnapshot<QuerySnapshot> surveySnapshot) {
            if (surveySnapshot.connectionState == ConnectionState.done) {
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
                  return Padding(
                    padding: const EdgeInsets.only(left: 14.0),
                    child: Slidable(
                      key: ValueKey(index),
                      actionPane: SlidableDrawerActionPane(),
                      actionExtentRatio: 0.25,
                      secondaryActions: <Widget>[
                        IconSlideAction(
                          caption: 'Delete',
                          color: Styles.drg_colorAttention,
                          icon: Icons.delete,
                          onTap: () {
                            log("In SurveySetDetailsScreen Slidable 'Delete': ${document.documentID}");
                            surveyBloc.deletePrismSurveyById(
                                id: document.documentID);
                            surveyBloc.currentAskedPerson = null;
                          },
                        ),
                        IconSlideAction(
                          caption: 'Edit',
                          color: Styles.drg_colorLighterGreen,
                          icon: Icons.edit,
                          onTap: () {
                            log("In SurveySetDetailsScreen Slidable 'Edit': ${document.documentID}");
                            _buildSurveyEditDialog(
                              context,
                              documentID: document.documentID,
                              surveyBloc: surveyBloc,
                              askedPerson: document.data['askedPerson'],
                            );
                          },
                        ),
                      ],
                      child: Container(
                        decoration: BoxDecoration(
                            color: Styles.drg_colorSecondary.withOpacity(.13),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(40),
                              bottomLeft: Radius.circular(40),
                            )),
                        margin: EdgeInsets.only(bottom: 2),
                        child: ListTile(
                          dense: true,
                          leading: Icon(Icons.person),
                          title: RichText(
                            text: TextSpan(
                              text: "${document.data['askedPerson']} ",
                              style: TextStyle(
                                color: Styles.drg_colorText,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                              children: [
                                TextSpan(
                                  text: "was asked ",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w200,
                                  ),
                                ),
                                TextSpan(
                                  text: timeago.format(DateTime.now().subtract(
                                      DateTime.now().difference(
                                          document.data['created'].toDate()))),
                                  style: TextStyle(
                                    fontWeight: FontWeight.w200,
                                  ),
                                )
                              ],
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

  buildMetaHeader({surveySetsSnapshot}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: <Widget>[
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "${surveySetsSnapshot?.data['name']}",
              style: TextStyle(
                  fontSize: Styles.drg_fontSizeMediumHeadline,
                  fontFamily: 'Bitter',
                  fontWeight: FontWeight.w700),
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Text("${surveySetsSnapshot.data['description']}",
                style: TextStyle(
                    fontSize: Styles.drg_fontSizesubHeadline,
                    fontWeight: FontWeight.w500)),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Granularity: ${surveySetsSnapshot.data['resolution']} \nCreated by User ID: ${surveySetsSnapshot.data['createdByUser']} \nUser displayName: TODO",
              style: TextStyle(fontSize: Styles.drg_fontSizeCopyText),
            ),
          ),
        ],
      ),
    );
  }

  void _buildSurveyEditDialog(
    context, {
    @required documentID,
    @required PrismSurveyBloc surveyBloc,
    @required String askedPerson,
  }) async {
    log("In SurveySetDetailsScreen _buildSurveyEditDialog 'Edit': $documentID");
    // final GlobalKey<FormState> _formSurveyEditKey = GlobalKey<FormState>();
    final GlobalKey<FormBuilderState> _formSurveyEditKey =
        GlobalKey<FormBuilderState>();
    // TextEditingController _surveyEditController = TextEditingController();

    await showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            backgroundColor: Styles.drg_colorSecondaryDeepDark,
            title: Text(
              "Edit Survey Metadata",
              style: TextStyle(
                fontFamily: 'Bitter',
                color: Styles.drg_colorSecondary,
              ),
            ),
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 26),
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
                          color: Styles.drg_colorSecondary,
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
                          color: Styles.drg_colorSecondary,
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
