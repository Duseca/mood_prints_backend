import 'package:mood_prints/constants/app_colors.dart';
import 'package:mood_prints/constants/app_images.dart';
import 'package:mood_prints/constants/app_sizes.dart';
import 'package:mood_prints/controller/client/auth/auth_client_controller.dart';
import 'package:mood_prints/view/screens/auth/login.dart';
import 'package:mood_prints/view/widget/custom_app_bar_widget.dart';
import 'package:mood_prints/view/widget/headings_widget.dart';
import 'package:mood_prints/view/widget/my_button_widget.dart';
import 'package:mood_prints/view/widget/my_text_field_widget.dart';
import 'package:mood_prints/view/widget/my_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreatePassword extends StatelessWidget {
  var ctrl = Get.find<AuthClientController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: simpleAppBar(
        title: 'Reset Password',
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
                  title: 'Enter New Password',
                  subTitle: 'Please enter something you will remember',
                ),
                Obx(
                  ()=> MyTextField(
                    controller: ctrl.passwordController,
                    hintText: 'Password',
                    suffix: InkWell(
                      onTap: (){
                        ctrl.passwordVisibityMethod();
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            Assets.imagesVisibility,
                            height: 20,
                          ),
                        ],
                      ),
                    ),
                    isObSecure: ctrl.passwordVisibility.value,
                  
                  ),
                ),
                // MyTextField(
                //   hintText: 'Repeat Password',
                //   suffix: Column(
                //     mainAxisAlignment: MainAxisAlignment.center,
                //     children: [
                //       Image.asset(
                //         Assets.imagesVisibility,
                //         height: 20,
                //       ),
                //     ],
                //   ),
                //   isObSecure: true,
                // ),
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

                    ctrl.ResetPasswordApi(otpCode: ctrl.otpCode , email: ctrl.emailController.text.trim(), newPassword: ctrl.passwordController.text.trim() , widget: _SuccessDialog());


                    // Get.dialog(_SuccessDialog());
                  },
                  buttonText: 'Confirm',
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
  const _SuccessDialog();

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
                  height: 118,
                ),
                MyText(
                  paddingTop: 24,
                  text: 'Password changed',
                  size: 20,
                  color: kSecondaryColor,
                  weight: FontWeight.bold,
                  textAlign: TextAlign.center,
                  paddingBottom: 14,
                ),
                MyText(
                  text: 'Your password has been changed successfully',
                  size: 14,
                  color: kGreyColor,
                  lineHeight: 1.5,
                  paddingLeft: 10,
                  paddingRight: 10,
                  textAlign: TextAlign.center,
                  paddingBottom: 20,
                ),
                MyButton(
                  buttonText: 'Continue',
                  onTap: () {
                    Get.back();
                    Get.offAll(() => Login());
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
