import 'dart:developer';
import 'package:mood_prints/constants/app_colors.dart';
import 'package:mood_prints/constants/app_fonts.dart';
import 'package:mood_prints/constants/app_images.dart';
import 'package:mood_prints/constants/app_sizes.dart';
import 'package:mood_prints/controller/client/auth/auth_client_controller.dart';
import 'package:mood_prints/services/user/user_services.dart';
import 'package:mood_prints/view/screens/auth/sign_up/client_sign_up/client_complete_profile.dart/client_complete_profile.dart';
import 'package:mood_prints/view/widget/custom_app_bar_widget.dart';
import 'package:mood_prints/view/widget/headings_widget.dart';
import 'package:mood_prints/view/widget/my_button_widget.dart';
import 'package:mood_prints/view/widget/my_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';

// ignore: must_be_immutable
class EmailVerification extends StatefulWidget {
  String? email;
  String? id;
  String? token;
  EmailVerification({
    Key? key,
    this.email,
    this.id,
    this.token,
  }) : super(key: key);

  @override
  State<EmailVerification> createState() => _EmailVerificationState();
}

class _EmailVerificationState extends State<EmailVerification> {
  final ctrl = Get.find<AuthController>();

  @override
  void dispose() {
    super.dispose();
    ctrl.otpMessage.value = '';
  }

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
      appBar: simpleAppBar(),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              shrinkWrap: true,
              padding: AppSizes.DEFAULT,
              physics: BouncingScrollPhysics(),
              children: [
                AuthHeading(
                  marginTop: 0.0,
                  title: 'OTP Verification',
                  subTitle:
                      'Enter the One-Time Password (OTP) sent to your email to verify your account.',
                ),
                SizedBox(
                  height: 40,
                ),
                Pinput(
                  length: 6,
                  onChanged: (value) {
                    ctrl.otpCode = value;
                    log('1--> OTP CODE: ${ctrl.otpCode}');
                  },
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
                Obx(
                  () => Align(
                    alignment: Alignment.center,
                    child: MyText(
                      paddingTop: 20,
                      text: "${ctrl.otpMessage}",
                      size: 12,
                      color: kSecondaryColor,
                      weight: FontWeight.w600,
                      letterSpacing: 2,
                    ),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: AppSizes.DEFAULT,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MyText(
                      text: 'Didn’t receive code? ',
                      size: 14,
                      weight: FontWeight.w500,
                    ),
                    MyText(
                      text: 'Resend code',
                      size: 14,
                      weight: FontWeight.w600,
                      color: kQuaternaryColor,
                      decoration: TextDecoration.underline,
                    ),
                  ],
                ),
                SizedBox(
                  height: 24,
                ),
                MyButton(
                  onTap: () {
                    if (ctrl.otpCode != null) {
                      log('2--> OTP CODE: ${ctrl.otpCode}');
                      ctrl.otpVerificationMethod(
                          email: widget.email.toString(),
                          otp: ctrl.otpCode.toString(),
                          token: widget.token.toString(),
                          id: widget.id.toString(),
                          widget: _SuccessDialog());

                      // UserService.instance.getUserInformation();
                      log('OTP value not null');
                    } else {
                      log('OTP value is null');
                    }
                  },
                  buttonText: 'Continue',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SuccessDialog extends StatelessWidget {
  const _SuccessDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Card(
          margin: AppSizes.DEFAULT,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Image.asset(
                  Assets.imagesCongrats,
                  height: 150,
                ),
                MyText(
                  paddingTop: 24,
                  text: 'Verification Complete!',
                  size: 24,
                  weight: FontWeight.bold,
                  textAlign: TextAlign.center,
                  paddingBottom: 8,
                ),
                MyText(
                  text:
                      'Thanks for your patience. Enjoy the all features of app',
                  size: 14,
                  color: kGreyColor,
                  weight: FontWeight.w500,
                  lineHeight: 1.5,
                  paddingLeft: 10,
                  paddingRight: 10,
                  textAlign: TextAlign.center,
                  paddingBottom: 24,
                ),
                MyButton(
                  buttonText: 'Done',
                  onTap: () async {
                    await UserService.instance.getUserInformation();
                    Get.back();
                    Get.to(() => ClientCompleteProfile());

                    // Get.to(() => CompleteProfile());
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
