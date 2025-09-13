import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mood_prints/constants/all_urls.dart';
import 'package:mood_prints/constants/app_colors.dart';
import 'package:mood_prints/constants/firebase_const.dart';
import 'package:mood_prints/controller/chat/chat_controller.dart';
import 'package:mood_prints/core/common/global_instance.dart';
import 'package:mood_prints/core/enums/user_type.dart';
import 'package:mood_prints/main.dart';
import 'package:mood_prints/model/chat/chat_thread_model.dart';
import 'package:mood_prints/model/client_model/user_model.dart';
import 'package:mood_prints/services/date_formator/general_service.dart';
import 'package:mood_prints/services/user/user_services.dart';
import 'package:mood_prints/services/user/user_type_service.dart';
import 'package:mood_prints/view/screens/chat/chat_screen.dart';
import 'package:mood_prints/view/widget/chat_head_tiles_widget.dart';
import 'package:mood_prints/view/widget/custom_app_bar_widget.dart';
import 'package:mood_prints/view/widget/my_text_widget.dart';

class ChatHead extends StatefulWidget {
  ChatHead({Key? key}) : super(key: key);

  @override
  State<ChatHead> createState() => _ChatHeadState();
}

class _ChatHeadState extends State<ChatHead> {
  var ctrl = Get.find<ChatController>();

  // Future<UserModel> fetchUserDetails(String userId) async {
  Future<UserModel> fetchUserDetails(String userId) async {
    try {
      var model = UserModel();
      final url = getClientByIDUrl + userId;
      final response =
          await apiService.get(url, false, showResult: false, successCode: 200);

      if (response != null) {
        final user = response['user'];

        model = UserModel.fromJson(user);
        // log('User Model -> ${model.toJson()}');
        return model;
      }
      return model;
    } catch (e) {
      log("This exception occurred while getting chat user data: $e");
      return UserModel();
    }
  }

  @override
  void initState() {
    super.initState();
    UserTypeService.instance.initUserType();
  }

  @override
  Widget build(BuildContext context) {
    // log("Called Init: ${UserTypeService.instance.userType}}");
    return Obx(
      () => Scaffold(
        appBar: simpleAppBar(
            title: 'Chats', centerTitle: false, haveLeading: false),
        body: (UserTypeService.instance.userType == UserType.client.name &&
                UserService.instance.userModel.value.authorizeTherapistAccess ==
                    false)
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.warning,
                      color: Colors.amber.shade600,
                      size: 70,
                    ),
                    MyText(
                      paddingTop: 10,
                      text: "Therapist Access Revoked",
                      size: 18,
                      color: kSecondaryColor,
                      weight: FontWeight.w600,
                    ),
                    MyText(
                      paddingLeft: 20,
                      paddingRight: 20,
                      textAlign: TextAlign.center,
                      paddingTop: 5,
                      text:
                          """You have disabled therapist access to your mood and emotional data. Your chats with your therapist will be disabled, and your therapist will no longer see your mood entries or updates.\n\n You can re-enable access anytime in Settings > My Therapist to resume therapist support.""",
                      size: 13,
                    ),
                  ],
                ),
              )
            : StreamBuilder(
                stream: chatCollection
                    .where('participants',
                        arrayContains: (UserTypeService.instance.userType ==
                                UserType.therapist.name)
                            ? UserService.instance.therapistDetailModel.value.id
                            : UserService.instance.userModel.value.id)
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.chat,
                          color: kGreyColor.withOpacity(0.5),
                          size: 50,
                        ),
                        MyText(
                          paddingTop: 10,
                          text: 'No Chats Found',
                          size: 16,
                          weight: FontWeight.w300,
                          color: kGreyColor.withOpacity(0.7),
                        )
                      ],
                    ));
                  }

                  List<ChatThreadModel> chatThreads = snapshot.data!.docs
                      .map((doc) => ChatThreadModel.fromMap(doc))
                      .toList();

                  return ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    itemCount: chatThreads.length,
                    itemBuilder: (context, index) {
                      ChatThreadModel chat = chatThreads[index];

                      //-------- Get the other user's ID -----------

                      String? myUserId =
                          UserService.instance.therapistDetailModel.value.id;

                      String otherUserId = chat.participants.firstWhere(
                        (id) => id != myUserId,
                        orElse: () => '',
                      );

                      // log('Other User ID -> $otherUserId');

                      return FutureBuilder<UserModel>(
                        future: fetchUserDetails(otherUserId),
                        builder: (context, userSnapshot) {
                          if (userSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return ListTile(title: Text('Loading...'));
                          }
                          if (!userSnapshot.hasData) {
                            return ListTile(title: Text('User not found'));
                          }
                          UserModel user = userSnapshot.data!;

                          return ChatHeadTiles(
                            profileImage: user.image ?? dummyImg,
                            name: user.fullName ?? "Unknown",
                            lastMsg: chat.lastMessage ?? "No messages yet",
                            time: (chat.lastMessageTime != null)
                                ? DateTimeService.instance
                                    .getSimpleUSDateFormat(
                                        chat.lastMessageTime!)
                                : "",
                            unreadCount: chat.unSeenMessage == true ? 1 : 0,
                            onTap: () => Get.to(() => ChatScreen(
                                  userName: user.fullName.toString(),
                                  profileImage: user.image.toString(),
                                  chatHeadID: chatThreads[index]
                                      .chatThreadId
                                      .toString(),
                                  clientID: otherUserId,
                                )),
                            isOnline: false,
                            isAway: false,
                            isNewMessage: false,
                          );
                        },
                      );
                    },
                  );
                },
              ),
      ),
    );
  }
}
