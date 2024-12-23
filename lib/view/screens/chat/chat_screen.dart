import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mood_prints/constants/app_colors.dart';
import 'package:mood_prints/constants/app_images.dart';

import 'package:mood_prints/main.dart';
import 'package:mood_prints/view/screens/therapist/report/report.dart';
import 'package:mood_prints/view/widget/chat_bubble_widget.dart';
import 'package:mood_prints/view/widget/common_image_view_widget.dart';
import 'package:mood_prints/view/widget/my_text_widget.dart';
import 'package:mood_prints/view/widget/send_field_widget.dart';

class ChatScreen extends StatefulWidget {
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<Map<String, dynamic>> chat = [
    {
      'isMe': true,
      'msg': 'Really!',
      'otherUserName': 'Marley Calzoni',
      'otherUserImg': dummyImg,
      'msgTime': '3:53 PM',
      'haveTaskBubble': false,
      'taskDetail': {},
    },
    {
      'isMe': false,
      'msg': 'Yeah, It’s really good!',
      'otherUserName': 'Marley Calzoni',
      'otherUserImg': dummyImg,
      'msgTime': '3:53 PM',
      'haveTaskBubble': false,
      'taskDetail': {},
    },
    {
      'isMe': false,
      'msg': 'Hi, Duseca! Welcome to our team',
      'otherUserName': 'Duseca software',
      'otherUserImg': dummyImg,
      'msgTime': '3:53 PM',
      'haveTaskBubble': true,
      'taskDetail': {},
    },
  ];

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
              url: dummyImg,
              radius: 100.0,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  MyText(
                    paddingLeft: 12,
                    text: 'Theo',
                    size: 16.43,
                    paddingBottom: 2,
                    weight: FontWeight.w600,
                  ),
                  MyText(
                    paddingLeft: 12,
                    text: 'Online',
                    size: 10,
                    color: kSecondaryColor,
                  ),
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
                GestureDetector(
                  onTap: () {
                    Get.to(() => Report());
                  },
                  child: Icon(
                    Icons.more_vert,
                    size: 20,
                    color: Colors.black,
                  ),
                ),
                SizedBox(),
              ],
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: chat.length,
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.fromLTRB(15, 60, 15, 100),
              itemBuilder: (context, index) {
                var data = chat[index];
                return ChatBubble(
                  isMe: data['isMe'],
                  myImg: dummyImg,
                  msg: data['msg'],
                  otherUserImg: data['otherUserImg'],
                  otherUserName: data['otherUserName'],
                  msgTime: data['msgTime'],
                  images: index == 2
                      ? [
                          dummyImg,
                          dummyImg,
                          dummyImg,
                          dummyImg,
                        ]
                      : [],
                  haveImages: index == 2,
                );
              },
            ),
          ),
          SendField(),
        ],
      ),
    );
  }
}
