import 'package:flutter/material.dart';
import 'package:mood_prints/constants/app_colors.dart';
import 'package:mood_prints/constants/app_sizes.dart';
import 'package:mood_prints/view/widget/custom_app_bar_widget.dart';
import 'package:mood_prints/view/widget/my_text_widget.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: simpleAppBar(
        title: 'Privacy Policy',
      ),
      body: ListView(
        shrinkWrap: true,
        padding: AppSizes.DEFAULT,
        physics: BouncingScrollPhysics(),
        children: [
          MyText(
            text: 'Introduction',
            size: 16,
            weight: FontWeight.w600,
            paddingBottom: 8,
          ),
          MyText(
            text:
                'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
            size: 12,
            weight: FontWeight.w500,
            color: kGreyColor2,
            lineHeight: 1.5,
            paddingBottom: 14,
          ),
          ...List.generate(
            3,
            (index) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MyText(
                    paddingTop: 3,
                    text: '*',
                    size: 12,
                    weight: FontWeight.w500,
                    color: kGreyColor,
                    lineHeight: 1.5,
                  ),
                  Expanded(
                    child: MyText(
                      paddingLeft: 10,
                      paddingBottom: 8,
                      text:
                          'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt.',
                      size: 12,
                      weight: FontWeight.w500,
                      color: kGreyColor,
                      lineHeight: 1.5,
                    ),
                  ),
                ],
              );
            },
          ),
          MyText(
            paddingTop: 10,
            text: 'Information we collect',
            size: 16,
            weight: FontWeight.w600,
            paddingBottom: 8,
          ),
          MyText(
            text:
                'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
            size: 12,
            weight: FontWeight.w500,
            color: kGreyColor,
            lineHeight: 1.5,
            paddingBottom: 14,
          ),
          ...List.generate(
            1,
            (index) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MyText(
                    paddingTop: 3,
                    text: '*',
                    size: 12,
                    weight: FontWeight.w500,
                    color: kGreyColor,
                    lineHeight: 1.5,
                  ),
                  Expanded(
                    child: MyText(
                      paddingLeft: 10,
                      paddingBottom: 8,
                      text:
                          'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt.',
                      size: 12,
                      weight: FontWeight.w500,
                      color: kGreyColor,
                      lineHeight: 1.5,
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
