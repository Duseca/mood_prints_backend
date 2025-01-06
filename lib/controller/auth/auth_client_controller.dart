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
import 'package:mood_prints/view/screens/launch/get_started.dart';
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

  //  --- Login Method ---

  Future<void> loginMethod({
    required String email,
    required String password,
  }) async {
    log("Try Called Login");
    log("Email ${email}");
    log("Password ${password}");
    try {
      showLoadingDialog();
      Map<String, dynamic> body = {
        'email': email,
        'password': password,
      };
      final response = await apiService.post(loginUrl, body, true,
          showResult: true, successCode: 200);
      hideLoadingDialog();

      if (response != null) {
        final token = response['token'];
        final user = response['user'];

        if (token != null && token.isNotEmpty) {
          UserModel userModel = UserModel.fromJson(user);
          log('user model -> ${userModel.username}');
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('token', token);
          await prefs.setString('id', userModel.id.toString());
          resetValues();
          Get.to(() => ClientNavBar());
        }
      }

      hideLoadingDialog();
    } catch (e) {
      hideLoadingDialog();
      log('Error:-> $e');
    }
  }

  //  --- SignUp Method ---

  Future<void> signUpClientMethod({
    required String fullName,
    required String email,
    required String password,
    required String userType,
  }) async {
    log("Try Called SignUp");
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

        if (token != null && token.isNotEmpty) {
          // log('--------------------------------------------');
          // log('Token:-> $token');
          // log('Id:-> $id');

          Get.to(() => EmailVerification(
                email: '$email',
                id: id,
                token: token,
              ));
        }
      }
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
    } catch (e) {
      hideLoadingDialog();
      log('Error:-> $e');
    }
  }

  //  --- Get Current User Information Method ---
  // This function is used when a user logs in or signs up for an account. After that, if the user closes the app and opens it again later, they won't need to authenticate to log in.

  Future<void> getCurrentUserDataMethod() async {
    log("Called Get Current User");
    try {
      showLoadingDialog();
      // SharedPreferences prefs = await SharedPreferences.getInstance();
      // final id = await prefs.getString('id');
      final id = await getStringSharedPrefMethod(key: 'id');
      if (id.isNotEmpty) {
        log('id is Not null -> ${id}');

        final url = getClientByIDUrl + id;
        final response =
            await apiService.get(url, true, showResult: true, successCode: 200);
        hideLoadingDialog();

        if (response != null) {
          final user = response['user'];
          UserModel userModel = UserModel.fromJson(user);
          log('user name -> ${userModel.username}');

          Get.to(() => ClientNavBar());
        }
      }

      hideLoadingDialog();
    } catch (e) {
      hideLoadingDialog();
      log('Error:-> $e');
    }
  }

  // --- Logout ---
  Future<String> getStringSharedPrefMethod({required String key}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final value = await prefs.getString('$key');

    if (value != null) {
      return value;
    } else {
      return '';
    }
  }

  // --- getString From Shared Pref ---

  Future<void> logOutMethod() async {
    showLoadingDialog();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final id = await prefs.remove('id');
    final token = await prefs.remove('token');
    log("Id removed from shared pref: $id");
    log("Token removed from shared pref: $token");
    Get.offAll(() => GetStarted());
    hideLoadingDialog();
  }

  // --- getString From Shared Pref ---

  Future<void> setStringSharedPrefMethod(
      {required String key, required String value}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('$key', '$value');
  }

  // --- Reset Controllers values ---

  resetValues() {
    fullNameController.clear();
    emailController.clear();
    passwordController.clear();
    update();
  }
}
