import 'package:mood_prints/constants/app_colors.dart';
import 'package:mood_prints/constants/app_fonts.dart';
import 'package:mood_prints/constants/app_sizes.dart';
import 'package:mood_prints/view/screens/auth/forgot_pass/create_password.dart';
import 'package:mood_prints/view/widget/custom_app_bar_widget.dart';
import 'package:mood_prints/view/widget/headings_widget.dart';
import 'package:mood_prints/view/widget/my_button_widget.dart';
import 'package:mood_prints/view/widget/my_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:pinput/pinput.dart';

class ForgotPassVerification extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final DEFAULT_THEME = PinTheme(
      width: 48,
      height: 56,
      margin: EdgeInsets.zero,
      textStyle: TextStyle(
        fontSize: 20,
        height: 0.0,
        fontWeight: FontWeight.bold,
        color: kSecondaryColor,
        fontFamily: AppFonts.URBANIST,
      ),
      decoration: BoxDecoration(
        border: Border.all(
          width: 1.0,
          color: kBorderColor,
        ),
        color: kWhiteColor,
        borderRadius: BorderRadius.circular(8),
      ),
    );
    return Scaffold(
      appBar: simpleAppBar(
        title: 'OTP Verification',
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              shrinkWrap: true,
              padding: AppSizes.DEFAULT,
              physics: BouncingScrollPhysics(),
              children: [
                AuthHeading(
                  title: 'Enter code',
                  subTitle:
                      'Enter the One-Time Password (OTP) sent to your email to verify.',
                ),
                SizedBox(
                  height: 10,
                ),
                Pinput(
                  length: 6,
                  onChanged: (value) {},
                  pinContentAlignment: Alignment.center,
                  defaultPinTheme: DEFAULT_THEME,
                  focusedPinTheme: DEFAULT_THEME.copyWith(
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 1.0,
                        color: kSecondaryColor,
                      ),
                      color: kSecondaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  submittedPinTheme: DEFAULT_THEME.copyWith(
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 1.0,
                        color: kSecondaryColor,
                      ),
                      color: kSecondaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  separatorBuilder: (index) {
                    return SizedBox(
                      width: 0,
                    );
                  },
                  onCompleted: (pin) => print(pin),
                ),
                SizedBox(
                  height: 35,
                ),
                MyText(
                  text: 'Didn\'t receive email?',
                  textAlign: TextAlign.center,
                  size: 15,
                  weight: FontWeight.w600,
                  paddingBottom: 12,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MyText(
                      text: 'You can resend code in ',
                      size: 15,
                      color: kGreyColor2,
                      weight: FontWeight.w500,
                    ),
                    MyText(
                      text: '55s',
                      size: 15,
                      weight: FontWeight.bold,
                      color: kSecondaryColor,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: AppSizes.DEFAULT,
            child: MyButton(
              onTap: () {
                Get.to(() => CreatePassword());
              },
              buttonText: 'Continue',
            ),
          ),
        ],
      ),
    );
  }
}
