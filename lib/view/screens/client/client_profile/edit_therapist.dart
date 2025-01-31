import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mood_prints/constants/app_colors.dart';
import 'package:mood_prints/constants/app_images.dart';
import 'package:mood_prints/constants/app_sizes.dart';
import 'package:mood_prints/controller/client/profile/profile_controller.dart';
import 'package:mood_prints/view/screens/client/client_profile/add_new_therapist.dart';
import 'package:mood_prints/view/widget/common_image_view_widget.dart';
import 'package:mood_prints/view/widget/custom_app_bar_widget.dart';
import 'package:mood_prints/view/widget/my_button_widget.dart';
import 'package:mood_prints/view/widget/my_text_widget.dart';

class EditTherapist extends StatelessWidget {
  bool haveTherapist;

  EditTherapist({super.key, this.haveTherapist = false});

  final ctrl = Get.find<ProfileController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: simpleAppBar(
        title: 'Therapist Details',
      ),
      body: Column(
        children: [
          SizedBox(height: 15),
          (haveTherapist)
              ? Column(
                  children: [
                    CommonImageView(
                      height: 100,
                      width: 100,
                      radius: 100,
                      imagePath: Assets.imagesProfileImageUser,
                    ),
                    SizedBox(height: 15),
                    MyText(
                      text: 'Asclad son of ola',
                      size: 15,
                      weight: FontWeight.w600,
                    ),
                    MyText(
                      paddingTop: 5,
                      text: 'example@gmail.com',
                      size: 15,
                      // weight: FontWeight.w600,
                    ),
                    MyText(
                      paddingBottom: 20,
                      paddingTop: 5,
                      text: '03150965522',
                      size: 15,
                      // weight: FontWeight.w600,
                    ),
                  ],
                )
              : Column(
                  children: [
                    Icon(
                      Icons.new_releases_rounded,
                      color: kHintColor,
                      size: 70,
                    ),
                    MyText(
                      paddingTop: 15,
                      text: 'No Therapist found.',
                      size: 15,
                      weight: FontWeight.w600,
                      color: kHintColor,
                    ),
                  ],
                ),
          SizedBox(height: 25),
          (haveTherapist)
              ? Padding(
                  padding: AppSizes.DEFAULT,
                  child: MyButton(
                    buttonText: 'Edit Therapist',
                    onTap: () {
                      Get.to(() => AddNewTherapist());
                    },
                  ),
                )
              : Padding(
                  padding: AppSizes.DEFAULT,
                  child: MyButton(
                    buttonText: 'Add New Therapist',
                    onTap: () {
                      // ctrl.getAllTherapist();

                      Get.to(() => AddNewTherapist());
                    },
                  ),
                ),
        ],
      ),
    );
  }
}

class _DeleteTherapist extends StatelessWidget {
  const _DeleteTherapist({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Material(
          color: Colors.transparent,
          child: Container(
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
                  text: 'Remove Therapist',
                  size: 16,
                  textAlign: TextAlign.center,
                  weight: FontWeight.w600,
                ),
                MyText(
                  textAlign: TextAlign.center,
                  paddingTop: 6,
                  text: 'Are you sure you want to remove?',
                  size: 13,
                  color: kGreyColor,
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Expanded(
                      child: MyButton(
                        textColor: kTertiaryColor,
                        bgColor: kWhiteColor,
                        buttonText: 'No',
                        onTap: () {},
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: MyButton(
                        bgColor: kRedColor,
                        buttonText: 'Remove',
                        onTap: () {},
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}



 // ----------- Front-end Code -------------

          // Expanded(
          //   child: ListView(
          //     shrinkWrap: true,
          //     padding: AppSizes.DEFAULT,
          //     physics: BouncingScrollPhysics(),
          //     children: [

          //       // MyTextField(
          //       //   labelText: 'Therapist First Name',
          //       // ),
          //       // MyTextField(
          //       //   labelText: 'Therapist Last Name',
          //       // ),
          //       // MyTextField(
          //       //   labelText: 'Country',
          //       // ),
          //       // MyTextField(
          //       //   labelText: 'State',
          //       // ),
          //       // MyTextField(
          //       //   labelText: 'City',
          //       // ),
          //       // MyButton(
          //       //   bgColor: kRedColor,
          //       //   buttonText: 'Remove Therapist',
          //       //   onTap: () {
          //       //     Get.dialog(_DeleteTherapist());
          //       //   },
          //       // ),
          //     ],
          //   ),
          // ),