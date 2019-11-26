import 'package:dragger_survey/src/styles.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    /// Initialize data, then navigator to Home screen.
    initData().then((_) {
      navigateToHomeScreen();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Styles.color_AppBackground,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            'assets/dragger-logo.png',
          ),
        ],
      ),
    );
  }

  Future initData() async {
    await Future.delayed(Duration(milliseconds: 800));
  }

  void navigateToHomeScreen() {
    Navigator.pushNamed(context, '/login');
  }
}
