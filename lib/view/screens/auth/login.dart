import 'package:mood_prints/constants/app_colors.dart';
import 'package:mood_prints/constants/app_images.dart';
import 'package:mood_prints/constants/app_sizes.dart';
import 'package:mood_prints/controller/auth/auth_client_controller.dart';
import 'package:mood_prints/view/screens/auth/forgot_pass/forgot_password.dart';
import 'package:mood_prints/view/screens/auth/sign_up/sign_up.dart';
import 'package:mood_prints/view/widget/custom_app_bar_widget.dart';
import 'package:mood_prints/view/widget/custom_check_box_widget.dart';
import 'package:mood_prints/view/widget/headings_widget.dart';
import 'package:mood_prints/view/widget/my_button_widget.dart';
import 'package:mood_prints/view/widget/my_text_field_widget.dart';
import 'package:mood_prints/view/widget/my_text_widget.dart';
import 'package:mood_prints/view/widget/social_login_%20widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Login extends StatelessWidget {
  final ctrl = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: logoAppBar(),
      body: ListView(
        shrinkWrap: true,
        physics: BouncingScrollPhysics(),
        padding: AppSizes.DEFAULT,
        children: [
          AuthHeading(
            title: 'Login',
            subTitle:
                'Login to your account to discover and book the best photographers effortlessly.',
          ),
          MyTextField(
            controller: ctrl.emailController,
            labelText: 'Email Address',
            hintText: 'Your email address...',
          ),
          MyTextField(
            controller: ctrl.passwordController,
            labelText: 'Password',
            hintText: 'Your password...',
            suffix: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  Assets.imagesVisibility,
                  height: 20,
                ),
              ],
            ),
            isObSecure: true,
            marginBottom: 12.0,
          ),
          Row(
            children: [
              CustomCheckBox(
                isActive: false,
                onTap: () {},
              ),
              Expanded(
                child: MyText(
                  paddingLeft: 8,
                  text: 'Remember me ',
                  size: 14,
                  weight: FontWeight.w500,
                ),
              ),
              MyText(
                onTap: () => Get.to(() => ForgotPassword()),
                text: 'Forgot password?',
                size: 14,
                weight: FontWeight.w600,
                textAlign: TextAlign.end,
                color: kQuaternaryColor,
              ),
            ],
          ),
          SizedBox(
            height: 16,
          ),
          MyButton(
            onTap: () {
              ctrl.loginMethod(
                  email: ctrl.emailController.text.trim(),
                  password: ctrl.passwordController.text.trim());
              // Get.to(() => TherapistNavBar());
            },
            buttonText: 'Login',
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
                  onTap: () {},
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
                text: 'Don’t have an account? ',
                weight: FontWeight.w500,
              ),
              MyText(
                onTap: () => Get.to(() => SignUp()),
                text: 'Register',
                color: kQuaternaryColor,
                decoration: TextDecoration.underline,
                weight: FontWeight.w600,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
