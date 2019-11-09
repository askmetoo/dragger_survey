import 'package:dragger_survey/src/screens/intro_views/page_model.dart';
import 'package:dragger_survey/src/styles.dart';
import 'package:flutter/material.dart';
import 'package:intro_views_flutter/intro_views_flutter.dart';

class IntroViews extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Widget introViews = IntroViewsFlutter(
      [
        teamPage,
        invitePage,
        setPage,
        surveyPage,
        insightsPage,
      ],
      onTapDoneButton: () async {
        // Navigator.pushNamed(context, '/surveysetslist');
        await Navigator.pushNamedAndRemoveUntil(
          context,
          '/surveysetslist',
          (_) => false,
        ); //MaterialPageRoute
      },
      columnMainAxisAlignment: MainAxisAlignment.center,
      showNextButton: false,
      showBackButton: false,
      showSkipButton: true,
      doneText: Text(
        "Done",
        style: TextStyle(
          color: Styles.drg_colorText,
          fontSize: 12.0,
          fontFamily: "Barlow",
        ),
      ),
      pageButtonTextStyles: new TextStyle(
        color: Colors.white,
        fontSize: 12.0,
        fontFamily: "Barlow",
      ),
    );

    return introViews;
  }
}
