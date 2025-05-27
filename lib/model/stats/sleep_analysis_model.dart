class SleepAnalysisModel {
  final String? reportType;
  final String? period;
  final int? totalEntries;
  final List<SleepData>? dateWiseSleepStats;
  final String? averageBedtime;
  final String? averageWakeupTime;

  SleepAnalysisModel({
    this.reportType,
    this.period,
    this.totalEntries,
    this.dateWiseSleepStats,
    this.averageBedtime,
    this.averageWakeupTime,
  });

  factory SleepAnalysisModel.fromJson(Map<String, dynamic> json) {
    return SleepAnalysisModel(
      reportType: json['reportType'] as String?,
      period: json['period'] as String?,
      totalEntries: json['totalEntries'] as int?,
      dateWiseSleepStats: (json['dateWiseSleepStats'] as List<dynamic>?)
          ?.map((item) => SleepData.fromJson(item as Map<String, dynamic>))
          .toList(),
      averageBedtime: json['averageBedtime'] ?? '' as String?,
      averageWakeupTime: json['averageWakeupTime'] ?? '' as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'reportType': reportType,
      'period': period,
      'totalEntries': totalEntries,
      'dateWiseSleepStats':
          dateWiseSleepStats?.map((item) => item.toJson()).toList(),
      'averageBedtime': averageBedtime,
      'averageWakeupTime': averageWakeupTime,
    };
  }
}

class SleepData {
  final String? date;
  final int? sleepTime;

  SleepData({this.date, this.sleepTime});

  factory SleepData.fromJson(Map<String, dynamic> json) {
    return SleepData(
      date: json['date'] as String?,
      sleepTime: json['sleepTime'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'sleepTime': sleepTime,
    };
  }
}
