import 'dart:developer';

import 'package:dragger_survey/src/blocs/blocs.dart';
import 'package:dragger_survey/src/styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future openColorChooser({@required context, @required teamDocSnapshot}) async {
  log("On Avatar tapped");
  await showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        ColorsBloc colorsBloc = Provider.of<ColorsBloc>(context);
        return Container(
          padding: EdgeInsets.fromLTRB(16, 12, 16, 24),
          height: 200,
          child: RichText(
            text: TextSpan(
              text: "Choose your team color for ",
              style: TextStyle(
                fontFamily: 'bitter',
                fontSize: 18,
                color: Styles.color_Text,
              ),
              children: [
                TextSpan(
                  text: "${teamDocSnapshot['name']}",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        );
      });
}
