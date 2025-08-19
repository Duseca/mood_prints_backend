import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mood_prints/constants/app_colors.dart';
import 'package:mood_prints/constants/app_images.dart';
import 'package:mood_prints/constants/app_sizes.dart';
import 'package:mood_prints/constants/loading_animation.dart';
import 'package:mood_prints/controller/client/auth/auth_client_controller.dart';
import 'package:mood_prints/core/enums/user_age_status.dart';
import 'package:mood_prints/core/enums/user_type.dart';
import 'package:mood_prints/services/date_formator/general_service.dart';
import 'package:mood_prints/view/screens/privacy_policy/general_terms.dart';
import 'package:mood_prints/view/screens/privacy_policy/pp_page.dart';
import 'package:mood_prints/view/screens/privacy_policy/privacy_policy_page.dart';
import 'package:mood_prints/view/widget/custom_app_bar_widget.dart';
import 'package:mood_prints/view/widget/custom_bottom_sheet_widget.dart';
import 'package:mood_prints/view/widget/custom_check_box_widget.dart';
import 'package:mood_prints/view/widget/dob_picker.dart';
import 'package:mood_prints/view/widget/my_button_widget.dart';
import 'package:mood_prints/view/widget/my_text_field_widget.dart';
import 'package:mood_prints/view/widget/my_text_widget.dart';

class SignUpSecondPage extends StatelessWidget {
  final String type;
  SignUpSecondPage({super.key, required this.type});

  final ctrl = Get.find<AuthClientController>();
  DateTime? dob, parentDob;

  GlobalKey<FormState> formKey2 = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: logoAppBar(),
      body: Padding(
        padding: AppSizes.DEFAULT,
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            children: [
              // ------ if The user type is -> Therapist  ----------

              (type == UserType.therapist.name)
                  ? Column(
                      children: [
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
                                        // ctrl.dob.value = dateTime;
                                        dob = dateTime;
                                      },
                                      onTap: () {
                                        ctrl.dob.value = dob;

                                        log("User Age Status: ---> ${ctrl.dob}");

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
                        MyTextField(
                          controller: ctrl.npiNumberController,
                          labelText: 'Npi Number',
                          hintText: 'Npi Number',
                        ),
                        MyTextField(
                          controller: ctrl.emergencyNameController,
                          labelText: 'Emergency Contact’s Full Name',
                          hintText: 'Emergency Contact’s Full Name',
                        ),
                        MyTextField(
                          controller: ctrl.emergencyEmailController,
                          labelText: 'Emergency Contact’s Email',
                          hintText: 'Emergency Contact’s Email',
                        ),
                        PhoneField(
                          title: "Emergency Contact’s Phone Number”",
                          controller: ctrl.emergencyPhoneNumberController,
                          onPhoneNumberChanged: (value) {
                            ctrl.emergencyFullPhoneNumber = value;
                            log("Full Phone Number: ${ctrl.emergencyFullPhoneNumber}");
                          },
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 10),
                          child: Row(
                            children: [
                              Obx(
                                () => CustomCheckBox(
                                  isActive: ctrl.therapist1.value,
                                  onTap: () {
                                    ctrl.checkBoxToggel(ctrl.therapist1);
                                  },
                                ),
                              ),
                              Expanded(
                                child: MyText(
                                  paddingLeft: 8,
                                  text:
                                      'I have read and agree to the Platform Services Agreement (PSA).',
                                  size: 13,
                                  weight: FontWeight.w500,
                                ),
                              ),
                              // MyText(
                              //   text: 'Terms & Conditions',
                              //   size: 13,
                              //   weight: FontWeight.w600,
                              //   color: kQuaternaryColor,
                              //   decoration: TextDecoration.underline,
                              // ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 10),
                          child: Row(
                            children: [
                              Obx(
                                () => CustomCheckBox(
                                  isActive: ctrl.therapist2.value,
                                  onTap: () {
                                    ctrl.checkBoxToggel(ctrl.therapist2);
                                  },
                                ),
                              ),
                              Expanded(
                                child: MyText(
                                  paddingLeft: 8,
                                  text:
                                      'I have executed and agree to the Business Associate Agreement (BAA).',
                                  size: 13,
                                  weight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 10),
                          child: Row(
                            children: [
                              Obx(
                                () => CustomCheckBox(
                                  isActive: ctrl.therapist3.value,
                                  onTap: () {
                                    ctrl.checkBoxToggel(ctrl.therapist3);
                                  },
                                ),
                              ),
                              Expanded(
                                child: MyText(
                                  paddingLeft: 8,
                                  text:
                                      'I have read and agree to the General Terms of Service.',
                                  size: 13,
                                  weight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 10),
                          child: Row(
                            children: [
                              Obx(
                                () => CustomCheckBox(
                                  isActive: ctrl.therapist4.value,
                                  onTap: () {
                                    ctrl.checkBoxToggel(ctrl.therapist4);
                                  },
                                ),
                              ),
                              Expanded(
                                child: MyText(
                                  paddingLeft: 8,
                                  text:
                                      'I have reviewed and acknowledge the Privacy Policy.',
                                  size: 13,
                                  weight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 10),
                          child: Row(
                            children: [
                              Obx(
                                () => CustomCheckBox(
                                  isActive: ctrl.therapist5.value,
                                  onTap: () {
                                    ctrl.checkBoxToggel(ctrl.therapist5);
                                  },
                                ),
                              ),
                              Expanded(
                                child: MyText(
                                  paddingLeft: 8,
                                  text:
                                      'I acknowledge the HIPAA Notice of Privacy Practices.',
                                  size: 13,
                                  weight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // // ------- Adding ""Services Consent"" 18-Aug-2025 ----------

                        Align(
                            alignment: Alignment.centerLeft,
                            child: MyText(
                              paddingTop: 10,
                              paddingBottom: 15,
                              text: "Services Consent",
                              weight: FontWeight.w700,
                            )),

                        Padding(
                          padding: EdgeInsets.only(bottom: 10),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Obx(
                                    () => CustomCheckBox(
                                      isActive: ctrl.therapist6.value,
                                      onTap: () {
                                        ctrl.checkBoxToggel(ctrl.therapist6);
                                      },
                                    ),
                                  ),
                                  Expanded(
                                    child: MyText(
                                      paddingLeft: 8,
                                      text:
                                          ' Please review and agree to the terms that allow us to provide our services.',
                                      size: 13,
                                      weight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              MyText(
                                paddingTop: 2,
                                paddingLeft: 26,
                                text:
                                    'Your consent to these terms is considered legally binding.',
                                size: 13,
                                weight: FontWeight.w500,
                                color: kSecondaryColor,
                                decoration: TextDecoration.underline,
                                onTap: () {
                                  Get.to(() => PPPage());
                                  // Handle the tap event
                                },
                              ),
                            ],
                          ),
                        ),

                        Padding(
                          padding: EdgeInsets.only(bottom: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Obx(
                                    () => CustomCheckBox(
                                      isActive: ctrl.therapist7.value,
                                      onTap: () {
                                        ctrl.checkBoxToggel(ctrl.therapist7);
                                      },
                                    ),
                                  ),
                                  Expanded(
                                    child: MyText(
                                      paddingLeft: 8,
                                      text:
                                          'By typing my name below, I adopt this as my electronic signature. I agree that this signature applies to all documents I have acknowledged above,',
                                      size: 13,
                                      weight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              MyText(
                                paddingTop: 2,
                                paddingLeft: 26,
                                text:
                                    'which are incorporated by reference and enforceable under U.S. e-signature law (15 U.S.C. § 7001 et seq.).',
                                size: 13,
                                weight: FontWeight.w500,
                                color: kSecondaryColor,
                                decoration: TextDecoration.underline,
                                onTap: () {
                                  Get.to(() => GeneralTermsPage());
                                  // Handle the tap event
                                },
                              ),
                            ],
                          ),
                        ),
                        MyTextField(
                            controller: ctrl.signatureController,
                            labelText: "Signature",
                            hintText: "Signature"),
                      ],
                    )

                  // ------ if The user type is -> Client  ----------

                  : Obx(
                      () => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
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
                                          // ctrl.dob.value = dateTime;
                                          dob = dateTime;
                                        },
                                        onTap: () {
                                          ctrl.dob.value = dob;

                                          ctrl.checkIfGuardianRequired(
                                              ctrl.dob.value!);

                                          log("User Age Status: ---> ${ctrl.userAgeStatus}");

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

                          // Gardian Contact if the age is less then 13

                          (ctrl.userAgeStatus == UserAgeStatus.age13To17.name)
                              ? MyText(
                                  paddingBottom: 20,
                                  text:
                                      "Users between 13-17 years old need to add parent / guardian information.",
                                  color: Colors.blue.shade800,
                                  size: 12,
                                )
                              : (ctrl.userAgeStatus ==
                                      UserAgeStatus.ageLessThan13.name)
                                  ? MyText(
                                      paddingBottom: 20,
                                      text:
                                          "User under 13, cannot create account.",
                                      color: Colors.red,
                                      size: 12,
                                    )
                                  : SizedBox.shrink(),

                          // --- Display Gardian Information feilds based on user age -------

                          (ctrl.userAgeStatus == UserAgeStatus.age13To17.name)
                              ? Column(
                                  children: [
                                    MyTextField(
                                      controller: ctrl.guardianNameController,
                                      labelText:
                                          'Parent / Guardian’s Full Name”',
                                      hintText:
                                          'Parent / Guardian’s Full Name”',
                                    ),
                                    MyTextField(
                                      controller: ctrl.guardianEmailController,
                                      labelText: 'Parent / Guardian’s Email',
                                      hintText: 'Parent / Guardian’s Email',
                                    ),
                                    // MyTextField(
                                    //   controller: ctrl.npiNumberController,
                                    //   labelText:
                                    //       'Parent / Guardian’s Phone Number',
                                    //   hintText:
                                    //       'Parent / Guardian’s Phone Number',
                                    // ),
                                    PhoneField(
                                      title: "Parent / Guardian’s Phone Number",
                                      controller:
                                          ctrl.guardianPhoneNumberController,
                                      onPhoneNumberChanged: (value) {
                                        ctrl.gradianFullPhoneNumber = value;
                                        log("Full Phone Number: ${ctrl.gradianFullPhoneNumber}");
                                      },
                                    ),
                                    Obx(
                                      () => MyTextField(
                                        isReadOnly: true,
                                        labelText:
                                            'Parent / Guardian’s Date of Birth',
                                        hintText:
                                            (ctrl.guardianDob.value != null)
                                                ? DateTimeService.instance
                                                    .getDateUsFormat(
                                                        ctrl.guardianDob.value!)
                                                : "Select date",
                                        suffix: InkWell(
                                          onTap: () {
                                            Get.bottomSheet(
                                              isScrollControlled: true,
                                              CustomBottomSheet(
                                                height: Get.height * 0.49,
                                                child: DobPicker(
                                                  initialDateTime:
                                                      ctrl.guardianDob.value,
                                                  onDateTimeChanged:
                                                      (dateTime) {
                                                    // ctrl.dob.value = dateTime;
                                                    parentDob = dateTime;
                                                  },
                                                  onTap: () {
                                                    ctrl.guardianDob.value =
                                                        parentDob;

                                                    log("User Age Status: ---> ${ctrl.userAgeStatus}");

                                                    Get.back();
                                                  },
                                                ),
                                              ),
                                            );
                                          },
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
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
                                  ],
                                )
                              : SizedBox(),

                          MyTextField(
                            controller: ctrl.emergencyNameController,
                            labelText: 'Emergency Contact’s Full Name',
                            hintText: 'Emergency Contact’s Full Name',
                          ),
                          MyTextField(
                            controller: ctrl.emergencyEmailController,
                            labelText: 'Emergency Contact’s Email',
                            hintText: 'Emergency Contact’s Email',
                          ),
                          PhoneField(
                            title: "Emergency Contact’s Phone Number",
                            controller: ctrl.emergencyPhoneNumberController,
                            onPhoneNumberChanged: (value) {
                              ctrl.emergencyFullPhoneNumber = value;
                              log("Full Phone Number: ${ctrl.emergencyFullPhoneNumber}");
                            },
                          ),

                          // MyTextField(
                          //     controller: ctrl.signatureController,
                          //     labelText: "Signature",
                          //     hintText: "Signature"),

                          // Padding(
                          //   padding: EdgeInsets.only(bottom: 10),
                          //   child: Row(
                          //     children: [
                          //       Obx(
                          //         () => CustomCheckBox(
                          //           isActive: ctrl.adult1.value,
                          //           onTap: () {
                          //             ctrl.checkBoxToggel(ctrl.adult1);
                          //           },
                          //         ),
                          //       ),
                          //       MyText(
                          //         paddingLeft: 8,
                          //         text: 'I accept the ',
                          //         size: 13,
                          //         weight: FontWeight.w500,
                          //       ),
                          //       MyText(
                          //         text: 'Terms & Conditions',
                          //         size: 13,
                          //         weight: FontWeight.w600,
                          //         color: kQuaternaryColor,
                          //         decoration: TextDecoration.underline,
                          //       ),
                          //     ],
                          //   ),
                          // ),
                          // Padding(
                          //   padding: EdgeInsets.only(bottom: 10),
                          //   child: Row(
                          //     children: [
                          //       Obx(
                          //         () => CustomCheckBox(
                          //           isActive: ctrl.adult2.value,
                          //           onTap: () {
                          //             ctrl.checkBoxToggel(ctrl.adult2);
                          //           },
                          //         ),
                          //       ),
                          //       Expanded(
                          //         child: MyText(
                          //           paddingLeft: 8,
                          //           text:
                          //               'I have read and agree to the Client Terms & Telehealth Consent (CTTC).',
                          //           size: 13,
                          //           weight: FontWeight.w500,
                          //         ),
                          //       ),
                          //     ],
                          //   ),
                          // ),
                          // Padding(
                          //   padding: EdgeInsets.only(bottom: 10),
                          //   child: Row(
                          //     children: [
                          //       Obx(
                          //         () => CustomCheckBox(
                          //           isActive: ctrl.adult3.value,
                          //           onTap: () {
                          //             ctrl.checkBoxToggel(ctrl.adult3);
                          //           },
                          //         ),
                          //       ),
                          //       Expanded(
                          //         child: MyText(
                          //           paddingLeft: 8,
                          //           text:
                          //               'I have reviewed and acknowledge the Privacy Policy.',
                          //           size: 13,
                          //           weight: FontWeight.w500,
                          //         ),
                          //       ),
                          //     ],
                          //   ),
                          // ),
                          // Padding(
                          //   padding: EdgeInsets.only(bottom: 10),
                          //   child: Row(
                          //     children: [
                          //       Obx(
                          //         () => CustomCheckBox(
                          //           isActive: ctrl.adult4.value,
                          //           onTap: () {
                          //             ctrl.checkBoxToggel(ctrl.adult4);
                          //           },
                          //         ),
                          //       ),
                          //       Expanded(
                          //         child: MyText(
                          //           paddingLeft: 8,
                          //           text:
                          //               'I have read the HIPAA Notice of Privacy Practices (NOPP).',
                          //           size: 13,
                          //           weight: FontWeight.w500,
                          //         ),
                          //       ),
                          //     ],
                          //   ),
                          // ),
                          // Padding(
                          //   padding: EdgeInsets.only(bottom: 10),
                          //   child: Row(
                          //     children: [
                          //       Obx(
                          //         () => CustomCheckBox(
                          //           isActive: ctrl.adult5.value,
                          //           onTap: () {
                          //             ctrl.checkBoxToggel(ctrl.adult5);
                          //           },
                          //         ),
                          //       ),
                          //       Expanded(
                          //         child: MyText(
                          //           paddingLeft: 8,
                          //           text:
                          //               'I agree to the Acceptable Use Rules described in § 6 of the CTTC.',
                          //           size: 13,
                          //           weight: FontWeight.w500,
                          //         ),
                          //       ),
                          //     ],
                          //   ),
                          // ),

                          // Padding(
                          //   padding: EdgeInsets.only(bottom: 10),
                          //   child: Row(
                          //     children: [
                          //       Obx(
                          //         () => CustomCheckBox(
                          //           isActive: ctrl.adult6.value,
                          //           onTap: () {
                          //             ctrl.checkBoxToggel(ctrl.adult6);
                          //           },
                          //         ),
                          //       ),
                          //       Expanded(
                          //         child: MyText(
                          //           paddingLeft: 8,
                          //           text: 'I confirm that I am a US citizen.',
                          //           size: 13,
                          //           weight: FontWeight.w500,
                          //         ),
                          //       ),
                          //     ],
                          //   ),
                          // ),

                          // ------ Check Box According to 18+ Age User --------

                          (ctrl.userAgeStatus == UserAgeStatus.age13To17.name)
                              ? Column(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(bottom: 10),
                                      child: Row(
                                        children: [
                                          Obx(
                                            () => CustomCheckBox(
                                              isActive: ctrl.gradian1.value,
                                              onTap: () {
                                                ctrl.checkBoxToggel(
                                                    ctrl.gradian1);
                                              },
                                            ),
                                          ),
                                          Expanded(
                                            child: MyText(
                                              paddingLeft: 8,
                                              text:
                                                  'I am the legal parent or guardian of the minor named below and have authority to consent.',
                                              size: 13,
                                              weight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(bottom: 10),
                                      child: Row(
                                        children: [
                                          Obx(
                                            () => CustomCheckBox(
                                              isActive: ctrl.gradian2.value,
                                              onTap: () {
                                                ctrl.checkBoxToggel(
                                                    ctrl.gradian2);
                                              },
                                            ),
                                          ),
                                          Expanded(
                                            child: MyText(
                                              paddingLeft: 8,
                                              text:
                                                  'I have read and agree to the Client Terms & Telehealth Consent on the minor’s behalf.',
                                              size: 13,
                                              weight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(bottom: 10),
                                      child: Row(
                                        children: [
                                          Obx(
                                            () => CustomCheckBox(
                                              isActive: ctrl.gradian3.value,
                                              onTap: () {
                                                ctrl.checkBoxToggel(
                                                    ctrl.gradian3);
                                              },
                                            ),
                                          ),
                                          Expanded(
                                            child: MyText(
                                              paddingLeft: 8,
                                              text:
                                                  'I have read and agree to the General Terms of Service on the minor’s behalf.',
                                              size: 13,
                                              weight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(bottom: 10),
                                      child: Row(
                                        children: [
                                          Obx(
                                            () => CustomCheckBox(
                                              isActive: ctrl.gradian4.value,
                                              onTap: () {
                                                ctrl.checkBoxToggel(
                                                    ctrl.gradian4);
                                              },
                                            ),
                                          ),
                                          Expanded(
                                            child: MyText(
                                              paddingLeft: 8,
                                              text:
                                                  'I have reviewed and acknowledge the Privacy Policy.',
                                              size: 13,
                                              weight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(bottom: 10),
                                      child: Row(
                                        children: [
                                          Obx(
                                            () => CustomCheckBox(
                                              isActive: ctrl.gradian5.value,
                                              onTap: () {
                                                ctrl.checkBoxToggel(
                                                    ctrl.gradian5);
                                              },
                                            ),
                                          ),
                                          Expanded(
                                            child: MyText(
                                              paddingLeft: 8,
                                              text:
                                                  'I have received and reviewed the HIPAA Notice of Privacy Practices (NOPP).',
                                              size: 13,
                                              weight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    Padding(
                                      padding: EdgeInsets.only(bottom: 10),
                                      child: Row(
                                        children: [
                                          Obx(
                                            () => CustomCheckBox(
                                              isActive: ctrl.gradian6.value,
                                              onTap: () {
                                                ctrl.checkBoxToggel(
                                                    ctrl.gradian6);
                                              },
                                            ),
                                          ),
                                          Expanded(
                                            child: MyText(
                                              paddingLeft: 8,
                                              text:
                                                  ' I agree to the Acceptable Use Rules described in § 6 of the CTTC.',
                                              size: 13,
                                              weight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    // // ------- Adding New 18-Aug-2025 ----------

                                    // MyText(text: "Services Consent"),

                                    // Padding(
                                    //   padding: EdgeInsets.only(bottom: 10),
                                    //   child: Row(
                                    //     children: [
                                    //       Obx(
                                    //         () => CustomCheckBox(
                                    //           isActive: ctrl.gradian6.value,
                                    //           onTap: () {
                                    //             ctrl.checkBoxToggel(
                                    //                 ctrl.gradian6);
                                    //           },
                                    //         ),
                                    //       ),
                                    //       Expanded(
                                    //         child: MyText(
                                    //           paddingLeft: 8,
                                    //           text:
                                    //               ' I agree to the Acceptable Use Rules described in § 6 of the CTTC.',
                                    //           size: 13,
                                    //           weight: FontWeight.w500,
                                    //         ),
                                    //       ),
                                    //     ],
                                    //   ),
                                    // ),

                                    Padding(
                                      padding: EdgeInsets.only(bottom: 10),
                                      child: Row(
                                        children: [
                                          Obx(
                                            () => CustomCheckBox(
                                              isActive: ctrl.gradian7.value,
                                              onTap: () {
                                                ctrl.checkBoxToggel(
                                                    ctrl.gradian7);
                                              },
                                            ),
                                          ),
                                          Expanded(
                                            child: MyText(
                                              paddingLeft: 8,
                                              text:
                                                  'I confirm that I am a US citizen.',
                                              size: 13,
                                              weight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    // SizedBox(height: 15),
                                    // MyTextField(
                                    //     controller: ctrl.signatureController,
                                    //     labelText: "Signature",
                                    //     hintText: "Signature"),
                                  ],
                                )
                              :
                              // ------ Check Box According to 18+ Age User --------

                              (ctrl.userAgeStatus ==
                                      UserAgeStatus.age18Plus.name)
                                  ? Column(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(bottom: 10),
                                          child: Row(
                                            children: [
                                              Obx(
                                                () => CustomCheckBox(
                                                  isActive: ctrl.adult1.value,
                                                  onTap: () {
                                                    ctrl.checkBoxToggel(
                                                        ctrl.adult1);
                                                  },
                                                ),
                                              ),
                                              MyText(
                                                paddingLeft: 8,
                                                text: 'I accept the ',
                                                size: 13,
                                                weight: FontWeight.w500,
                                              ),
                                              MyText(
                                                text: 'Terms & Conditions',
                                                size: 13,
                                                weight: FontWeight.w600,
                                                color: kQuaternaryColor,
                                                decoration:
                                                    TextDecoration.underline,
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(bottom: 10),
                                          child: Row(
                                            children: [
                                              Obx(
                                                () => CustomCheckBox(
                                                  isActive: ctrl.adult2.value,
                                                  onTap: () {
                                                    ctrl.checkBoxToggel(
                                                        ctrl.adult2);
                                                  },
                                                ),
                                              ),
                                              Expanded(
                                                child: MyText(
                                                  paddingLeft: 8,
                                                  text:
                                                      'I have read and agree to the Client Terms & Telehealth Consent (CTTC).',
                                                  size: 13,
                                                  weight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(bottom: 10),
                                          child: Row(
                                            children: [
                                              Obx(
                                                () => CustomCheckBox(
                                                  isActive: ctrl.adult3.value,
                                                  onTap: () {
                                                    ctrl.checkBoxToggel(
                                                        ctrl.adult3);
                                                  },
                                                ),
                                              ),
                                              Expanded(
                                                child: MyText(
                                                  paddingLeft: 8,
                                                  text:
                                                      'I have reviewed and acknowledge the Privacy Policy.',
                                                  size: 13,
                                                  weight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(bottom: 10),
                                          child: Row(
                                            children: [
                                              Obx(
                                                () => CustomCheckBox(
                                                  isActive: ctrl.adult4.value,
                                                  onTap: () {
                                                    ctrl.checkBoxToggel(
                                                        ctrl.adult4);
                                                  },
                                                ),
                                              ),
                                              Expanded(
                                                child: MyText(
                                                  paddingLeft: 8,
                                                  text:
                                                      'I have read the HIPAA Notice of Privacy Practices (NOPP).',
                                                  size: 13,
                                                  weight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(bottom: 10),
                                          child: Row(
                                            children: [
                                              Obx(
                                                () => CustomCheckBox(
                                                  isActive: ctrl.adult5.value,
                                                  onTap: () {
                                                    ctrl.checkBoxToggel(
                                                        ctrl.adult5);
                                                  },
                                                ),
                                              ),
                                              Expanded(
                                                child: MyText(
                                                  paddingLeft: 8,
                                                  text:
                                                      'I agree to the Acceptable Use Rules described in § 6 of the CTTC.',
                                                  size: 13,
                                                  weight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(bottom: 10),
                                          child: Row(
                                            children: [
                                              Obx(
                                                () => CustomCheckBox(
                                                  isActive: ctrl.adult6.value,
                                                  onTap: () {
                                                    ctrl.checkBoxToggel(
                                                        ctrl.adult6);
                                                  },
                                                ),
                                              ),
                                              Expanded(
                                                child: MyText(
                                                  paddingLeft: 8,
                                                  text:
                                                      'I confirm that I am a US citizen.',
                                                  size: 13,
                                                  weight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),

                                        // // ------- Adding ""Services Consent"" 18-Aug-2025 ----------

                                        Align(
                                            alignment: Alignment.centerLeft,
                                            child: MyText(
                                              paddingTop: 10,
                                              paddingBottom: 15,
                                              text: "Services Consent",
                                              weight: FontWeight.w700,
                                            )),

                                        Padding(
                                          padding: EdgeInsets.only(bottom: 10),
                                          child: Column(
                                            children: [
                                              Row(
                                                children: [
                                                  Obx(
                                                    () => CustomCheckBox(
                                                      isActive:
                                                          ctrl.adult7.value,
                                                      onTap: () {
                                                        ctrl.checkBoxToggel(
                                                            ctrl.adult7);
                                                      },
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: MyText(
                                                      paddingLeft: 8,
                                                      text:
                                                          ' Please review and agree to the terms that allow us to provide our services.',
                                                      size: 13,
                                                      weight: FontWeight.w500,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              MyText(
                                                paddingTop: 2,
                                                paddingLeft: 26,
                                                text:
                                                    'Your consent to these terms is considered legally binding.',
                                                size: 13,
                                                weight: FontWeight.w500,
                                                color: kSecondaryColor,
                                                decoration:
                                                    TextDecoration.underline,
                                                onTap: () {
                                                  Get.to(() => PPPage());
                                                  // Handle the tap event
                                                },
                                              ),
                                            ],
                                          ),
                                        ),

                                        Padding(
                                          padding: EdgeInsets.only(bottom: 10),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Obx(
                                                    () => CustomCheckBox(
                                                      isActive:
                                                          ctrl.adult8.value,
                                                      onTap: () {
                                                        ctrl.checkBoxToggel(
                                                            ctrl.adult8);
                                                      },
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: MyText(
                                                      paddingLeft: 8,
                                                      text:
                                                          'By typing my name below, I adopt this as my electronic signature. I agree that this signature applies to all documents I have acknowledged above,',
                                                      size: 13,
                                                      weight: FontWeight.w500,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              MyText(
                                                paddingTop: 2,
                                                paddingLeft: 26,
                                                text:
                                                    'which are incorporated by reference and enforceable under U.S. e-signature law (15 U.S.C. § 7001 et seq.).',
                                                size: 13,
                                                weight: FontWeight.w500,
                                                color: kSecondaryColor,
                                                decoration:
                                                    TextDecoration.underline,
                                                onTap: () {
                                                  Get.to(
                                                      () => GeneralTermsPage());
                                                  // Handle the tap event
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    )
                                  : SizedBox(),

                          SizedBox(height: 15),
                          MyTextField(
                              controller: ctrl.signatureController,
                              labelText: "Signature",
                              hintText: "Signature"),
                        ],
                      ),
                    ),

              SizedBox(
                height: 50,
              ),

              (type == UserType.therapist.name)
                  ? MyButton(
                      buttonText: "Continue",
                      onTap: () {
                        if (ctrl.therapist1.value == false ||
                            ctrl.therapist2.value == false ||
                            ctrl.therapist3.value == false ||
                            ctrl.therapist4.value == false ||
                            ctrl.therapist5.value == false) {
                          displayToast(
                              msg: "Please set the checkboxs to true.");
                        } else {
                          if (ctrl.signatureController.text.isEmpty) {
                            displayToast(
                                msg: "Please add the your signature/typedName");

                            return;
                          }
                          ctrl.signUpClientMethod(
                            dob: DateTimeService.instance
                                .getDateIsoFormat(ctrl.dob.value!),
                            npiNumber: ctrl.npiNumberController.text,
                            email: ctrl.emailController.text.trim(),
                            password: ctrl.passwordController.text.trim(),
                            fullName: ctrl.fullNameController.text.trim(),
                            userType: type,
                            isUsCitizien: true,
                            signature: ctrl.signatureController.text.trim(),
                          );
                        }
                      },
                    )
                  :

                  //-------------------------------------------
                  //---------- Client Side Button -------------
                  //-------------------------------------------
                  Obx(
                      () => MyButton(
                        bgColor: (type == UserType.client.name &&
                                ctrl.userAgeStatus ==
                                    UserAgeStatus.ageLessThan13.name)
                            ? kGreyColor.withValues(alpha: 0.5)
                            : kSecondaryColor,
                        onTap: () {
                          if (type == UserType.client.name &&
                              ctrl.userAgeStatus ==
                                  UserAgeStatus.ageLessThan13.name) {
                            displayToast(
                                msg:
                                    "Users under 13 years old cannot create an account.");
                            log("Users under 13 years old cannot create an account.");
                          } else if (type == UserType.client.name &&
                              ctrl.userAgeStatus ==
                                  UserAgeStatus.age13To17.name) {
                            if (ctrl.gradian1.value == false ||
                                ctrl.gradian2.value == false ||
                                ctrl.gradian3.value == false ||
                                ctrl.gradian4.value == false ||
                                ctrl.gradian5.value == false ||
                                ctrl.gradian6.value == false ||
                                ctrl.gradian7.value == false) {
                              displayToast(
                                  msg: "Please set the checkbox to true.");
                            } else {
                              if (ctrl.guardianDob.value == null) {
                                displayToast(
                                    msg: "Please inter the gurdian details");
                                return;
                              }

                              ctrl.signUpClientMethod(
                                dob: DateTimeService.instance
                                    .getDateIsoFormat(ctrl.dob.value!),
                                // npiNumber: ctrl.npiNumberController.text,
                                email: ctrl.emailController.text.trim(),
                                password: ctrl.passwordController.text.trim(),
                                fullName: ctrl.fullNameController.text.trim(),
                                userType: type,

                                isUsCitizien: true,

                                gradianName:
                                    ctrl.guardianNameController.text.trim(),
                                gradianEmail:
                                    ctrl.guardianEmailController.text.trim(),
                                gradianPhone: ctrl.gradianFullPhoneNumber,
                                gradianDOB: DateTimeService.instance
                                    .getDateIsoFormat(ctrl.guardianDob.value!),

                                // gradianDOB: (ctrl.guardianDob.value != null)
                                //     ? DateTimeService.instance.getDateIsoFormat(
                                //         ctrl.guardianDob.value!)
                                //     : DateTimeService.instance
                                //         .getDateIsoFormat(DateTime.now()),

                                emergencyName:
                                    ctrl.emergencyNameController.text.trim(),
                                emergencyEmail:
                                    ctrl.emergencyEmailController.text.trim(),
                                emergencyPhone: ctrl.emergencyFullPhoneNumber,
                                guardianInfoComplete: true,
                                signature: ctrl.signatureController.text.trim(),
                              );

                              log("DOB ---- --- : ${DateTimeService.instance.getDateIsoFormat(ctrl.guardianDob.value!)}");
                            }
                          } else if (type == UserType.client.name &&
                              ctrl.userAgeStatus ==
                                  UserAgeStatus.age18Plus.name) {
                            if (ctrl.adult1.value == false ||
                                ctrl.adult2.value == false ||
                                ctrl.adult3.value == false ||
                                ctrl.adult4.value == false ||
                                ctrl.adult5.value == false ||
                                ctrl.adult6.value == false ||
                                ctrl.adult7.value == false ||
                                ctrl.adult8.value == false) {
                              displayToast(
                                  msg: "Please set the checkbox to true.");
                            } else {
                              if (ctrl.signatureController.text.isEmpty) {
                                displayToast(
                                    msg:
                                        "Please add the your signature/typedName");

                                return;
                              }
                              ctrl.signUpClientMethod(
                                dob: DateTimeService.instance
                                    .getDateIsoFormat(ctrl.dob.value!),
                                npiNumber: ctrl.npiNumberController.text,
                                email: ctrl.emailController.text.trim(),
                                password: ctrl.passwordController.text.trim(),
                                fullName: ctrl.fullNameController.text.trim(),
                                userType: type,
                                emergencyName:
                                    ctrl.emergencyNameController.text.trim(),
                                emergencyEmail:
                                    ctrl.emergencyEmailController.text.trim(),
                                emergencyPhone: ctrl.emergencyFullPhoneNumber,
                                guardianInfoComplete: true,
                                signature: ctrl.signatureController.text.trim(),
                              );
                            }
                          } else {
                            // if (formKey2.currentState!.validate()) {
                            //   if (ctrl.acceptTermsAndCondition == true) {
                            //     ctrl.signUpClientMethod(
                            //         npiNumber: ctrl.npiNumberController.text,
                            //         email: ctrl.emailController.text.trim(),
                            //         password: ctrl.passwordController.text.trim(),
                            //         fullName: ctrl.fullNameController.text.trim(),
                            //         userType: type);
                            //   } else {
                            //     displayToast(
                            //         msg:
                            //             "Please accept the terms and conditions to proceed.");
                            //     // if (ctrl.acceptTermsAndCondition.value == false) {

                            //     // } else if (ctrl.ageRestriction.value == false) {
                            //     //   displayToast(msg: "i am 13.");
                            //     // }
                            //   }
                            // }
                          }

                          // Get.to(() => ClientCompleteProfile());
                          // Get.to(() => EmailVerification());
                        },
                        buttonText: 'Continue',
                      ),
                    ),

              SizedBox(height: 20),

              MyButton(
                buttonText: "Back",
                onTap: () {
                  Get.back();
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
