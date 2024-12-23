import 'package:mood_prints/constants/app_colors.dart';
import 'package:mood_prints/view/widget/my_text_widget.dart';
import 'package:flutter/material.dart';

class AuthHeading extends StatelessWidget {
  const AuthHeading({
    super.key,
    required this.title,
    required this.subTitle,
    this.marginTop,
  });
  final String? title;
  final String? subTitle;
  final double? marginTop;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        MyText(
          paddingTop: marginTop ?? 10,
          text: title ?? '',
          size: 24,
          paddingBottom: 6,
          weight: FontWeight.bold,
        ),
        if (subTitle!.isNotEmpty)
          MyText(
            text: subTitle ?? '',
            size: 14,
            lineHeight: 1.5,
            paddingBottom: 24,
            color: kGreyColor,
            weight: FontWeight.w500,
          ),
      ],
    );
  }
}
