import 'dart:async';
import 'package:buhairi_academy_application/Customs/Colors.dart';
import 'package:buhairi_academy_application/Screens/introduction/app_description.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(milliseconds: 2500),(){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> AppDescription()));
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: Splash_Color.splash_Color,
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Center(
            child: Image.asset("assets/images/logo.png",
            ),
          ),
        ),
      ),
    );
  }
}