import 'dart:async';

import 'package:flutter/material.dart';
import 'package:trackpocket/screens/get_started.dart';
import 'package:trackpocket/theme/app_theme.dart';
import 'package:trackpocket/utiles/const.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Future.delayed(Duration(seconds: 1), () {
      if (!mounted) return;
      nextRemovePage(context, GetStartedScreen());
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Center(
            child: SizedBox(
              height: 220,
              width: 220,
              child: Image.asset(
                "$imagesPath/trackpocket1.png",
                color: subMainColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
