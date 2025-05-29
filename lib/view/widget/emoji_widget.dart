import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mood_prints/constants/app_colors.dart';

// ignore: must_be_immutable
class EmojiCustomWidget extends StatelessWidget {
  void Function(Category?, Emoji)? onEmojiSelected;
  EmojiCustomWidget({
    super.key,
    required this.onEmojiSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height * 0.45,
      padding: EdgeInsets.symmetric(
        horizontal: 10,
      ),
      decoration: BoxDecoration(
        color: kWhiteColor,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 15, bottom: 10),
            height: 4,
            width: 80,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.2),
              borderRadius: BorderRadius.circular(100),
            ),
          ),

          // ----------> Emoji Picker <----------

          EmojiPicker(
              onEmojiSelected: onEmojiSelected,
              //  (Category? category, Emoji emoji) {
              //   String SelectedEmoji = emoji.emoji;

              //   // Do something when emoji is tapped (optional)
              //   // log(
              //   //   'e: ${emoji.toString()}',
              //   // );

              //   log(
              //     'emoji: ${SelectedEmoji}',
              //   );
              // },
              onBackspacePressed: () {
                // Do something when the user taps the backspace button (optional)
                // Set it to null to hide the Backspace-Button
              },
              config: Config(
                  categoryViewConfig: CategoryViewConfig(
                    indicatorColor: kSecondaryColor,
                    iconColorSelected: kSecondaryColor,
                    backgroundColor: Colors.transparent,
                    tabIndicatorAnimDuration: Duration(milliseconds: 100),
                  ),
                  bottomActionBarConfig: BottomActionBarConfig(enabled: false),
                  height: Get.height * 0.4,
                  // bgColor: const Color(0xFFF2F2F2),
                  checkPlatformCompatibility: true,
                  emojiViewConfig: EmojiViewConfig(
                      verticalSpacing: 5, backgroundColor: Colors.transparent
                      // Issue:
                      )))
        ],
      ),
    );
  }
}
