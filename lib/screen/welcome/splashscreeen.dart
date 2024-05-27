// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:ecommerce_app/screen/welcome/onboarding_page.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () {
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (_) => OnBoardingPage()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Container(
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 300),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Kutuku",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 50,
                            color: Colors.white),
                      ),
                      Text(
                        "Any shopping just from home",
                        style: TextStyle(
                            fontWeight: FontWeight.w300,
                            fontSize: 20,
                            color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
              Spacer(),
              Text(
                "version 1.0.0",
                style: TextStyle(
                    fontWeight: FontWeight.w300,
                    fontSize: 20,
                    color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
