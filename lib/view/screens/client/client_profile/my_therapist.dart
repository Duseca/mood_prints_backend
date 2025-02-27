import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mood_prints/constants/app_colors.dart';
import 'package:mood_prints/constants/app_images.dart';
import 'package:mood_prints/constants/app_sizes.dart';
import 'package:mood_prints/constants/app_styling.dart';
import 'package:mood_prints/services/user/user_services.dart';
import 'package:mood_prints/view/screens/client/client_profile/add_new_therapist.dart';
import 'package:mood_prints/view/widget/common_image_view_widget.dart';
import 'package:mood_prints/view/widget/custom_app_bar_widget.dart';
import 'package:mood_prints/view/widget/my_button_widget.dart';
import 'package:mood_prints/view/widget/my_text_widget.dart';

// ignore: must_be_immutable
class MyTherapist extends StatelessWidget {
  // bool haveTherapist;

  MyTherapist({
    super.key,
    // this.haveTherapist = false
  });

  // final ctrl = Get.find<ProfileController>();

  // bool haveTherapist;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: simpleAppBar(
        title: 'My Therapist',
      ),
      body: Column(
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
                          buttonText: 'Edit Therapist',
                          onTap: () {
                            Get.to(() => AddNewTherapist(
                                  editTherapist: true,
                                ));
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