import 'package:flutter/material.dart';
import 'package:mood_prints/constants/app_images.dart';
import 'package:mood_prints/constants/app_sizes.dart';
import 'package:mood_prints/constants/app_styling.dart';
import 'package:mood_prints/view/widget/my_text_widget.dart';

class CustomCard extends StatelessWidget {
  const CustomCard({
    super.key,
    required this.title,
    this.onEdit,
    this.onMore,
    required this.child,
    this.haveEditButton = true,
  });

  final String title;
  final Widget child;
  final VoidCallback? onEdit;
  final VoidCallback? onMore;
  final bool haveEditButton;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppStyling.CUSTOM_CARD,
      padding: AppSizes.DEFAULT,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    MyText(
                      text: title,
                      size: 16,
                      weight: FontWeight.w600,
                      paddingRight: 8,
                    ),
                    Visibility(
                      visible: haveEditButton,
                      child: GestureDetector(
                        onTap: onEdit,
                        child: Image.asset(
                          Assets.imagesPencil,
                          height: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: haveEditButton,
                child: GestureDetector(
                  onTap: onMore,
                  child: Image.asset(
                    Assets.imagesMoreHorizontal,
                    height: 20,
                  ),
                ),
              ),
            ],
          ),
          child,
        ],
      ),
    );
  }
}
