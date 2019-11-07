import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dragger_survey/src/styles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dragger_survey/src/blocs/blocs.dart';
import 'package:dragger_survey/src/widgets/dragger_board/select_granularity.dart';

class SurveySetForm extends StatefulWidget {
  @override
  _SurveySetFormState createState() => _SurveySetFormState();
}

class _SurveySetFormState extends State<SurveySetForm> {
  final _formKey = GlobalKey<FormState>();
  bool _formHasChanged = false;

  // required
  DateTime _created = DateTime.now().toUtc();
  String _name;
  int _resolution = 7;
  String _xName;
  String _yName;

  // Optional
  String _description = "";
  String _xDescription = "";
  String _yDescription = "";
  // ignore: unused_field
  dynamic _prismSurveys = [];

  // When edited
  // ignore: unused_field
  DateTime _edited;

  // Meta information
  String _createdByUser;
  String _createdByUserName;
  String _lastEditedByUser;
  String _lastEditedByUserName;
  DocumentSnapshot _createdByTeam;
  String _createdByTeamId;
  String _createdByTeamName;

  FocusNode firstFocus;
  FocusNode secondFocus;
  FocusNode thirdFocus;
  FocusNode fourthFocus;
  FocusNode fifthFocus;
  FocusNode sixthFocus;

  @override
  void initState() {
    super.initState();
    firstFocus = FocusNode();
    secondFocus = FocusNode();
    thirdFocus = FocusNode();
    fourthFocus = FocusNode();
    fifthFocus = FocusNode();
    sixthFocus = FocusNode();
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    firstFocus.dispose();
    secondFocus.dispose();
    thirdFocus.dispose();
    fourthFocus.dispose();
    fifthFocus.dispose();
    sixthFocus.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final TeamBloc teamBloc = Provider.of<TeamBloc>(context);
    FirebaseUser _user = Provider.of<FirebaseUser>(context);
    bool loggedIn = _user != null;
    _createdByTeam = teamBloc.currentSelectedTeam;
    _createdByTeamId = teamBloc.currentSelectedTeamId ??
        teamBloc?.currentSelectedTeam?.documentID;

    log("In SurveySetForm - value of teamBloc.currentSelectedTeam == null: ${teamBloc.currentSelectedTeam == null}");
    log("In SurveySetForm - value of teamBloc.currentSelectedTeamId: ${teamBloc.currentSelectedTeamId}");

    if (teamBloc?.currentSelectedTeam != null &&
        teamBloc?.currentSelectedTeam?.data['name'] != null) {
      _createdByTeamName = teamBloc?.currentSelectedTeam?.data['name'];
    }
    if (loggedIn) {
      _createdByUserName = _user.displayName;
    }

    return Form(
      key: _formKey,
      onChanged: () {
        if (_formKey.currentState.validate()) {
          setState(() {
            _formHasChanged = true;
          });
        }
      },
      child: _buildForm(context: context, formKey: _formKey),
    );
  }

  Widget _buildForm({@required context, @required formKey}) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SelectGranularity(),
          TextFormField(
            focusNode: firstFocus,
            onEditingComplete: () =>
                FocusScope.of(context).requestFocus(secondFocus),
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.text,
            style: Styles.drg_textFieldContent,

            decoration: InputDecoration(
              labelStyle: TextStyle(
                color: Styles.drg_colorPrimary,
                fontSize: Styles.drg_fontSizeFloatingLabel,
                fontWeight: FontWeight.w700,
              ),
              isDense: true,
              labelText: "Survey Name",
              hintStyle: TextStyle(fontSize: Styles.drg_fontSizeHintText),
              hintText: "A meaningful name",
            ),
            // initialValue: attribute,
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter a name';
              }
              return null;
            },
            onSaved: (value) => _name = value,
          ),
          TextFormField(
            minLines: 1,
            maxLines: 4,
            maxLength: 180,
            focusNode: secondFocus,
            onEditingComplete: () =>
                FocusScope.of(context).requestFocus(thirdFocus),
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              isDense: true,
              labelStyle: TextStyle(color: Styles.drg_colorPrimary),
              labelText: "Survey set description",
              hintText: "The description of the prism survey",
            ),
            // initialValue: attribute,
            onSaved: (value) => _description = value,
          ),
          TextFormField(
            focusNode: thirdFocus,
            onEditingComplete: () =>
                FocusScope.of(context).requestFocus(fourthFocus),
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              labelStyle: TextStyle(
                color: Styles.drg_colorPrimary,
                fontWeight: FontWeight.w700,
              ),
              isDense: true,
              labelText: "Label for x-axis",
              hintText: "Should be easy to understand",
            ),
            // initialValue: attribute,
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter a label';
              }
              return null;
            },
            onSaved: (value) => _xName = value,
          ),
          TextFormField(
            focusNode: fourthFocus,
            onEditingComplete: () =>
                FocusScope.of(context).requestFocus(fifthFocus),
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              labelStyle: TextStyle(color: Styles.drg_colorPrimary),
              isDense: true,
              labelText: "X-axis desciption",
              hintText: "What does the x-axis stand for",
            ),
            // initialValue: attribute,
            onSaved: (value) => _xDescription = value,
          ),
          TextFormField(
            focusNode: fifthFocus,
            onEditingComplete: () =>
                FocusScope.of(context).requestFocus(sixthFocus),
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              labelStyle: TextStyle(
                color: Styles.drg_colorPrimary,
                fontWeight: FontWeight.w700,
              ),
              isDense: true,
              labelText: "Label for y-axis",
              hintText: "Should be easy to understand",
            ),
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter a label';
              }
              return null;
            },
            onSaved: (value) => _yName = value,
          ),
          TextFormField(
            focusNode: sixthFocus,
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              labelStyle: TextStyle(color: Styles.drg_colorPrimary),
              isDense: true,
              labelText: "Y-axis desciption",
              hintText: "What does the y-axis stand for",
            ),
            onSaved: (value) => _yDescription = value,
          ),
          _buildFormButtons(
            context: context,
            formKey: formKey,
          ),
        ],
      ),
    );
  }

  Widget _buildFormButtons({@required context, @required formKey}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        children: <Widget>[
          _buildSubmitButton(formKey, context),
          _buildCancelButton(context)
        ],
      ),
    );
  }

  SizedBox _buildSubmitButton(
    formKey,
    prismSurveySetBloc,
  ) {
    return SizedBox(
      width: double.infinity,
      child: FlatButton(
        disabledColor: Colors.orange.shade50.withOpacity(0.4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        color: Colors.orange,
        textColor: Colors.white,
        onPressed: _formHasChanged
            ? () {
                log("1a) ----> In SurveySetForm - Submit button presssed");
                _submitButtonOnPressed(
                  formKey: formKey,
                );
                Navigator.of(context).pop();
              }
            : null,
        child: Text('Submit'),
      ),
    );
  }

  SizedBox _buildCancelButton(context) {
    return SizedBox(
      width: double.infinity,
      child: FlatButton(
        textColor: Styles.drg_colorPrimary,
        onPressed: () {
          print("Cancel button presssed");
          Navigator.of(context).pop();
        },
        child: Text('Cancel'),
      ),
    );
  }

  void _sendFormValuesToBloc() {
    log("1e-1) ----> In SurveySetForm _sendFormValuesToBloc()");
    final PrismSurveySetBloc prismSurveySetBloc =
        Provider.of<PrismSurveySetBloc>(context);
    final MatrixGranularityBloc granularityBloc =
        Provider.of<MatrixGranularityBloc>(context);

    Map<String, dynamic> surveySet = {
      "created": _created,
      "name": _name,
      "description": _description,
      "resolution": granularityBloc.matrixGranularity,
      "xName": _xName,
      "xDescription": _xDescription,
      "yName": _yName,
      "yDescription": _yDescription,
      "createdByUser": _createdByUser,
      "createdByUserName": _createdByUserName,
      "createdByUserName": _createdByUserName,
      "createdByTeam": _createdByTeamId,
      "createdByTeamName": _createdByTeamName,
      "lastEditedByUser": _lastEditedByUser,
      "lastEditedByUserName": _lastEditedByUserName,
    };
    print("===============================");
    print("Values sent to bloc:");
    print("_created: $_created");
    print("_name: $_name");
    print("_description: $_description");
    print("_resolution: $_resolution");
    print("_xName: $_xName");
    print("_xDescription: $_xDescription");
    print("_yName: $_yName");
    print("_yDescription: $_yDescription");
    print("_createdByUser: $_createdByUser");
    print("_createdByUserName: $_createdByUserName");
    print("_createdByTeam: $_createdByTeam");
    print("_createdByTeamName: $_createdByTeamName");
    print("_lastEditedByUser: $_lastEditedByUser");
    print("_lastEditedByUserName: $_lastEditedByUserName");
    print("================================");

    prismSurveySetBloc.addPrismSurveySetToDb(surveySet: surveySet);
    log("1e-2) ----> Form values have been sent to bloc");
  }

  void _submitButtonOnPressed({formKey}) {
    final SignInBloc signInBloc = Provider.of<SignInBloc>(context);
    final TeamBloc teamBloc = Provider.of<TeamBloc>(context);

    if (formKey.currentState.validate()) {
      log("1b) ----> In SurveySetForm _submitButtonOnPressed - has been validated.");

      log("1b-b ----> teamBloc.currentSelectedTeamId: ${teamBloc.currentSelectedTeamId}");

      signInBloc.currentUser.then((currentUserValue) {
        log("current team: ${teamBloc?.currentSelectedTeam?.documentID}");
        log("1c) ----> In SurveySetForm - signInBloc.currentUser future value: $currentUserValue");
        _createdByUser = currentUserValue.uid;
        log("1d) ----> In SurveySetForm - _createdByUser value: $_createdByUser");
        _sendFormValuesToBloc();
        log("1f) ----> In SurveySetForm - after _sendFormValuesToBloc()");

        log("1g) ----> In SurveySetForm Sending form values to bloc.");

        log("1h) ----> data sent:");
        print("_created: $_created");
        print("_name: $_name");
        print("_description: $_description");
        print("_resolution: $_resolution");
        print("_xName: $_xName");
        print("_yName: $_yName");
        print("_xDescription: $_xDescription");
        print("_xDescription: $_xDescription");
        print("_yDescription: $_yDescription");
        print("_createdByUser: $_createdByUser");
        print("_createdByUserName: $_createdByUserName");
        print("_createdByTeam: $_createdByTeam");
        print("_createdByTeamName: $_createdByTeamName");
      });

      formKey.currentState.save();
    }
  }
}
