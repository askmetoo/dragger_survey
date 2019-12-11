import 'package:flutter/material.dart';
import 'package:dragger_survey/src/styles.dart';

import 'package:dragger_survey/src/screens/survey_sets_list/widgets/widgets.dart';

class CreateNewSurveySetFAB extends StatelessWidget {
  const CreateNewSurveySetFAB({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      elevation: 12,
      backgroundColor: Theme.of(context).dialogBackgroundColor,
      // backgroundColor: Styles.color_Secondary,
      label: Text(
        "Create new survey set",
        style: TextStyle(
          color: Theme.of(context).cursorColor.withOpacity(0.8),
          // color: Styles.color_Text.withOpacity(0.8),
        ),
      ),
      icon: Icon(
        Icons.library_add,
        color: Theme.of(context).cursorColor.withOpacity(0.8),
        // color: Styles.color_SecondaryDeepDark,
      ),
      tooltip: "Add new Survey Set",
      onPressed: () {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                titleTextStyle: TextStyle(
                  fontFamily: 'Bitter',
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Styles.color_Text.withOpacity(.8),
                ),
                titlePadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 12, horizontal: 4),
                elevation: 10,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(3),
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                title: Text("New survey set"),
                backgroundColor: Theme.of(context).dialogBackgroundColor,
                // backgroundColor: Styles.color_Secondary,
                contentTextStyle: TextStyle(color: Theme.of(context).cursorColor),
                // contentTextStyle: TextStyle(color: Styles.color_Text),
                content: SurveySetForm(),
              );
            });
      },
    );
  }
}
