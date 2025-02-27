import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mood_prints/constants/app_sizes.dart';
import 'package:mood_prints/view/widget/common_image_view_widget.dart';
import 'package:mood_prints/view/widget/my_button_widget.dart';
import 'package:mood_prints/view/widget/my_text_widget.dart';

// ignore: must_be_immutable
class ViewPicture extends StatelessWidget {
  String imageUrl;
  ViewPicture({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: MyText(
          paddingLeft: 12,
          text: 'View Image',
          size: 16.43,
          paddingBottom: 2,
          weight: FontWeight.w600,
        ),
      ),
      body: Padding(
        padding: AppSizes.DEFAULT,
        child: Column(
          children: [
            Expanded(
              child: CommonImageView(
                url: imageUrl,
                fit: BoxFit.contain,
              ),
            ),
            SizedBox(height: 20),
            MyButton(
              buttonText: 'Close',
              onTap: () {
                Get.close(1);
              },
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
