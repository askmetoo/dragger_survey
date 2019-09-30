import 'package:dragger_survey/src/screens/screens.dart';
import 'package:dragger_survey/src/widgets/widgets.dart';
import 'package:flutter/material.dart';

import '../styles.dart';

class DraggerScaffoldScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Styles.drg_colorAppBackground,
      appBar: AppBar(),
      body: DraggerScreen(),
      endDrawer: UserDrawer(),
    );
  }
}