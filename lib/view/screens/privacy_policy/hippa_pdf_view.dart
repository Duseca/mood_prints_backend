import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mood_prints/constants/app_colors.dart';
import 'package:mood_prints/constants/app_images.dart';
import 'package:mood_prints/constants/app_sizes.dart';
import 'package:mood_prints/controller/client/profile/profile_controller.dart';
import 'package:mood_prints/services/user/user_services.dart';
import 'package:mood_prints/view/widget/checkbox_widget.dart';
import 'package:mood_prints/view/widget/custom_app_bar_widget.dart';
import 'package:mood_prints/view/widget/my_button_widget.dart';
import 'package:mood_prints/view/widget/my_text_widget.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:typed_data';

class HippaScreen extends StatefulWidget {
  final bool showConsent;

  const HippaScreen({super.key, this.showConsent = true});
  @override
  _HippaScreenState createState() => _HippaScreenState();
}

class _HippaScreenState extends State<HippaScreen> {
  PdfViewerController _pdfViewerController = PdfViewerController();
  Uint8List? _pdfData;
  ProfileController profileController = Get.find();
  @override
  void initState() {
    super.initState();
    loadPdfFromAssets();
  }

  Future<void> loadPdfFromAssets() async {
    final ByteData bytes = await rootBundle.load('assets/pdf/HIPPA.pdf');
    setState(() {
      _pdfData = bytes.buffer.asUint8List();
      checkAccessValues();
    });
  }

  void checkAccessValues() async {
    profileController.moodPrintAccess.value =
        UserService.instance.userModel.value.authorizeMoodPrintsAccess!;
    profileController.therapistAccess.value =
        UserService.instance.userModel.value.authorizeTherapistAccess!;

    log("⚙️ Model Value 1: ${profileController.moodPrintAccess.value}");
    log("⚙️ Model Value 2: ${profileController.therapistAccess.value}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: simpleAppBar(
        title: 'General Terms and Condition',
      ),
      body: _pdfData == null
          ? Center(child: CircularProgressIndicator())
          : SfPdfViewer.memory(
              _pdfData!,
              controller: _pdfViewerController,
            ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Obx(
            //   () => CheckBoxWidget(
            //     isChecked: profileController.therapistAccess.value,
            //     onChanged: (bool) {
            //       profileController.therapistAccess.value =
            //           !profileController.therapistAccess.value;
            //     },
            //     text: 'Authorize Therapist Access',
            //   ),
            // ),
            SizedBox(
              height: 5,
            ),
            widget.showConsent
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Obx(
                        () => CheckBoxWidget(
                          isChecked: profileController.moodPrintAccess.value,
                          //  profileController.moodPrintAccess.value :
                          //  UserService.instance.userModel.value.authorizeMoodPrintsAccess!,
                          onChanged: (bool) {
                            profileController.moodPrintAccess.value =
                                !profileController.moodPrintAccess.value;
                          },
                          // text: 'Authorize MoodPrints Access\n(Required for App Use)',
                          text: 'I consent to this agreement.',
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: MyButton(
                          buttonText: 'Done',
                          onTap: () {
                            if (profileController.moodPrintAccess.value ==
                                true) {
                              Get.dialog(SuccessDialog(
                                title: "MoodPrints Access Disabled",
                                description:
                                    "Disabling MoodPrints access will turn off mood tracking, chat, and emotional insights. Your account will be scheduled for deletion in 10 days unless access is restored.",
                                onTap: () {
                                  profileController.updateUserAccess();
                                  Get.back();
                                },
                              ));
                            } else if (profileController
                                    .moodPrintAccess.value ==
                                true) {
                              Get.dialog(SuccessDialog(
                                title: "MoodPrints Access Revoked",
                                description:
                                    "You've successfully enabled MoodPrints access.\n App functionality is now unlocked:\n• Mood tracking.\n• Emotional insights.\n•",
                                onTap: () {
                                  profileController.updateUserAccess();
                                  Get.back();
                                },
                              ));
                            }

                            // else if (profileController.therapistAccess.value == false &&
                            //     profileController.moodPrintAccess.value == false) {
                            //   Get.dialog(SuccessDialog(
                            //     title:
                            //         "You've disabled both MoodPrints and Therapist access.",
                            //     description:
                            //         "This will:\n• Disable mood tracking, insights, and chat features.\n• Revoke therapist access to your records.\n• Schedule your account for deletion in 10 days.\n\n To continue using the app, please re-enable at least MoodPrints access.",
                            //     isContentFromStart: true,
                            //     onTap: () {
                            //       profileController.updateUserAccess();
                            //       Get.back();
                            //     },
                            //   ));
                            // } else {
                            //   Get.dialog(SuccessDialog(
                            //     isContentFromStart: true,
                            //     title: "All Access Enabled",
                            //     description:
                            //         "You've successfully enabled both MoodPrints and Therapist access.\nFull app functionality is now unlocked:\n• Mood tracking.\n• Emotional insights.\n• Therapist communication.\n• Personalized mental health support",
                            //     onTap: () {
                            //       profileController.updateUserAccess();
                            //       Get.back();
                            //     },
                            //   ));
                            // }

                            // ##############################################

                            // if (profileController.moodPrintAccess.value == false &&
                            //     profileController.therapistAccess.value == true) {
                            //   Get.dialog(SuccessDialog(
                            //     title: "MoodPrints Access Disabled",
                            //     description:
                            //         "Disabling MoodPrints access will turn off mood tracking, chat, and emotional insights. Your account will be scheduled for deletion in 10 days unless access is restored.",
                            //     onTap: () {
                            //       profileController.updateUserAccess();
                            //       Get.back();
                            //     },
                            //   ));
                            // } else if (profileController.therapistAccess.value == false &&
                            //     profileController.moodPrintAccess.value == true) {
                            //   Get.dialog(SuccessDialog(
                            //     title: "Therapist Access Revoked",
                            //     description:
                            //         "Your therapist will no longer be able to view your mood history or receive emotional data from your account.",
                            //     onTap: () {
                            //       profileController.updateUserAccess();
                            //       Get.back();
                            //     },
                            //   ));
                            // } else if (profileController.therapistAccess.value == false &&
                            //     profileController.moodPrintAccess.value == false) {
                            //   Get.dialog(SuccessDialog(
                            //     title:
                            //         "You've disabled both MoodPrints and Therapist access.",
                            //     description:
                            //         "This will:\n• Disable mood tracking, insights, and chat features.\n• Revoke therapist access to your records.\n• Schedule your account for deletion in 10 days.\n\n To continue using the app, please re-enable at least MoodPrints access.",
                            //     isContentFromStart: true,
                            //     onTap: () {
                            //       profileController.updateUserAccess();
                            //       Get.back();
                            //     },
                            //   ));
                            // } else {
                            //   Get.dialog(SuccessDialog(
                            //     isContentFromStart: true,
                            //     title: "All Access Enabled",
                            //     description:
                            //         "You've successfully enabled both MoodPrints and Therapist access.\nFull app functionality is now unlocked:\n• Mood tracking.\n• Emotional insights.\n• Therapist communication.\n• Personalized mental health support",
                            //     onTap: () {
                            //       profileController.updateUserAccess();
                            //       Get.back();
                            //     },
                            //   ));
                            // }
                          },
                        ),
                      ),
                    ],
                  )
                : SizedBox()
          ],
        ),
      ),
    );
  }
}

class SuccessDialog extends StatelessWidget {
  String? title;
  String? description;
  VoidCallback? onTap;
  bool isContentFromStart;

  SuccessDialog(
      {super.key,
      this.description,
      this.title,
      this.onTap,
      this.isContentFromStart = false});

  @override
  Widget build(BuildContext context) {
    return Column(
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
              crossAxisAlignment: (isContentFromStart)
                  ? CrossAxisAlignment.start
                  : CrossAxisAlignment.stretch,
              children: [
                Align(
                    alignment: Alignment.center,
                    child: (isContentFromStart)
                        ? Image.asset(
                            Assets.imagesCongrats,
                            height: 100,
                          )
                        : Icon(
                            Icons.warning,
                            color: Colors.amber.shade700,
                            size: 70,
                          )),
                Align(
                  alignment: Alignment.center,
                  child: MyText(
                    paddingTop: 24,
                    text: '$title',
                    size: 24,
                    weight: FontWeight.bold,
                    textAlign: TextAlign.center,
                    paddingBottom: 8,
                  ),
                ),
                MyText(
                  text: '$description',
                  size: 14,
                  color: kGreyColor,
                  weight: FontWeight.w500,
                  lineHeight: 1.5,
                  paddingLeft: 10,
                  paddingRight: 10,
                  textAlign:
                      (isContentFromStart) ? TextAlign.start : TextAlign.center,
                  paddingBottom: 24,
                ),
                Row(
                  children: [
                    Expanded(
                      child: MyButton(
                        buttonText: 'Cancel',
                        bgColor: kSecondaryColor.withValues(alpha: 0.1),
                        textColor: kSecondaryColor,
                        onTap: () {
                          Get.back();
                        },
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                        child: MyButton(buttonText: 'Proceed', onTap: onTap)),
                  ],
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
