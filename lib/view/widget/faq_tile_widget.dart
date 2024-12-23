import 'package:mood_prints/constants/app_colors.dart';
import 'package:mood_prints/view/widget/my_text_widget.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';

class FaqTile extends StatelessWidget {
  const FaqTile({
    required this.title,
    required this.subTitle,
  });
  final String title;
  final String subTitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.symmetric(
        horizontal: 18,
      ),
      decoration: BoxDecoration(
        color: kWhiteColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ExpandableNotifier(
        child: ScrollOnExpand(
          child: ExpandablePanel(
            theme: ExpandableThemeData(
              tapHeaderToExpand: true,
              hasIcon: false,
            ),
            header: Container(
              height: 48,
              child: Row(
                children: [
                  Expanded(
                    child: MyText(
                      paddingLeft: 5,
                      text: title,
                      size: 14,
                      weight: FontWeight.w600,
                    ),
                  ),
                  Icon(
                    Icons.arrow_drop_down,
                  ),
                ],
              ),
            ),
            collapsed: SizedBox(),
            expanded: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  height: 1,
                  color: kBorderColor,
                ),
                MyText(
                  paddingTop: 12,
                  text: subTitle,
                  paddingLeft: 10,
                  paddingRight: 10,
                  paddingBottom: 20,
                  lineHeight: 1.6,
                  size: 14,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
