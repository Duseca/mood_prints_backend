import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mood_prints/constants/app_colors.dart';
import 'package:mood_prints/constants/app_images.dart';
import 'package:mood_prints/constants/app_sizes.dart';
import 'package:mood_prints/controller/client/auth/auth_client_controller.dart';
import 'package:mood_prints/main.dart';
import 'package:mood_prints/services/date_formator/general_service.dart';
import 'package:mood_prints/view/widget/common_image_view_widget.dart';
import 'package:mood_prints/view/widget/custom_app_bar_widget.dart';
import 'package:mood_prints/view/widget/custom_bottom_sheet_widget.dart';
import 'package:mood_prints/view/widget/custom_drop_down_widget.dart';
import 'package:mood_prints/view/widget/dob_picker.dart';
import 'package:mood_prints/view/widget/my_button_widget.dart';
import 'package:mood_prints/view/widget/my_text_field_widget.dart';
import 'package:mood_prints/view/widget/my_text_widget.dart';

class ClientCompleteProfile extends StatelessWidget {
  ClientCompleteProfile({
    super.key,
  });

  final ctrl = Get.find<AuthClientController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: simpleAppBar(
        title: 'Profile Completion',
        actions: [
          // Center(
          //   child: MyText(
          //     text: 'SKip',
          //     color: kSecondaryColor,
          //   ),
          // ),
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
                      // Obx(() => InkWell(
                      //       onTap: () async {
                      //         await ctrl.profileImagePicker();
                      //       },
                      //       child:

                      //     )),

                      // InkWell(onTap: () {
                      //   ctrl.profileImagePicker();
                      // }, child: Obx(() {
                      //   return (ctrl.selectedProfileImage.value != null)
                      //       ? CommonImageView(
                      //           height: 128,
                      //           width: 128,
                      //           radius: 100.0,
                      //           file: File(ctrl.selectedProfileImage.value!),
                      //         )
                      //       : CommonImageView(
                      //           height: 128,
                      //           width: 128,
                      //           radius: 100.0,
                      //           url: dummyImg,
                      //         );
                      // })),

                      InkWell(
                        onTap: () async {
                          await ctrl.profileImagePicker();
                        },
                        child: Obx(() {
                          return (ctrl.selectedProfileImage.value != null &&
                                  ctrl.selectedProfileImage.value!.isNotEmpty)
                              ? CommonImageView(
                                  height: 128,
                                  width: 128,
                                  radius: 100.0,
                                  file: File(ctrl.selectedProfileImage.value!),
                                )
                              : CommonImageView(
                                  height: 128,
                                  width: 128,
                                  radius: 100.0,
                                  url: dummyImg,
                                );
                        }),
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
                  controller: ctrl.fullNameController,
                  marginBottom: 6.0,
                  labelText: 'Username',
                  hintText: 'Username',
                ),
                MyText(
                  text: 'Note: Username can’t be changed once created.',
                  size: 10,
                  color: kGreyColor2,
                  weight: FontWeight.w500,
                  paddingBottom: 16,
                ),
                PhoneField(
                  controller: ctrl.phoneNumberController,
                  onPhoneNumberChanged: (value) {
                    ctrl.FullPhoneNumber = value;
                    log("Full Phone Number: ${ctrl.FullPhoneNumber}");
                  },
                ),

                Obx(
                  () => CustomDropDown(
                    labelText: 'Gender',
                    hint: '${ctrl.selectedGenderValue.value}',
                    items: ctrl.gender,
                    selectedValue: '${ctrl.selectedGenderValue.value}',
                    onChanged: (value) {
                      ctrl.selectedGenderValue.value = value;
                    },
                  ),
                ),
                Obx(
                  () => MyTextField(
                    isReadOnly: true,
                    labelText: 'Date of Birth',
                    hintText: (ctrl.dob.value != null)
                        ? DateTimeService.instance
                            .getDateUsFormat(ctrl.dob.value!)
                        : "Select date",
                    suffix: InkWell(
                      onTap: () {
                        Get.bottomSheet(
                          isScrollControlled: true,
                          CustomBottomSheet(
                            height: Get.height * 0.49,
                            child: DobPicker(
                              initialDateTime: ctrl.dob.value,
                              onDateTimeChanged: (dateTime) {
                                ctrl.dob.value = dateTime;

                                log("date: ${ctrl.dob.value}");
                              },
                              onTap: () {
                                Get.back();
                              },
                            ),
                          ),
                        );
                      },
                      child: Column(
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
                  ),
                ),

                // --------- If User type is Therapist than display these fields -------------

                (ctrl.currentUserType == 'therapist')
                    ? Column(
                        children: [
                          MyTextField(
                            controller: ctrl.countryController,
                            labelText: 'Country',
                          ),
                          MyTextField(
                            controller: ctrl.stateController,
                            labelText: 'State',
                          ),
                          MyTextField(
                            controller: ctrl.cityController,
                            labelText: 'City',
                          ),
                        ],
                      )
                    : SizedBox.shrink(),

                MyTextField(
                  controller: ctrl.BioController,
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
                ctrl.profileCompletionMethod();
              },
            ),
          ),
        ],
      ),
    );
  }
}
