import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mood_prints/constants/app_colors.dart';
import 'package:mood_prints/constants/app_images.dart';
import 'package:mood_prints/constants/app_sizes.dart';
import 'package:mood_prints/constants/app_styling.dart';
import 'package:mood_prints/controller/client/profile/profile_controller.dart';
import 'package:mood_prints/view/widget/common_image_view_widget.dart';
import 'package:mood_prints/view/widget/custom_app_bar_widget.dart';
import 'package:mood_prints/view/widget/my_button_widget.dart';
import 'package:mood_prints/view/widget/my_text_widget.dart';

class AddNewTherapist extends StatelessWidget {
  bool editTherapist;
  AddNewTherapist({super.key, this.editTherapist = false});

  final ctrl = Get.find<ProfileController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: simpleAppBar(
        title: (editTherapist) ? 'Edit Therapist' : 'Add New',
      ),
      body: Column(
        children: [
          SizedBox(height: 20),
          (editTherapist)
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
              : Obx(
                  () => Column(
                    children: [
                      (ctrl.selectedTherapistModel.value != null)
                          ? Column(
                              children: [
                                CommonImageView(
                                  height: 100,
                                  width: 100,
                                  radius: 100,
                                  url: ctrl.selectedTherapistModel.value?.image,
                                ),
                                SizedBox(height: 15),
                                MyText(
                                  text:
                                      '${ctrl.selectedTherapistModel.value?.fullName}',
                                  size: 15,
                                  weight: FontWeight.w600,
                                ),
                                MyText(
                                  paddingTop: 5,
                                  text:
                                      '${ctrl.selectedTherapistModel.value?.email}',
                                  size: 15,
                                  // weight: FontWeight.w600,
                                ),
                                MyText(
                                  // paddingBottom: 20,
                                  paddingTop: 5,
                                  text:
                                      '${ctrl.selectedTherapistModel.value?.phoneNumber}',
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
                    ],
                  ),
                ),
          SizedBox(height: 40),
          Align(
            alignment: Alignment.centerLeft,
            child: MyText(
              paddingLeft: 20,
              textAlign: TextAlign.start,
              paddingBottom: 7,
              paddingTop: 5,
              text: 'Search Therapist',
              size: 15,
              // weight: FontWeight.w600,
            ),
          ),

          // Padding(
          //   padding: AppSizes.HORIZONTAL,
          //   child: CustomDropDown(
          //       hint: 'item',
          //       items: ['1', '2', '3', '4', '5'],
          //       selectedValue: '1',
          //       onChanged: (v) {

          //       }),
          // ),

          TappableCard(
            onTap: () {
              ctrl.getAllTherapist();
            },
          ),

          Obx(
            () => Column(
              children: [
                (ctrl.isLoading.value == true && ctrl.allTherapists.isEmpty)
                    ? CircularProgressIndicator()
                    : (ctrl.isLoading.value == false &&
                            ctrl.allTherapists.isNotEmpty)
                        ? Container(
                            margin: AppSizes.HORIZONTAL,
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 16),
                            height: 250,
                            width: Get.width,
                            decoration: AppStyling.CUSTOM_CARD,
                            child: SingleChildScrollView(
                              physics: BouncingScrollPhysics(),
                              child: Column(
                                children: List.generate(
                                  ctrl.allTherapists.length,
                                  (index) => InkWell(
                                    onTap: () {
                                      ctrl.selectedTherapistModel.value =
                                          ctrl.allTherapists[index];

                                      ctrl.allTherapists.clear();
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.only(bottom: 8),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          CommonImageView(
                                            height: 40,
                                            width: 40,
                                            radius: 100,
                                            url:
                                                "${ctrl.allTherapists[index].image}",
                                          ),
                                          SizedBox(width: 15),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              MyText(
                                                text:
                                                    "${ctrl.allTherapists[index].fullName}",
                                                size: 14,
                                                weight: FontWeight.w600,
                                              ),
                                              MyText(
                                                paddingTop: 5,
                                                text:
                                                    "${ctrl.allTherapists[index].email}",
                                                size: 12,

                                                // weight: FontWeight.w600,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ))
                        : SizedBox.shrink(),
              ],
            ),
          ),

          // ctrl.getAllTherapist();

          // Expanded(
          //   child: ListView(
          //     shrinkWrap: true,
          //     padding: AppSizes.DEFAULT,
          //     physics: BouncingScrollPhysics(),
          //     children: [
          //       MyTextField(
          //         labelText: 'Therapist First Name',
          //       ),
          //       MyTextField(
          //         labelText: 'Therapist Last Name',
          //       ),
          //       MyTextField(
          //         labelText: 'Country',
          //       ),
          //       MyTextField(
          //         labelText: 'State',
          //       ),
          //       MyTextField(
          //         labelText: 'City',
          //       ),
          //     ],
          //   ),
          // ),

          // Padding(
          //   padding: AppSizes.DEFAULT,
          //   child: MyButton(
          //     buttonText: 'Add New Therapist',
          //     onTap: () {},
          //   ),
          // ),
        ],
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
              padding: AppSizes.DEFAULT,
              child: MyButton(
                buttonText: 'Save',
                onTap: () {
                  ctrl.changeTherapist();
                },
              ))
        ],
      ),
    );
  }
}

class TappableCard extends StatelessWidget {
  VoidCallback? onTap;
  final bool haveData;

  TappableCard({
    super.key,
    this.haveData = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: AppSizes.HORIZONTAL,
          padding: AppSizes.DEFAULT,
          height: 50,
          width: Get.width,
          decoration: AppStyling.CUSTOM_CARD,
          child: InkWell(
            onTap: onTap,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                MyText(
                  text: "Search Therapist",
                  size: 12,
                ),
                Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: kHintColor,
                )
              ],
            ),
          ),
        ),
        SizedBox(height: 10),

        // Search Card
      ],
    );
  }
}

// class LocalModel {
//   final String? name;
//   final String? therapistId;
//   final String? profilePicture;
//   final String? email;

//   LocalModel({
//     this.name,
//     this.therapistId,
//     this.profilePicture,
//     this.email,
//   });

//   // Factory constructor to create an instance from JSON
//   factory LocalModel.fromJson(Map<String, dynamic> json) {
//     return LocalModel(
//       name: json['name'],
//       therapistId: json['therapistID'], // Keeping API field name
//       profilePicture: json['profilePicture'],
//       email: json['email'],
//     );
//   }

//   // Convert instance to JSON
//   Map<String, dynamic> toJson() {
//     return {
//       'name': name,
//       'therapistID': therapistId, // Match the original JSON key
//       'profilePicture': profilePicture,
//       'email': email,
//     };
//   }
// }
