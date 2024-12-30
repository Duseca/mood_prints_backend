import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:mood_prints/constants/app_sizes.dart';
import 'package:mood_prints/view/widget/my_button_widget.dart';

// ignore: must_be_immutable
class DobPicker extends StatelessWidget {
  final Function(dynamic) onDateTimeChanged;
  final DateTime? initialDateTime;
  var mode;
  DobPicker(
      {super.key,
      required this.onDateTimeChanged,
      this.initialDateTime,
      this.mode = CupertinoDatePickerMode.date});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: Get.height * 0.30,
          child: CupertinoDatePicker(
              minimumYear: 1995,
              maximumYear: 2080,
              mode: mode,
              dateOrder: DatePickerDateOrder.dmy,
              //  showDayOfWeek: false,
              initialDateTime: initialDateTime,
              onDateTimeChanged: onDateTimeChanged),
        ),
        Spacer(),
        Padding(
          padding: AppSizes.DEFAULT,
          child: MyButton(
              buttonText: 'Done',
              onTap: () {
                Get.back();
              }),
        )
      ],
    );
  }
}
