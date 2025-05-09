import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mood_prints/constants/app_colors.dart';
import 'package:mood_prints/constants/app_images.dart';
import 'package:mood_prints/constants/app_sizes.dart';
import 'package:mood_prints/controller/client/profile/profile_controller.dart';
import 'package:mood_prints/model/client_model/user_model.dart';
import 'package:mood_prints/services/date_formator/general_service.dart';
import 'package:mood_prints/services/user/user_services.dart';
import 'package:mood_prints/view/widget/common_image_view_widget.dart';
import 'package:mood_prints/view/widget/custom_app_bar_widget.dart';
import 'package:mood_prints/view/widget/custom_bottom_sheet_widget.dart';
import 'package:mood_prints/view/widget/dob_picker.dart';
import 'package:mood_prints/view/widget/my_button_widget.dart';
import 'package:mood_prints/view/widget/my_text_field_widget.dart';
import 'package:mood_prints/view/widget/my_text_widget.dart';

import '../../widget/intel_phone_field_widget.dart';

class EditProfile extends StatefulWidget {
  // UserModel? model;
  EditProfile({
    super.key,
  });

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  var ctrl = Get.find<ProfileController>();
  var userModel = UserModel();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    log('--------- VVRR --------');

    var userModel = UserService.instance.userModel.value;

    if (userModel.authProvider == 'google') {
      ctrl.fullNameController.text = userModel.fullName!;
      ctrl.phoneNumberController.text = userModel.phoneNumber ?? '';

      ctrl.bioController.text = userModel.bio != null ? userModel.bio! : '';
    } else {
      ctrl.fullNameController.text = userModel.fullName!;
      ctrl.phoneNumberController.text = userModel.phoneNumber ?? '';
      ctrl.dob.value = DateTime.parse(userModel.dob!);
      ctrl.bioController.text = userModel.bio!;
    }

    ctrl.extractCountryCode('${ctrl.phoneNumberController.text.trim()}');
  }

  @override
  Widget build(BuildContext context) {
    // var userModel = UserService.instance.userModel.value;
    //
    //
    // if (userModel.authProvider == 'google') {
    //   ctrl.fullNameController.text = userModel.fullName!;
    //   ctrl.phoneNumberController.text = userModel.phoneNumber ?? '' ;
    //
    //   ctrl.bioController.text = userModel.bio != null ? userModel.bio! : '';
    // } else {
    //   ctrl.fullNameController.text = userModel.fullName!;
    //   ctrl.phoneNumberController.text = userModel.phoneNumber ?? '' ;
    //   ctrl.dob.value = DateTime.parse(userModel.dob!);
    //   ctrl.bioController.text = userModel.bio!;
    // }
    //
    //
    // ctrl.extractCountryCode('${ctrl.phoneNumberController.text.trim()}');
// setState(() {
//
// });

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
                                  onTap: () {
                                    ctrl.profileImagePicker();
                                  },
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
                    Obx(
                      () => (ctrl.selectedProfileImage.value != null)
                          ? CommonImageView(
                              height: 70,
                              width: 70,
                              radius: 100.0,
                              file: File(ctrl.selectedProfileImage.value!))
                          : CommonImageView(
                              height: 70,
                              width: 70,
                              radius: 100.0,
                              url: UserService.instance.userModel.value.image,
                            ),
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 20),
                  height: 1,
                  color: kBorderColor,
                ),
                MyTextField(
                  controller: ctrl.fullNameController,
                  labelText: 'Full Name',
                  hintText: 'Your full name here...',
                ),

                // MyTextField(
                //   controller: ctrl.emailController,
                //   labelText: 'Email Address',
                //   hintText: 'Your email address...',
                // ),
                // PhoneField(
                //   controller: ctrl.phoneNumberController,
                // ),
                // Obx(
                //   ()=> UpdatedPhoneField(
                //     // initialFlag: ,
                //     initialCountryCode: ctrl.countryCode.value,
                //     controller: ctrl.phoneNumberController,
                //
                //     onPhoneNumberChanged: (value) {
                //       ctrl.completePhoneNumber = value;
                //       log("Complete Phone Number: ${value}");
                //     },
                //   ),
                // ),

                IntlPhoneFieldWidget(
                  initialCountryCode: ctrl.initialCountryCodeValue.value,
                  controller: ctrl.phoneNumberController,
                  onChanged: (v) {
                    ctrl.completePhoneNumber = v.completeNumber;

                    log("onChanged -------> ${ctrl.completePhoneNumber}");
                  },
                ),
                SizedBox(height: 16.0),

                // Obx(
                //   () => CustomDropDown(
                //     labelText: 'Gender',
                //     hint: ctrl.selectedGenderValue.value,
                //     items: ctrl.genderList,
                //     selectedValue: ctrl.selectedGenderValue.value,
                //     onChanged: (v) {
                //       ctrl.selectedGenderValue.value = v;
                //     },
                //   ),
                // ),

                // - Centerd -

                // Obx(
                //   () => CustomDropDown(
                //     labelText: 'Gender',
                //     hint: ctrl.selectedGenderValue.value.isEmpty
                //         ? 'Select Gender'
                //         : ctrl.selectedGenderValue.value,
                //     items: ctrl.genderList,
                //     selectedValue: ctrl.selectedGenderValue.value,

                //     // ctrl.genderList.contains(ctrl.selectedGenderValue.value.toString())
                //     //     ? ctrl.selectedGenderValue.value
                //     //     : null, // Ensure selected value exists in list
                //     onChanged: (v) {
                //       ctrl.selectedGenderValue.value = v;
                //     },
                //   ),
                // ),

                // MyTextField(
                //   labelText: 'Date of Birth',
                //   hintText: (ctrl.dob.value != null)
                //       ? ctrl.dob.value.toString()
                //       : 'Select date of birth',
                //   suffix: Column(
                //     mainAxisAlignment: MainAxisAlignment.center,
                //     children: [
                //       Image.asset(
                //         Assets.imagesCalendarA,
                //         height: 20,
                //         color: kSecondaryColor,
                //       ),
                //     ],
                //   ),
                // ),

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
                              initialDateTime: DateTime.now(),
                              onDateTimeChanged: (dateTime) {
                                ctrl.dob.value = dateTime;

                                log("date: ${ctrl.dob.value}");
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
                MyTextField(
                  controller: ctrl.bioController,
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
              onTap: () {
                ctrl.updateUserProfile(
                    userId: userModel.id!,
                    oldProfileImageUrl: userModel.image!);
              },
            ),
          ),
        ],
      ),
    );
  }
}
