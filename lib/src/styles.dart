import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Styles {
  static const textHeadline = TextStyle(
    color: Color.fromRGBO(0, 0, 0, 0.8),
    fontFamily: 'NotoSans',
    fontSize: 32,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w600
  );
  static const textSecondHeadline = TextStyle(
    color: Color.fromRGBO(0, 0, 0, 0.8),
    fontFamily: 'NotoSans',
    fontSize: 20,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w400,
  );
  static const textListTitle = TextStyle(
    color: Color.fromRGBO(0, 0, 0, 0.8),
    fontFamily: 'NotoSans',
    fontSize: 20,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w400,
  );
  static const textListContent = TextStyle(
    color: Color.fromRGBO(0, 0, 0, 0.8),
    fontFamily: 'NotoSans',
    fontSize: 16,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w400,
  );
  static const colorAttention = Color(0xffff0200);
  static const colorPrimary = Color(0xff119da4);
  static const colorSecondary = Color(0xfff7b71d);
  static const colorText = Color(0xff0e2431);

  static const colorYellowGreen = Color(0xffffff7f);
  static const colorLighterGreen = Color(0xffafa939);
  static const colorGreen = Color(0xff2b580c);
  static const colorDarkerGreen = Color(0xff2f4a36);

  static const orangeColorDonNotUse = Color(0xfff9b248);
  static const redColorDonNotUse = Color(0xfffc3a52);

  // TODOs:
  static const minorText = TextStyle();
  static const headlineName = TextStyle();
  static const headlineDescription = TextStyle();
  static const cardTitleText = TextStyle();
  static const cardCategoryText = TextStyle();
  static const cardDescriptionText = TextStyle();
  static const detailsTitleText = TextStyle();
  static const detailsPreferredCategoryText = TextStyle();
  static const detailsCategoryText = TextStyle();
  static const detailsDescriptionText = TextStyle();
  static const detailsBoldDescriptionText = TextStyle();

  static const appBackground = Color(0xffc66400);

  static const scaffoldBackground = Color(0xfff0f0f0);

  static const searchBackground = Color(0xffe0e0e0);

  static const frostedBackground = Color(0xccf8f8f8);

  static const closeButtonUnpressed = Color(0xff101010);

  static const closeButtonPressed = Color(0xff808080);

  static const preferenceIcon = IconData(
    0xf443,
    fontFamily: CupertinoIcons.iconFont,
    fontPackage: CupertinoIcons.iconFontPackage,
  );

  static const calorieIcon = IconData(
    0xf3bb,
    fontFamily: CupertinoIcons.iconFont,
    fontPackage: CupertinoIcons.iconFontPackage,
  );

  static const checkIcon = IconData(
    0xf383,
    fontFamily: CupertinoIcons.iconFont,
    fontPackage: CupertinoIcons.iconFontPackage,
  );

  static const servingInfoBorderColor = Color(0xffb0b0b0);

  static const ColorFilter desaturatedColorFilter =
      // 222222 is a random color that has low color saturation.
      ColorFilter.mode(Color(0xFF222222), BlendMode.saturation);
}
