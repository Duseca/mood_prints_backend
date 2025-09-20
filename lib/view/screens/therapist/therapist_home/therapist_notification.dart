import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:mood_prints/constants/app_colors.dart';
import 'package:mood_prints/constants/app_images.dart';
import 'package:mood_prints/constants/app_sizes.dart';
import 'package:mood_prints/controller/client/profile/profile_controller.dart';
import 'package:mood_prints/controller/notification/notification_controller.dart';
import 'package:mood_prints/core/enums/notification_type.dart';
import 'package:mood_prints/view/widget/common_image_view_widget.dart';
import 'package:mood_prints/view/widget/custom_app_bar_widget.dart';
import 'package:mood_prints/view/widget/my_button_widget.dart';
import 'package:mood_prints/view/widget/my_text_widget.dart';
import '../../../../services/user/user_services.dart';

// ignore: must_be_immutable
class TherapistNotificationPage extends StatefulWidget {
  TherapistNotificationPage({super.key});

  @override
  State<TherapistNotificationPage> createState() =>
      _TherapistNotificationPageState();
}

class _TherapistNotificationPageState extends State<TherapistNotificationPage> {
  var ctrl = Get.find<NotificationController>();
  var pctrl = Get.find<ProfileController>();

  @override
  void initState() {
    super.initState();

    ctrl.getAllNotification(
        UserService.instance.therapistDetailModel.value.id ??
            UserService.instance.userModel.value.id);
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
                                      // :  (ctrl.notificationList[index].requestId
                                      //             ?.status ==
                                      //         Status.removed.name)
                                      //     ? Status.removed.name
                                          : Status.declined.name,
                          title: '${ctrl.notificationList[index].title}',
                          description: '${ctrl.notificationList[index].body}',
                          // onRemoveTap: () async {
                          //   await pctrl.deleteRelation(
                          //       requestId: ctrl
                          //           .notificationList[index].requestId!.id
                          //           .toString(),
                          //       clientID: ctrl
                          //           .notificationList[index].requestId!.clientId
                          //           .toString(),
                          //       therapistID: ctrl.notificationList[index]
                          //           .requestId!.therapistId
                          //           .toString());
                          //   await pctrl.createNotification(
                          //       title: 'Removal Request accepted',
                          //       fullName:
                          //           "${UserService.instance.therapistDetailModel.value.fullName}",
                          //       notificationMsg:
                          //           "has accepted your${(ctrl.notificationList[index].requestId?.status == Status.removed.name) ? " removal" : ''} request.",
                          //       message:
                          //           "${UserService.instance.therapistDetailModel.value.fullName} has accepted your removal request.",
                          //       reciverID: ctrl
                          //           .notificationList[index].requestId!.clientId
                          //           .toString(),
                          //       showcard: false);
                          //   await ctrl.deleteNotificationRequest(
                          //       title: "Removal Request Accepted",
                          //       message: "You have accepted removal request",
                          //       requestId: ctrl
                          //           .notificationList[index].requestId!.id
                          //           .toString());
                          // },
                          onAcceptTap: () async {
                            // ---------- Accept Request notification send to the client --------------
                            var name = UserService
                                .instance.therapistDetailModel.value.fullName;

                            await pctrl.createNotificationWithoutRequest(
                              title: 'Request Accepted',
                              notificationMsg:
                                  "${name} has selected you as their patient.",
                              message:
                                  "${UserService.instance.therapistDetailModel.value.fullName} has selected you as their patient.",
                              reciverID: ctrl
                                  .notificationList[index].requestId!.clientId
                                  .toString(),
                            );

                            //----------- Update notification status & Build Connection with client --------------

                            await ctrl.updateNotificationStatus(
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

                            await ctrl.deleteNotification(
                                notificationID:
                                    ctrl.notificationList[index].id.toString());
                          },
                          onDeclineTap: () async {
                            // ---------- Declined Request notification send to the client --------------

                            await pctrl.createNotification(
                                title: 'Request Declined',
                                fullName:
                                    "${UserService.instance.therapistDetailModel.value.fullName}",
                                notificationMsg:
                                    "has declined your${(ctrl.notificationList[index].requestId?.status == Status.removed.name) ? " removal" : ''} request.",
                                message:
                                    "${UserService.instance.therapistDetailModel.value.fullName} has declined your request.",
                                reciverID: ctrl
                                    .notificationList[index].requestId!.clientId
                                    .toString(),
                                showcard: false);

                            //----------- Update notification status --------------

                            if ((ctrl.notificationList[index].requestId
                                    ?.status ==
                                Status.removed.name)) {
                              await ctrl.updateNotificationStatus(
                                  requestId: ctrl
                                      .notificationList[index].requestId!.id
                                      .toString(),
                                  status: Status.accepted.name,
                                  clientID: ctrl.notificationList[index]
                                      .requestId!.clientId
                                      .toString(),
                                  therapistID: ctrl.notificationList[index]
                                      .requestId!.therapistId
                                      .toString());
                            } else {
                              await ctrl.deleteNotificationRequest(
                                  requestId: ctrl
                                      .notificationList[index].requestId!.id
                                      .toString());
                            }
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
  final VoidCallback? onDeclineTap, onAcceptTap, onRemoveTap;
  Function(BuildContext)? onDeleteTap;

  GeneralNotificationCard({
    super.key,
    this.title,
    this.description,
    this.type = 'request',
    this.status = 'pending',
    this.onDeclineTap,
    this.onAcceptTap,
    this.onRemoveTap,
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
                          : (status == Status.removed.name)
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
                                          bgColor: kGreyColor2,
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
                                              onTap: onRemoveTap,
                                              bgColor: Colors.red.shade600,
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
  final String? title, message;
  const RequestDeclineCard({super.key, this.title, this.message});

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
                  text: title ?? 'Request Declined!',
                  size: 16,
                  textAlign: TextAlign.center,
                  weight: FontWeight.w600,
                ),
                MyText(
                  textAlign: TextAlign.center,
                  paddingTop: 6,
                  text:
                      "${message ?? "You have declined the request"}. The user will be notified, and no connection has been made.",
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
