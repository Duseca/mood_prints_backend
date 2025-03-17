import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mood_prints/constants/app_colors.dart';
import 'package:mood_prints/constants/app_sizes.dart';
import 'package:mood_prints/constants/app_styling.dart';
import 'package:mood_prints/controller/client/profile/profile_controller.dart';
import 'package:mood_prints/services/user/user_services.dart';
import 'package:mood_prints/view/screens/client/client_profile/my_therapist.dart';
import 'package:mood_prints/view/widget/common_image_view_widget.dart';
import 'package:mood_prints/view/widget/custom_app_bar_widget.dart';
import 'package:mood_prints/view/widget/my_button_widget.dart';
import 'package:mood_prints/view/widget/my_text_widget.dart';

// ignore: must_be_immutable
class AddNewTherapist extends StatefulWidget {
  bool editTherapist;
  AddNewTherapist({super.key, this.editTherapist = false});

  @override
  State<AddNewTherapist> createState() => _AddNewTherapistState();
}

class _AddNewTherapistState extends State<AddNewTherapist> {
  final ctrl = Get.find<ProfileController>();
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    ctrl.selectedTherapistModel.value = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: simpleAppBar(
        title: (widget.editTherapist) ? 'Edit Therapist' : 'Add Therapist',
      ),
      body: Obx(
        () => Column(
          children: [
            SizedBox(height: 20),
            (widget.editTherapist)
                ?
                //(UserService.instance.relationWithTherapist.isNotEmpty)
                // ?

                (ctrl.selectedTherapistModel.value != null)
                    ? MyTherapistCard(
                        imageUrl: ctrl.selectedTherapistModel.value?.image,
                        fullname: ctrl.selectedTherapistModel.value?.fullName,
                        email: ctrl.selectedTherapistModel.value?.email,
                        phoneNumber:
                            ctrl.selectedTherapistModel.value?.phoneNumber,
                        location: "${ctrl.selectedTherapistModel.value?.city}}",
                      )
                    : Column(
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
                : Obx(
                    () => Column(
                      children: [
                        (ctrl.selectedTherapistModel.value != null)
                            ? MyTherapistCard(
                                imageUrl:
                                    ctrl.selectedTherapistModel.value?.image,
                                fullname:
                                    ctrl.selectedTherapistModel.value?.fullName,
                                email: ctrl.selectedTherapistModel.value?.email,
                                phoneNumber: ctrl
                                    .selectedTherapistModel.value?.phoneNumber,
                                location:
                                    "${ctrl.selectedTherapistModel.value?.city}}",
                              )
                            : NoTherapistCard()
                      ],
                    ),
                  ),
            SizedBox(
                height: (ctrl.selectedTherapistModel.value != null) ? 20 : 40),
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
            Obx(() => TappableCard(
                  hint: (ctrl.selectedTherapistModel.value?.fullName != null)
                      ? ctrl.selectedTherapistModel.value!.fullName
                      : 'Search Therapist',
                  onTap: () {
                    ctrl.getAllTherapist();
                  },
                )),
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
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(left: 20, right: 20, bottom: 40, top: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            MyButton(
              buttonText: 'Request Therapist',
              onTap: () {
                // ctrl.changeTherapist();
                ctrl.requestNotification(
                    therapistID:
                        ctrl.selectedTherapistModel.value!.id.toString());
              },
            )
          ],
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class TappableCard extends StatelessWidget {
  VoidCallback? onTap;
  final bool haveData;
  final String? hint;

  TappableCard({
    super.key,
    this.haveData = false,
    this.onTap,
    this.hint,
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
                  text: hint ?? "Search Therapist",
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

class RequestCard extends StatelessWidget {
  final String message;
  const RequestCard({
    super.key,
    required this.message,
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
                  text: 'Request Therapist',
                  size: 16,
                  textAlign: TextAlign.center,
                  weight: FontWeight.w600,
                ),
                MyText(
                  textAlign: TextAlign.center,
                  paddingTop: 6,
                  // text: 'Are you sure you want to remove?',
                  text: '$message',
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
                        buttonText: 'Close',
                        onTap: () {
                          Get.close(2);
                        },
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
