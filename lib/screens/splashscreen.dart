import 'dart:async';

import 'package:flutter/material.dart';
import 'package:read_and_brew/screens/homepage.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double _opacity = 0;

  @override
  void initState() {
    super.initState();
    Timer(
        Duration(seconds: 3),
        () => Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => MyHomePage())));
    _fadeInImage();
  }

  void _fadeInImage() {
    Future.delayed(Duration(milliseconds: 200)).then((_) {
      setState(() {
        _opacity = 1;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white,
            Colors.white,
            Color.fromARGB(255, 172, 255, 169),
            Color.fromARGB(255, 172, 255, 169)
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          AnimatedOpacity(
            opacity: _opacity,
            duration: Duration(seconds: 2),
            child: Container(
              width: 300, // Set your desired width
              height: 300, // Set your desired height
              child: Image.asset('assets/images/splash.png'),
            ),
          ),
        ],
      ),
    );
  }
}
