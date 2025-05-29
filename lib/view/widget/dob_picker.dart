import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:mood_prints/view/widget/my_button_widget.dart';

// ignore: must_be_immutable
class DobPicker extends StatelessWidget {
  final Function(dynamic) onDateTimeChanged;
  final DateTime? initialDateTime;
  var mode;
  VoidCallback? onTap;

  double? dobWidgetheight;
  DobPicker({
    super.key,
    required this.onDateTimeChanged,
    this.initialDateTime,
    this.mode = CupertinoDatePickerMode.date,
    this.dobWidgetheight,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: dobWidgetheight ?? Get.height * 0.30,
          child: CupertinoDatePicker(
              minimumYear: 1995,
              maximumYear: 2080,
              mode: mode,
              dateOrder: DatePickerDateOrder.dmy,
              //  showDayOfWeek: false,
              initialDateTime: initialDateTime,
              onDateTimeChanged: onDateTimeChanged),
        ),
        // Spacer(),

        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: MyButton(buttonText: 'Done', onTap: (){
            Get.back();
          }),
        )
      ],
    );
  }
}
