import 'package:dragger_survey/src/blocs/blocs.dart';
import 'package:flutter/material.dart';
import 'package:dragger_survey/src/app.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(ChangeNotifierProvider<ThemeBloc>(
    create: (BuildContext context) => ThemeBloc(), child: App()));
}
