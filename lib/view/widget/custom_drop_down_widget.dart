import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:mood_prints/constants/app_colors.dart';
import 'package:mood_prints/constants/app_images.dart';
import 'package:mood_prints/view/widget/my_text_widget.dart';

class CustomDropDown extends StatelessWidget {
  CustomDropDown({
    required this.hint,
    required this.items,
    required this.selectedValue,
    required this.onChanged,
    this.bgColor,
    this.marginBottom,
    this.width,
    this.labelText,
  });

  final List<dynamic> items;
  String selectedValue;
  final ValueChanged<dynamic>? onChanged;
  String hint;
  String? labelText;
  Color? bgColor;
  double? marginBottom, width;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: marginBottom ?? 16,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (labelText != null)
            MyText(
              text: labelText ?? '',
              size: 12,
              paddingBottom: 6,
              weight: FontWeight.bold,
            ),
          DropdownButtonHideUnderline(
            child: DropdownButton2(
              items: items
                  .map(
                    (item) => DropdownMenuItem<dynamic>(
                      value: item,
                      child: MyText(
                        text: item,
                        size: 14,
                      ),
                    ),
                  )
                  .toList(),
              value: selectedValue,
              onChanged: onChanged,
              iconStyleData: IconStyleData(
                icon: SizedBox(),
              ),
              isDense: true,
              isExpanded: false,
              customButton: Container(
                height: 48,
                padding: EdgeInsets.symmetric(
                  horizontal: 15,
                ),
                decoration: BoxDecoration(
                  color: kWhiteColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: MyText(
                        text: selectedValue == hint ? hint : selectedValue,
                        size: 14,
                        color:
                            selectedValue == hint ? kGreyColor : kTertiaryColor,
                      ),
                    ),
                    Icon(
                      Icons.arrow_drop_down,
                    ),
                  ],
                ),
              ),
              menuItemStyleData: MenuItemStyleData(
                height: 35,
              ),
              dropdownStyleData: DropdownStyleData(
                elevation: 6,
                maxHeight: 300,
                offset: Offset(0, -5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: kWhiteColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class CustomDropDown2 extends StatelessWidget {
  CustomDropDown2({
    required this.hint,
    required this.items,
    required this.selectedValue,
    required this.onChanged,
    this.marginBottom,
    this.width,
  });

  final List<dynamic> items;
  String selectedValue;
  final ValueChanged<dynamic>? onChanged;
  String hint;
  double? marginBottom, width;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2(
        items: items
            .map(
              (item) => DropdownMenuItem<dynamic>(
                value: item,
                child: MyText(
                  text: item,
                  size: 12,
                  weight: FontWeight.w500,
                  color: kTertiaryColor,
                ),
              ),
            )
            .toList(),
        value: selectedValue,
        onChanged: onChanged,
        iconStyleData: IconStyleData(
          icon: SizedBox(),
        ),
        isDense: true,
        isExpanded: false,
        customButton: Container(
          height: 30,
          padding: EdgeInsets.symmetric(
            horizontal: 10,
          ),
          decoration: BoxDecoration(
            border: Border.all(
              width: 1.0,
              color: kBorderColor,
            ),
            borderRadius: BorderRadius.circular(5),
            color: kWhiteColor,
          ),
          child: Row(
            children: [
              Expanded(
                child: MyText(
                  text: selectedValue == hint ? hint : selectedValue,
                  size: 12,
                  color: selectedValue == hint ? kGreyColor : kTertiaryColor,
                ),
              ),
              Image.asset(
                Assets.imagesDropdownIcon,
                height: 12,
              ),
            ],
          ),
        ),
        menuItemStyleData: MenuItemStyleData(
          height: 30,
        ),
        dropdownStyleData: DropdownStyleData(
          elevation: 6,
          maxHeight: 300,
          offset: Offset(0, -5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            color: kWhiteColor,
          ),
        ),
      ),
    );
  }
}
