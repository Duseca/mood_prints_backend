import 'package:mood_prints/constants/app_colors.dart';
import 'package:mood_prints/constants/app_images.dart';
import 'package:mood_prints/view/widget/my_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

AppBar simpleAppBar(
    {bool haveLeading = true,
    bool centerTitle = true,
    String? title,
    List<Widget>? actions,
    VoidCallback? onTitleTap}) {
  return AppBar(
    backgroundColor: kWhiteColor,
    automaticallyImplyLeading: false,
    centerTitle: centerTitle,
    leading: haveLeading
        ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 5),
                child: GestureDetector(
                  onTap: () => Get.back(),
                  child: Image.asset(
                    Assets.imagesArrowBack,
                    height: 32,
                  ),
                ),
              ),
            ],
          )
        : null,
    title: MyText(
      onTap: onTitleTap,
      text: title ?? '',
      size: 16,
      color: kTertiaryColor,
      weight: FontWeight.w600,
    ),
    actions: actions,
  );
}

AppBar logoAppBar() {
  return AppBar(
    automaticallyImplyLeading: false,
    centerTitle: true,
    title: Image.asset(
      Assets.imagesLogo,
      height: 23,
    ),
  );
}
