import 'package:flutter/material.dart';
import 'package:mood_prints/constants/app_colors.dart';

class AppStyling {
  static final CUSTOM_TILE = BoxDecoration(
    borderRadius: BorderRadius.circular(8),
    color: kWhiteColor,
    boxShadow: [
      BoxShadow(
        offset: Offset(0, 4),
        blurRadius: 20,
        color: kTertiaryColor.withOpacity(0.1),
      ),
    ],
  );
  static final CUSTOM_CARD = BoxDecoration(
    borderRadius: BorderRadius.circular(12),
    color: kWhiteColor,
    boxShadow: [
      BoxShadow(
        offset: Offset(0, 4),
        blurRadius: 20,
        color: kTertiaryColor.withOpacity(0.1),
      ),
    ],
  );
}
