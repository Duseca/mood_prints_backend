import 'package:flutter/material.dart';
import 'package:mood_prints/constants/app_colors.dart';
import 'package:mood_prints/constants/app_images.dart';
import 'package:mood_prints/constants/app_sizes.dart';
import 'package:mood_prints/main.dart';
import 'package:mood_prints/view/widget/common_image_view_widget.dart';

import 'package:mood_prints/view/widget/custom_app_bar_widget.dart';
import 'package:mood_prints/view/widget/custom_drop_down_widget.dart';
import 'package:mood_prints/view/widget/my_button_widget.dart';
import 'package:mood_prints/view/widget/my_text_field_widget.dart';
import 'package:mood_prints/view/widget/my_text_widget.dart';

class EditProfile extends StatelessWidget {
  const EditProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: simpleAppBar(
        title: 'Edit Profile',
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              shrinkWrap: true,
              padding: AppSizes.DEFAULT,
              physics: BouncingScrollPhysics(),
              children: [
                MyText(
                  text: 'Basic Information',
                  size: 18,
                  weight: FontWeight.w700,
                  paddingBottom: 16,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          MyText(
                            text: 'Profile photo',
                            paddingBottom: 4,
                            weight: FontWeight.w700,
                          ),
                          MyText(
                            text: 'Recommended 300 x 300 px',
                            size: 12,
                            color: kQuaternaryColor,
                            weight: FontWeight.w500,
                            paddingBottom: 16,
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: 78,
                                child: MyButton(
                                  height: 30,
                                  radius: 4,
                                  textSize: 12,
                                  weight: FontWeight.w600,
                                  buttonText: 'Change',
                                  onTap: () {},
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    CommonImageView(
                      height: 70,
                      width: 70,
                      radius: 100.0,
                      url: dummyImg,
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 20),
                  height: 1,
                  color: kBorderColor,
                ),
                MyTextField(
                  labelText: 'Full Name',
                  hintText: 'Your full name here...',
                ),
                MyTextField(
                  labelText: 'Email Address',
                  hintText: 'Your email address...',
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
                  labelText: 'Bio',
                  maxLines: 4,
                ),
              ],
            ),
          ),
          Padding(
            padding: AppSizes.DEFAULT,
            child: MyButton(
              buttonText: 'Save changes',
              onTap: () {},
            ),
          ),
        ],
      ),
    );
  }
}
