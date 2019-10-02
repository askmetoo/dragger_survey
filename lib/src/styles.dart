import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Styles {
  static const drg_fontSizeCopyText = 14.0;
  static const drg_fontSizeFieldContentText = 16.0;
  static const drg_fontSizeBigHeadline = 30.0;
  static const drg_fontSizeMediumHeadline = 19.0;
  static const drg_fontSizesubHeadline = 16.0;
  static const drg_fontSizeFloatingLabel = 14.0;
  static const drg_fontSizeHintText = 14.0;

  static const drg_textHeadline = TextStyle(
      color: Color.fromRGBO(0, 0, 0, 0.8),
      fontFamily: 'Bitter',
      fontSize: Styles.drg_fontSizeBigHeadline,
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w600);
  static const drg_textSecondHeadline = TextStyle(
    color: Color.fromRGBO(0, 0, 0, 0.8),
    fontFamily: 'Bitter',
    fontSize: Styles.drg_fontSizeMediumHeadline,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w400,
  );
  static const drg_textListTitle = TextStyle(
    color: Styles.drg_colorText,
    fontFamily: 'Bitter',
    fontSize: Styles.drg_fontSizeMediumHeadline,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w600,
  );
  static const drg_textListContent = TextStyle(
    color: Color.fromRGBO(0, 0, 0, 0.8),
    fontFamily: 'Barlow',
    fontSize: Styles.drg_fontSizeCopyText,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w400,
  );
  static const drg_selectButton = TextStyle(
    color: Styles.drg_colorPrimary,
    fontFamily: 'Barlow',
    fontSize: Styles.drg_fontSizeCopyText,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w400,
  );
  static const drg_textFieldContent = TextStyle(
    fontSize: Styles.drg_fontSizeFieldContentText,
    fontWeight: FontWeight.w400,
    color: Styles.drg_colorDarkerGreen,
  );

  static const Color drg_colorAttention = Color(0xffff0200);
  static const Color drg_colorContrast = Color(0xff119da4);
  static const Color drg_colorPrimary = Color(0xffc66400);
  static const Color drg_colorSecondary = Color(0xfff7b71d);
  static const Color drg_colorSecondaryDeepDark = Color(0xff583c00);
  static const Color drg_colorText = Color(0xff0e2431);
  static const Color drg_colorTextMediumDark = Color(0xff465761);
  static Color drgColorTextMediumLight = drg_colorText.withOpacity(0.8);

  static const Color drg_colorYellowGreen = Color(0xffffff7f);
  static const Color drg_colorLighterGreen = Color(0xffafa939);
  static const Color drg_colorGreen = Color(0xff2b580c);
  static const Color drg_colorDarkerGreen = Color(0xff2f4a36);

  static const Color orangeColorDonNotUse = Color(0xfff9b248);
  static const Color redColorDonNotUse = Color(0xfffc3a52);

  static const Color drg_colorAppBackground = drg_colorPrimary;
  static const Color drg_colorAppBackgroundMedium = Color(0xffff933b);
  static const Color drg_colorAppBackgroundLight = Color(0xffffc46a);
  static const Color drg_colorAppBackgroundShiny = Color(0xffffe8c1);

  static const Color drg_scaffoldBackground = Color(0xfff0f0f0);
}
