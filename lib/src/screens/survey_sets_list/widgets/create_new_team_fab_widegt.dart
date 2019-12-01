import 'package:flutter/material.dart';
import 'package:dragger_survey/src/blocs/blocs.dart';
import 'package:dragger_survey/src/styles.dart';

import 'package:dragger_survey/src/screens/survey_sets_list/widgets/widgets.dart';

class CreateNewTeamFAB extends StatelessWidget {
  const CreateNewTeamFAB({
    Key key,
    @required this.teamBloc,
  }) : super(key: key);

  final TeamBloc teamBloc;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      backgroundColor: Styles.color_Secondary,
      icon: Icon(
        Icons.people,
        color: Styles.color_Text.withOpacity(.8),
      ),
      label: Text(
        'Create new Team',
        style: TextStyle(
          color: Styles.color_Text.withOpacity(0.8),
        ),
      ),
      onPressed: () {
        teamBloc.updatingTeamData = false;
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(
                "Create new Team",
                style: TextStyle(
                  fontFamily: 'Bitter',
                  fontWeight: FontWeight.w200,
                ),
              ),
              content: CreateTeamForm(),
              elevation: 10,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(3),
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              backgroundColor: Styles.color_Secondary,
              contentTextStyle: TextStyle(color: Styles.color_Text),
            );
          },
        );
      },
    );
  }
}
