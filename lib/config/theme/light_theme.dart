import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_fonts.dart';

final ThemeData lightTheme = ThemeData(
  scaffoldBackgroundColor: kPrimaryColor,
  fontFamily: AppFonts.URBANIST,
  appBarTheme: AppBarTheme(
    elevation: 0,
    backgroundColor: kPrimaryColor,
  ),
  splashColor: kWhiteColor.withOpacity(0.10),
  highlightColor: kWhiteColor.withOpacity(0.10),
  colorScheme: ColorScheme.fromSwatch().copyWith(
    secondary: kSecondaryColor.withOpacity(0.1),
    primary: kSecondaryColor,
  ),
  useMaterial3: false,
  textSelectionTheme: TextSelectionThemeData(
    cursorColor: kWhiteColor,
  ),
);
