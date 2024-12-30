import 'dart:async';
import 'package:mood_prints/constants/app_colors.dart';
import 'package:mood_prints/view/screens/auth/sign_up/client_sign_up/client_complete_profile.dart/client_complete_profile.dart';
import 'package:mood_prints/view/screens/auth/sign_up/client_sign_up/client_complete_profile.dart/fill_therapist_details.dart';
import 'package:mood_prints/view/screens/launch/get_started.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mood_prints/view/widget/my_text_widget.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    splashScreenHandler();
  }

  void splashScreenHandler() {
    Timer(
      Duration(seconds: 2),
      () => Get.offAll(() => GetStarted()
          // ClientCompleteProfile(),

          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          MyText(
            text: 'LOGO',
            size: 42,
            color: kSecondaryColor,
            textAlign: TextAlign.center,
            weight: FontWeight.bold,
          ),
        ],
      ),
    );
  }
}
