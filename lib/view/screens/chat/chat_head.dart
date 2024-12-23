import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mood_prints/constants/app_sizes.dart';
import 'package:mood_prints/main.dart';
import 'package:mood_prints/view/screens/chat/chat_screen.dart';
import 'package:mood_prints/view/widget/chat_head_tiles_widget.dart';
import 'package:mood_prints/view/widget/custom_app_bar_widget.dart';

class ChatHead extends StatelessWidget {
  const ChatHead({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: simpleAppBar(
        title: 'Chats',
        centerTitle: false,
        haveLeading: false,
      ),
      body: ListView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.fromLTRB(20, 16, 20, 100),
        physics: BouncingScrollPhysics(),
        itemCount: 10,
        itemBuilder: (context, index) {
          return ChatHeadTiles(
            profileImage: dummyImg,
            name: 'Josiah Zayner',
            lastMsg: 'How are you today?',
            time: index == 0 ? '18.31' : 'Yesterday',
            unreadCount: index == 0 ? 3 : 0,
            onTap: () => Get.to(() => ChatScreen()),
            isNewMessage: index == 0,
            isOnline: index == 2 ? false : true,
            isAway: index == 2 ? true : false,
          );
        },
      ),
    );
  }
}
