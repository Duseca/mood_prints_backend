import 'dart:developer';

import 'package:intl/intl.dart';

class DateTimeService {
  DateTimeService._privateConstructor();

  static DateTimeService? _instance;

  static DateTimeService get instance {
    _instance ??= DateTimeService._privateConstructor();
    return _instance!;
  }

  // Month Year e.g ("January 2024")

  String getMonthYearFormat(DateTime date) {
    String month = DateFormat('MMMM').format(date);
    String year = DateFormat('yyyy').format(date);
    return '$month $year';
  }

  // Format date as "dd EEEE" (e.g., "16 Tue")

  String formatDateWithDay(DateTime dateTime) {
    return DateFormat('dd E').format(dateTime);
  }

  // simple format date picker
  // 10 jan 2025
  String getSimpleUSDateFormat(DateTime date) {
    // Formatting the day
    String day = DateFormat('d').format(date);
    // Formatting the month as a three-letter abbreviation
    String month = DateFormat('MMM').format(date);
    // Formatting the year
    String year = DateFormat('yyyy').format(date);

    return '$day $month $year';
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

  String formatTimeToAMPM(time) {
    if (time != null) {
      final finalTime = DateFormat('hh:mm a').format(time);
      return finalTime;
    } else {
      log('Time is $time');
      return '';
    }
  }
}
