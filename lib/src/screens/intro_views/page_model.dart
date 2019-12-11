import 'dart:developer';

import 'package:dragger_survey/src/blocs/blocs.dart';
import 'package:dragger_survey/src/styles.dart';
import 'package:flutter/material.dart';
import 'package:intro_views_flutter/Models/page_view_model.dart';
import 'package:provider/provider.dart';

final PageViewModel teamPage = PageViewModel(
  pageColor: Styles.color_Secondary,
  bubble: Icon(
    Icons.people,
    color: Styles.color_AppBackgroundLight,
  ),
  bubbleBackgroundColor: Styles.color_AppBackground,
  body: Text(
    'Before your first survey, prepare your set-up with building a team - even if you start as the only member of the team. Later on, it is easy to invite others.',
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
    color: Styles.color_Secondary,
  ),
  titleTextStyle: TextStyle(
    fontFamily: 'SonsieOne',
    color: Colors.white,
    fontSize: 32,
    height: 1.1,
  ),
  bodyTextStyle: TextStyle(
    fontFamily: 'Barlow',
    color: Styles.color_Primary,
    fontSize: 18,
    fontWeight: FontWeight.w500,
  ),
);

final PageViewModel invitePage = PageViewModel(
  pageColor: Styles.color_Complementary,
  bubble: Icon(
    Icons.person_add,
    color: Styles.color_AppBackgroundLight,
  ),
  bubbleBackgroundColor: Styles.color_AppBackground,
  body: Text(
    'After the a team is provided with name and description, you can invite others as members by scanning a QR code in their profile page.',
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
    color: Styles.color_Complementary,
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
  pageColor: Styles.color_AppBackgroundLight,
  bubble: Icon(
    Icons.storage,
    color: Styles.color_AppBackgroundLight,
  ),
  bubbleBackgroundColor: Styles.color_AppBackground,
  body: Text(
    'Collect a buch of quick surveys in a set of surveys - a Survey Set - to get quick insights to two specific metrics with the granularity you think is the best.',
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
    color: Styles.color_AppBackgroundLight,
  ),
  titleTextStyle: TextStyle(
    fontFamily: 'SonsieOne',
    color: Colors.white,
    fontSize: 32,
    height: 1.1,
  ),
  bodyTextStyle: TextStyle(
    fontFamily: 'Barlow',
    color: Styles.color_Primary,
    fontSize: 18,
    fontWeight: FontWeight.w500,
  ),
);

final PageViewModel surveyPage = PageViewModel(
  pageColor: Styles.color_AppBackgroundMedium,
  bubble: Icon(
    Icons.question_answer,
    color: Styles.color_AppBackgroundLight,
  ),
  bubbleBackgroundColor: Styles.color_AppBackground,
  body: Text(
    'Once the Survey Set is created, you can survey people at a finger tip. \nThe asked person then only drags a chip to his desired position on the Dragger Board.',
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
    color: Styles.color_AppBackgroundMedium,
  ),
  titleTextStyle: TextStyle(
    fontFamily: 'SonsieOne',
    color: Colors.white,
    fontSize: 32,
    height: 1.1,
  ),
  bodyTextStyle: TextStyle(
    fontFamily: 'Barlow',
    color: Styles.color_Primary,
    fontSize: 18,
    fontWeight: FontWeight.w500,
  ),
);

final PageViewModel insightsPage = PageViewModel(
  pageColor: Styles.color_AppBackgroundShiny,
  bubble: Icon(
    Icons.people,
    color: Styles.color_AppBackgroundLight,
  ),
  bubbleBackgroundColor: Styles.color_AppBackground,
  body: Text(
    'Eventally after several surveys made you can get the resulst displayed as a scattered plot chart or as graph over time',
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
    color: Styles.color_AppBackgroundShiny,
  ),
  titleTextStyle: TextStyle(
    fontFamily: 'SonsieOne',
    color: Styles.color_Primary,
    fontSize: 32,
    height: 1.1,
  ),
  bodyTextStyle: TextStyle(
    fontFamily: 'Barlow',
    color: Styles.color_Primary,
    fontSize: 18,
    fontWeight: FontWeight.w500,
  ),
);

final PageViewModel readyPage = PageViewModel(
  pageColor: Styles.color_Secondary,
  bubble: Icon(
    Icons.people,
    color: Styles.color_AppBackgroundLight,
  ),
  bubbleBackgroundColor: Styles.color_AppBackground,
  body: Text(
    "Ready! Now it's time to explore the feedback of the people. Go out and listen!",
  ),
  title: Text(
    'Start Dragging!',
    textAlign: TextAlign.center,
  ),
  mainImage: Image.asset(
    'assets/undraw_feedback_h2ft.png',
    width: double.infinity,
    alignment: Alignment.topCenter,
    colorBlendMode: BlendMode.modulate,
    color: Styles.color_Secondary,
  ),
  titleTextStyle: TextStyle(
    fontFamily: 'SonsieOne',
    color: Colors.white,
    fontSize: 32,
    height: 1.1,
  ),
  bodyTextStyle: TextStyle(
    fontFamily: 'Barlow',
    color: Styles.color_Primary,
    fontSize: 18,
    fontWeight: FontWeight.w500,
  ),
);
