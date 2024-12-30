import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:mood_prints/constants/all_urls.dart';
import 'package:mood_prints/constants/loading_animation.dart';
import 'package:mood_prints/core/common/global_instance.dart';
import 'package:mood_prints/model/user_model.dart';
import 'package:mood_prints/services/date_formator/general_service.dart';
import 'package:mood_prints/view/screens/auth/sign_up/email_verification.dart';
import 'package:mood_prints/view/screens/bottom_nav_bar/client_nav_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends GetxController {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  RxString otpMessage = ''.obs;
  String? otpCode;
  String? newUserTempId;
  // --- Profile Setup ---
  final TextEditingController phoneNumberController = TextEditingController();
  String? FullPhoneNumber;
  RxString selectedGenderValue = 'Male'.obs;
  RxList<String> gender = <String>['Male', 'Female', 'Not Preferred'].obs;
  Rx<DateTime?> dob = Rx<DateTime?>(null);
  final TextEditingController BioController = TextEditingController();
  final TextEditingController TherapistAccountNumberController =
      TextEditingController();

  //  --- SignUp Method ---

  Future<void> signUpClientMethod({
    required String fullName,
    required String email,
    required String password,
    required String userType,
  }) async {
    log("Try Called SignUp");
    log("Email ${email}");
    log("Password ${password}");
    log("userType ${userType}");
    log("fullName ${fullName}");
    try {
      showLoadingDialog();
      Map<String, dynamic> body = {
        'email': email,
        'password': password,
        'userType': userType,
        'fullName': fullName,
      };
      final response = await apiService.post(signUpUrl, body, true,
          showResult: true, successCode: 201);
      hideLoadingDialog();

      if (response != null) {
        final token = response['token'];
        final user = response['user'];
        final id = user['_id'];

        // Here i want to get id directly and print the response

        if (token != null && token.isNotEmpty) {
          // log('Response:-> $response');
          log('--------------------------------------------');
          log('Token:-> $token');
          log('Id:-> $id');

          Get.to(() => EmailVerification(
                email: '$email',
                id: id,
                token: token,
              ));
        }

        // Get.to(() => ClientCompleteProfile());
      }
      log("global called");
      hideLoadingDialog();
    } catch (e) {
      hideLoadingDialog();
      log('Error:-> $e');
    }
  }

  // --- OTP-Verification ---

  Future<void> otpVerificationMethod({
    required String email,
    required String otp,
    required Widget widget,
    required String token,
    required String id,
  }) async {
    log("Try Called Otp verification");
    log("Email ${email}");
    log("Otp ${otp}");

    try {
      showLoadingDialog();

      Map<String, dynamic> body = {
        'email': email,
        'otp': otp,
      };
      final response = await apiService.post(otpVerificationUrl, body, true,
          showResult: true, successCode: 200);

      hideLoadingDialog();

      if (response != null) {
        otpMessage.value = 'OTP verified successfully.';
        final message = response['message'];
        log('Message:-> $message');
        if (message != null && message.isNotEmpty) {
          newUserTempId = id;
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('token', token);
          await prefs.setString('id', newUserTempId!);

          Get.dialog(widget);
        }
        resetValues();
      } else {
        otpMessage.value = 'Invalid OTP';
        log('Invalid OTP');
      }
    } catch (e) {
      hideLoadingDialog();
      log('Error:-> $e');
    }
  }

  // // --- Profile Completion ---

  Future<void> profileCompletionMethod() async {
    try {
      if (fullNameController.text.isNotEmpty &&
          FullPhoneNumber != null &&
          dob.value != null &&
          BioController.text.isNotEmpty) {
        log('Fields Are Not Empty');

        showLoadingDialog();

        // Map<String, dynamic> body = {
        //   'fullName': fullNameController.text,
        //   'phoneNumber': FullPhoneNumber,
        //   'dob': DateFormatorService.instance.getDateIsoFormat(dob.value!),
        //   'gender': selectedGenderValue.value.toLowerCase(),
        //   'bio': BioController.text,
        // };

        UserModel model = UserModel(
          fullName: fullNameController.text.trim(),
          phoneNumber: FullPhoneNumber,
          dob: DateFormatorService.instance.getDateIsoFormat(dob.value!),
          gender: selectedGenderValue.value.toLowerCase(),
          bio: BioController.text,
        );

        final updateTherapistURL = updateClientUrl + newUserTempId.toString();

        final response = await apiService.putWithBody(
            updateTherapistURL, model.toJson(), false,
            showResult: true, successCode: 200);

        hideLoadingDialog();

        if (response != null) {
          final message = response['message'];
          final user = response['user'];
          log('Message:-> $message');
          // log('Response:-> $response');
          if (message != null && message.isNotEmpty) {
            final model = UserModel.fromJson(user);
            log("m username: ${model.fullName}");
            log("m bio: ${model.bio}");

            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.setBool('isProfileSetup', true);

            Get.offAll(() => ClientNavBar());
          }

          log('User Profile Updated');
        } else {
          log('User Not Updated');
        }
      } else {
        displayToast(msg: 'Please add all information');
        log('Fields are empty');
      }

      // -------- OLD CODE -----------
    } catch (e) {
      hideLoadingDialog();
      log('Error:-> $e');
    }
  }

  // --- Setup Profile ---

  Future<void> SetupProfile() async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // await prefs.setBool('isProfileSetup', true);
  }

  resetValues() {
    fullNameController.clear();
    emailController.clear();
    passwordController.clear();
    update();
  }
}
