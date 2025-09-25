import 'dart:async';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl_phone_field/country_picker_dialog.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:mood_prints/constants/app_colors.dart';

import 'my_text_widget.dart';

class IntlPhoneFieldWidget extends StatelessWidget {
  final String? lebel;
  final String? initialValue;
  FutureOr<String?> Function(PhoneNumber?)? validator;
  final Function(dynamic)? onChanged;
  final Function(dynamic)? onCountryChanged;

  TextEditingController? controller = TextEditingController();
  String? initialCountryCode, label;
  IntlPhoneFieldWidget(
      {super.key,
      this.lebel,
      this.controller,
      this.onCountryChanged,
      this.onChanged,
      this.initialValue,
      this.validator,
      this.initialCountryCode = '+1',
      this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MyText(
          text: label ?? "Phone Number",
          size: 12,
          paddingBottom: 6,
          weight: FontWeight.bold,
        ),
        Container(
          child: Center(
            child: IntlPhoneField(
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              onCountryChanged: onCountryChanged,
              validator: validator,
              onChanged: onChanged,
              controller: controller,
              autovalidateMode: AutovalidateMode.disabled,
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
                  fontSize: 12,
                  color: kWhiteColor,
                  fontWeight: FontWeight.w500),
              dropdownIconPosition: IconPosition.trailing,
              dropdownDecoration: BoxDecoration(
                  color: kSecondaryColor,
                  borderRadius: BorderRadius.circular(24)),
              decoration: InputDecoration(
                filled: true,
                fillColor: kWhiteColor,
                counterText: '',
                contentPadding: EdgeInsets.symmetric(
                  vertical: 3,
                ),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide:
                        BorderSide(width: 1, color: Colors.transparent)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(width: 1, color: kSecondaryColor)),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide:
                        BorderSide(width: 1, color: Colors.transparent)),
              ),
              initialValue: initialCountryCode,
            ),
          ),
        ),
      ],
    );
  }
}
