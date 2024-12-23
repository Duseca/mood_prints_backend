import 'package:mood_prints/constants/app_sizes.dart';
import 'package:mood_prints/view/screens/auth/forgot_pass/forgot_pass_verification.dart';

import 'package:mood_prints/view/widget/custom_app_bar_widget.dart';
import 'package:mood_prints/view/widget/headings_widget.dart';
import 'package:mood_prints/view/widget/my_button_widget.dart';
import 'package:mood_prints/view/widget/my_text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgotPassword extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: simpleAppBar(
        title: 'Forgot Password',
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ListView(
              shrinkWrap: true,
              physics: BouncingScrollPhysics(),
              padding: AppSizes.DEFAULT,
              children: [
                AuthHeading(
                  title: 'Forgot Password!',
                  subTitle:
                      'Not a problem! Please enter your email address to change your password.',
                ),
                MyTextField(
                  labelText: 'Email Address',
                  hintText: 'Your email address...',
                ),
              ],
            ),
          ),
          Padding(
            padding: AppSizes.DEFAULT,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                MyButton(
                  onTap: () {
                    Get.to(() => ForgotPassVerification());
                  },
                  buttonText: 'Send OTP',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
