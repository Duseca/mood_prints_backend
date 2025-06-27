import 'package:flutter/material.dart';
import 'package:mood_prints/constants/app_colors.dart';
import 'package:mood_prints/view/widget/my_text_widget.dart';

class CheckBoxWidget extends StatelessWidget {
  final bool isChecked;
  final Function(bool?)? onChanged;
  final Color kborderColor;
  final String text;
  final bool haveCheckBoxTrue = false;

  CheckBoxWidget({
    super.key,
    this.isChecked = false,
    required this.onChanged,
    required this.text,
    this.kborderColor = kSecondaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          height: 20,
          width: 20,
          child: Checkbox(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            side: BorderSide(
              color: (isChecked == true) ? kSecondaryColor : kborderColor,
            ),
            checkColor: Colors.white,
            activeColor: Colors.red,
            focusColor: Colors.amber,
            fillColor: MaterialStatePropertyAll(
              (isChecked == true) ? kSecondaryColor : Colors.transparent,
            ),
            value: isChecked,
            onChanged: onChanged,
          ),
        ),
        SizedBox(
          width: 10,
        ),
        MyText(
          text: text,
          size: 12,
          weight: FontWeight.w600,
        ),
      ],
    );
  }
}
