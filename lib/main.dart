import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';

import 'HomeScreen.dart';


main() {
  runApp(MaterialApp(
    home: AnimatedSplashScreen(
      backgroundColor: Colors.indigo,
      splashIconSize: 200,
      splash: CircleAvatar(
        child: Image.asset('images/logo.png'),
        backgroundColor: Colors.indigo,
        radius: 90,
      ),
      nextScreen: HomeScreen(),
      splashTransition: SplashTransition.fadeTransition,
      //  pageTransitionType: PageTransitionType.scale,
    ),
    debugShowCheckedModeBanner: false,
  ));
}
