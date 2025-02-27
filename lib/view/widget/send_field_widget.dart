import 'package:flutter/material.dart';
import 'package:mood_prints/constants/app_colors.dart';
import 'package:mood_prints/constants/app_images.dart';
import 'package:mood_prints/constants/app_sizes.dart';

class SendField extends StatelessWidget {
  SendField({
    Key? key,
    this.hintText,
    this.controller,
    this.onChanged,
    this.onTap,
    this.validator,
    this.onAttachmentTap,
    this.onEmojiTap,
    this.haveSendButton = false,
    this.isLoading = false,
    this.onSendTap,
  }) : super(key: key);
  final String? hintText;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final GestureTapCallback? onTap;
  final FormFieldValidator<String>? validator;
  final VoidCallback? onEmojiTap, onAttachmentTap, onSendTap;
  final bool haveSendButton;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppSizes.DEFAULT,
      decoration: BoxDecoration(
        color: kPrimaryColor,
        border: Border(
          top: BorderSide(
            color: Color(0xffEDEDED),
            width: 1.0,
          ),
        ),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: onAttachmentTap,
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: kWhiteColor,
              ),
              child: Center(
                child: Image.asset(
                  Assets.imagesAttachment,
                  height: 23.99,
                  color: kSecondaryColor,
                ),
              ),
            ),
          ),
          SizedBox(
            width: 8,
          ),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: TextFormField(
                cursorColor: Colors.black,
                // textAlignVertical: TextAlignVertical.center,
                controller: controller,
                onTap: onTap,
                onChanged: onChanged,
                validator: validator,
                autovalidateMode: AutovalidateMode.always,
                cursorWidth: 1.0,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                ),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: kWhiteColor,
                  hintText: 'Write a message...',
                  hintStyle: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 15,
                  ),
                  // suffixIcon: Column(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [
                  //     GestureDetector(
                  //       onTap: onAttachmentTap,
                  //       child: Image.asset(
                  //         Assets.imagesMic,
                  //         height: 23.99,
                  //         color: kSecondaryColor,
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  focusedErrorBorder: InputBorder.none,
                ),
              ),
            ),
          ),
          SizedBox(
            width: 8,
          ),
          (haveSendButton)
              ? GestureDetector(
                  onTap: onSendTap,
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: kWhiteColor,
                    ),
                    child: Center(
                        child: (isLoading)
                            ? SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                    color: kSecondaryColor, strokeWidth: 2.0),
                              )
                            : Icon(
                                Icons.send,
                                color: kSecondaryColor,
                              )
                        //  Image.asset(
                        //   Assets.imagesMic,
                        //   height: 23.99,
                        //   color: kSecondaryColor,
                        // ),
                        ),
                  ),
                )
              : GestureDetector(
                  onTap: onAttachmentTap,
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: kWhiteColor,
                    ),
                    child: Center(
                      child: Image.asset(
                        Assets.imagesMic,
                        height: 23.99,
                        color: kSecondaryColor,
                      ),
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
