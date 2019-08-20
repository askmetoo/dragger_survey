import 'package:dragger_survey/src/blocs/blocs.dart';
import 'package:dragger_survey/src/styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SurveySetDetailsScreen extends StatelessWidget {
  final String id;
  SurveySetDetailsScreen({Key key, this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final PrismSurveySetBloc surveySetsBloc =
        Provider.of<PrismSurveySetBloc>(context);

    String _id = id;
    print("ooooooo---> _id: $_id");

    return FutureBuilder(
        future: surveySetsBloc.getPrismSurveySetById(id: _id),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return Text("ConnectionState.none");
              break;
            case ConnectionState.waiting:
              return Text("Survey is waiting");
              break;
            case ConnectionState.active:
              return Text("Survey is active");
              break;
            case ConnectionState.done:
              return Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "${snapshot.data['name']}",
                        style: TextStyle(
                            fontSize: Styles.drg_fontSizeMediumHeadline),
                      ),
                      Text(
                        "${snapshot.data['description']}",
                        style:
                            TextStyle(fontSize: Styles.drg_fontSizesubHeadline)
                      ),
                      Text(
                        "Granularity: ${snapshot.data['resolution']}",
                        style:
                            TextStyle(fontSize: Styles.drg_fontSizeCopyText),
                      ),
                    ],
                  ),
                ),
              );
              break;
          }
          return Text("Nothing here");
        });
  }
}
