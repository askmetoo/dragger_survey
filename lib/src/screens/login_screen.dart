import 'package:dragger_survey/src/services/sign_in.dart';
import 'package:dragger_survey/src/styles.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Styles.appBackground,
        child: Center(child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(image: AssetImage('assets/dragger-logo.png'),),
            SizedBox(height: 50,),
            _singInButton(),
          ],
        ),),
      ),
    );
  }

  Widget _singInButton() {
    return OutlineButton(
      splashColor: Styles.secondaryColor,
      onPressed: () async {
        await Future.delayed(Duration(seconds: 1));
        Navigator.pushNamed(context, '/draggerboard');
      
        // TODO: reactivate
        // signInWithGoogle().whenComplete( () {
        //   Navigator.pushReplacementNamed(context, '/profile');
        // });
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
      highlightElevation: 0,
      borderSide: BorderSide(color: Styles.secondaryColor),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Sign-In with Google", style: TextStyle(fontSize: 20, color: Styles.secondaryColor),)
          ],
        ),),
    );
  }
}