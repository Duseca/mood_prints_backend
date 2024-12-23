import 'package:flutter/material.dart';
import 'package:mood_prints/constants/app_images.dart';
import 'package:mood_prints/constants/app_sizes.dart';
import 'package:mood_prints/constants/app_styling.dart';
import 'package:mood_prints/view/widget/my_text_widget.dart';

class CustomCard extends StatelessWidget {
  const CustomCard({
    super.key,
    required this.title,
    required this.onEdit,
    required this.onMore,
    required this.child,
  });
  final String title;
  final Widget child;
  final VoidCallback onEdit;
  final VoidCallback onMore;

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
                    GestureDetector(
                      onTap: onEdit,
                      child: Image.asset(
                        Assets.imagesPencil,
                        height: 20,
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: onMore,
                child: Image.asset(
                  Assets.imagesMoreHorizontal,
                  height: 20,
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
