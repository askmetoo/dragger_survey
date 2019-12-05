import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dragger_survey/src/blocs/blocs.dart';
import 'package:dragger_survey/src/styles.dart';
import 'package:dragger_survey/src/widgets/widgets.dart';
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
    final SurveySetBloc prismSurveySetBloc =
        Provider.of<SurveySetBloc>(context);
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
    final SurveyBloc prismSurveyBloc =
        Provider.of<SurveyBloc>(context);
    final SurveySetBloc prismSurveySetBloc =
        Provider.of<SurveySetBloc>(context);

    if (prismSurveySetBloc.currentPrismSurveySet == null) {
      log("In Dragger Screen prismSurveySetBloc.currentPrismSurveySet == null: ${prismSurveySetBloc.currentPrismSurveySet == null}");
    }

    return (MediaQuery.of(context).orientation == Orientation.portrait)
        ? BuildPortraitLayout(
            xName: _xName,
            yName: _yName,
            formKey: _formKey,
            surveySet: surveySet,
            matrixGranularityBloc: matrixGranularityBloc,
            prismSurveyBloc: prismSurveyBloc,
          )
        : BuildLandscapeLayout(
            xName: _xName,
            yName: _yName,
            formKey: _formKey,
            surveySet: surveySet,
            matrixGranularityBloc: matrixGranularityBloc,
            prismSurveyBloc: prismSurveyBloc,
          );
  }
}

class BuildPortraitLayout extends StatelessWidget {
  const BuildPortraitLayout({
    Key key,
    @required String xName,
    @required String yName,
    @required GlobalKey<FormState> formKey,
    @required this.surveySet,
    @required this.matrixGranularityBloc,
    @required this.prismSurveyBloc,
  })  : _xName = xName,
        _yName = yName,
        _formKey = formKey,
        super(key: key);

  final String _xName;
  final String _yName;
  final GlobalKey<FormState> _formKey;
  final DocumentSnapshot surveySet;
  final MatrixGranularityBloc matrixGranularityBloc;
  final SurveyBloc prismSurveyBloc;

  @override
  Widget build(BuildContext context) {
    final DraggableItemBloc draggableItemBloc =
        Provider.of<DraggableItemBloc>(context);

    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Padding(
        padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            BuildAskedPersonDropdown(),
            BuildBoard(
              xLabel: _xName,
              yLabel: _yName,
            ),
            DraggerBoardButtons(
              formKey: _formKey,
              currentSurveySet: surveySet?.documentID,
            ),
            if (draggableItemBloc.startedDragging)
              Text(
                "$_xName: ${prismSurveyBloc.rowIndex + 1}     |     $_yName: ${prismSurveyBloc.colIndex + 1}\nGranularity: ${matrixGranularityBloc.matrixGranularity}",
                style: TextStyle(
                    color: Styles.color_AppBackgroundMedium.withOpacity(.8),
                    height: 1.5),
                textAlign: TextAlign.center,
              ),
          ],
        ),
      ),
    );
  }
}

class BuildLandscapeLayout extends StatelessWidget {
  const BuildLandscapeLayout({
    Key key,
    @required String xName,
    @required String yName,
    @required GlobalKey<FormState> formKey,
    @required this.surveySet,
    @required this.matrixGranularityBloc,
    @required this.prismSurveyBloc,
  })  : _xName = xName,
        _yName = yName,
        _formKey = formKey,
        super(key: key);

  final String _xName;
  final String _yName;
  final GlobalKey<FormState> _formKey;
  final DocumentSnapshot surveySet;
  final MatrixGranularityBloc matrixGranularityBloc;
  final SurveyBloc prismSurveyBloc;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(
              flex: 6,
              child: BuildBoard(
                xLabel: _xName,
                yLabel: _yName,
              ),
            ),
            Expanded(
              flex: 4,
              child: Container(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    BuildAskedPersonDropdown(),
                    DraggerBoardButtons(
                      formKey: _formKey,
                      currentSurveySet: surveySet?.documentID,
                    ),
                    Text(
                      "Granularity: ${matrixGranularityBloc.matrixGranularity} \n$_xName: ${prismSurveyBloc.rowIndex + 1} \n$_yName: ${prismSurveyBloc.colIndex + 1}",
                      style: TextStyle(
                        color:
                            Styles.color_AppBackgroundMedium.withOpacity(.8),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BuildAskedPersonDropdown extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final SurveyBloc prismSurveyBloc =
        Provider.of<SurveyBloc>(context);

    return Padding(
      padding: EdgeInsets.only(left: 12.0),
      child: SizedBox(
        width: double.infinity,
        height: 40,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(right: 8.0),
                  child: Tooltip(
                    message: "Asked person or role",
                    child: IconShadowWidget(
                      Icon(
                        Icons.person,
                        color: Styles.color_Success,
                        size: 30,
                      ),
                      shadowColor: Styles.color_Text,
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
                  child: Text(
                    prismSurveyBloc?.currentAskedPerson,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: Styles.color_Secondary,
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
              color: Styles.color_Secondary.withOpacity(.6),
              iconSize: 20,
            ),
          ],
        ),
      ),
    );
  }

  _builduildAskedPersonDialog(
      {context, SurveyBloc prismSurveyBloc}) async {
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    TextEditingController _askedPersonController = TextEditingController();

    _askedPersonController.text =
        prismSurveyBloc.currentAskedPerson ?? 'Anonymous';

    await showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            backgroundColor: Styles.color_SecondaryDeepDark,
            title: Text(
              "Whom will you ask?",
              style: TextStyle(
                fontFamily: 'Bitter',
                color: Styles.color_Secondary,
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
                        onTap: () {
                          _askedPersonController.selection = TextSelection(
                              baseOffset: 0,
                              extentOffset: _askedPersonController.text.length);
                        },
                        controller: _askedPersonController,
                        onSubmitted: (value) {
                          _askedPersonController.text = value;
                        },
                        style: TextStyle(
                          color: Styles.color_Secondary,
                          fontWeight: FontWeight.w700
                        ),
                        decoration: InputDecoration(
                            isDense: true,
                            labelText: "Role or name",
                            labelStyle:
                                TextStyle(color: Styles.color_Secondary.withOpacity(.7))),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 12.0),
                      child: FlatButton(
                        child: Text("Speichern"),
                        color: Styles.color_Secondary,
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
    final SurveyBloc prismSurveyBloc =
        Provider.of<SurveyBloc>(context);

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
                    hintText: "Name or Role of asked person.",
                    labelStyle: TextStyle(color: Styles.color_AppBackground),
                    errorStyle: TextStyle(
                        fontSize: 14,
                        color: Colors.white60,
                        backgroundColor: Styles.color_Attention,
                        fontWeight: FontWeight.w700),
                    counterStyle: TextStyle(
                      color: Styles.color_Text,
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
        MatrixBoard(
          xLabel: xLabel,
          yLabel: yLabel,
        ),
      ],
    );
  }
}
