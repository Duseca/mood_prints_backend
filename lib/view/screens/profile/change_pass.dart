import 'package:flutter/material.dart';
import 'package:mood_prints/constants/app_images.dart';
import 'package:mood_prints/constants/app_sizes.dart';
import 'package:mood_prints/view/widget/custom_app_bar_widget.dart';
import 'package:mood_prints/view/widget/my_button_widget.dart';
import 'package:mood_prints/view/widget/my_text_field_widget.dart';

class ChangePass extends StatelessWidget {
  const ChangePass({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: simpleAppBar(
        title: 'Change password',
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              shrinkWrap: true,
              padding: AppSizes.DEFAULT,
              physics: BouncingScrollPhysics(),
              children: [
                MyTextField(
                  labelText: 'Old Password',
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
                ),
                MyTextField(
                  labelText: 'Create New Password',
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
                ),
                MyTextField(
                  labelText: 'Confirm Password',
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
