import 'dart:developer';

import 'package:dragger_survey/src/screens/team/widgets/widgets.dart';
import 'package:flutter/material.dart';

Future openColorChooser({@required context, @required teamDocSnapshot}) async {
  log("On Avatar tapped");
  await showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return ColorChooserWidget(teamDocSnapshot: teamDocSnapshot);
      });
}
