import 'dart:developer';
import 'dart:math' hide log;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dragger_survey/src/blocs/blocs.dart';
import 'package:dragger_survey/src/screens/screens.dart';
import 'package:dragger_survey/src/styles.dart';
import 'package:dragger_survey/src/widgets/widgets.dart' hide SimpleDialog;
import 'package:flutter/material.dart';
import 'package:icon_shadow/icon_shadow.dart';
import 'package:provider/provider.dart';

class DraggerScreen extends StatefulWidget {
  DraggerScreen({Key key}) : super(key: key);
  @override
  _DraggerScreenState createState() => _DraggerScreenState();
}

class _DraggerScreenState extends State<DraggerScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _xName = '';
  String _yName = '';
  DocumentSnapshot surveySet;

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    final PrismSurveySetBloc prismSurveySetBloc =
        Provider.of<PrismSurveySetBloc>(context);
    surveySet = await prismSurveySetBloc?.currentPrismSurveySet;
    try {
      setState(() {
        _xName = surveySet?.data['xName'];
        _yName = surveySet?.data['yName'];
      });
    } catch (e) {
      log("ERROR in DraggerScreen: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final MatrixGranularityBloc matrixGranularityBloc =
        Provider.of<MatrixGranularityBloc>(context);
    final PrismSurveyBloc prismSurveyBloc =
        Provider.of<PrismSurveyBloc>(context);
    final PrismSurveySetBloc prismSurveySetBloc =
        Provider.of<PrismSurveySetBloc>(context);
    final SignInBloc signInBloc = Provider.of<SignInBloc>(context);

    if (signInBloc.currentUser == null) {
      print("User is not signed in!");
      return SplashScreen();
    } else {}

    if (prismSurveySetBloc.currentPrismSurveySet == null) {
      log("In Dragger Screen prismSurveySetBloc.currentPrismSurveySet == null: ${prismSurveySetBloc.currentPrismSurveySet == null}");
    }
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Padding(
        padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 12.0),
              child: SizedBox(
                height: 40,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Tooltip(
                            message: "Asked person or role",
                            child: IconShadowWidget(
                              Icon(
                                Icons.person,
                                color: Styles.drg_colorLighterGreen,
                                size: 30,
                              ),
                              shadowColor: Styles.drg_colorText,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            _builduildAskedPersonDialog(
                              context: context,
                              prismSurveyBloc: prismSurveyBloc,
                            );
                          },
                          child: Container(
                            width: 250,
                            child: Text(
                              prismSurveyBloc?.currentAskedPerson,
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                                color: Styles.drg_colorSecondary,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        _builduildAskedPersonDialog(
                          context: context,
                          prismSurveyBloc: prismSurveyBloc,
                        );
                      },
                      color: Styles.drg_colorSecondary.withOpacity(.6),
                      iconSize: 20,
                    ),
                  ],
                ),
              ),
            ),
            // BuildAskedRoleForm(
            //   formKey: _formKey,
            // ),
            Padding(
              padding: const EdgeInsets.only(left: 30.0, right: 20),
              child: BuildBoard(
                xLabel: _xName,
                yLabel: _yName,
              ),
            ),
            Text(
                "Granularity: ${matrixGranularityBloc.matrixGranularity} \nStone is dragged to \n$_xName: ${prismSurveyBloc.rowIndex} \n$_yName: ${prismSurveyBloc.colIndex}"),
            DraggerBoardButtonRow(
              formKey: _formKey,
              currentSurveySet: surveySet?.documentID,
            ),
          ],
        ),
      ),
    );
  }

  _builduildAskedPersonDialog(
      {context, PrismSurveyBloc prismSurveyBloc}) async {
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    TextEditingController _askedPersonController = TextEditingController();
    _askedPersonController.text = 'Anonymous';

    await showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            backgroundColor: Styles.drg_colorSecondaryDeepDark,
            title: Text(
              "Whom will you ask?",
              style: TextStyle(
                fontFamily: 'Bitter',
                color: Styles.drg_colorSecondary,
              ),
            ),
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 26),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Form(
                      key: _formKey,
                      child: TextField(
                        onChanged: (value) {
                          _askedPersonController.text = value;
                        },
                        style: TextStyle(
                          color: Styles.drg_colorYellowGreen,
                        ),
                        decoration: InputDecoration(
                            isDense: true,
                            labelText: "Role or name",
                            labelStyle:
                                TextStyle(color: Styles.drg_colorLighterGreen)),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 12.0),
                      child: FlatButton(
                        child: Text("Speichern"),
                        color: Styles.drg_colorSecondary,
                        onPressed: () {
                          log("_askedPersonController.text: ${_askedPersonController.text}");
                          prismSurveyBloc.currentAskedPerson =
                              _askedPersonController.text;
                          Navigator.pop(context);
                        },
                      ),
                    )
                  ],
                ),
              ),
            ],
          );
        });
  }
}

class BuildAskedRoleForm extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  BuildAskedRoleForm({this.formKey});

  @override
  _BuildAskedRoleFormState createState() => _BuildAskedRoleFormState();
}

class _BuildAskedRoleFormState extends State<BuildAskedRoleForm> {
  TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.text = '';
  }

  @override
  Widget build(BuildContext context) {
    final PrismSurveyBloc prismSurveyBloc =
        Provider.of<PrismSurveyBloc>(context);

    return Form(
        key: widget.formKey,
        child: Padding(
          padding: EdgeInsets.only(left: 10, right: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(
                  "Name or role",
                  textAlign: TextAlign.left,
                ),
              ),
              TextFormField(
                onChanged: (val) {
                  setState(() {
                    _controller.text = val;
                  });
                  prismSurveyBloc.currentAskedPerson = _controller.text;
                },
                validator: (val) {
                  if (val.trim().length < 2) {
                    return '  At least 2 characters  ';
                  }
                  if (val.trim().length > 30) {
                    return '  Max 30 characters  ';
                  }
                  return null;
                },
                autovalidate: false,
                maxLines: 1,
                maxLength: 30,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    filled: true,
                    fillColor: Colors.white60,
                    // labelText: "Role or name",
                    hintText: "Name or Role of asked person.",
                    labelStyle: TextStyle(color: Styles.drg_colorAppBackground),
                    // focusColor: Colors.white,
                    errorStyle: TextStyle(
                        fontSize: 14,
                        color: Colors.white60,
                        backgroundColor: Styles.drg_colorAttention,
                        fontWeight: FontWeight.w700),
                    counterStyle: TextStyle(
                      color: Styles.drg_colorText,
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(
                        color: Colors.red,
                        width: 3,
                        style: BorderStyle.solid,
                      ),
                    )),
              ),
            ],
          ),
        ));
  }
}

class BuildBoard extends StatelessWidget {
  final String xLabel;
  final String yLabel;
  BuildBoard({this.xLabel, this.yLabel});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(left: 0.0),
          child: Transform.rotate(
            angle: -pi / 2,
                      child: MatrixBoard(
              xLabel: xLabel,
              yLabel: yLabel,
            ),
          ),
        ),
        // MatrixBoard(xLabel: xLabel, yLabel: yLabel,),
      ],
    );
  }
}
