import 'package:flutter/material.dart';
import 'package:mood_prints/constants/app_colors.dart';
import 'package:mood_prints/main.dart';
import 'package:mood_prints/view/widget/common_image_view_widget.dart';
import 'package:mood_prints/view/widget/my_text_widget.dart';

// ignore: must_be_immutable
class ChatBubble extends StatelessWidget {
  ChatBubble({
    Key? key,
    required this.isMe,
    required this.otherUserImg,
    required this.otherUserName,
    required this.msgTime,
    required this.msg,
    required this.myImg,
    required this.haveImages,
    required this.images,
  }) : super(key: key);

  final String msg, otherUserName, otherUserImg, msgTime, myImg;
  final bool isMe, haveImages;
  final List<String> images;

  @override
  Widget build(BuildContext context) {
    if (haveImages) {
      return isMe ? _rightImageBubble() : _leftImageBubble();
    } else {
      return isMe ? _rightMessageBubble() : _leftMessageBubble();
    }
  }

  Widget _rightMessageBubble() {
    return Padding(
      padding: EdgeInsets.only(
        bottom: 16,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: kSecondaryColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(0),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      MyText(
                        text: msg,
                        size: 11.36,
                        color: kPrimaryColor,
                        paddingBottom: 2,
                      ),
                      Text(
                        msgTime,
                        style: TextStyle(
                          fontSize: 12.39,
                          color: kPrimaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 10.31,
          ),
          _profileImage(dummyImg),
        ],
      ),
    );
  }

  Widget _leftMessageBubble() {
    return Padding(
      padding: EdgeInsets.only(
        bottom: 16,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _profileImage(otherUserImg),
          SizedBox(
            width: 10.39,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IntrinsicWidth(
                  child: Container(
                    margin: EdgeInsets.only(right: 49.48),
                    padding: EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: kWhiteColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                        bottomLeft: Radius.circular(0),
                        bottomRight: Radius.circular(10),
                      ),
                    ),
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: MyText(
                            text: otherUserName,
                            size: 13.42,
                            weight: FontWeight.w600,
                            color: kSecondaryColor,
                            paddingBottom: 10.32,
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: MyText(
                            text: msg,
                            size: 11.36,
                            paddingBottom: 2,
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Text(
                            msgTime,
                            style: TextStyle(
                              fontSize: 11.36,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _leftImageBubble() {
    return Padding(
      padding: EdgeInsets.only(
        bottom: 16,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _profileImage(otherUserImg),
          SizedBox(
            width: 10.39,
          ),
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 4.13,
                mainAxisSpacing: 4.13,
                mainAxisExtent: 103.23,
              ),
              physics: BouncingScrollPhysics(),
              itemCount: images.length,
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return CommonImageView(
                  height: 103.23,
                  width: 103.23,
                  radius: 4.13,
                  url: images[index],
                );
              },
            ),
          ),
          SizedBox(width: 49.48),
        ],
      ),
    );
  }

  Widget _rightImageBubble() {
    return Padding(
      padding: EdgeInsets.only(
        bottom: 16,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          SizedBox(width: 49.48),
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 4.13,
                mainAxisSpacing: 4.13,
                mainAxisExtent: 103.23,
              ),
              physics: BouncingScrollPhysics(),
              itemCount: images.length,
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return CommonImageView(
                  height: 103.23,
                  width: 103.23,
                  radius: 4.13,
                  url: images[index],
                );
              },
            ),
          ),
          SizedBox(
            width: 10.31,
          ),
          _profileImage(dummyImg),
        ],
      ),
    );
  }

  Widget _profileImage(String url) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        CommonImageView(
          height: 41.29,
          width: 41.29,
          url: url,
          fit: BoxFit.cover,
          radius: 100,
        ),
        Positioned(
          right: 0,
          bottom: 0,
          child: Container(
            height: 11.84,
            width: 11.84,
            decoration: BoxDecoration(
              border: Border.all(
                width: 1.97,
                color: kPrimaryColor,
              ),
              shape: BoxShape.circle,
              color: kSecondaryColor,
            ),
          ),
        ),
      ],
    );
  }
}
