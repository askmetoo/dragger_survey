import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Styles {
  static const drg_fontSizeCopyText = 16.0;
  static const drg_fontSizeFieldContentText = 16.0;
  static const drg_fontSizeBigHeadline = 32.0;
  static const drg_fontSizeMediumHeadline = 22.0;
  static const drg_fontSizesubHeadline = 20.0;
  static const drg_fontSizeFloatingLabel = 14.0;
  static const drg_fontSizeHintText = 14.0;

  static const drg_textHeadline = TextStyle(
      color: Color.fromRGBO(0, 0, 0, 0.8),
      fontFamily: 'NotoSans',
      fontSize: Styles.drg_fontSizeBigHeadline,
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w600);
  static const drg_textSecondHeadline = TextStyle(
    color: Color.fromRGBO(0, 0, 0, 0.8),
    fontFamily: 'NotoSans',
    fontSize: Styles.drg_fontSizeMediumHeadline,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w400,
  );
  static const drg_textListTitle = TextStyle(
    color: Color.fromRGBO(0, 0, 0, 0.8),
    fontFamily: 'NotoSans',
    fontSize: Styles.drg_fontSizeMediumHeadline,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w400,
  );
  static const drg_textListContent = TextStyle(
    color: Color.fromRGBO(0, 0, 0, 0.8),
    fontFamily: 'NotoSans',
    fontSize: Styles.drg_fontSizeCopyText,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w400,
  );
  static const drg_selectButton = TextStyle(
    color: Styles.drg_colorPrimary,
    fontFamily: 'NotoSans',
    fontSize: Styles.drg_fontSizeCopyText,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w400,
  );
  static const drg_textFieldContent = TextStyle(
    fontSize: Styles.drg_fontSizeFieldContentText,
    fontWeight: FontWeight.w400,
    color: Styles.drg_colorDarkerGreen,
  );
  static const drg_colorAttention = Color(0xffff0200);
  static const drg_colorPrimary = Color(0xff119da4);
  static const drg_colorSecondary = Color(0xfff7b71d);
  static const drg_colorText = Color(0xff0e2431);

  static const drg_colorYellowGreen = Color(0xffffff7f);
  static const drg_colorLighterGreen = Color(0xffafa939);
  static const drg_colorGreen = Color(0xff2b580c);
  static const drg_colorDarkerGreen = Color(0xff2f4a36);

  static const orangeColorDonNotUse = Color(0xfff9b248);
  static const redColorDonNotUse = Color(0xfffc3a52);

  static const drg_colorAppBackground = Color(0xffc66400);

  static const drg_scaffoldBackground = Color(0xfff0f0f0);
}
