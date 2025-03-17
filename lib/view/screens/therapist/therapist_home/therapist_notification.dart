import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:mood_prints/constants/app_colors.dart';
import 'package:mood_prints/constants/app_images.dart';
import 'package:mood_prints/constants/app_sizes.dart';
import 'package:mood_prints/controller/notification/notification_controller.dart';
import 'package:mood_prints/core/enums/notification_type.dart';
import 'package:mood_prints/view/widget/common_image_view_widget.dart';
import 'package:mood_prints/view/widget/custom_app_bar_widget.dart';
import 'package:mood_prints/view/widget/my_button_widget.dart';
import 'package:mood_prints/view/widget/my_text_widget.dart';

// ignore: must_be_immutable
class TherapistNotificationPage extends StatefulWidget {
  TherapistNotificationPage({super.key});

  @override
  State<TherapistNotificationPage> createState() =>
      _TherapistNotificationPageState();
}

class _TherapistNotificationPageState extends State<TherapistNotificationPage> {
  var ctrl = Get.find<NotificationController>();

  @override
  void initState() {
    super.initState();

    ctrl.getAllNotification();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          appBar: simpleAppBar(
            title: 'Notifications',
            centerTitle: true,
            haveLeading: true,
          ),
          body: (ctrl.isLoading.value)
              ? Center(child: CircularProgressIndicator())
              : (ctrl.isLoading.value == false &&
                      ctrl.notificationList.isNotEmpty)
                  ? ListView.builder(
                      padding: AppSizes.DEFAULT,
                      itemBuilder: (context, index) {
                        return GeneralNotificationCard(
                          isLoading: ctrl.isRequestAccepted.value,
                          type: (ctrl.notificationList[index].type ==
                                  NotificationType.request.name)
                              ? NotificationType.request.name
                              : NotificationType.general.name,
                          status:
                              (ctrl.notificationList[index].requestId?.status ==
                                      Status.pending.name)
                                  ? Status.pending.name
                                  : (ctrl.notificationList[index].requestId
                                              ?.status ==
                                          Status.accepted.name)
                                      ? Status.accepted.name
                                      : Status.declined.name,
                          title: '${ctrl.notificationList[index].title}',
                          description: '${ctrl.notificationList[index].body}',
                          onAcceptTap: () {
                            log('Accept Tapped');

                            // Update notification status & Buidl Connection with client

                            ctrl.updateNotificationStatus(
                                requestId: ctrl
                                    .notificationList[index].requestId!.id
                                    .toString(),
                                status: Status.accepted.name,
                                clientID: ctrl
                                    .notificationList[index].requestId!.clientId
                                    .toString(),
                                therapistID: ctrl.notificationList[index]
                                    .requestId!.therapistId
                                    .toString());


                          },
                          onDeclineTap: () {
                            log('Decline Tapped ${ctrl.notificationList[index].requestId!.id}');
                            ctrl.deleteNotificationRequest(
                                requestId: ctrl
                                    .notificationList[index].requestId!.id
                                    .toString());
                            // ctrl.updateNotificationStatus(
                            //     requestId:
                            //         ctrl.notificationList[index].id.toString(),
                            //     status: Status.declined.name);
                          },
                          onDeleteTap: (v) {
                            ctrl.deleteNotification(
                                notificationID:
                                    ctrl.notificationList[index].id.toString());
                          },
                        );
                      },
                      itemCount: ctrl.notificationList.length,
                    )
                  : Center(
                      child: MyText(
                        text: 'No Notification Found',
                        size: 16,
                        weight: FontWeight.w600,
                      ),
                    ),
        ));
  }
}

// ------ Notification Card Widget ----------

class GeneralNotificationCard extends StatelessWidget {
  final String? title;
  final String? description;
  final String type;
  final String status;
  final bool isLoading;
  final VoidCallback? onDeclineTap, onAcceptTap;
  Function(BuildContext)? onDeleteTap;

  GeneralNotificationCard({
    super.key,
    this.title,
    this.description,
    this.type = 'request',
    this.status = 'pending',
    this.onDeclineTap,
    this.onAcceptTap,
    required this.isLoading,
    required this.onDeleteTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16),
      child: (type == NotificationType.request.name)
          ? Slidable(
              endActionPane: ActionPane(motion: ScrollMotion(), children: [
                SlidableAction(
                  onPressed: onDeleteTap,

                  backgroundColor: Color(0xFFFE4A49),
                  foregroundColor: Colors.white,
                  icon: Icons.delete,
                  borderRadius: BorderRadius.circular(10),
                  spacing: 0,
                  // label: '',
                ),
              ]),
              child:
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                CommonImageView(
                  // height: 17.19,
                  width: 17.19,
                  imagePath: Assets.imagesChainIcon,
                ),
                SizedBox(width: 10),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MyText(
                        text: '$title',
                        size: 14,
                        weight: FontWeight.w600,
                      ),
                      MyText(
                        paddingBottom: 10,
                        paddingTop: 3,
                        text: "$description",
                        size: 12,
                        weight: FontWeight.w400,
                        color: kHintColor,
                      ),
                      (status == Status.pending.name)
                          ? Row(
                              children: [
                                SizedBox(
                                  height: 30,
                                  width: 70,
                                  child: MyButton(
                                      radius: 100,
                                      textSize: 10,
                                      buttonText: 'Decline',
                                      onTap: onDeclineTap,
                                      bgColor: Colors.red.shade600,
                                      textColor: kWhiteColor),
                                ),
                                SizedBox(width: 10),
                                SizedBox(
                                  height: 30,
                                  width: 70,
                                  child: (isLoading)
                                      ? CircularProgressIndicator(
                                          color: kSecondaryColor,
                                        )
                                      : MyButton(
                                          radius: 100,
                                          textSize: 10,
                                          buttonText: 'Accept',
                                          onTap: onAcceptTap,
                                          bgColor: Colors.green,
                                          textColor: kWhiteColor),
                                ),
                              ],
                            )
                          : (status == Status.accepted.name)
                              ? SizedBox.shrink()
                              : SizedBox.shrink()
                    ],
                  ),
                ),
              ]),
            )
          : Slidable(
              endActionPane: ActionPane(motion: ScrollMotion(), children: [
                SlidableAction(
                  onPressed: onDeleteTap,
                  backgroundColor: Color(0xFFFE4A49),
                  foregroundColor: Colors.white,
                  icon: Icons.delete,
                  borderRadius: BorderRadius.circular(10),
                  spacing: 0,
                ),
              ]),
              child:
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                CommonImageView(
                  height: 17.19,
                  width: 17.19,
                  imagePath: Assets.imagesNotificationRectangleIcon,
                ),
                SizedBox(width: 10),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MyText(
                        text: '$title',
                        size: 14,
                        weight: FontWeight.w600,
                      ),
                      MyText(
                        paddingTop: 3,
                        text: "$description",
                        size: 12,
                        weight: FontWeight.w400,
                        color: kHintColor,
                      ),
                    ],
                  ),
                )
              ]),
            ),
    );
  }
}

class RequestAcceptedCard extends StatelessWidget {
  const RequestAcceptedCard({
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
                  text: 'Connection Successful! 🎉 ',
                  size: 16,
                  textAlign: TextAlign.center,
                  weight: FontWeight.w600,
                ),
                MyText(
                  textAlign: TextAlign.center,
                  paddingTop: 6,
                  text:
                      "You are now connected! You can start chatting and continue your journey together.",
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
                        buttonText: 'Got it',
                        onTap: () {
                          Get.close(2);
                          // hideLoadingDialog();
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

class RequestDeclineCard extends StatelessWidget {
  const RequestDeclineCard({
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
                  text: 'Request Declined!',
                  size: 16,
                  textAlign: TextAlign.center,
                  weight: FontWeight.w600,
                ),
                MyText(
                  textAlign: TextAlign.center,
                  paddingTop: 6,
                  text:
                      "You have declined the request. The user will be notified, and no connection has been made.",
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
                        buttonText: 'Okay',
                        onTap: () {
                          Get.close(2);
                          // hideLoadingDialog();
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
