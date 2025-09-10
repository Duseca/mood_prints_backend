import 'package:country_picker/country_picker.dart';
import 'package:mood_prints/constants/app_colors.dart';
import 'package:mood_prints/constants/app_fonts.dart';
import 'package:mood_prints/core/utils/validators.dart';
import 'package:mood_prints/view/widget/my_text_widget.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class MyTextField extends StatefulWidget {
  MyTextField({
    Key? key,
    this.controller,
    this.hintText,
    this.labelText,
    this.onChanged,
    this.isObSecure = false,
    this.marginBottom = 16.0,
    this.maxLines = 1,
    this.labelSize,
    this.prefix,
    this.suffix,
    this.isReadOnly,
    this.onTap,
    this.validator,
  }) : super(key: key);

  String? labelText, hintText;
  TextEditingController? controller;
  ValueChanged<String>? onChanged;
  bool? isObSecure, isReadOnly;
  double? marginBottom;
  int? maxLines;
  double? labelSize;
  Widget? prefix, suffix;
  final VoidCallback? onTap;
  String? Function(String?)? validator;

  @override
  State<MyTextField> createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  bool isFocused = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: widget.marginBottom!),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (widget.labelText != null)
            MyText(
              text: widget.labelText ?? '',
              size: widget.labelSize ?? 12,
              paddingBottom: 6,
              weight: FontWeight.bold,
            ),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Focus(
              onFocusChange: (focus) {
                setState(() {
                  isFocused = focus;
                });
              },
              child: TextFormField(
                onTap: widget.onTap,
                validator: widget.validator,
                textAlignVertical:
                    widget.prefix != null || widget.suffix != null
                        ? TextAlignVertical.center
                        : null,
                cursorColor: isFocused ? kQuaternaryColor : kTertiaryColor,
                maxLines: widget.maxLines,
                readOnly: widget.isReadOnly ?? false,
                controller: widget.controller,
                onChanged: widget.onChanged,
                textInputAction: TextInputAction.next,
                obscureText: widget.isObSecure!,
                obscuringCharacter: '*',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: isFocused ? kQuaternaryColor : kTertiaryColor,
                ),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: isFocused
                      ? kQuaternaryColor.withOpacity(0.05)
                      : kWhiteColor,
                  prefixIcon: widget.prefix,
                  suffixIcon: widget.suffix,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: widget.maxLines! > 1 ? 15 : 0,
                  ),
                  hintText: widget.hintText,
                  hintStyle: TextStyle(
                    fontSize: 14,
                    color: kHintColor,
                  ),
                  border: InputBorder.none,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: isFocused ? kQuaternaryColor : kWhiteColor,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: isFocused ? kQuaternaryColor : kBorderColor,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  errorBorder: InputBorder.none,
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
class MyTextField2 extends StatefulWidget {
  MyTextField2({
    Key? key,
    this.controller,
    this.hintText,
    this.labelText,
    this.onChanged,
    this.isObSecure = false,
    this.marginBottom = 16.0,
    this.maxLines = 1,
    this.labelSize,
    this.validator,
    this.prefix,
    this.suffix,
    this.isReadOnly,
    this.maxLength,
    this.onTap,
  }) : super(key: key);

  String? labelText, hintText;
  TextEditingController? controller;
  ValueChanged<String>? onChanged;
  bool? isObSecure, isReadOnly;
  double? marginBottom;
  int? maxLines, maxLength;
  double? labelSize;

  Widget? prefix, suffix;
  String? Function(String?)? validator;

  final VoidCallback? onTap;
  @override
  State<MyTextField2> createState() => _MyTextField2State();
}

class _MyTextField2State extends State<MyTextField2> {
  bool isFocused = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: widget.marginBottom!),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (widget.labelText != null)
            MyText(
              text: widget.labelText ?? '',
              size: widget.labelSize ?? 12,
              paddingBottom: 6,
              weight: FontWeight.bold,
            ),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: TextFormField(
              onTap: widget.onTap,
              textAlignVertical: widget.prefix != null || widget.suffix != null
                  ? TextAlignVertical.center
                  : null,
              cursorColor: kTertiaryColor,
              maxLines: widget.maxLines,
              readOnly: widget.isReadOnly ?? false,
              controller: widget.controller,
              onChanged: widget.onChanged,
              validator: widget.validator,
              textInputAction: TextInputAction.next,
              maxLength: widget.maxLength,
              obscureText: widget.isObSecure!,
              obscuringCharacter: '*',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: kTertiaryColor,
              ),
              decoration: InputDecoration(
                counterStyle: TextStyle(color: kTertiaryColor),
                filled: true,
                fillColor: kOffWhiteColor,
                prefixIcon: widget.prefix,
                suffixIcon: widget.suffix,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: widget.maxLines! > 1 ? 15 : 0,
                ),
                hintText: widget.hintText,
                hintStyle: TextStyle(
                  fontSize: 14,
                  color: kHintColor,
                ),
                border: InputBorder.none,
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: kWhiteColor,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: kBorderColor,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                errorBorder: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// // ignore: must_be_immutable
// class PhoneField extends StatefulWidget {
//   PhoneField(
//       {Key? key,
//       this.controller,
//       this.onChanged,
//       this.marginBottom = 16.0,
//       this.countryCodeValue})
//       : super(key: key);

//   TextEditingController? controller;
//   ValueChanged<String>? onChanged;
//   double? marginBottom;
//   String? countryCodeValue;

//   @override
//   State<PhoneField> createState() => _PhoneFieldState();
// }

// class _PhoneFieldState extends State<PhoneField> {
//   String countryFlag = '🇺🇸';
//   String countryCode = '1';
//   bool isFocused = false;

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: [
//           MyText(
//             text: 'Phone Number',
//             size: 12,
//             paddingBottom: 6,
//             weight: FontWeight.bold,
//           ),
//           ClipRRect(
//             borderRadius: BorderRadius.circular(8),
//             child: Focus(
//               onFocusChange: (focus) {
//                 setState(() {
//                   isFocused = focus;
//                 });
//               },
//               child: TextFormField(
//                 cursorColor: isFocused ? kQuaternaryColor : kTertiaryColor,
//                 controller: widget.controller,
//                 onChanged: widget.onChanged,
//                 textInputAction: TextInputAction.next,
//                 style: TextStyle(
//                   fontSize: 12,
//                   color: isFocused ? kQuaternaryColor : kTertiaryColor,
//                 ),
//                 decoration: InputDecoration(
//                   filled: true,
//                   fillColor: isFocused
//                       ? kQuaternaryColor.withOpacity(0.05)
//                       : kWhiteColor,
//                   prefixIcon: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       MyText(
//                         paddingLeft: 15,
//                         paddingRight: 10,
//                         onTap: () {
//                           showCountryPicker(
//                             context: context,
//                             countryListTheme: CountryListThemeData(
//                               flagSize: 25,
//                               backgroundColor: kPrimaryColor,
//                               textStyle: TextStyle(
//                                 fontSize: 14,
//                                 color: kTertiaryColor,
//                                 fontFamily: AppFonts.URBANIST,
//                               ),
//                               bottomSheetHeight: 500,
//                               borderRadius: BorderRadius.only(
//                                 topLeft: Radius.circular(25.0),
//                                 topRight: Radius.circular(25.0),
//                               ),
//                               searchTextStyle: TextStyle(
//                                 fontSize: 14,
//                                 color: kTertiaryColor,
//                                 fontFamily: AppFonts.URBANIST,
//                               ),
//                               inputDecoration: InputDecoration(
//                                 contentPadding:
//                                     EdgeInsets.symmetric(horizontal: 15),
//                                 fillColor: kWhiteColor,
//                                 filled: true,
//                                 hintText: 'Search',
//                                 hintStyle: TextStyle(
//                                   fontSize: 14,
//                                   color: kHintColor,
//                                   fontFamily: AppFonts.URBANIST,
//                                 ),
//                                 border: InputBorder.none,
//                                 enabledBorder: InputBorder.none,
//                                 focusedBorder: InputBorder.none,
//                                 focusedErrorBorder: InputBorder.none,
//                               ),
//                             ),
//                             onSelect: (Country country) {
//                               setState(() {
//                                 countryFlag = country.flagEmoji;
//                                 countryCode = country.countryCode;
//                                 widget.countryCodeValue = countryCode;
//                                 log("country Code With Number:${widget.countryCodeValue}-${widget.controller?.text}");
//                               });
//                             },
//                           );
//                         },
//                         text: '${countryFlag} +${countryCode}',
//                         size: 14,
//                         weight: FontWeight.w600,
//                       ),
//                     ],
//                   ),
//                   contentPadding: EdgeInsets.symmetric(
//                     horizontal: 15,
//                   ),
//                   hintText: '000 000 0000',
//                   hintStyle: TextStyle(
//                     fontSize: 12,
//                     color: kHintColor,
//                   ),
//                   border: InputBorder.none,
//                   enabledBorder: OutlineInputBorder(
//                     borderSide: BorderSide(
//                       color: isFocused ? kQuaternaryColor : kWhiteColor,
//                       width: 1,
//                     ),
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   focusedBorder: OutlineInputBorder(
//                     borderSide: BorderSide(
//                       color: isFocused ? kQuaternaryColor : kBorderColor,
//                       width: 1,
//                     ),
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   errorBorder: InputBorder.none,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

//-----------------------------------------

// ignore: must_be_immutable

class PhoneField extends StatefulWidget {
  PhoneField({
    Key? key,
    this.controller,
    this.onChanged,
    this.marginBottom = 16.0,
    this.onPhoneNumberChanged,
    this.title,
  }) : super(key: key);

  TextEditingController? controller;
  ValueChanged<String>? onChanged;
  ValueChanged<String>? onPhoneNumberChanged; // Callback for full number
  double? marginBottom;
  String? title;

  @override
  State<PhoneField> createState() => _PhoneFieldState();
}

class _PhoneFieldState extends State<PhoneField> {
  String countryFlag = '🇺🇸';
  String countryCode = '1'; // Default numeric country code
  bool isFocused = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          MyText(
            text: widget.title ?? 'Phone Number',
            size: 12,
            paddingBottom: 6,
            weight: FontWeight.bold,
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Focus(
              onFocusChange: (focus) {
                setState(() {
                  isFocused = focus;
                });
              },
              child: TextFormField(
                keyboardType: TextInputType.number,
                cursorColor: isFocused ? kQuaternaryColor : kTertiaryColor,
                controller: widget.controller,
                onChanged: (value) {
                  widget.onChanged?.call(value);
                  String fullNumber = '+$countryCode${widget.controller?.text}';
                  widget.onPhoneNumberChanged?.call(fullNumber);
                },
                validator: (value) {
                  return ValidationService.instance.digitValidator(value);
                },
                textInputAction: TextInputAction.next,
                style: TextStyle(
                  fontSize: 14,
                  color: isFocused ? kQuaternaryColor : kTertiaryColor,
                ),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: isFocused
                      ? kQuaternaryColor.withOpacity(0.05)
                      : kWhiteColor,
                  prefixIcon: SizedBox(
                    width: 90,
                    child: GestureDetector(
                      onTap: () {
                        showCountryPicker(
                          context: context,
                          countryListTheme: CountryListThemeData(
                            flagSize: 25,
                            backgroundColor: kPrimaryColor,
                            textStyle: TextStyle(
                              fontSize: 14,
                              color: kTertiaryColor,
                              fontFamily: AppFonts.URBANIST,
                            ),
                            bottomSheetHeight: 500,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(25.0),
                              topRight: Radius.circular(25.0),
                            ),
                            searchTextStyle: TextStyle(
                              fontSize: 14,
                              color: kTertiaryColor,
                              fontFamily: AppFonts.URBANIST,
                            ),
                            inputDecoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 15),
                              fillColor: kWhiteColor,
                              filled: true,
                              hintText: 'Search',
                              hintStyle: TextStyle(
                                fontSize: 14,
                                color: kHintColor,
                                fontFamily: AppFonts.URBANIST,
                              ),
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              focusedErrorBorder: InputBorder.none,
                            ),
                          ),
                          onSelect: (Country country) {
                            setState(() {
                              countryFlag = country.flagEmoji;
                              countryCode = country.phoneCode;
                            });
                            // Call full number callback
                            String fullNumber =
                                '+$countryCode${widget.controller?.text}';
                            widget.onPhoneNumberChanged?.call(fullNumber);
                            // log("Full Number: $fullNumber");
                          },
                        );
                      },
                      child: Center(
                        child: MyText(
                          text: '$countryFlag +$countryCode',
                          size: 14,
                          weight: FontWeight.w600,
                          paddingLeft: 15,
                          paddingRight: 10,
                        ),
                      ),
                    ),
                  ),
                  // contentPadding: EdgeInsets.symmetric(horizontal: 15),
                  hintText: '000 000 0000',
                  hintStyle: TextStyle(
                    fontSize: 12,
                    color: kHintColor,
                  ),
                  border: InputBorder.none,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: isFocused ? kQuaternaryColor : kWhiteColor,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: isFocused ? kQuaternaryColor : kBorderColor,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  errorBorder: InputBorder.none,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class UpdatedPhoneField extends StatefulWidget {
  UpdatedPhoneField({
    Key? key,
    this.controller,
    this.onChanged,
    this.marginBottom = 16.0,
    this.onPhoneNumberChanged,
    this.initialCountryCode = '1', // New parameter for initial country code
    this.initialFlag = '🇺🇸', // New parameter for initial flag
  }) : super(key: key);

  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onPhoneNumberChanged; // Callback for full number
  final double? marginBottom;
  final String initialCountryCode; // Add initial country code
  final String initialFlag; // Add initial flag

  @override
  State<UpdatedPhoneField> createState() => _UpdatedPhoneFieldState();
}

class _UpdatedPhoneFieldState extends State<UpdatedPhoneField> {
  late String countryFlag;
  late String countryCode;
  bool isFocused = false;

  @override
  void initState() {
    super.initState();
    // Initialize country code and flag from the provided initial values
    countryFlag = widget.initialFlag;
    countryCode = widget.initialCountryCode;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: widget.marginBottom!),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          MyText(
            text: 'Phone Number',
            size: 12,
            paddingBottom: 6,
            weight: FontWeight.bold,
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Focus(
              onFocusChange: (focus) {
                setState(() {
                  isFocused = focus;
                });
              },
              child: TextFormField(
                keyboardType: TextInputType.number,
                cursorColor: isFocused ? kQuaternaryColor : kTertiaryColor,
                controller: widget.controller,
                onChanged: (value) {
                  widget.onChanged?.call(value);
                  String fullNumber = '+$countryCode${widget.controller?.text}';
                  widget.onPhoneNumberChanged?.call(fullNumber);
                },
                textInputAction: TextInputAction.next,
                style: TextStyle(
                  fontSize: 12,
                  color: isFocused ? kQuaternaryColor : kTertiaryColor,
                ),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: isFocused
                      ? kQuaternaryColor.withOpacity(0.05)
                      : kWhiteColor,
                  prefixIcon: SizedBox(
                    width: 90,
                    child: GestureDetector(
                      onTap: () {
                        showCountryPicker(
                          context: context,
                          countryListTheme: CountryListThemeData(
                            flagSize: 25,
                            backgroundColor: kPrimaryColor,
                            textStyle: TextStyle(
                              fontSize: 14,
                              color: kTertiaryColor,
                              fontFamily: AppFonts.URBANIST,
                            ),
                            bottomSheetHeight: 500,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(25.0),
                              topRight: Radius.circular(25.0),
                            ),
                            searchTextStyle: TextStyle(
                              fontSize: 14,
                              color: kTertiaryColor,
                              fontFamily: AppFonts.URBANIST,
                            ),
                            inputDecoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 15),
                              fillColor: kWhiteColor,
                              filled: true,
                              hintText: 'Search',
                              hintStyle: TextStyle(
                                fontSize: 14,
                                color: kHintColor,
                                fontFamily: AppFonts.URBANIST,
                              ),
                              border: InputBorder.none,
                            ),
                          ),
                          onSelect: (Country country) {
                            setState(() {
                              countryFlag = country.flagEmoji;
                              countryCode = country.phoneCode;
                            });
                            // Update full number
                            String fullNumber =
                                '+$countryCode${widget.controller?.text}';
                            widget.onPhoneNumberChanged?.call(fullNumber);
                          },
                        );
                      },
                      child: Center(
                        child: MyText(
                          // text: '$countryFlag +$countryCode',
                          text: '+${countryCode}',
                          size: 14,
                          weight: FontWeight.w600,
                          paddingLeft: 15,
                          paddingRight: 10,
                        ),
                      ),
                    ),
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 15),
                  hintText: '000 000 0000',
                  hintStyle: TextStyle(
                    fontSize: 12,
                    color: kHintColor,
                  ),
                  border: InputBorder.none,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: isFocused ? kQuaternaryColor : kWhiteColor,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: isFocused ? kQuaternaryColor : kBorderColor,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
