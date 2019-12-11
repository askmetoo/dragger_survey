import 'dart:developer';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';

// import 'package:simple_permissions/simple_permissions.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:dragger_survey/src/blocs/blocs.dart';
import 'package:dragger_survey/src/styles.dart';
import 'package:dragger_survey/src/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:charts_flutter/flutter.dart' as charts hide Color;

class SurveySetGraphsScreen extends StatefulWidget {
  final String surveySetId;
  SurveySetGraphsScreen({Key key, this.surveySetId}) : super(key: key);

  @override
  _SurveySetGraphsScreenState createState() => _SurveySetGraphsScreenState();
}

class _SurveySetGraphsScreenState extends State<SurveySetGraphsScreen> {
  DocumentSnapshot currentSurveySet;
  String _xLabel;
  String _yLabel;
  bool _allowWriteFile = true;

  Future get _localPath async {
    // Application documents directory: /data/user/0/{package_name}/{app_name}
    final applicationDirectory = await getApplicationDocumentsDirectory();

    // External storage directory: /storage/emulated/0
    // ignore: unused_local_variable
    final externalDirectory = await getExternalStorageDirectory();

    // Application temporary directory: /data/user/0/{package_name}/cache
    // ignore: unused_local_variable
    final tempDirectory = await getTemporaryDirectory();

    return applicationDirectory.path;
  }

  Future get _localFile async {
    final path = await _localPath;

    return File('$path/survey_xxx.csv');
  }

  Future _writeToFile({String surveyString}) async {
    if (!_allowWriteFile) {
      log("In SurveySetGraphScreen _writeToFile - value of _allowWriteFile: $_allowWriteFile");
      return null;
    }

    final file = await _localFile;

    // Write the file
    File result = await file.writeAsString('$surveyString');

    if (result == null) {
      print("Writing survey to file failed");
    } else {
      print("Successfully writing to file");

      print("Reading the content of file");
      String readResult = await _readFile();
      print("readResult: " + readResult.toString());
    }
  }

  Future _readFile() async {
    try {
      final file = await _localFile;

      // Read the file
      return await file.readAsString();
    } catch (e) {
      return null;
    }
  }

  @override
  void initState() {
    super.initState();
    // _requestWritePermission();
  }

  @override
  Widget build(BuildContext context) {
    final SurveySetBloc surveySetsBloc =
        Provider.of<SurveySetBloc>(context);
    final SurveyBloc surveyBloc = Provider.of<SurveyBloc>(context);

    int _granulariy = 0;
    final double dotRadius = 3;
    int _sum = 0;

    List<SurveyResult> data = [];

    return FutureBuilder<DocumentSnapshot>(
        future: surveySetsBloc.currentPrismSurveySet,
        builder: (context, surveySetSnapshot) {
          if (surveySetSnapshot.connectionState == ConnectionState.done) {
            if (!surveySetSnapshot.hasData) {
              print(
                  "In SurveySetGraphScreen - surveySetSnapshot has no data: ${surveySetSnapshot?.data} ");
              return Center(
                child: Container(
                  child: buildNoDataAvailable(),
                ),
              );
            }

            _xLabel = surveySetSnapshot?.data?.data['xName'];
            _yLabel = surveySetSnapshot?.data?.data['yName'];

            return FutureBuilder<QuerySnapshot>(
                future: surveyBloc.getPrismSurveyQuery(
                    fieldName: 'surveySet', fieldValue: widget.surveySetId),
                builder:
                    (context, AsyncSnapshot<QuerySnapshot> surveySnapshot) {
                  if (surveySnapshot.connectionState == ConnectionState.done) {
                    if (surveySnapshot.data.documents.isEmpty) {
                      print(
                          "In SurveySetGraphScreen - surveySnapshot has no data.");
                      return Center(
                        child: Container(
                          child: buildNoDataAvailable(),
                        ),
                      );
                    }

                    surveySnapshot.data.documents.forEach((doc) {
                      _sum += 1;
                      data.add(
                        SurveyResult(
                          xValue: doc.data['xValue'],
                          yValue: doc.data['yValue'],
                          radius: dotRadius,
                        ),
                      );
                    });
                    data.forEach((value) {
                      log("------> forEach value: ${value.xValue} / ${value.yValue}, radius: ${value.radius}");
                      var newData = data.where((testValue) {
                        if (testValue.xValue == value.xValue &&
                            testValue.yValue == value.yValue) {
                          testValue.radius += 3;
                          return true;
                        }
                        return false;
                      });
                      newData.forEach((newDoc) => log(
                          "------> forEach newDoc: ${newDoc.xValue} / ${newDoc.yValue}, radius: ${newDoc.radius}"));
                    });

                    return SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 20, 8, 0),
                        child: Column(
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.fromLTRB(14, 0, 0, 0),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  surveySetSnapshot?.data?.data['name'] ??
                                      "Survey title",
                                  style: TextStyle(
                                    fontFamily: 'Bitter',
                                    fontSize: Styles.fontSize_MediumHeadline,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                            AspectRatio(
                              aspectRatio: 1,
                              child: SurveyScatterPlotChart.withData(
                                  data, _xLabel, _yLabel, _granulariy),
                            ),
                            Text("Surveys in total: $_sum"),
                            Padding(
                              padding: const EdgeInsets.only(top: 16.0),
                              child: RaisedButton.icon(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(12),
                                  topRight: Radius.circular(4),
                                  bottomLeft: Radius.circular(12),
                                  bottomRight: Radius.circular(12),
                                )),
                                color: Styles.color_Secondary.withOpacity(.7),
                                elevation: .6,
                                icon: Icon(
                                  Icons.share,
                                  color: Styles.color_Complementary,
                                ),
                                label: Text(
                                  'Share as string in CSV format',
                                  style:
                                      TextStyle(color: Styles.color_Complementary),
                                ),
                                onPressed: () {
                                  List<List<dynamic>> list = [[]];
                                  list.add([
                                    surveySetSnapshot.data.data['xName'],
                                    surveySetSnapshot.data.data['yName']
                                  ]);
                                  surveySnapshot.data.documents.forEach((doc) {
                                    list.add([
                                      doc.data['xValue'],
                                      doc.data['yValue']
                                    ]);
                                  });
                                  var result = ListToCsvConverter()
                                      .convert(list,
                                          fieldDelimiter: ';',
                                          textDelimiter: ',',
                                          eol: '\n')
                                      .toString();
                                  print("-----\/\/\/");
                                  print(result);
                                  Share.share(result);
                                  _writeToFile(surveyString: result);
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  }
                  return SurveyScatterPlotChart.withData(
                      data, _xLabel, _yLabel, _granulariy);
                });
          }
          return Container();
        });
  }
}

class SurveyScatterPlotChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;
  final SurveyResult data;
  final String xLabel;
  final String yLabel;
  final int granularity;

  SurveyScatterPlotChart(this.seriesList,
      {this.data, this.animate, this.xLabel, this.yLabel, this.granularity});

  /// Creates a [ScatterPlotChart] with sample data and no transition.
  factory SurveyScatterPlotChart.withData(data, xLabel, yLabel, granularity) {
    return SurveyScatterPlotChart(
      _createData(data: data, granularity: granularity),
      // Disable animations for image tests.
      animate: true,
      xLabel: xLabel,
      yLabel: yLabel,
    );
  }

  @override
  Widget build(BuildContext context) {
    return charts.ScatterPlotChart(
      seriesList,
      animate: animate,
      domainAxis: charts.NumericAxisSpec(
        tickProviderSpec: charts.BasicNumericTickProviderSpec(
          desiredMinTickCount: granularity?.toInt() ?? 3,
        ),
      ),
      primaryMeasureAxis: charts.NumericAxisSpec(
        tickProviderSpec: charts.BasicNumericTickProviderSpec(
          desiredMinTickCount: granularity?.toInt() ?? 3,
        ),
      ),
      // TODO:
      defaultRenderer: charts.PointRendererConfig(customSymbolRenderers: {
        'circle': charts.CircleSymbolRenderer(isSolid: true),
      }),
      behaviors: [
        charts.ChartTitle('$xLabel',
            behaviorPosition: charts.BehaviorPosition.bottom,
            titleOutsideJustification:
                charts.OutsideJustification.middleDrawArea),
        charts.ChartTitle('$yLabel',
            behaviorPosition: charts.BehaviorPosition.start,
            titleOutsideJustification:
                charts.OutsideJustification.middleDrawArea),
      ],
    );
  }

  /// Create one series with sample hard coded data.
  static List<charts.Series<SurveyResult, int>> _createData(
      {data, granularity}) {
    return [
      charts.Series<SurveyResult, int>(
        id: 'Surveys',
        colorFn: (SurveyResult survey, _) {
          return charts.ColorUtil.fromDartColor(Styles.color_Complementary);
        },
        domainFn: (SurveyResult survey, _) => survey.xValue,
        domainLowerBoundFn: (SurveyResult survey, _) => 0,
        domainUpperBoundFn: (SurveyResult survey, _) => granularity,
        measureFn: (SurveyResult survey, _) => survey.yValue,
        measureLowerBoundFn: (SurveyResult survey, _) => 0,
        measureUpperBoundFn: (SurveyResult survey, _) => granularity,
        radiusPxFn: (SurveyResult survey, _) => survey.radius,
        data: data,
      )
    ];
  }
}

/// Linear data type.
class SurveyResult {
  final int xValue;
  final int yValue;
  double radius;

  SurveyResult({
    this.xValue,
    this.yValue,
    this.radius,
  });
}
