import 'package:flutter/material.dart';
import 'dart:async';
import 'home_screen.dart'; // Import HomeScreen

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToHomeScreen();
  }

  // Function to navigate to HomeScreen after a delay
  _navigateToHomeScreen() async {
    await Future.delayed(Duration(seconds: 6)); // Splash screen duration
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.red, Colors.black],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [0.3, 1],
            tileMode: TileMode.clamp,
          ),
        ),
        child: Center(
          child: AnimatedOpacity(
            opacity: 1.0,
            duration: Duration(seconds: 1),
            child: Image.asset(
              'assets/logo.png', // Replace with your logo path
              width: 150, // Adjust logo size
              height: 150, // Adjust logo size
            ),
          ),
        ),
      ),
    );
  }
}
