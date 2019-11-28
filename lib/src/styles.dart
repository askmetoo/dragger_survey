import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Styles {
  static const fontSize_CopyText = 14.0;
  static const fontSize_FieldContentText = 16.0;
  static const fontSize_BigHeadline = 30.0;
  static const fontSize_MediumHeadline = 19.0;
  static const fontSize_SubHeadline = 16.0;
  static const fontSize_FloatingLabel = 14.0;
  static const fontSize_HintText = 14.0;

  ///***
  ///* COLORS section
  ///*/
  static const Color _clrPrimary = Color(0xffc66400);
  static const Color _clrSecondary = Color(0xfff7b71d);
  static const Color _clrContrast = Color(0xff119da4);
  static const Color _clrAttention = Color(0xffff0200);
  static const Color _clrSuccess = Color(0xffafa939);
  static const Color _clrSecondaryDeepDark = Color(0xff583c00);
  static const Color _clrText = Color(0xff0e2431);
  static const Color _clrAppBackgroundMedium = Color(0xffff933b);
  static const Color _clrAppBackgroundLight = Color(0xffffc46a);
  static const Color _clrAppBackgroundShiny = Color(0xffffe8c1);
  static const Color _clrWhite = Color(0xffffffff);
  static const Color _clrBlack = Color(0xff000000);

  // ignore: non_constant_identifier_names
  static Color color_Primary = _clrPrimary;
  set colorPrimary(newColor) {
    color_Primary = newColor;
  }
  // ignore: non_constant_identifier_names
  static Color color_Text = _clrText;
  set colorText(newColor) {
    color_Primary = newColor;
  }
  // ignore: non_constant_identifier_names
  static Color color_Secondary = _clrSecondary;
  set colorSecondary(newColor) {
    color_Secondary = newColor;
  }
  // ignore: non_constant_identifier_names
  static Color color_Contrast = _clrContrast;
  set colorContrast(newColor) {
    color_Secondary = newColor;
  }
  // ignore: non_constant_identifier_names
  static Color color_Attention = _clrAttention;
  set colorAttentionContrast(newColor) {
    color_Secondary = newColor;
  }
  // ignore: non_constant_identifier_names
  static Color color_Success = _clrSuccess;
  set colorSuccess(newColor) {
    color_Secondary = newColor;
  }
  // ignore: non_constant_identifier_names
  static Color color_SecondaryDeepDark = _clrSecondaryDeepDark;
  set colorSecondaryDeepDark(newColor) {
    color_Secondary = newColor;
  }
  // ignore: non_constant_identifier_names
  static Color color_AppBackground = color_Primary;
  // ignore: non_constant_identifier_names
  static Color color_AppBackgroundMedium = _clrAppBackgroundMedium;
  set colorAppBackgroundMedium(newColor) {
    color_Secondary = newColor;
  }
  // ignore: non_constant_identifier_names
  static Color color_AppBackgroundLight = _clrAppBackgroundLight;
  set colorAppBackgroundLight(newColor) {
    color_Secondary = newColor;
  }
  // ignore: non_constant_identifier_names
  static Color color_AppBackgroundShiny = _clrAppBackgroundShiny;
  set colorAppBackgroundShiny(newColor) {
    color_Secondary = newColor;
  }
  // ignore: non_constant_identifier_names
  static Color color_White = _clrWhite;
  set colorWhite(newColor) {
    color_Secondary = newColor;
  }
  // ignore: non_constant_identifier_names
  static Color color_Black = _clrBlack;
  set colorBlack(newColor) {
    color_Secondary = newColor;
  }

  static const Color tClr1_primary = Color(0xffaeea00);
  static const Color _tClr1_primaryLight = Color(0xffe4ff54);
  static const Color _tClr1_primaryDark = Color(0xff79b700);
  static const Color _tClr1_secondary = Color(0xff18ffff);

  static setColorsToAppStandard() {
    color_Primary = _clrPrimary;
    color_Secondary = _clrSecondary;
    color_AppBackground = _clrPrimary;
    color_AppBackgroundLight = _clrAppBackgroundLight;
    color_SecondaryDeepDark = _clrSecondaryDeepDark;
  }
  static setColorsToTeam1() {
    color_Primary = tClr1_primary;
    color_Secondary = _tClr1_secondary;
    color_AppBackground = tClr1_primary;
    color_AppBackgroundLight = _tClr1_primaryLight;
    color_SecondaryDeepDark = _tClr1_primaryDark;
  }
}
