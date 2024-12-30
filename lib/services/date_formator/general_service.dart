import 'dart:developer';

import 'package:intl/intl.dart';

class DateFormatorService {
  DateFormatorService._privateConstructor();

  static DateFormatorService? _instance;

  static DateFormatorService get instance {
    _instance ??= DateFormatorService._privateConstructor();
    return _instance!;
  }

  // Date in US format
  // Oct 25 21

  String getDateUsFormat(DateTime date) {
    // Formatting the month as a three-letter abbreviation
    String month = DateFormat('MMM').format(date);
    // Formatting the day with suffix (st, nd, rd, th)
    String day = date.day.toString() + getDaySuffix(date.day);
    // Formatting the year
    String year = DateFormat('yyyy').format(date);

    return '$month $day, $year';
  }

  // Date in ISO format
  //YYYY-MM-DD
  //2025-10-30

  String getDateIsoFormat(DateTime date) {
    // Formatting the date in ISO 8601 format (YYYY-MM-DD)
    String formattedDate = DateFormat('yyyy-MM-dd').format(date);
    return formattedDate;
  }

  String getDaySuffix(int day) {
    if (day >= 11 && day <= 13) {
      return 'th';
    }
    switch (day % 10) {
      case 1:
        return 'st';
      case 2:
        return 'nd';
      case 3:
        return 'rd';
      default:
        return 'th';
    }
  }

  // Time in AM & PM format

  String getTimeFormator(time) {
    if (time != null) {
      final finalTime = DateFormat('hh:mm a').format(time);
      return finalTime;
    } else {
      log('Time is $time');
      return '';
    }
  }
}
