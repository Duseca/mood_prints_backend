// method to show the loading dialog
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:mood_prints/constants/app_colors.dart';

void showLoadingDialog() {
  Get.dialog(
    // Center(child: CircularProgressIndicator()),
    Center(
        child: LoadingAnimationWidget.newtonCradle(
            color: kSecondaryColor, size: 150)),
    barrierDismissible: false,
  );
}

// method to hide the loading dialog
void hideLoadingDialog() {
  if (Get.isDialogOpen == true) {
    Get.close(1);
  }
  // Navigator.pop(context);
}

// -------------- Validation -------------------

String? validateName(String? value) {
  if (value == null || value.isEmpty) {
    return 'Name cannot be empty';
  }
  if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
    return 'Name can only contain alphabetic characters';
  }
  return null;
}

String? validateEmail(String? value) {
  if (value == null || value.isEmpty) {
    return 'Email cannot be empty';
  }
  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
    return 'Enter a valid email address';
  }
  return null;
}

String? validatePhoneNumber(String? value) {
  if (value == null || value.isEmpty) {
    return 'Phone number cannot be empty';
  }
  if (!RegExp(r'^\d{10,15}$').hasMatch(value)) {
    return 'Enter a valid phone number (10-15 digits)';
  }
  return null;
}

String? validatePassword(String? value) {
  if (value == null || value.isEmpty) {
    return 'Password cannot be empty';
  }
  if (value.length < 8) {
    return 'Password must be at least 8 characters long';
  }
  if (!RegExp(r'^(?=.*[a-zA-Z])(?=.*\d)').hasMatch(value)) {
    return 'Password must contain both letters and numbers';
  }
  return null;
}

displayToast({required String msg, Toast toastLength = Toast.LENGTH_SHORT}) {
  Fluttertoast.showToast(
    msg: msg,
    toastLength: toastLength,
    gravity: ToastGravity.TOP,
    timeInSecForIosWeb: 1,
    backgroundColor: kSecondaryColor,
    textColor: kPrimaryColor,
    fontSize: 14.0,
  );
}
