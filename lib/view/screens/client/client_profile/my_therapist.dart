import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mood_prints/constants/app_colors.dart';
import 'package:mood_prints/constants/app_images.dart';
import 'package:mood_prints/constants/app_sizes.dart';
import 'package:mood_prints/constants/app_styling.dart';
import 'package:mood_prints/constants/loading_animation.dart';
import 'package:mood_prints/controller/client/profile/profile_controller.dart';
import 'package:mood_prints/services/user/user_services.dart';
import 'package:mood_prints/view/screens/client/client_profile/add_new_therapist.dart';
import 'package:mood_prints/view/widget/checkbox_widget.dart';
import 'package:mood_prints/view/widget/common_image_view_widget.dart';
import 'package:mood_prints/view/widget/custom_app_bar_widget.dart';
import 'package:mood_prints/view/widget/my_button_widget.dart';
import 'package:mood_prints/view/widget/my_text_widget.dart';

// ignore: must_be_immutable
class MyTherapist extends StatefulWidget {
  // bool haveTherapist;

  MyTherapist({
    super.key,
    // this.haveTherapist = false
  });

  @override
  State<MyTherapist> createState() => _MyTherapistState();
}

class _MyTherapistState extends State<MyTherapist> {
  ProfileController profileController = Get.find();
  Future<void> _refresh() async {
    await Future.delayed(Duration(seconds: 2));
    await UserService.instance.getUserInformation();
    setState(() {
      checkAccessValues();
    });
  }

  void checkAccessValues() async {
    // profileController.moodPrintAccess.value =
    //     UserService.instance.userModel.value.authorizeMoodPrintsAccess!;
    profileController.therapistAccess.value =
        UserService.instance.userModel.value.authorizeTherapistAccess!;

    // log("⚙️ Model Value 1: ${profileController.moodPrintAccess.value}");
    log("⚙️ Model Value 2: ${profileController.therapistAccess.value}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: simpleAppBar(
        title: 'My Therapist',
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: ListView(
          children: [
            SizedBox(height: 15),
            (UserService.instance.relationWithTherapist.isNotEmpty)
                ? Column(
                    children: List.generate(
                        UserService.instance.relationWithTherapist.length,
                        (index) {
                      var data = UserService
                          .instance.relationWithTherapist[index].therapist;
                      return MyTherapistCard(
                        imageUrl: data?.image,
                        fullname: data?.fullName,
                        email: data?.email,
                        phoneNumber: data?.phoneNumber,
                        location: data?.city,
                      );
                    }),
                  )
                : Center(child: NoTherapistCard()),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(left: 20, right: 20, bottom: 40, top: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            (UserService.instance.relationWithTherapist.isNotEmpty)
                ? Row(
                    children: [
                      Expanded(
                        child: MyButton(
                          bgColor: kRedColor,
                          buttonText: 'Send Removal Request',
                          onTap: () async {
                            if (UserService.instance.requests.isNotEmpty &&
                                UserService.instance.requests.first.status !=
                                    "removed") {
                              Get.find<ProfileController>().sendRemovalRequest(
                                  therapistID: UserService
                                          .instance
                                          .relationWithTherapist
                                          .first
                                          .therapist
                                          ?.id ??
                                      "",
                                  clientID:
                                      UserService.instance.userModel.value.id ??
                                          "");
                            } else {
                              Get.dialog(RequestCard(
                                title: "Request Already Exists",
                                message:
                                    'You already have an active removal request. Wait until therapist accept or decline it.',
                              ));
                            }
                          },
                        ),
                      ),
                      // SizedBox(width: 20),
                      // Expanded(
                      //   child: MyButton(
                      //     buttonText: 'Edit Therapist',
                      //     onTap: () {
                      //       Get.to(() => AddNewTherapist());
                      //     },
                      //   ),
                      // ),
                    ],
                  )
                : MyButton(
                    buttonText: 'Add New Therapist',
                    onTap: () {
                      Get.to(() => AddNewTherapist(
                            editTherapist: false,
                          ));
                    },
                  ),

            // ------- Hippa ----------
            SizedBox(height: 20),

            Obx(
              () => CheckBoxWidget(
                isChecked: profileController.therapistAccess.value,
                onChanged: (newValue) {
                  profileController.therapistAccess.value =
                      !profileController.therapistAccess.value;
                },
                text: 'Authorize Therapist Access',
              ),
            ),
            SizedBox(height: 12),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: MyButton(
                buttonText: 'Done',
                onTap: () async {
                  if (UserService
                          .instance.userModel.value.authorizeTherapistAccess ==
                      profileController.therapistAccess.value) {
                    Get.back();
                  } else {
                    if (profileController.therapistAccess.value) {
                      // ✅ Access enabled
                      Get.dialog(SuccessDialog(
                        title: "Therapist Access Granted",
                        description:
                            "Your therapist will now be able to view your mood history and receive emotional data from your account.",
                        onTap: () async {
                          await profileController.updateUserAccess();
                          Get.back();
                        },
                      ));
                    } else {
                      // ❌ Access disabled
                      Get.dialog(SuccessDialog(
                        title: "Therapist Access Revoked",
                        description:
                            "This will:\n• Disable mood tracking, insights, and chat features.\n• Revoke therapist access to your records.\n• Schedule your account for deletion in 10 days.",
                        onTap: () async {
                          await profileController.updateUserAccess();
                          Get.back();
                        },
                      ));
                    }
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

class NoTherapistCard extends StatelessWidget {
  const NoTherapistCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
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
    );
  }
}

// ------ My Therapist Card ----------

class MyTherapistCard extends StatelessWidget {
  final String? imageUrl, fullname, email, phoneNumber, location;
  const MyTherapistCard(
      {super.key,
      this.email,
      this.fullname,
      this.imageUrl,
      this.location,
      this.phoneNumber});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      decoration: AppStyling.CUSTOM_CARD,
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Row(
        children: [
          (imageUrl != null)
              ? CommonImageView(
                  height: 100,
                  width: 100,
                  radius: 100,
                  url: imageUrl,
                )
              : CommonImageView(
                  height: 100,
                  width: 100,
                  radius: 100,
                  imagePath: Assets.imagesProfileImageUser,
                ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MyText(
                  paddingBottom: 5,
                  text: '$fullname',
                  size: 17,
                  weight: FontWeight.w600,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.email_outlined,
                      size: 13,
                      color: kHintColor,
                    ),
                    Expanded(
                      child: MyText(
                        paddingLeft: 5,
                        text: '$email',
                        size: 13,

                        // textOverflow: TextOverflow.ellipsis,
                        // weight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 2),
                Row(
                  children: [
                    Icon(
                      Icons.phone_outlined,
                      size: 13,
                      color: kHintColor,
                    ),
                    MyText(
                      paddingLeft: 5,
                      text: '$phoneNumber',
                      size: 13,
                      // weight: FontWeight.w600,
                    ),
                  ],
                ),
                SizedBox(height: 2),
                Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: 13,
                      color: kHintColor,
                    ),
                    MyText(
                      paddingLeft: 5,
                      text: '$location',
                      size: 13,
                      // weight: FontWeight.w600,
                    ),
                  ],
                ),
              ],
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
