class SleepModel {
  final String reportType;
  final String period;
  final int totalEntries;
  final List<DateWiseSleepStats> dateWiseSleepStats;

  SleepModel({
    required this.reportType,
    required this.period,
    required this.totalEntries,
    required this.dateWiseSleepStats,
  });

  factory SleepModel.fromJson(Map<String, dynamic> json) {
    return SleepModel(
      reportType: json['reportType'] as String,
      period: json['period'] as String,
      totalEntries: json['totalEntries'] as int,
      dateWiseSleepStats: (json['dateWiseSleepStats'] as List<dynamic>)
          .map((e) => DateWiseSleepStats.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'reportType': reportType,
      'period': period,
      'totalEntries': totalEntries,
      'dateWiseSleepStats': dateWiseSleepStats.map((e) => e.toJson()).toList(),
    };
  }
}



class DateWiseSleepStats {
  final String date;
  final double sleepTime;

  DateWiseSleepStats({
    required this.date,
    required this.sleepTime,
  });

  factory DateWiseSleepStats.fromJson(Map<String, dynamic> json) {
    return DateWiseSleepStats(
      date: json['date'] as String,
      // Convert sleepTime to double regardless of whether it's an int or double
      sleepTime: (json['sleepTime'] is int)
          ? (json['sleepTime'] as int).toDouble()
          : json['sleepTime'] as double,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'sleepTime': sleepTime,
    };
  }
}
