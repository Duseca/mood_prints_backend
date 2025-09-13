import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mood_prints/constants/app_colors.dart';
import 'package:mood_prints/constants/app_fonts.dart';
import 'package:mood_prints/constants/app_images.dart';
import 'package:mood_prints/constants/app_sizes.dart';
import 'package:mood_prints/constants/firebase_const.dart';
import 'package:mood_prints/constants/loading_animation.dart';
import 'package:mood_prints/controller/client/auth/auth_client_controller.dart';
import 'package:mood_prints/core/enums/user_age_status.dart';
import 'package:mood_prints/core/enums/user_type.dart';
import 'package:mood_prints/core/utils/validators.dart';
import 'package:mood_prints/services/date_formator/general_service.dart';
import 'package:mood_prints/services/user/user_services.dart';
import 'package:mood_prints/view/screens/auth/sign_up/client_sign_up/client_complete_profile.dart/client_complete_profile.dart';
import 'package:mood_prints/view/screens/auth/sign_up/email_verification.dart';
import 'package:mood_prints/view/screens/privacy_policy/b_a.dart';
import 'package:mood_prints/view/screens/privacy_policy/general_terms.dart';
import 'package:mood_prints/view/screens/privacy_policy/hippa_pdf_view.dart';
import 'package:mood_prints/view/screens/privacy_policy/nopp.dart';
import 'package:mood_prints/view/screens/privacy_policy/p_s.dart';
import 'package:mood_prints/view/screens/privacy_policy/pp_page.dart';
import 'package:mood_prints/view/screens/privacy_policy/terms_and_telehealth_consent.dart';
import 'package:mood_prints/view/widget/custom_app_bar_widget.dart';
import 'package:mood_prints/view/widget/custom_bottom_sheet_widget.dart';
import 'package:mood_prints/view/widget/custom_check_box_widget.dart';
import 'package:mood_prints/view/widget/dob_picker.dart';
import 'package:mood_prints/view/widget/my_button_widget.dart';
import 'package:mood_prints/view/widget/my_text_field_widget.dart';
import 'package:mood_prints/view/widget/my_text_widget.dart';

class SignUpSecondPage extends StatelessWidget {
  final String type;
  final bool isSocialSignin;
  SignUpSecondPage(
      {super.key, required this.type, this.isSocialSignin = false});

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
          child: Form(
            key: formKey2,
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
                              validator: (value) {
                                return ValidationService.instance
                                    .emptyValidator(value);
                              },
                              controller: TextEditingController(
                                  text: (ctrl.dob.value != null)
                                      ? DateTimeService.instance
                                          .getDateUsFormat(ctrl.dob.value!)
                                      : ''),
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
                            labelText: 'NPI Number',
                            hintText: 'NPI Number',
                            validator: (value) {
                              return ValidationService.instance
                                  .emptyValidator(value);
                            },
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
                              return ValidationService.instance
                                  .emailValidator(value);
                            },
                          ),
                          PhoneField(
                            title: "Emergency Contact’s Phone Number”",
                            controller: ctrl.emergencyPhoneNumberController,
                            onPhoneNumberChanged: (value) {
                              ctrl.emergencyFullPhoneNumber = value;
                              log("Full Phone Number: ${ctrl.emergencyFullPhoneNumber}");
                            },
                          ),
                          Obx(
                            () => CheckBoxWithHyperLink(
                              text1: "I agree to the ",
                              text2: 'Platform Services Agreement (PSA).',
                              isActive: ctrl.therapist1.value,
                              onBoxTap: () {
                                ctrl.checkBoxToggel(ctrl.therapist1);
                              },
                              onHyperLinkTap: () {
                                Get.to(() => PSPage());
                              },
                            ),
                          ),

                          Obx(
                            () => CheckBoxWithHyperLink(
                              text1: "I agree to the ",
                              text2: 'Business Associate Agreement (BAA).',
                              isActive: ctrl.therapist2.value,
                              onBoxTap: () {
                                ctrl.checkBoxToggel(ctrl.therapist2);
                              },
                              onHyperLinkTap: () {
                                Get.to(() => BAPage());
                              },
                            ),
                          ),

                          Obx(
                            () => CheckBoxWithHyperLink(
                              text1: "I agree to the ",
                              text2: 'General Terms of Service.',
                              isActive: ctrl.therapist3.value,
                              onBoxTap: () {
                                ctrl.checkBoxToggel(ctrl.therapist3);
                              },
                              onHyperLinkTap: () {
                                Get.to(() => GeneralTermsPage());
                              },
                            ),
                          ),

                          Obx(
                            () => CheckBoxWithHyperLink(
                              text1: "I have read and agree to the ",
                              text2: 'Privacy Policy.',
                              isActive: ctrl.therapist4.value,
                              onBoxTap: () {
                                ctrl.checkBoxToggel(ctrl.therapist4);
                              },
                              onHyperLinkTap: () {
                                Get.to(() => PPPage());
                              },
                            ),
                          ),

                          // Obx(
                          //   () => CheckBoxWithHyperLink(
                          //     text1:
                          //         "I have received and acknowledge the HIPAA Notice of ",
                          //     text2: 'Privacy Practices (NOPP).',
                          //     isActive: ctrl.therapist5.value,
                          //     onBoxTap: () {
                          //       ctrl.checkBoxToggel(ctrl.therapist5);
                          //     },
                          //     onHyperLinkTap: () {
                          //       Get.to(() => PPPage());
                          //     },
                          //   ),
                          // ),

                          // ------- Services Consent ----------

                          Align(
                              alignment: Alignment.centerLeft,
                              child: MyText(
                                paddingTop: 10,
                                paddingBottom: 15,
                                text: "Services Consent",
                                weight: FontWeight.w700,
                              )),

                          Obx(
                            () => CheckBoxWithText(
                              text:
                                  "I have reviewed and agree to the terms, which are legally binding.",
                              isActive: ctrl.therapist5.value,
                              onTap: () {
                                ctrl.checkBoxToggel(ctrl.therapist5);
                              },
                            ),
                          ),

                          Obx(
                            () => CheckBoxWithText(
                              text:
                                  "By typing my name below, I adopt it as my electronic signature. I agree that this electronic signature applies to all documents I have acknowledged above, which are incorporated by reference and are enforceable under U.S. e-signature law (15 U.S.C. § 7001 et seq.).",
                              isActive: ctrl.therapist6.value,
                              onTap: () {
                                ctrl.checkBoxToggel(ctrl.therapist6);
                              },
                            ),
                          ),

                          // Padding(
                          //   padding: EdgeInsets.only(bottom: 10),
                          //   child: Column(
                          //     crossAxisAlignment: CrossAxisAlignment.start,
                          //     children: [
                          //       Row(
                          //         children: [
                          //           Obx(
                          //             () => CustomCheckBox(
                          //               isActive: ctrl.therapist7.value,
                          //               onTap: () {
                          //                 ctrl.checkBoxToggel(ctrl.therapist7);
                          //               },
                          //             ),
                          //           ),
                          //           Expanded(
                          //             child: MyText(
                          //               paddingLeft: 8,
                          //               text:
                          //                   '',
                          //               size: 13,
                          //               weight: FontWeight.w500,
                          //             ),
                          //           ),
                          //         ],
                          //       ),
                          //       MyText(
                          //         paddingTop: 2,
                          //         paddingLeft: 26,
                          //         text:
                          //             '',
                          //         size: 13,
                          //         weight: FontWeight.w500,
                          //         color: kSecondaryColor,
                          //         decoration: TextDecoration.underline,
                          //         onTap: () {
                          //           Get.to(() => GeneralTermsPage());
                          //           // Handle the tap event
                          //         },
                          //       ),
                          //     ],
                          //   ),
                          // ),
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
                                controller: TextEditingController(
                                    text: (ctrl.dob.value != null)
                                        ? DateTimeService.instance
                                            .getDateUsFormat(ctrl.dob.value!)
                                        : ""),
                                hintText: (ctrl.dob.value != null)
                                    ? DateTimeService.instance
                                        .getDateUsFormat(ctrl.dob.value!)
                                    : "Select date",
                                validator: (value) {
                                  return ValidationService.instance
                                      .emptyValidator(value);
                                },
                                suffix: InkWell(
                                  onTap: () {
                                    Get.bottomSheet(
                                      isScrollControlled: true,
                                      CustomBottomSheet(
                                        height: Get.height * 0.49,
                                        child: DobPicker(
                                          initialDateTime: ctrl.dob.value,
                                          onDateTimeChanged: (dateTime) {
                                            dob = dateTime;
                                            log("onchanged");
                                          },
                                          onTap: () {
                                            log("------------------ on Tap Callledkbwriiiiiiiiiib----------------");
                                            ctrl.dob.value = dob;

                                            ctrl.checkIfGuardianRequired(
                                                ctrl.dob.value!);

                                            log("User Age Status: ---> ${ctrl.userAgeStatus.value}");

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

                            (ctrl.userAgeStatus.value ==
                                    UserAgeStatus.age13To17.name)
                                ? MyText(
                                    paddingBottom: 20,
                                    text:
                                        "Users between 13-17 years old need to add parent / guardian information.",
                                    color: Colors.blue.shade800,
                                    size: 12,
                                  )
                                : (ctrl.userAgeStatus.value ==
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

                            (ctrl.userAgeStatus.value ==
                                    UserAgeStatus.age13To17.name)
                                ? Column(
                                    children: [
                                      MyTextField(
                                        controller: ctrl.guardianNameController,
                                        labelText:
                                            'Parent / Guardian’s Full Name”',
                                        hintText:
                                            'Parent / Guardian’s Full Name”',
                                        validator: (value) {
                                          return ValidationService.instance
                                              .userNameValidator(value);
                                        },
                                      ),
                                      MyTextField(
                                        controller:
                                            ctrl.guardianEmailController,
                                        labelText: 'Parent / Guardian’s Email',
                                        hintText: 'Parent / Guardian’s Email',
                                        validator: (value) {
                                          return ValidationService.instance
                                              .emailValidator(value);
                                        },
                                      ),
                                      // MyTextField(
                                      //   controller: ctrl.npiNumberController,
                                      //   labelText:
                                      //       'Parent / Guardian’s Phone Number',
                                      //   hintText:
                                      //       'Parent / Guardian’s Phone Number',
                                      // ),
                                      PhoneField(
                                        title:
                                            "Parent / Guardian’s Phone Number",
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
                                          controller: TextEditingController(
                                              text: (ctrl.guardianDob.value !=
                                                      null)
                                                  ? DateTimeService.instance
                                                      .getDateUsFormat(ctrl
                                                          .guardianDob.value!)
                                                  : ''),
                                          validator: (value) {
                                            return ValidationService.instance
                                                .emptyValidator(value);
                                          },
                                          labelText:
                                              'Parent / Guardian’s Date of Birth',
                                          hintText: (ctrl.guardianDob.value !=
                                                  null)
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
                                return ValidationService.instance
                                    .emailValidator(value);
                              },
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
                                      Obx(
                                        () => CheckBoxWithHyperLink(
                                          text1: "I agree to the ",
                                          text2:
                                              'Terms & Telehealth Consent (CTTC) on the minor’s behalf.',
                                          isActive: ctrl.gradian1.value,
                                          onBoxTap: () {
                                            ctrl.checkBoxToggel(ctrl.gradian1);
                                          },
                                          onHyperLinkTap: () {
                                            Get.to(() => PPPage());
                                          },
                                        ),
                                      ),
                                      Obx(
                                        () => CheckBoxWithHyperLink(
                                          text1: "I agree to the Client ",
                                          text2:
                                              'Terms & Telehealth Consent (CTTC) on the minor’s behalf.',
                                          isActive: ctrl.gradian2.value,
                                          onBoxTap: () {
                                            ctrl.checkBoxToggel(ctrl.gradian2);
                                          },
                                          onHyperLinkTap: () {
                                            Get.to(() => PPPage());
                                          },
                                        ),
                                      ),
                                      Obx(
                                        () => CheckBoxWithHyperLink(
                                          text1: "I agree to the General ",
                                          text2:
                                              'Terms of Service on the minor’s behalf.',
                                          isActive: ctrl.gradian3.value,
                                          onBoxTap: () {
                                            ctrl.checkBoxToggel(ctrl.gradian3);
                                          },
                                          onHyperLinkTap: () {
                                            Get.to(() => PPPage());
                                          },
                                        ),
                                      ),
                                      Obx(
                                        () => CheckBoxWithHyperLink(
                                          text1:
                                              "I have read and agree to the ",
                                          text2: 'Privacy Policy.',
                                          isActive: ctrl.gradian4.value,
                                          onBoxTap: () {
                                            ctrl.checkBoxToggel(ctrl.gradian4);
                                          },
                                          onHyperLinkTap: () {
                                            Get.to(() => PPPage());
                                          },
                                        ),
                                      ),
                                      Obx(
                                        () => CheckBoxWithHyperLink(
                                          text1:
                                              "I acknowledge receipt of the HIPAA Notice of Privacy Practices ",
                                          text2: '(NOPP).',
                                          isActive: ctrl.gradian5.value,
                                          onBoxTap: () {
                                            ctrl.checkBoxToggel(ctrl.gradian5);
                                          },
                                          onHyperLinkTap: () {
                                            Get.to(() => NOPPPage());
                                          },
                                        ),
                                      ),
                                      Obx(
                                        () => CheckBoxWithHyperLink(
                                          text1:
                                              "I agree to the Acceptable Use Rules in § 6 of the ",
                                          text2: 'CTTC.',
                                          isActive: ctrl.gradian6.value,
                                          onBoxTap: () {
                                            ctrl.checkBoxToggel(ctrl.gradian6);
                                          },
                                          onHyperLinkTap: () {
                                            Get.to(() => PPPage());
                                          },
                                        ),
                                      ),
                                      Obx(
                                        () => CheckBoxWithHyperLink(
                                          text1:
                                              "I confirm that I am a US citizen.",
                                          text2: '',
                                          isActive: ctrl.gradian7.value,
                                          onBoxTap: () {
                                            ctrl.checkBoxToggel(ctrl.gradian7);
                                          },
                                          onHyperLinkTap: () {
                                            Get.to(() => PPPage());
                                          },
                                        ),
                                      ),
                                    ],
                                  )
                                :
                                // ------ Check Box According to 18+ Age User --------

                                (ctrl.userAgeStatus ==
                                        UserAgeStatus.age18Plus.name)
                                    ? Column(
                                        children: [
                                          // Obx(
                                          //   () => CheckBoxWithHyperLink(
                                          //     text1: "I accept the ",
                                          //     text2: 'Terms & Conditions',
                                          //     isActive: ctrl.adult1.value,
                                          //     onBoxTap: () {
                                          //       ctrl.checkBoxToggel(ctrl.adult1);
                                          //     },
                                          //     onHyperLinkTap: () {
                                          //       Get.to(() => PPPage());
                                          //     },
                                          //   ),
                                          // ),

                                          Obx(
                                            () => CheckBoxWithHyperLink(
                                              text1: "I agree to the ",
                                              text2:
                                                  'Client Terms & Telehealth Consent (CTTC).',
                                              isActive: ctrl.adult1.value,
                                              onBoxTap: () {
                                                ctrl.checkBoxToggel(
                                                    ctrl.adult1);
                                              },
                                              onHyperLinkTap: () {
                                                Get.to(() =>
                                                    ClientAndTeleHealthConsentPage());
                                              },
                                            ),
                                          ),

                                          Obx(
                                            () => CheckBoxWithHyperLink(
                                              text1:
                                                  "I have reviewed and acknowledge receipt of the ",
                                              text2: 'Privacy Policy.',
                                              isActive: ctrl.adult2.value,
                                              onBoxTap: () {
                                                ctrl.checkBoxToggel(
                                                    ctrl.adult2);
                                              },
                                              onHyperLinkTap: () {
                                                Get.to(() => PPPage());
                                              },
                                            ),
                                          ),

                                          Obx(
                                            () => CheckBoxWithHyperLink(
                                              text1:
                                                  "I have read and understood the HIPAA Notice of ",
                                              text2:
                                                  'Privacy Practices (NOPP).',
                                              isActive: ctrl.adult3.value,
                                              onBoxTap: () {
                                                ctrl.checkBoxToggel(
                                                    ctrl.adult3);
                                              },
                                              onHyperLinkTap: () {
                                                Get.to(() => NOPPPage());
                                              },
                                            ),
                                          ),

                                          Obx(
                                            () => CheckBoxWithHyperLink(
                                              text1: "I agree to the ",
                                              text2: 'General Terms of use.',
                                              isActive: ctrl.adult4.value,
                                              onBoxTap: () {
                                                ctrl.checkBoxToggel(
                                                    ctrl.adult4);
                                              },
                                              onHyperLinkTap: () {
                                                Get.to(
                                                    () => GeneralTermsPage());
                                              },
                                            ),
                                          ),

                                          // Obx(
                                          //   () => CheckBoxWithHyperLink(
                                          //     text1:
                                          //         "I confirm that I am a US citizen.",
                                          //     text2: '',
                                          //     isActive: ctrl.adult6.value,
                                          //     onBoxTap: () {
                                          //       ctrl.checkBoxToggel(ctrl.adult6);
                                          //     },
                                          //     onHyperLinkTap: () {
                                          //       Get.to(() => PPPage());
                                          //     },
                                          //   ),
                                          // ),

                                          // ------- "Services Consent" ----------

                                          Align(
                                              alignment: Alignment.centerLeft,
                                              child: MyText(
                                                paddingTop: 10,
                                                paddingBottom: 15,
                                                text: "Services Consent",
                                                weight: FontWeight.w700,
                                              )),

                                          Obx(
                                            () => CheckBoxWithText(
                                              text:
                                                  "Please review and agree to the terms that allow us to provide our services. Your consent to these terms is considered legally binding.",
                                              isActive: ctrl.adult5.value,
                                              onTap: () {
                                                ctrl.checkBoxToggel(
                                                    ctrl.adult5);
                                              },
                                            ),
                                          ),

                                          Obx(
                                            () => CheckBoxWithText(
                                              text:
                                                  "By typing my name below, I adopt this as my electronic signature. I agree that this signature applies to all documents I have acknowledged above, which are incorporated by reference and enforceable under U.S. e-signature law (15 U.S.C. § 7001 et seq.).",
                                              isActive: ctrl.adult6.value,
                                              onTap: () {
                                                ctrl.checkBoxToggel(
                                                    ctrl.adult6);
                                              },
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
                          if (formKey2.currentState!.validate()) {
                            if (ctrl.fullNameController.text.trim() ==
                                ctrl.emergencyNameController.text.trim()) {
                              displayToast(
                                msg:
                                    "Emergency contact is not same, try different emergency name",
                              );
                              return;
                            }

                            if (ctrl.emailController.text.trim() ==
                                ctrl.emergencyEmailController.text.trim()) {
                              displayToast(
                                msg:
                                    "Emergency email cannot be the same as yours. Try again",
                              );
                              return;
                            }

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
                                    msg:
                                        "Please add the your signature/typedName");

                                return;
                              }
                              // if (isSocialSignin) {
                              ctrl.signUpClientMethod(
                                  dob: DateTimeService.instance
                                      .getDateIsoFormat(ctrl.dob.value!),
                                  npiNumber: ctrl.npiNumberController.text,
                                  password: isSocialSignin
                                      ? null
                                      : ctrl.passwordController.text.trim(),
                                  email: isSocialSignin
                                      ? auth.currentUser?.email ?? ""
                                      : ctrl.emailController.text.trim(),
                                  fullName: isSocialSignin
                                      ? auth.currentUser?.displayName ?? ""
                                      : ctrl.fullNameController.text.trim(),
                                  emergencyName:
                                      ctrl.emergencyNameController.text.trim(),
                                  emergencyEmail:
                                      ctrl.emergencyEmailController.text.trim(),
                                  emergencyPhone: ctrl.emergencyFullPhoneNumber,
                                  userType: type,
                                  isUsCitizien: true,
                                  signature:
                                      ctrl.signatureController.text.trim(),
                                  widget: _SuccessDialog());
                              // } else {
                              //   Get.to(EmailVerification(
                              //     email: ctrl.emailController.text.trim(),
                              //     type: type,
                              //   ));
                              // }
                            }
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
                            if (formKey2.currentState!.validate()) {
                              if (ctrl.fullNameController.text.trim() ==
                                  ctrl.emergencyNameController.text.trim()) {
                                displayToast(
                                  msg:
                                      "Emergency contact is not same, try different emergency name",
                                );
                                return;
                              }

                              if (ctrl.emailController.text.trim() ==
                                  ctrl.emergencyEmailController.text.trim()) {
                                displayToast(
                                  msg:
                                      "Emergency email cannot be the same as yours. Try again",
                                );
                                return;
                              }

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
                                        msg:
                                            "Please inter the gurdian details");
                                    return;
                                  }
                                  // if (isSocialSignin) {
                                  ctrl.signUpClientMethod(
                                      dob: DateTimeService.instance
                                          .getDateIsoFormat(ctrl.dob.value!),
                                      password: isSocialSignin
                                          ? null
                                          : ctrl.passwordController.text.trim(),
                                      // npiNumber: ctrl.npiNumberController.text,
                                      email: isSocialSignin
                                          ? auth.currentUser?.email ?? ""
                                          : ctrl.emailController.text.trim(),
                                      fullName: isSocialSignin
                                          ? auth.currentUser?.displayName ?? ""
                                          : ctrl.fullNameController.text.trim(),
                                      userType: type,
                                      isUsCitizien: true,
                                      gradianName: ctrl
                                          .guardianNameController.text
                                          .trim(),
                                      gradianEmail: ctrl
                                          .guardianEmailController.text
                                          .trim(),
                                      gradianPhone: ctrl.gradianFullPhoneNumber,
                                      gradianDOB: DateTimeService.instance
                                          .getDateIsoFormat(
                                              ctrl.guardianDob.value!),
                                      emergencyName: ctrl
                                          .emergencyNameController.text
                                          .trim(),
                                      emergencyEmail: ctrl
                                          .emergencyEmailController.text
                                          .trim(),
                                      emergencyPhone:
                                          ctrl.emergencyFullPhoneNumber,
                                      guardianInfoComplete: true,
                                      signature:
                                          ctrl.signatureController.text.trim(),
                                      widget: _SuccessDialog());
                                  // } else {
                                  //   Get.to(EmailVerification(
                                  //     email: ctrl.emailController.text.trim(),
                                  //     type: type,
                                  //   ));
                                  // }

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
                                    ctrl.adult6.value == false) {
                                  displayToast(
                                      msg: "Please set the checkbox to true.");
                                } else {
                                  if (ctrl.signatureController.text.isEmpty) {
                                    displayToast(
                                        msg:
                                            "Please add the your signature/typedName");

                                    return;
                                  }
                                  // if (isSocialSignin) {
                                  ctrl.signUpClientMethod(
                                      dob: DateTimeService.instance
                                          .getDateIsoFormat(ctrl.dob.value!),
                                      npiNumber: ctrl.npiNumberController.text,
                                      password: isSocialSignin
                                          ? null
                                          : ctrl.passwordController.text.trim(),
                                      email: isSocialSignin
                                          ? auth.currentUser?.email ?? ""
                                          : ctrl.emailController.text.trim(),
                                      fullName: isSocialSignin
                                          ? auth.currentUser?.displayName ?? ""
                                          : ctrl.fullNameController.text.trim(),
                                      userType: type,
                                      emergencyName: ctrl
                                          .emergencyNameController.text
                                          .trim(),
                                      emergencyEmail: ctrl
                                          .emergencyEmailController.text
                                          .trim(),
                                      emergencyPhone:
                                          ctrl.emergencyFullPhoneNumber,
                                      guardianInfoComplete: true,
                                      signature:
                                          ctrl.signatureController.text.trim(),
                                      widget: _SuccessDialog());
                                  // } else {
                                  //   Get.to(EmailVerification(
                                  //     email: ctrl.emailController.text.trim(),
                                  //     type: type,
                                  //   ));
                                  // }
                                }
                              }
                            }
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
      ),
    );
  }
}

class _SuccessDialog extends StatelessWidget {
  const _SuccessDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Card(
            margin: AppSizes.DEFAULT,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Image.asset(
                    Assets.imagesCongrats,
                    height: 150,
                  ),
                  MyText(
                    paddingTop: 24,
                    text: 'Verification Complete!',
                    size: 24,
                    weight: FontWeight.bold,
                    textAlign: TextAlign.center,
                    paddingBottom: 8,
                  ),
                  MyText(
                    text:
                        'Thanks for your patience. Enjoy the all features of app',
                    size: 14,
                    color: kGreyColor,
                    weight: FontWeight.w500,
                    lineHeight: 1.5,
                    paddingLeft: 10,
                    paddingRight: 10,
                    textAlign: TextAlign.center,
                    paddingBottom: 24,
                  ),
                  MyButton(
                    buttonText: 'Done',
                    onTap: () async {
                      // await UserService.instance.getUserInformation();
                      Get.back();
                      Get.back();
                      final ctrl = Get.find<AuthClientController>();
                      ctrl.fullNameController.text =
                          UserService.instance.userModel.value.fullName ?? "";
                      ctrl.emailController.text =
                          UserService.instance.userModel.value.email ?? "";
                      ctrl.phoneNumberController.text =
                          UserService.instance.userModel.value.phoneNumber ??
                              "";

                      Get.off(() => ClientCompleteProfile());
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CheckBoxWithText extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final bool isActive;
  CheckBoxWithText({
    super.key,
    required this.isActive,
    required this.onTap,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomCheckBox(
                isActive: isActive,
                //  ctrl.adult8.value,
                onTap: onTap,
              ),
              Expanded(
                child: MyText(
                  paddingLeft: 8,
                  text: text,
                  size: 13,
                  weight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class CheckBoxWithHyperLink extends StatelessWidget {
  final String text1, text2;
  final VoidCallback onBoxTap;
  final bool isActive;
  bool isTextSimple;
  final VoidCallback onHyperLinkTap;
  CheckBoxWithHyperLink({
    super.key,
    required this.isActive,
    required this.onBoxTap,
    required this.text1,
    required this.text2,
    this.isTextSimple = false,
    required this.onHyperLinkTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomCheckBox(
                isActive: isActive,
                //  ctrl.adult8.value,
                onTap: onBoxTap,
              ),
              SizedBox(width: 8),
              Expanded(
                child: RichText(
                  text: TextSpan(
                    text: text1,
                    style: TextStyle(
                        color: kTertiaryColor,
                        fontSize: 13,
                        fontFamily: AppFonts.URBANIST),
                    children: [
                      TextSpan(
                        text: text2,
                        style: TextStyle(
                            fontFamily: AppFonts.URBANIST,
                            color: (isTextSimple)
                                ? kTertiaryColor
                                : kSecondaryColor,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            decoration: (isTextSimple)
                                ? TextDecoration.none
                                : TextDecoration.underline),
                        recognizer: TapGestureRecognizer()
                          ..onTap = onHyperLinkTap,

                        // () {
                        //   ScaffoldMessenger.of(context).showSnackBar(
                        //     const SnackBar(content: Text("Sign Up tapped")),
                        //   );
                        // },
                      ),
                    ],
                  ),
                ),
              ),
              // Expanded(
              //   child: MyText(
              //     paddingLeft: 8,
              //     text: text,
              //     size: 13,
              //     weight: FontWeight.w500,
              //   ),
              // ),
            ],
          ),
        ],
      ),
    );
  }
}
