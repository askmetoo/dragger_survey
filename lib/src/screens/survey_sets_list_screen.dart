import 'package:dragger_survey/src/services/services.dart';
import 'package:dragger_survey/src/styles.dart';
import 'package:flutter/material.dart';
import 'package:dragger_survey/src/blocs/blocs.dart';
import 'package:provider/provider.dart';

class SurveySetsListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final PrismSurveySetBloc surveySetsBloc =
        Provider.of<PrismSurveySetBloc>(context);

    return Scaffold(
      backgroundColor: Styles.appBackground,
      appBar: AppBar(
        title: Text("Survey Sets"),
      ),
      body: _buildSetsListView(surveySetsBloc, context),
    );
  }

  Widget _buildSetsListView(PrismSurveySetBloc bloc, BuildContext context) {
    return FutureBuilder<List<PrismSurveySet>>(
      future: bloc.allPrismSurveySets,
      builder: (BuildContext context,
          AsyncSnapshot<List<PrismSurveySet>> surveySetSnapshot) {
        if (!(surveySetSnapshot.hasData)) {
          print(
              'surveySetSnapshot snapshot data is: ${surveySetSnapshot.data}');
          return Container(
            child: Center(
              child: Text("Survey Set has no data"),
            ),
          );
        }
        return ListView.builder(
          itemCount: surveySetSnapshot.data.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              title: Text("Name: ${surveySetSnapshot.data[index].name}"),
            );
          },
        );
      },
    );
  }
}

// ListView _OLD_buildSetsListView(
//     PrismSurveySetBloc surveySetsBloc, BuildContext context) {
//   return ListView(
//     children: <Widget>[
//       ListTile(
//         title: Text("surveySetsBloc: ${surveySetsBloc.allPrismSurveySets}"),
//       ),
//       ListTile(
//         title: Text(
//           "Item 1",
//           style: Styles.textListTitle,
//         ),
//         subtitle: Text(
//           "Bal bla bla",
//           style: Styles.textListContent,
//         ),
//         onTap: () {
//           Navigator.pushNamed(context, '/surveysetscaffold');
//         },
//       ),
//       ListTile(
//         title: Text(
//           "Item 2",
//           style: Styles.textListTitle,
//         ),
//         subtitle: Text(
//           "Bal bla bla",
//           style: Styles.textListContent,
//         ),
//         onTap: () {
//           Navigator.pushNamed(context, '/surveysetscaffold');
//         },
//       ),
//       ListTile(
//         title: Text(
//           "Item 3",
//           style: Styles.textListTitle,
//         ),
//         subtitle: Text(
//           "Bal bla bla",
//           style: Styles.textListContent,
//         ),
//         onTap: () {
//           Navigator.pushNamed(context, '/surveysetscaffold');
//         },
//       ),
//       ListTile(
//         title: Text(
//           "Item 4",
//           style: Styles.textListTitle,
//         ),
//         subtitle: Text(
//           "Bal bla bla",
//           style: Styles.textListContent,
//         ),
//         onTap: () {
//           Navigator.pushNamed(context, '/surveysetscaffold');
//         },
//       ),
//       ListTile(
//         title: Text(
//           "Item 5",
//           style: Styles.textListTitle,
//         ),
//         subtitle: Text(
//           "Bal bla bla",
//           style: Styles.textListContent,
//         ),
//         onTap: () {
//           Navigator.pushNamed(context, '/surveysetscaffold');
//         },
//       ),
//       ListTile(
//         title: Text(
//           "Item 6",
//           style: Styles.textListTitle,
//         ),
//         subtitle: Text(
//           "Bal bla bla",
//           style: Styles.textListContent,
//         ),
//         onTap: () {
//           Navigator.pushNamed(context, '/surveysetscaffold');
//         },
//       ),
//     ],
//   );
// }
