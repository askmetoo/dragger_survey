import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dragger_survey/src/blocs/blocs.dart';
import 'package:dragger_survey/src/styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ColorChooserWidget extends StatelessWidget {
  final DocumentSnapshot teamDocSnapshot;
  const ColorChooserWidget({
    Key key,
    this.teamDocSnapshot,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ColorsBloc colorsBloc = Provider.of<ColorsBloc>(context);
    ThemeBloc themeBloc = Provider.of<ThemeBloc>(context);

    List<Color> colors = [
      Styles.color_Primary,
      Styles.tClr1_primary,
    ];


    return Container(
      padding: EdgeInsets.fromLTRB(16, 12, 16, 24),
      height: 200,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          ChooserTitle(teamDocSnapshot: teamDocSnapshot),
          Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: Row(
              children: <Widget>[
                ...colors.map((color) {
                  return Padding(
                    key: ValueKey(color.toString()),
                    padding: const EdgeInsets.only(right: 8.0),
                    child: GestureDetector(
                      onTapDown: (TapDownDetails tabDownDetails) {
                        
                        int index = colors.indexOf(color);
                        log("Choosen color theme index: $index");
                        if (index == 0) {
                          themeBloc.setColorTheme(ThemeType.Standard);
                          log("Choosen color theme: ${ThemeType.Standard}");
                          log("Choosen color: $color");
                        } else if (index == 1) {
                          log("Choosen color theme: ${ThemeType.Team1}");
                          log("Choosen color: $color");
                          themeBloc.setColorTheme(ThemeType.Team1);
                        }
                        Navigator.of(context).pop();
                      },
                                          child: ClipRRect(
                        borderRadius: BorderRadius.circular(40),
                        child: Container(
                          width: 50,
                          height: 50,
                          color: color,
                        ),
                      ),
                    ),
                  );
                })
              ],
            ),
          )
        ],
      ),
    );
  }
}

class ChooserTitle extends StatelessWidget {
  const ChooserTitle({
    Key key,
    @required this.teamDocSnapshot,
  }) : super(key: key);

  final DocumentSnapshot teamDocSnapshot;

  @override
  Widget build(BuildContext context) {
    return RichText(
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
    );
  }
}
