import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import 'my_text_widget.dart';

// ignore: must_be_immutable
class MyButton extends StatelessWidget {
  MyButton({
    required this.buttonText,
    required this.onTap,
    this.height = 48,
    this.textSize,
    this.weight,
    this.radius,
    this.customChild,
    this.bgColor,
    this.textColor,
  });

  final String buttonText;
  final VoidCallback onTap;
  double? height, textSize, radius;
  FontWeight? weight;
  Widget? customChild;
  Color? bgColor, textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius ?? 10),
        color: bgColor ?? kSecondaryColor,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          splashColor: kWhiteColor.withOpacity(0.1),
          highlightColor: kWhiteColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(radius ?? 10),
          child: customChild != null
              ? customChild
              : Center(
                  child: MyText(
                    text: buttonText,
                    size: textSize ?? 16,
                    weight: weight ?? FontWeight.w600,
                    color: textColor ?? kWhiteColor,
                  ),
                ),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class MyBorderButton extends StatelessWidget {
  MyBorderButton({
    required this.buttonText,
    required this.onTap,
    this.height = 48,
    this.textSize,
    this.weight,
    this.child,
    this.radius,
    this.buttonColor = kWhiteColor,
    this.bgColor,
    this.textColor,
  });

  final String buttonText;
  final VoidCallback onTap;
  double? height, textSize;
  FontWeight? weight;
  Widget? child;
  double? radius;
  final Color? buttonColor;
  final Color? bgColor;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius ?? 10),
        color: bgColor ?? Colors.transparent,
        border: Border.all(
          width: 1.0,
          color: buttonColor!,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          splashColor: buttonColor!.withOpacity(0.1),
          highlightColor: buttonColor!.withOpacity(0.1),
          borderRadius: BorderRadius.circular(radius ?? 10),
          child: child != null
              ? child
              : Center(
                  child: MyText(
                    text: buttonText,
                    size: textSize ?? 16,
                    weight: weight ?? FontWeight.w600,
                    color: textColor ?? buttonColor,
                  ),
                ),
        ),
      ),
    );
  }
}
