// class ModeStatsModel {
//   final String? reportType;
//   final String? period;
//   final List<DateWiseStressStats>? dateWiseStressStats;

//   ModeStatsModel({
//     required this.reportType,
//     required this.period,
//     required this.dateWiseStressStats,
//   });

//   factory ModeStatsModel.fromJson(Map<String, dynamic> json) {
//     // log("Parsing Report JSON: $json");
//     return ModeStatsModel(
//       reportType: json['reportType'],
//       period: json['period'],
//       dateWiseStressStats: (json['dateWiseStressStats'] as List?)?.map((item) {
//         // log("Parsing DateWiseStressStats Item: $item");
//         return DateWiseStressStats.fromJson(item);
//       }).toList(),
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'reportType': reportType,
//       'period': period,
//       'dateWiseStressStats':
//           dateWiseStressStats?.map((e) => e.toJson()).toList(),
//     };
//   }
// }

// class DateWiseStressStats {
//   final String? date;
//   final int? stressLevel;

//   DateWiseStressStats({
//     required this.date,
//     required this.stressLevel,
//   });

//   factory DateWiseStressStats.fromJson(Map<String, dynamic> json) {
//     return DateWiseStressStats(
//       date: json['date'],
//       stressLevel: json['stressLevel'],
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'date': date,
//       'stressLevel': stressLevel,
//     };
//   }
// }

// --------- Mode Flow --------------x

class MoodFlowModel {
  final String date;
  final int mood;

  MoodFlowModel({required this.date, required this.mood});

  factory MoodFlowModel.fromJson(Map<String, dynamic> json) {
    return MoodFlowModel(
      date: json['date'] ?? '',
      mood: json['mood'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'mood': mood,
    };
  }
}
