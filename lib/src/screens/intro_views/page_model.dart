import 'package:dragger_survey/src/styles.dart';
import 'package:flutter/material.dart';
import 'package:intro_views_flutter/Models/page_view_model.dart';

final PageViewModel teamPage = PageViewModel(
  pageColor: Styles.drg_colorSecondary,
  bubble: Icon(
    Icons.people,
    color: Styles.drg_colorAppBackgroundLight,
  ),
  bubbleBackgroundColor: Styles.drg_colorAppBackground,
  body: Text(
    'Start with building a team - even if you start as only member in the team. Later on, it is easy to invite others as members.',
  ),
  title: Text(
    'Build a Team',
    textAlign: TextAlign.center,
  ),
  mainImage: Image.asset(
    'assets/undraw_team_spirit_hrr4.png',
    width: double.infinity,
    alignment: Alignment.topCenter,
    colorBlendMode: BlendMode.modulate,
    color: Styles.drg_colorSecondary,
  ),
  titleTextStyle: TextStyle(
    fontFamily: 'SonsieOne',
    color: Colors.white,
    fontSize: 32,
    height: 1.1,
  ),
  bodyTextStyle: TextStyle(
    fontFamily: 'Barlow',
    color: Styles.drg_colorPrimary,
    fontSize: 18,
    fontWeight: FontWeight.w500,
  ),
);

final PageViewModel invitePage = PageViewModel(
  pageColor: Styles.drg_colorContrast,
  bubble: Icon(
    Icons.person_add,
    color: Styles.drg_colorAppBackgroundLight,
  ),
  bubbleBackgroundColor: Styles.drg_colorAppBackground,
  body: Text(
    'Start with building a team - even if you are at first the only member. Later, you can invite others by QR code in their profile.',
  ),
  title: Text(
    'Invite Team Members',
    textAlign: TextAlign.center,
  ),
  mainImage: Image.asset(
    'assets/undraw_invite_i6u7.png',
    width: double.infinity,
    alignment: Alignment.topCenter,
    colorBlendMode: BlendMode.modulate,
    color: Styles.drg_colorContrast,
  ),
  titleTextStyle: TextStyle(
    fontFamily: 'SonsieOne',
    color: Colors.white,
    fontSize: 32,
    height: 1.1,
  ),
  bodyTextStyle: TextStyle(
    fontFamily: 'Barlow',
    color: Colors.white,
    fontSize: 18,
    fontWeight: FontWeight.w500,
  ),
);

final PageViewModel setPage = PageViewModel(
  pageColor: Styles.drg_colorAppBackgroundLight,
  bubble: Icon(
    Icons.storage,
    color: Styles.drg_colorAppBackgroundLight,
  ),
  bubbleBackgroundColor: Styles.drg_colorAppBackground,
  body: Text(
    'Collect a buch of quick surveys in a Survey Set to get quick insights to two specific metrics with the granularity you strive for.',
  ),
  title: Text(
    'Gather Quick Feedback in a Survey Set',
    textAlign: TextAlign.center,
  ),
  mainImage: Image.asset(
    'assets/undraw_collecting_fjjl.png',
    width: double.infinity,
    alignment: Alignment.topCenter,
    colorBlendMode: BlendMode.modulate,
    color: Styles.drg_colorAppBackgroundLight,
  ),
  titleTextStyle: TextStyle(
    fontFamily: 'SonsieOne',
    color: Colors.white,
    fontSize: 32,
    height: 1.1,
  ),
  bodyTextStyle: TextStyle(
    fontFamily: 'Barlow',
    color: Styles.drg_colorPrimary,
    fontSize: 18,
    fontWeight: FontWeight.w500,
  ),
);

final PageViewModel surveyPage = PageViewModel(
  pageColor: Styles.drg_colorAppBackgroundMedium,
  bubble: Icon(
    Icons.question_answer,
    color: Styles.drg_colorAppBackgroundLight,
  ),
  bubbleBackgroundColor: Styles.drg_colorAppBackground,
  body: Text(
    'After a Survey Set is created, you can make your surveys on a finger tip. \nThe surveyed person then only drags a chip to a desired position on the Dragger Board.',
  ),
  title: Text(
    'Surveying made easy and fast.',
    textAlign: TextAlign.center,
  ),
  mainImage: Image.asset(
    'assets/undraw_searching_p5ux.png',
    width: double.infinity,
    alignment: Alignment.topCenter,
    colorBlendMode: BlendMode.modulate,
    color: Styles.drg_colorAppBackgroundMedium,
  ),
  titleTextStyle: TextStyle(
    fontFamily: 'SonsieOne',
    color: Colors.white,
    fontSize: 32,
    height: 1.1,
  ),
  bodyTextStyle: TextStyle(
    fontFamily: 'Barlow',
    color: Styles.drg_colorPrimary,
    fontSize: 18,
    fontWeight: FontWeight.w500,
  ),
);

final PageViewModel insightsPage = PageViewModel(
  pageColor: Styles.drg_colorAppBackgroundShiny,
  bubble: Icon(
    Icons.people,
    color: Styles.drg_colorAppBackgroundLight,
  ),
  bubbleBackgroundColor: Styles.drg_colorAppBackground,
  body: Text(
    'After several surveys made you are able to get the resulst displayed as a Scattered Plot Chart or Graph over time',
  ),
  title: Text(
    'Get Insights with Graphs',
    textAlign: TextAlign.center,
  ),
  mainImage: Image.asset(
    'assets/undraw_personal_goals_edgd.png',
    width: double.infinity,
    alignment: Alignment.topCenter,
    colorBlendMode: BlendMode.modulate,
    color: Styles.drg_colorAppBackgroundShiny,
  ),
  titleTextStyle: TextStyle(
    fontFamily: 'SonsieOne',
    color: Styles.drg_colorPrimary,
    fontSize: 32,
    height: 1.1,
  ),
  bodyTextStyle: TextStyle(
    fontFamily: 'Barlow',
    color: Styles.drg_colorPrimary,
    fontSize: 18,
    fontWeight: FontWeight.w500,
  ),
);
