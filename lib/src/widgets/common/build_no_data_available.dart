import 'package:flutter/material.dart';
import 'package:dragger_survey/src/styles.dart';

buildNoDataAvailable() {
  return Column(
    children: <Widget>[
      Spacer(
        flex: 8,
      ),
      Text(
        "There's         ",
        style: TextStyle(
          fontFamily: 'SonsieOne',
          fontSize: 26,
          letterSpacing: -2,
          color: Styles.color_Secondary,
          shadows: [
            Shadow(
              color: Styles.color_Text.withOpacity(.3),
              blurRadius: 8,
            ),
            Shadow(
                color: Styles.color_Text.withOpacity(.1),
                blurRadius: 3,
                offset: Offset(5, 6)),
          ],
        ),
      ),
      Text(
        "      no Data",
        style: TextStyle(
          fontFamily: 'SonsieOne',
          fontSize: 34,
          letterSpacing: -2,
          color: Styles.color_Text.withOpacity(0.7),
          shadows: [
            Shadow(
              color: Styles.color_Text.withOpacity(.2),
              blurRadius: 5,
            ),
            Shadow(
                color: Styles.color_Text.withOpacity(.2),
                blurRadius: 3,
                offset: Offset(2, 3)),
          ],
        ),
      ),
      Text(
        "available   ",
        style: TextStyle(
          fontFamily: 'SonsieOne',
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: Styles.color_Secondary,
          shadows: [
            Shadow(
              color: Styles.color_Text.withOpacity(.3),
              blurRadius: 8,
            ),
            Shadow(
                color: Styles.color_Text.withOpacity(.1),
                blurRadius: 3,
                offset: Offset(5, 6)),
          ],
        ),
      ),
      Spacer(
        flex: 1,
      ),
      Text(
        "Please, first start a survey.",
        style: TextStyle(
          fontFamily: 'Bitter',
          fontWeight: FontWeight.w700,
          color: Styles.color_Text.withOpacity(.7),
        ),
      ),
      Spacer(
        flex: 8,
      ),
      Spacer(
        flex: 8,
      ),
    ],
  );
}
