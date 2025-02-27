import 'dart:async';
import 'package:mood_prints/constants/app_colors.dart';
import 'package:mood_prints/controller/client/auth/auth_client_controller.dart';
import 'package:mood_prints/controller/client/home/client_home_controller.dart';
import 'package:mood_prints/services/user/user_services.dart';
import 'package:mood_prints/services/user/user_type_service.dart';
import 'package:mood_prints/view/screens/bottom_nav_bar/client_nav_bar.dart';
import 'package:mood_prints/view/screens/bottom_nav_bar/therapist_nav_bar.dart';
import 'package:mood_prints/view/screens/launch/get_started.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mood_prints/view/widget/my_text_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
      // Get.offAll(() => TherapistNavBar());
    });
  }

  Future<void> checkUserStatus() async {
    String? checkingID = await Get.find<AuthClientController>()
        .getStringSharedPrefMethod(key: 'id');

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await UserTypeService.instance.initUserType();
    final userType = await prefs.getString('userType');

    if (checkingID.isNotEmpty) {
      // await Get.put(AuthController()).getCurrentUserDataMethod();
      await UserService.instance.getUserInformation();

      if (userType == 'client') {
        await Get.find<ClientHomeController>().getAllBoard();
        await Get.find<ClientHomeController>()
            .allStats(userID: UserService.instance.userModel.value.id!);
        ();
        Get.offAll(() => ClientNavBar());
      } else if (userType == 'therapist') {
        Get.offAll(() => TherapistNavBar());
      }

      // Get.offAll(() => ClientNavBar());
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
