import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mood_prints/constants/app_colors.dart';
import 'package:mood_prints/constants/app_images.dart';
import 'package:mood_prints/constants/app_sizes.dart';
import 'package:mood_prints/constants/firebase_const.dart';
import 'package:mood_prints/controller/chat/chat_controller.dart';
import 'package:mood_prints/core/enums/message_type.dart';
import 'package:mood_prints/core/enums/user_type.dart';
import 'package:mood_prints/main.dart';
import 'package:mood_prints/model/chat/message_model.dart';
import 'package:mood_prints/services/date_formator/general_service.dart';
import 'package:mood_prints/services/user/user_services.dart';
import 'package:mood_prints/services/user/user_type_service.dart';
import 'package:mood_prints/view/screens/chat/view_picture.dart';
import 'package:mood_prints/view/screens/therapist/report/report.dart';
import 'package:mood_prints/view/widget/chat_bubble_widget.dart';
import 'package:mood_prints/view/widget/common_image_view_widget.dart';
import 'package:mood_prints/view/widget/my_text_widget.dart';
import 'package:mood_prints/view/widget/send_field_widget.dart';

class ChatScreen extends StatefulWidget {
  final String profileImage;
  final String userName;
  final String chatHeadID;
  final String clientID;

  ChatScreen({
    required this.profileImage,
    required this.userName,
    required this.chatHeadID,
    required this.clientID,
  });
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollToBottom(); // Scroll to bottom when chat opens
  }

  void _scrollToBottom() {
    Future.delayed(Duration(milliseconds: 500), () {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  Stream<QuerySnapshot> getMessagesStream() {
    return chatCollection
        .doc(widget.chatHeadID)
        .collection("messages")
        .orderBy("sentAt", descending: false) // Natural chat order
        .snapshots();
  }

  var ctrl = Get.find<ChatController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: kWhiteColor,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () => Get.back(),
              child: RotatedBox(
                quarterTurns: 2,
                child: Image.asset(
                  Assets.imagesArrowNext,
                  height: 22,
                ),
              ),
            ),
            SizedBox(
              width: 8,
            ),
            CommonImageView(
              height: 38,
              width: 38,
              url: widget.profileImage,
              radius: 100.0,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  MyText(
                    paddingLeft: 12,
                    text: '${widget.userName}',
                    size: 16.43,
                    paddingBottom: 2,
                    weight: FontWeight.w600,
                  ),
                  // MyText(
                  //   paddingLeft: 12,
                  //   text: 'Online',
                  //   size: 10,
                  //   color: kSecondaryColor,
                  // ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          Center(
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 10,
              children: [
                // If user is therapist than display the chart-button else nothing to display
                (UserTypeService.instance.userType == UserType.therapist.name)
                    ? GestureDetector(
                        onTap: () {
                          Get.to(() => Report(
                                clientID: widget.clientID,
                              ));
                        },
                        child: Icon(
                          Icons.bar_chart,
                          size: 20,
                          color: kHintColor.withOpacity(0.8),
                        ),
                      )
                    : SizedBox.shrink(),
                SizedBox(),
              ],
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: getMessagesStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text("No messages yet"));
                }

                return ListView.builder(
                  controller: _scrollController,
                  padding: EdgeInsets.fromLTRB(15, 10, 15, 70),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    MessageModel msg = MessageModel.fromMap(
                      snapshot.data!.docs[index].data() as Map<String, dynamic>,
                    );

                    bool isCurrentUserMsg = (UserTypeService
                                .instance.userType ==
                            UserType.therapist.name)
                        ? UserService.instance.therapistDetailModel.value.id ==
                            snapshot.data!.docs[index]['sentBy']
                        : UserService.instance.userModel.value.id ==
                            snapshot.data!.docs[index]['sentBy'];

                    log('$isCurrentUserMsg');

                    return ChatBubble(
                      isMe: (UserTypeService.instance.userType ==
                              UserType.therapist.name)
                          ? msg.sentBy ==
                              UserService.instance.therapistDetailModel.value.id
                          : msg.sentBy ==
                              UserService.instance.userModel.value.id,
                      myImg: dummyImg,
                      msg: msg.textMessage ?? "",
                      otherUserImg: msg.senderProfileImage ?? "",
                      otherUserName: msg.senderName ?? "Unknown",
                      msgTime: msg.sentAt != null
                          ? DateTimeService.instance
                              .formatTimeToAMPM(msg.sentAt!)
                          : "",
                      haveImages: (msg.messageType == MsgType.picture_msg.name)
                          ? true
                          : false,
                      imageUrl: msg.pictureMedia,
                      onImageTap: () {
                        Get.to(() =>
                            ViewPicture(imageUrl: msg.pictureMedia.toString()));
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      bottomSheet: Obx(
        () => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // -------- If Image picked from gallery --------

            (ctrl.selectedImage.value != null)
                ? Padding(
                    padding: AppSizes.DEFAULT,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Display Image

                        Container(
                          height: 150,
                          width: 150,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                  image: FileImage(
                                      File(ctrl.selectedImage.value!)),
                                  fit: BoxFit.cover)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              InkWell(
                                onTap: () {
                                  ctrl.selectedImage.value = null;
                                },
                                child: Container(
                                    height: 24,
                                    width: 24,
                                    decoration: BoxDecoration(
                                        color: Colors.red,
                                        shape: BoxShape.circle),
                                    child: Icon(
                                      Icons.close,
                                      color: kPrimaryColor,
                                      size: 16,
                                    )),
                              )
                            ],
                          ),
                        ),

                        // Send Image button
                        GestureDetector(
                          onTap: () {
                            log('Press');

                            if (UserTypeService.instance.userType ==
                                UserType.therapist.name) {
                              final user = UserService
                                  .instance.therapistDetailModel.value;

                              ctrl.messagesPictureHandler(
                                type: MsgType.picture_msg.name,
                                senderID: user.id!,
                                senderName: user.fullName!,
                                senderProfileImage: user.image!,
                                threadID: widget.chatHeadID,
                              );

                              _scrollToBottom();
                            } else {
                              final user = UserService.instance.userModel.value;

                              ctrl.messagesPictureHandler(
                                type: MsgType.picture_msg.name,
                                senderID: user.id!,
                                senderName: user.fullName!,
                                senderProfileImage: user.image!,
                                threadID: widget.chatHeadID,
                              );

                              _scrollToBottom();
                            }
                          },
                          child: Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: kSecondaryColor),
                              color: kWhiteColor,
                            ),
                            child: Center(
                                child: (ctrl.isLoading.value)
                                    ? SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                            color: kSecondaryColor,
                                            strokeWidth: 2.0),
                                      )
                                    : Icon(
                                        Icons.send,
                                        color: kSecondaryColor,
                                      )),
                          ),
                        )
                      ],
                    ),
                  )
                : SendField(
                    controller: ctrl.textMessageController,
                    haveSendButton: true,
                    isLoading: ctrl.isLoading.value,
                    onAttachmentTap: () {
                      Get.bottomSheet(_MoreContent());
                    },
                    onSendTap: () async {
                      log("My Terrible Code");

                      if (UserTypeService.instance.userType ==
                          UserType.therapist.name) {
                        log("1");
                        final user =
                            UserService.instance.therapistDetailModel.value;

                        if (ctrl.isLoading.value == false) {
                          if (ctrl.textMessageController.text
                              .trim()
                              .isNotEmpty) {
                            ctrl.messagesHandler(
                                type: MsgType.text_msg.name,
                                senderID: user.id!,
                                senderName: user.fullName!,
                                senderProfileImage: user.image!,
                                threadID: widget.chatHeadID,
                                newMessage:
                                    ctrl.textMessageController.text.trim());

                            _scrollToBottom();
                          }
                        } else {
                          log("------> My Terrible Therapist");
                        }
                      } else {
                        final user = UserService.instance.userModel.value;

                        if (ctrl.isLoading.value == false) {
                          if (ctrl.textMessageController.text
                              .trim()
                              .isNotEmpty) {
                            ctrl.messagesHandler(
                                type: MsgType.text_msg.name,
                                senderID: user.id!,
                                senderName: user.fullName!,
                                senderProfileImage: user.image!,
                                threadID: widget.chatHeadID,
                                newMessage:
                                    ctrl.textMessageController.text.trim());

                            _scrollToBottom();
                          }
                        } else {
                          log("------> My Terrible User ");
                        }
                      }
                    },
                  ),
          ],
        ),
      ),
    );
  }
}

class NewMessageBage extends StatelessWidget {
  const NewMessageBage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Expanded(
        //   child: HorizantalDivider(
        //     color: kSecondaryColor,
        //     thickness: 0.8,
        //   ),
        // ),
        MyText(
          paddingLeft: 15,
          paddingRight: 15,
          text: "New messages",
          size: 12,
          weight: FontWeight.w500,
          color: kSecondaryColor,
        ),
        // Expanded(
        //   child: HorizantalDivider(
        //     color: kSecondaryColor,
        //     thickness: 0.8,
        //   ),
        // )
      ],
    );
  }
}

class _MoreContent extends StatefulWidget {
  const _MoreContent({super.key});

  @override
  State<_MoreContent> createState() => _MoreContentState();
}

class _MoreContentState extends State<_MoreContent> {
  var ctrl = Get.find<ChatController>();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppSizes.DEFAULT,
      decoration: BoxDecoration(
          color: kPrimaryColor,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 25),
            height: 2,
            width: 100,
            color: kGreyColor2.withOpacity(0.5),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _MoreButton(
                icon: Icons.photo,
                text: 'Gallery',
                onTap: () {
                  ctrl.imageFromGallery();
                },
              ),
              _MoreButton(
                text: 'Camera',
                onTap: () {
                  ctrl.imageFromCamera();
                },
              ),
            ],
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}

class _MoreButton extends StatelessWidget {
  final String? text;
  final IconData? icon;
  final VoidCallback? onTap;
  const _MoreButton({
    super.key,
    this.icon,
    this.text,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.all(15),
            decoration:
                BoxDecoration(color: kSecondaryColor, shape: BoxShape.circle),
            child: Icon(
              icon ?? Icons.camera,
              color: kPrimaryColor,
            ),
          ),
        ),
        MyText(paddingTop: 5, text: '$text')
      ],
    );
  }
}
