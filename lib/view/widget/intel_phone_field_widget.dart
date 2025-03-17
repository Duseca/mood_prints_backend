import 'package:flutter/material.dart';
import 'package:intl_phone_field/country_picker_dialog.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:mood_prints/constants/app_colors.dart';
import 'my_text_widget.dart';

// ignore: must_be_immutable
class IntlPhoneFieldWidget extends StatelessWidget {
  final String? lebel;
  TextEditingController? controller ;
  Function(String)? onSubmitted;
  dynamic onCountryChanged;
  dynamic onSaved;
  var onChanged;
  String? Function(PhoneNumber?)? validator;
  IntlPhoneFieldWidget(
      {super.key,
      this.lebel,
      this.controller,
      this.onSubmitted,
      this.onSaved,
      this.onChanged,
      this.onCountryChanged,
      required this.validator


      });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MyText(
          text: 'Phone Number',
          size: 12,
          paddingBottom: 6,
          weight: FontWeight.bold,
        ),
        IntlPhoneField(
          validator: validator,
          onChanged: onChanged,
          onSaved: onSaved,

          onCountryChanged: onCountryChanged,
          onSubmitted: onSubmitted,
          controller: controller,
          autovalidateMode: AutovalidateMode.always,
          style: TextStyle(color: kTertiaryColor),
          showCountryFlag: false,
          flagsButtonPadding: EdgeInsets.symmetric(horizontal: 5),
          flagsButtonMargin:
              EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 5),
          showDropdownIcon: true,
          dropdownIcon: Icon(
            Icons.keyboard_arrow_down_rounded,
            color: kWhiteColor,
            size: 15,
          ),
          pickerDialogStyle: PickerDialogStyle(
            backgroundColor: kPrimaryColor,
          ),
          dropdownTextStyle: TextStyle(
              fontSize: 12, color: kWhiteColor, fontWeight: FontWeight.w500),
          dropdownIconPosition: IconPosition.trailing,
          dropdownDecoration: BoxDecoration(
              color: kSecondaryColor, borderRadius: BorderRadius.circular(24)),
          decoration: InputDecoration(
            counterText: '',
            filled: true,
            fillColor: Colors.white,
            contentPadding: EdgeInsets.symmetric(
              vertical: 3,
            ),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(width: 1, color: kGreyColor3)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(width: 1, color: kSecondaryColor)),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(width: 1, color: kGreyColor3)),
          ),
          initialCountryCode: 'US',
        ),
      ],
    );
  }
}
