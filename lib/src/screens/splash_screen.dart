import 'package:dragger_survey/src/styles.dart';
import 'package:flutter/material.dart';
import 'package:dragger_survey/src/screens/home_screen.dart';
import 'package:page_transition/page_transition.dart';

import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    /// Initialize data, then navigator to Home screen.
    initData().then((value) {
      navigateToHomeScreen();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Styles.drg_colorAppBackground,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            'assets/dragger-logo.png',
//          width: 200,
          ),
        ],
      ),
    );
  }

  Future initData() async {
    await Future.delayed(Duration(milliseconds: 100));
  }

  void navigateToHomeScreen() {
    /// Push home screen and replace (close/exit) splash screen.
    Navigator.pushNamed(context, '/login');
    // Navigator.pushReplacement(
    //   context,
    //   PageTransition(
    //     curve: Curves.easeIn,
    //     duration: Duration(milliseconds: 400),
    //     type: PageTransitionType.fade,
    //     child: LoginScreen(),
    //   ),
    // );
  }
}
