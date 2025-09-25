import 'dart:async';
import 'package:mood_prints/constants/app_colors.dart';
import 'package:mood_prints/controller/client/auth/auth_client_controller.dart';
import 'package:mood_prints/controller/client/home/client_home_controller.dart';
import 'package:mood_prints/core/binding/binding.dart';
import 'package:mood_prints/services/user/user_services.dart';
import 'package:mood_prints/services/user/user_type_service.dart';
import 'package:mood_prints/view/screens/auth/sign_up/client_sign_up/client_complete_profile.dart/client_complete_profile.dart';
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
    });
  }

  Future<void> checkUserStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? remeberMe = await prefs.getBool('remember_me');
    if (remeberMe == true) {
      String? checkingID = await Get.find<AuthClientController>()
          .getStringSharedPrefMethod(key: 'id');

      await UserTypeService.instance.initUserType();
      final userType = await prefs.getString('userType');

      if (checkingID.isNotEmpty) {
        await UserService.instance.getUserInformation();

        if (userType == 'client') {
          if (UserService.instance.userModel.value.phoneNumber == null ||
              UserService.instance.userModel.value.phoneNumber == "") {
            final ctrl = Get.find<AuthClientController>();
            ctrl.fullNameController.text =
                UserService.instance.userModel.value.fullName ?? "";
            ctrl.emailController.text =
                UserService.instance.userModel.value.email ?? "";
            ctrl.newUserTempId = UserService.instance.userModel.value.id;

            Get.to(ClientCompleteProfile());
          } else {
            Get.offAll(() => ClientNavBar(), binding: BottomBarBinding());
          }
        } else if (userType == 'therapist') {
          if (UserService.instance.therapistDetailModel.value.phoneNumber ==
                  null ||
              UserService.instance.therapistDetailModel.value.phoneNumber ==
                  "") {
            final ctrl = Get.find<AuthClientController>();
            ctrl.fullNameController.text =
                UserService.instance.therapistDetailModel.value.fullName ?? "";
            ctrl.emailController.text =
                UserService.instance.therapistDetailModel.value.email ?? "";
            ctrl.newUserTempId =
                UserService.instance.therapistDetailModel.value.id;

            Get.to(ClientCompleteProfile());
          } else {
            Get.offAll(() => TherapistNavBar(), binding: BottomBarBinding());
          }
        }
      } else {
        Get.offAll(() => GetStarted());
      }
    } else {
      Get.find<AuthClientController>().logOutMethod();
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
