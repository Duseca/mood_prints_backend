import 'package:flutter/material.dart';
import 'package:mood_prints/constants/app_colors.dart';
import 'package:mood_prints/constants/app_images.dart';
import 'package:mood_prints/view/widget/common_image_view_widget.dart';
import 'package:mood_prints/view/widget/my_text_widget.dart';

// ignore: must_be_immutable
class ChatHeadTiles extends StatelessWidget {
  ChatHeadTiles({
    Key? key,
    required this.profileImage,
    required this.name,
    required this.lastMsg,
    required this.time,
    this.unreadCount = 0,
    required this.onTap,
    required this.isOnline,
    required this.isAway,
    required this.isNewMessage,
  }) : super(key: key);

  final String profileImage, name, lastMsg, time;
  int? unreadCount;
  final VoidCallback onTap;
  final bool isOnline, isAway, isNewMessage;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Material(
        color: Colors.transparent,
        child: ListTile(
          selected: true,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(7.8),
          ),
          selectedTileColor:
              isNewMessage ? kSecondaryColor.withOpacity(0.10) : kWhiteColor,
          onTap: onTap,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 7.8,
            vertical: 0,
          ),
          leading: Stack(
            children: [
              CommonImageView(
                height: 47,
                width: 47,
                url: profileImage,
                fit: BoxFit.cover,
                radius: 100,
              ),
              Positioned(
                right: 2,
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
                    color: isOnline ? kSecondaryColor : Colors.transparent,
                  ),
                ),
              ),
            ],
          ),
          title: MyText(
            text: name,
            weight: FontWeight.w600,
            paddingBottom: 4,
            size: 12.67,
            maxLines: 1,
          ),
          subtitle: Row(
            children: [
              Image.asset(
                Assets.imagesDoubleTick,
                height: 15.6,
              ),
              Expanded(
                child: MyText(
                  paddingLeft: 4,
                  text: lastMsg,
                  size: 11.7,
                  color: kGreyColor,
                  maxLines: 1,
                  textOverflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          trailing: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MyText(
                paddingTop: unreadCount! > 0 ? 10 : 0,
                text: time,
                size: 10.72,
                color: kGreyColor,
                paddingBottom: unreadCount! > 0 ? 5 : 0,
              ),
              unreadCount! > 0
                  ? Container(
                      margin: EdgeInsets.only(bottom: 5),
                      height: 20,
                      width: 20,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: kSecondaryColor,
                      ),
                      child: Center(
                        child: MyText(
                          text: unreadCount.toString(),
                          size: 8.77,
                          paddingLeft: 1,
                          weight: FontWeight.w700,
                          color: kPrimaryColor,
                        ),
                      ),
                    )
                  : SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
