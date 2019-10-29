import 'package:flutter/material.dart';

class Loader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      height: 250,
      child: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: 100),
          child: AspectRatio(
            aspectRatio: 1,
            child: CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }
}

class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Loader(),
      ),
    );
  }
}
