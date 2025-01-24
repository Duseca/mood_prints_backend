class EmotionStatsModel {
  final String? reportType;
  final String? period;
  final int? totalEntries;
  final List<StressLevelPercentage>? stressLevelPercentages;

  EmotionStatsModel({
    this.reportType,
    this.period,
    this.totalEntries,
    this.stressLevelPercentages,
  });

  factory EmotionStatsModel.fromJson(Map<String, dynamic> json) {
    return EmotionStatsModel(
      reportType: json['reportType'] as String?,
      period: json['period'] as String?,
      totalEntries: json['totalEntries'] as int?,
      stressLevelPercentages: (json['stressLevelPercentages'] as List<dynamic>?)
          ?.map((item) =>
              StressLevelPercentage.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'reportType': reportType,
      'period': period,
      'totalEntries': totalEntries,
      'stressLevelPercentages':
          stressLevelPercentages?.map((item) => item.toJson()).toList(),
    };
  }
}

class StressLevelPercentage {
  final String? stressLevel;
  final String? percentage;

  StressLevelPercentage({this.stressLevel, this.percentage});

  factory StressLevelPercentage.fromJson(Map<String, dynamic> json) {
    return StressLevelPercentage(
      stressLevel: json['stressLevel'] as String?,
      percentage: json['percentage'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'stressLevel': stressLevel,
      'percentage': percentage,
    };
  }
}
