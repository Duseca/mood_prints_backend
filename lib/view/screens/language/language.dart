import 'package:flutter/material.dart';
import 'package:mood_prints/constants/app_colors.dart';
import 'package:mood_prints/constants/app_sizes.dart';
import 'package:mood_prints/constants/app_styling.dart';
import 'package:mood_prints/view/widget/custom_app_bar_widget.dart';
import 'package:mood_prints/view/widget/custom_check_box_widget.dart';
import 'package:mood_prints/view/widget/my_button_widget.dart';
import 'package:mood_prints/view/widget/my_text_widget.dart';


class Language extends StatelessWidget {
  const Language({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: simpleAppBar(
        title: 'Language',
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ListView(
              shrinkWrap: true,
              padding: AppSizes.DEFAULT,
              physics: BouncingScrollPhysics(),
              children: [
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: AppStyling.CUSTOM_TILE,
                  child: ListView.separated(
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    physics: BouncingScrollPhysics(),
                    itemCount: 1,
                    separatorBuilder: (context, index) {
                      return Container(
                        height: 1,
                        color: kBorderColor,
                        margin: EdgeInsets.symmetric(vertical: 16),
                      );
                    },
                    itemBuilder: (context, index) {
                      final List<String> _items = [
                        'English',
                      ];
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          MyText(
                            text: _items[index],
                            size: 14,
                            weight: FontWeight.w600,
                          ),
                          CustomCheckBox(
                            isRadio: true,
                            isActive: index == 0,
                            onTap: () {},
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: AppSizes.DEFAULT,
            child: MyButton(
              buttonText: 'Save changes',
              onTap: () {},
            ),
          ),
        ],
      ),
    );
  }
}
