import 'package:flutter/material.dart';

class DraggerBoardForm extends StatefulWidget {
  @override
  _DraggerBoardFormState createState() => _DraggerBoardFormState();
}

class _DraggerBoardFormState extends State<DraggerBoardForm> {
  final _formKey = GlobalKey<FormState>();

  String _askedPerson = '';
  double _xValue = 25.0;
  double _yValue = 95.0;
  bool _formHasChanged = false;
  Map<String, Object> surveyData;

  @override
  Widget build(BuildContext context) {
    return Container();
    // NEW: DAO import //
    // final prismSurveyDao = Provider.of<AppDatabase>(context).prismSurveyDao;

    // sendFormValuesToBloc() {
    //   prismSurveyBloc.setCreated(created: DateTime.now());
    //   prismSurveySetBloc.setName(name: _surveyName);
    //   prismSurveySetBloc.setXName(xName: _xName);
    //   prismSurveySetBloc.setYName(yName: _yName);

    //   if (prismSurveyBloc.formIsEmpty) {
    //     prismSurveyBloc.insertCurrentPrismSurveyToDb();
    //     print("prismSurveyBloc insertCurrentPrismSurveyToDb");
    //     prismSurveyBloc.getAllPrismSurveysFromDb().then((value) => print(
    //         "last value id: ${value.last.id} name: ${value.last.askedPerson}"));
    //   } else {
    //     print("prismSurveyBloc gather current survey");
    //     prismSurveyBloc.updatePrismSurvey(
    //       prismSurvey: prismSurveyBloc.gatherCurrentPrismSurvey(),
    //     );
    //   }
    // }
    // TODO //
    // sendFormvaluesToDb() {
    //   PrismSurvey surveyData = {
    //     "created"
    //         "askedPerson": _askedPerson,
    //     "xValue": _xValue,
    //     "yValue": _yValue,
    //   } as PrismSurvey;
    // TODO:
    // prismSurveyDao.insertPrismSurvey(surveyData);
  }

  buttonOnPressed({formKey}) {
    // Validate will return true if the form is valid, or false if
    // the form is invalid.
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      // TODO:
      // sendFormvaluesToDb();

      // Process data.
      print("_askedPerson: $_askedPerson");
      print("_xValue: $_xValue");
      print("_yValue: $_yValue");
    }
  }
  // TODO:
  // return Form(
  //   key: _formKey,
  //   onChanged: () {
  //     if (_formKey.currentState.validate()) {
  //       setState(() {
  //         _formHasChanged = true;
  //       });
  //     }
  //   },
  //   child: Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: <Widget>[
  //       TextFormField(
  //         textInputAction: TextInputAction.next,
  //         keyboardType: TextInputType.text,
  //         decoration: InputDecoration(
  //           labelText: "Survey name",
  //           hintText: "Please provide a meaningful name",
  //         ),
  //         // TODO //
  //         initialValue: "",
  //         // initialValue: prismSurveySetBloc.name ?? "",
  //         validator: (value) {
  //           if (value.isEmpty) {
  //             return 'Please enter some text';
  //           }
  //           return null;
  //         },
  //         onSaved: (value) {
  //           setState(() {
  //             _askedPerson = value;
  //           });
  //         },
  //       ),
  //       // TODO: the x value comes from the draggable item and drag target
  //       // TextFormField(
  //       //   textInputAction: TextInputAction.next,
  //       //   keyboardType: TextInputType.text,
  //       //   decoration: InputDecoration(
  //       //     labelText: "Horizontal label",
  //       //     hintText: "Please provide a x-axis label name",
  //       //   ),
  //       //   // TODO //
  //       //   initialValue: "",
  //       //   // initialValue: prismSurveySetBloc.xName ?? "",
  //       //   validator: (value) {
  //       //     if (value.isEmpty) {
  //       //       return 'Please enter some text';
  //       //     }
  //       //     return null;
  //       //   },
  //       //   // TODO //
  //       //   onSaved: (value) {
  //       //     setState(() {
  //       //       _xValue = value;
  //       //     });
  //       //   },
  //       // ),
  //       // TODO: the x value comes from the draggable item and drag target
  //       // TextFormField(
  //       //   textInputAction: TextInputAction.next,
  //       //   keyboardType: TextInputType.text,
  //       //   decoration: InputDecoration(
  //       //     labelText: "Vertical label",
  //       //     hintText: "Please provide a y-axis label name",
  //       //   ),
  //       //   // TODO //
  //       //   initialValue: "",
  //       //   // initialValue: prismSurveyDao..yName ?? "",
  //       //   validator: (value) {
  //       //     if (value.isEmpty) {
  //       //       return 'Please enter some text';
  //       //     }
  //       //     return null;
  //       //   },
  //       //   onSaved: (value) {
  //       //     setState(() {
  //       //       _yValue = value;
  //       //     });
  //       //   },
  //       // ),
  //       // TODO: Granularity will be set in the form of the surve set screen
  //       SelectGranularity(),
  //       Padding(
  //         padding: const EdgeInsets.symmetric(vertical: 8.0),
  //         child: SizedBox(
  //           width: double.infinity,
  //           child: RaisedButton(
  //             disabledColor: Colors.orange.shade50,
  //             shape: RoundedRectangleBorder(
  //                 borderRadius: BorderRadius.circular(20)),
  //             color: Colors.orange,
  //             textColor: Colors.white,
  //             onPressed: _formHasChanged
  //                 ? () {
  //                     buttonOnPressed(formKey: _formKey);
  //                     Navigator.pop(context);
  //                   }
  //                 : null,
  //             child: Text('Submit'),
  //           ),
  //         ),
  //       ),
  //       SizedBox(
  //         width: double.infinity,
  //         child: FlatButton(
  //           splashColor: Colors.blue,
  //           textColor: Colors.grey.shade700,
  //           child: Text("Abbrechen"),
  //           onPressed: () {
  //             Navigator.pop(context);
  //           },
  //         ),
  //       ),
  //     ],
  //   ),
  // );
  // }
}
