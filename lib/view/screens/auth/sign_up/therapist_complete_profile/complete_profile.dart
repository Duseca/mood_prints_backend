import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mood_prints/constants/app_colors.dart';
import 'package:mood_prints/constants/app_images.dart';
import 'package:mood_prints/constants/app_sizes.dart';
import 'package:mood_prints/controller/client/auth/auth_client_controller.dart';
import 'package:mood_prints/main.dart';
import 'package:mood_prints/view/widget/common_image_view_widget.dart';
import 'package:mood_prints/view/widget/custom_app_bar_widget.dart';
import 'package:mood_prints/view/widget/custom_drop_down_widget.dart';
import 'package:mood_prints/view/widget/my_button_widget.dart';
import 'package:mood_prints/view/widget/my_text_field_widget.dart';
import 'package:mood_prints/view/widget/my_text_widget.dart';

class CompleteProfile extends StatelessWidget {
  const CompleteProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: simpleAppBar(
        title: 'Profile Completion',
        actions: [
          Center(
            child: MyText(
              text: 'SKip',
              color: kSecondaryColor,
            ),
          ),
          SizedBox(
            width: 20,
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ListView(
              shrinkWrap: true,
              padding: AppSizes.DEFAULT,
              physics: BouncingScrollPhysics(),
              children: [
                Center(
                  child: Stack(
                    children: [
                      CommonImageView(
                        height: 128,
                        width: 128,
                        radius: 100.0,
                        url: dummyImg,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          height: 32,
                          width: 32,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: kWhiteColor,
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 10,
                                offset: Offset(0, 4),
                                color: kBorderColor.withOpacity(0.16),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Image.asset(
                              Assets.imagesAddImage,
                              height: 18,
                              color: kSecondaryColor,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                MyTextField(
                  marginBottom: 6.0,
                  labelText: 'Username',
                ),
                MyText(
                  text: 'Note: Username can’t be changed once created.',
                  size: 10,
                  color: kGreyColor2,
                  weight: FontWeight.w500,
                  paddingBottom: 16,
                ),
                PhoneField(),
                CustomDropDown(
                  labelText: 'Gender',
                  hint: 'Select',
                  items: [
                    'Select',
                    'Male',
                    'Female',
                  ],
                  selectedValue: 'Select',
                  onChanged: (v) {},
                ),
                MyTextField(
                  labelText: 'Date of Birth',
                  suffix: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        Assets.imagesCalendarA,
                        height: 20,
                        color: kSecondaryColor,
                      ),
                    ],
                  ),
                ),
                MyTextField(
                  labelText: 'Country',
                ),
                MyTextField(
                  labelText: 'State',
                ),
                MyTextField(
                  labelText: 'City',
                ),
                MyTextField(
                  labelText: 'Bio',
                ),
              ],
            ),
          ),
          Padding(
            padding: AppSizes.DEFAULT,
            child: MyButton(
              buttonText: 'Continue',
              onTap: () {
                // Get.to(() => PhoneVerification());
                Get.find<AuthController>().profileCompletionMethod();
              },
            ),
          ),
        ],
      ),
    );
  }
}
