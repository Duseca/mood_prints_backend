import 'package:mood_prints/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class CustomCheckBox extends StatelessWidget {
  CustomCheckBox({
    Key? key,
    required this.isActive,
    required this.onTap,
    this.unSelectedColor,
    this.isRadio = false,
  }) : super(key: key);

  final bool isActive;
  final bool? isRadio;
  final VoidCallback onTap;
  final Color? unSelectedColor;

  @override
  Widget build(BuildContext context) {
    if (isRadio!) {
      return GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: Duration(
            milliseconds: 230,
          ),
          curve: Curves.easeInOut,
          height: 20,
          width: 20,
          decoration: BoxDecoration(
            border: Border.all(
              width: 1.0,
              color: kQuaternaryColor,
            ),
            shape: BoxShape.circle,
          ),
          child: !isActive
              ? SizedBox()
              : Center(
                  child: AnimatedContainer(
                    margin: EdgeInsets.all(3),
                    duration: Duration(
                      milliseconds: 230,
                    ),
                    curve: Curves.easeInOut,
                    height: Get.height,
                    width: Get.width,
                    decoration: BoxDecoration(
                      color: kQuaternaryColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
        ),
      );
    } else {
      return GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: Duration(
            milliseconds: 230,
          ),
          curve: Curves.easeInOut,
          height: 20,
          width: 20,
          decoration: BoxDecoration(
            border: Border.all(
              width: 1.0,
              color: isActive ? kQuaternaryColor : kWhiteColor,
            ),
            color: isActive ? kQuaternaryColor : kWhiteColor,
            borderRadius: BorderRadius.circular(3.3),
          ),
          child: !isActive
              ? SizedBox()
              : Icon(
                  Icons.check,
                  size: 16,
                  color: kWhiteColor,
                ),
        ),
      );
    }
  }
}
