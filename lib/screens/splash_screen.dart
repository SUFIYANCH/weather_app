import 'dart:async';

import 'package:flutter/material.dart';
import 'package:weather_app/utils/responsive.dart';
import 'package:weather_app/screens/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> animation;
  @override
  void initState() {
    animationController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1500));
    animation = CurvedAnimation(
        parent: animationController,
        curve: Curves.bounceOut,
        reverseCurve: Curves.bounceInOut);
    animationController.forward();
    Timer(
      Duration(milliseconds: 2500),
      () => Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(),
          )),
    );
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff213555),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ScaleTransition(
            scale: animation,
            child: Image.asset(
              'assets/splashlogo.png',
              width: 250,
            ),
          ),
          Center(
            child: Text(
              'Weather App',
              style: TextStyle(
                  fontSize: R.sw(40, context),
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          )
        ],
      ),
    );
  }
}
