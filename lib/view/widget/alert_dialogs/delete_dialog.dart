import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mood_prints/constants/app_colors.dart';
import 'package:mood_prints/constants/app_sizes.dart';
import 'package:mood_prints/view/widget/my_button_widget.dart';
import 'package:mood_prints/view/widget/my_text_widget.dart';

class DeleteDialog extends StatelessWidget {
  final VoidCallback? onDeleteTap;
  const DeleteDialog({super.key, this.onDeleteTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Material(
          color: Colors.transparent,
          child: Container(
            padding: AppSizes.DEFAULT,
            margin: AppSizes.DEFAULT,
            decoration: BoxDecoration(
              color: kWhiteColor,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              children: [
                MyText(
                  text: 'Are you sure you want to delete?',
                  size: 16,
                  weight: FontWeight.w600,
                  paddingBottom: 16,
                ),
                MyText(
                  text: 'All records of this block will be deleted.',
                  size: 14,
                  color: kGreyColor,
                  weight: FontWeight.w400,
                  paddingBottom: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: MyBorderButton(
                        textColor: kGreyColor,
                        bgColor: kLightGreyColor,
                        buttonColor: kBorderColor,
                        buttonText: 'Cancel',
                        onTap: () {
                          Get.back();
                        },
                      ),
                    ),
                    SizedBox(
                      width: 12,
                    ),
                    Expanded(
                      child: MyButton(
                          buttonText: 'Delete',
                          bgColor: kRedColor,
                          onTap: onDeleteTap),
                    ),
                  ],
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
