import 'dart:developer';
import 'package:mood_prints/constants/app_colors.dart';
import 'package:mood_prints/constants/app_images.dart';
import 'package:mood_prints/constants/app_sizes.dart';
import 'package:mood_prints/constants/loading_animation.dart';
import 'package:mood_prints/controller/client/auth/auth_client_controller.dart';
import 'package:mood_prints/view/screens/auth/login.dart';
import 'package:mood_prints/view/widget/custom_app_bar_widget.dart';
import 'package:mood_prints/view/widget/custom_check_box_widget.dart';
import 'package:mood_prints/view/widget/headings_widget.dart';
import 'package:mood_prints/view/widget/my_button_widget.dart';
import 'package:mood_prints/view/widget/my_text_field_widget.dart';
import 'package:mood_prints/view/widget/my_text_widget.dart';
import 'package:mood_prints/view/widget/social_login_%20widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class ClientSignUp extends StatelessWidget {
  final String type;
  ClientSignUp({Key? key, required this.type}) : super(key: key);

  final ctrl = Get.find<AuthClientController>();
  GlobalKey<FormState> formKey2 = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    log("I am a $type");
    return Form(
      key: formKey2,
      child: Scaffold(
        appBar: logoAppBar(),
        body: ListView(
          shrinkWrap: true,
          physics: BouncingScrollPhysics(),
          padding: AppSizes.DEFAULT,
          children: [
            AuthHeading(
              title: 'Signup',
              subTitle:
                  'Create your account to discover and book the best photographers effortlessly.',
            ),
            MyTextField(
                controller: ctrl.fullNameController,
                labelText: 'Full Name',
                hintText: 'Your full name here...',
                validator: validateName),
            MyTextField(
              controller: ctrl.emailController,
              labelText: 'Email Address',
              hintText: 'Your email address...',
              validator: validateEmail,
            ),
            Obx(
              () => MyTextField(
                isObSecure: ctrl.passwordVisibility.value,
                controller: ctrl.passwordController,
                labelText: 'Create Password',
                hintText: 'Your password...',
                validator: validatePassword,
                suffix: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        ctrl.passwordVisibityMethod();
                        log('work');
                      },
                      child: Image.asset(
                        Assets.imagesVisibility,
                        height: 20,
                      ),
                    ),
                  ],
                ),
                marginBottom: 12.0,
              ),
            ),
            Row(
              children: [
                Obx(
                  () => CustomCheckBox(
                    isActive: ctrl.acceptTermsAndCondition.value,
                    onTap: () {
                      ctrl.checkBoxValue();
                    },
                  ),
                ),
                MyText(
                  paddingLeft: 8,
                  text: 'I accept the ',
                  size: 13,
                  weight: FontWeight.w500,
                ),
                MyText(
                  text: 'Terms & Conditions',
                  size: 13,
                  weight: FontWeight.w600,
                  color: kQuaternaryColor,
                  decoration: TextDecoration.underline,
                ),
              ],
            ),
            SizedBox(
              height: 16,
            ),
            MyButton(
              onTap: () {
                if (formKey2.currentState!.validate()) {
                  if (ctrl.acceptTermsAndCondition == true) {
                    ctrl.signUpClientMethod(
                        email: ctrl.emailController.text.trim(),
                        password: ctrl.passwordController.text.trim(),
                        fullName: ctrl.fullNameController.text.trim(),
                        userType: type);
                  } else {
                    displayToast(
                        msg:
                            "Please accept the terms and conditions to proceed.");
                  }
                }

                // Get.to(() => ClientCompleteProfile());
                // Get.to(() => EmailVerification());
              },
              buttonText: 'Continue',
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(0, 21.82, 0, 20.77),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 0.9,
                      color: kBorderColor,
                    ),
                  ),
                  MyText(
                    text: 'Or',
                    size: 12,
                    color: kTertiaryColor,
                    paddingLeft: 16.05,
                    paddingRight: 16.05,
                  ),
                  Expanded(
                    child: Container(
                      height: 0.9,
                      color: kBorderColor,
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: SocialLogin(
                    onTap: () {
                      ctrl.googleAuth(userType: type);
                      // ctrl.isUserExistWithEmail(email: 'mood1@gmail.com');
                    },
                    icon: Assets.imagesGoogle,
                    title: 'Google',
                  ),
                ),
                SizedBox(
                  width: 13.79,
                ),
                Expanded(
                  child: SocialLogin(
                    onTap: () {},
                    icon: Assets.imagesApple,
                    title: 'Apple',
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MyText(
                  text: 'Already have an account? ',
                  weight: FontWeight.w500,
                ),
                MyText(
                  onTap: () => Get.offAll(() => Login()),
                  text: 'Login',
                  color: kQuaternaryColor,
                  decoration: TextDecoration.underline,
                  weight: FontWeight.w600,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
