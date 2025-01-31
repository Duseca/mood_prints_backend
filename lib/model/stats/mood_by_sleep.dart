class MoodBySleepModel {
  final String reportType;
  final String period;
  final int totalEntries;
  final List<MoodSleepStats> dateWiseMoodStats;

  MoodBySleepModel({
    required this.reportType,
    required this.period,
    required this.totalEntries,
    required this.dateWiseMoodStats,
  });

  factory MoodBySleepModel.fromJson(Map<String, dynamic> json) {
    return MoodBySleepModel(
      reportType: json['reportType'] ?? '',
      period: json['period'] ?? '',
      totalEntries: json['totalEntries'] ?? 0,
      dateWiseMoodStats: (json['dateWiseMoodStats'] as List<dynamic>?)
              ?.map((e) => MoodSleepStats.fromJson(e))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'reportType': reportType,
      'period': period,
      'totalEntries': totalEntries,
      'dateWiseMoodStats': dateWiseMoodStats.map((e) => e.toJson()).toList(),
    };
  }
}

class MoodSleepStats {
  final String date;
  final int mood;
  final int sleepDuration;

  MoodSleepStats(
      {required this.date, required this.mood, required this.sleepDuration});

  factory MoodSleepStats.fromJson(Map<String, dynamic> json) {
    return MoodSleepStats(
      date: json['date'] ?? '',
      mood: json['mood'] ?? 0,
      sleepDuration: json['sleepDuration'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'mood': mood,
      'sleepDuration': sleepDuration,
    };
  }
}
