import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mood_prints/constants/app_colors.dart';
import 'package:mood_prints/constants/app_images.dart';
import 'package:mood_prints/constants/app_sizes.dart';
import 'package:mood_prints/constants/loading_animation.dart';
import 'package:mood_prints/controller/client/profile/profile_controller.dart';
import 'package:mood_prints/core/utils/validators.dart';
import 'package:mood_prints/model/client_model/user_model.dart';
import 'package:mood_prints/services/date_formator/general_service.dart';
import 'package:mood_prints/services/user/user_services.dart';
import 'package:mood_prints/view/widget/common_image_view_widget.dart';
import 'package:mood_prints/view/widget/custom_app_bar_widget.dart';
import 'package:mood_prints/view/widget/custom_bottom_sheet_widget.dart';
import 'package:mood_prints/view/widget/custom_drop_down_widget.dart';
import 'package:mood_prints/view/widget/dob_picker.dart';
import 'package:mood_prints/view/widget/my_button_widget.dart';
import 'package:mood_prints/view/widget/my_text_field_widget.dart';
import 'package:mood_prints/view/widget/my_text_widget.dart';

import '../../widget/intel_phone_field_widget.dart';

class EditProfile extends StatefulWidget {
  // UserModel? model;
  EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  var ctrl = Get.find<ProfileController>();
  var userModel = UserModel();

  @override
  void initState() {
    super.initState();

    var userModel = UserService.instance.userModel.value;

    if (userModel.authProvider == 'google') {
      ctrl.fullNameController.text = userModel.fullName!;
      ctrl.completePhoneNumber = userModel.phoneNumber ?? '';

      ctrl.bioController.text = userModel.bio != null ? userModel.bio! : '';
      ctrl.selectedGenderValue.value = userModel.gender ?? '';
      if (ctrl.selectedGenderValue.value.isEmpty) {
        ctrl.selectedGenderValue.value = "male";
      }
    } else {
      ctrl.fullNameController.text = userModel.fullName!;
      ctrl.completePhoneNumber = userModel.phoneNumber ?? '';
      ctrl.dob.value = DateTime.parse(userModel.dob!);
      ctrl.bioController.text = userModel.bio!;
      ctrl.selectedGenderValue.value = userModel.gender ?? '';
      if (ctrl.selectedGenderValue.value.isEmpty) {
        ctrl.selectedGenderValue.value = "male";
      }
    }

    ctrl.emergencyEmailController.text = userModel.emergencyEmail ?? "";
    ctrl.emergencyNameController.text = userModel.emergencyName ?? "";
    ctrl.emergencyFullPhoneNumber = userModel.emergencyPhone ?? "";
    ctrl.signatureController.text = userModel.signatureText ?? "";

    log('--------- VVRR --------${ctrl.selectedGenderValue.value} :: ${userModel.gender}');
  }

  final _formKey = GlobalKey<FormState>();

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
      body: Form(
        key: _formKey,
        child: Column(
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

                  Obx(
                    () => IntlPhoneFieldWidget(
                      initialCountryCode: ctrl.initialCountryCodeValue.value,
                      controller: ctrl.phoneNumberController,
                      onChanged: (v) {
                        ctrl.completePhoneNumber = v.completeNumber;

                        log("onChanged -------> ${ctrl.completePhoneNumber}");
                      },
                    ),
                  ),
                  SizedBox(height: 16.0),

                  Obx(
                    () => (ctrl.selectedGenderValue.value == 'Male')
                        ? CustomDropDown(
                            labelText: 'Gender',
                            hint: ctrl.selectedGenderValue.value,
                            items: ['male', 'female', 'other'],
                            selectedValue: ctrl.selectedGenderValue.value,
                            onChanged: (v) {
                              ctrl.selectedGenderValue.value = v;
                            },
                          )
                        : CustomDropDown(
                            labelText: 'Gender',
                            hint: ctrl.selectedGenderValue.value,
                            items: ['female', 'male', 'other'],
                            selectedValue: ctrl.selectedGenderValue.value,
                            onChanged: (v) {
                              ctrl.selectedGenderValue.value = v;
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
                    controller: ctrl.emergencyNameController,
                    labelText: 'Emergency Contact’s Full Name',
                    hintText: 'Emergency Contact’s Full Name',
                    validator: (value) {
                      return ValidationService.instance
                          .userNameValidator(value);
                    },
                  ),
                  MyTextField(
                    controller: ctrl.emergencyEmailController,
                    labelText: 'Emergency Contact’s Email',
                    hintText: 'Emergency Contact’s Email',
                    validator: (value) {
                      return ValidationService.instance.emailValidator(value);
                    },
                  ),
                  Obx(
                    () => IntlPhoneFieldWidget(
                      label: "Emergency Contact’s Phone Number",
                      initialCountryCode:
                          ctrl.initialEmergencyCountryCode.value,
                      controller: ctrl.emergencyPhoneNumberController,
                      onChanged: (v) {
                        ctrl.emergencyFullPhoneNumber = v.completeNumber;

                        log("onChanged -------> ${ctrl.completePhoneNumber}");
                      },
                    ),
                  ),
                  MyTextField(
                    controller: ctrl.signatureController,
                    labelText: "Signature",
                    hintText: "Signature",
                    validator: (p0) {
                      return ValidationService.instance.emptyValidator(p0);
                    },
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
                  if (_formKey.currentState!.validate()) {
                    if (ctrl.fullNameController.text.trim() ==
                        ctrl.emergencyNameController.text.trim()) {
                      displayToast(
                        msg:
                            "Emergency contact is not same, try different emergency name",
                      );
                      return;
                    }

                    if (userModel.email ==
                        ctrl.emergencyEmailController.text.trim()) {
                      displayToast(
                        msg:
                            "Emergency email cannot be the same as yours. Try again",
                      );
                      return;
                    }

                    log("User-ID: ${UserService.instance.userModel.value.id.toString()}");
                    ctrl.updateUserProfile(
                        userId:
                            UserService.instance.userModel.value.id.toString(),
                        oldProfileImageUrl: UserService
                            .instance.userModel.value.image
                            .toString());
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
