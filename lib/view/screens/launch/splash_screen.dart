import 'dart:async';
import 'dart:developer';
import 'package:mood_prints/constants/app_colors.dart';
import 'package:mood_prints/controller/client/auth/auth_client_controller.dart';
import 'package:mood_prints/controller/client/home/client_home_controller.dart';
import 'package:mood_prints/services/user/user_services.dart';

import 'package:mood_prints/view/screens/bottom_nav_bar/client_nav_bar.dart';
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
    Timer(Duration(seconds: 2), () async {
      checkUserStatus();
    });
  }

  Future<void> checkUserStatus() async {
    String? checkingID =
        await Get.find<AuthController>().getStringSharedPrefMethod(key: 'id');

    if (checkingID.isNotEmpty) {
      // await Get.put(AuthController()).getCurrentUserDataMethod();
      await UserService.instance.getUserInformation();
      await Get.find<ClientHomeController>().getAllBoard();

      Get.offAll(() => ClientNavBar());
    } else {
      Get.offAll(() => GetStarted());
    }
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
