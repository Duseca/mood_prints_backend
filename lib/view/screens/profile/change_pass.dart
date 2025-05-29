import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mood_prints/constants/app_colors.dart';
import 'package:mood_prints/constants/app_images.dart';
import 'package:mood_prints/constants/app_sizes.dart';
import 'package:mood_prints/constants/loading_animation.dart';
import 'package:mood_prints/controller/client/auth/auth_client_controller.dart';
import 'package:mood_prints/controller/client/profile/profile_controller.dart';
import 'package:mood_prints/view/widget/custom_app_bar_widget.dart';
import 'package:mood_prints/view/widget/my_button_widget.dart';
import 'package:mood_prints/view/widget/my_text_field_widget.dart';
import 'package:mood_prints/view/widget/my_text_widget.dart';

class ChangePass extends StatelessWidget {
  ChangePass({super.key});
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final loginCtrl = Get.find<AuthClientController>();
  final ctrl = Get.find<ProfileController>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Scaffold(
        appBar: simpleAppBar(
          title: 'Change password',
        ),
        body: Obx(
          () => Column(
            children: [
              Expanded(
                child: ListView(
                  shrinkWrap: true,
                  padding: AppSizes.DEFAULT,
                  physics: BouncingScrollPhysics(),
                  children: [
                    MyTextField(
                      controller: ctrl.oldPasswordController,
                      labelText: 'Old Password',
                      hintText: 'Your password...',
                      suffix: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () {
                              log('work');
                              ctrl.passwordVisibityMethod(ctrl.visiblityOld);
                            },
                            child: Image.asset(
                              Assets.imagesVisibility,
                              height: 20,
                            ),
                          ),
                        ],
                      ),
                      isObSecure: ctrl.visiblityOld.value,
                      validator: validatePassword,
                    ),
                    MyTextField(
                      controller: ctrl.newPasswordController,
                      labelText: 'Create New Password',
                      hintText: 'Your password...',
                      suffix: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () {
                              log('work');
                              ctrl.passwordVisibityMethod(ctrl.visiblityNew);
                            },
                            child: Image.asset(
                              Assets.imagesVisibility,
                              height: 20,
                            ),
                          ),
                        ],
                      ),
                      isObSecure: ctrl.visiblityNew.value,
                      validator: validatePassword,
                    ),
                    MyTextField(
                      controller: ctrl.confirmPasswordController,
                      labelText: 'Confirm Password',
                      hintText: 'Your password...',
                      suffix: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () {
                              log('work');
                              ctrl.passwordVisibityMethod(
                                  ctrl.visiblityConfrim);
                            },
                            child: Image.asset(
                              Assets.imagesVisibility,
                              height: 20,
                            ),
                          ),
                        ],
                      ),
                      isObSecure: ctrl.visiblityConfrim.value,
                      validator: validatePassword,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: AppSizes.DEFAULT,
                child: MyButton(
                  buttonText: 'Save changes',
                  onTap: () {
                    // Get.dialog(PasswordChangeDialog(
                    //   message: '',
                    // ));

                    if (formKey.currentState!.validate()) {
                      if (ctrl.newPasswordController.text.trim() ==
                          ctrl.confirmPasswordController.text.trim()) {
                        ctrl.changePassword(
                            oldPassword: ctrl.oldPasswordController.text.trim(),
                            newPassword: ctrl.newPasswordController.text.trim(),
                            confrimPassword:
                                ctrl.confirmPasswordController.text.trim());
                      } else {
                        displayToast(
                            msg:
                                "Your new password does not match the confirm password.");
                      }
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PasswordChangeDialog extends StatelessWidget {
  final String message;
  const PasswordChangeDialog({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Material(
          color: Colors.transparent,
          child: Container(
            // height: 200,
            margin: AppSizes.DEFAULT,
            padding: AppSizes.DEFAULT,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: kPrimaryColor,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                MyText(
                  text: 'Password Updated',
                  size: 16,
                  textAlign: TextAlign.center,
                  weight: FontWeight.w600,
                ),
                MyText(
                  textAlign: TextAlign.center,
                  paddingTop: 6,
                  text: '$message',
                  size: 13,
                  color: kGreyColor,
                ),
                SizedBox(
                  height: 20,
                ),
                Expanded(
                  child: MyButton(
                    buttonText: 'Done',
                    onTap: () {
                      Get.close(2);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
