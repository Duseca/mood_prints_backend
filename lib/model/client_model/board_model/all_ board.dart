// Main Response Model
// class BoardEntriesResponse {
//   final List<BoardEntry> data;

//   BoardEntriesResponse({
//     required this.data,
//   });

//   factory BoardEntriesResponse.fromJson(Map<String, dynamic> json) {
//     return BoardEntriesResponse(
//       data: List<BoardEntry>.from(
//           json['data'].map((entry) => BoardEntry.fromJson(entry))),
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'data': data.map((entry) => entry.toJson()).toList(),
//     };
//   }
// }

// class BoardEntriesResponse {
//   final List<BoardEntry> data;

//   BoardEntriesResponse({
//     required this.data,
//   });

//   // Updated fromJson constructor to handle data as a List
//   factory BoardEntriesResponse.fromJson(List<dynamic> json) {
//     return BoardEntriesResponse(
//       data: List<BoardEntry>.from(
//           json.map((entry) => BoardEntry.fromJson(entry))),
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'data': data.map((entry) => entry.toJson()).toList(),
//     };
//   }
// }

class BoardEntriesResponse {
  final List<BoardEntry> data;

  BoardEntriesResponse({
    required this.data,
  });

  // Safely handle the parsing of the response
  factory BoardEntriesResponse.fromJson(List<dynamic> json) {
    return BoardEntriesResponse(
      data: List<BoardEntry>.from(
        json.map((entry) => BoardEntry.fromJson(entry)).toList(),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data.map((entry) => entry.toJson()).toList(),
    };
  }
}

// Board Entry Model
class BoardEntry {
  final Sleep sleep;
  final String id;
  final String userId;
  final DateTime date;
  final int stressLevel;
  final int irritateLevel;
  final String note;
  final List<String>? photos;
  final List<DynamicField>? dynamicFields;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int version;

  BoardEntry({
    required this.sleep,
    required this.id,
    required this.userId,
    required this.date,
    required this.stressLevel,
    required this.irritateLevel,
    required this.note,
    this.photos,
    this.dynamicFields,
    required this.createdAt,
    required this.updatedAt,
    required this.version,
  });

  factory BoardEntry.fromJson(Map<String, dynamic> json) {
    return BoardEntry(
      sleep: Sleep.fromJson(json['sleep']),
      id: json['_id'],
      userId: json['userId'],
      date: DateTime.parse(json['date']),
      stressLevel: json['stressLevel'],
      irritateLevel: json['irritateLevel'] ?? 0,
      note: json['note'],
      photos: json.containsKey('photos') && json['photos'] != null
          ? List<String>.from(json['photos'])
          : null,
      dynamicFields:
          json.containsKey('dynamicFields') && json['dynamicFields'] != null
              ? List<DynamicField>.from(json['dynamicFields']
                  .map((field) => DynamicField.fromJson(field)))
              : null,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      version: json['__v'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sleep': sleep.toJson(),
      '_id': id,
      'userId': userId,
      'date': date.toIso8601String(),
      'stressLevel': stressLevel,
      'irritateLevel': irritateLevel,
      'note': note,
      'photos': photos,
      'dynamicFields': dynamicFields?.map((field) => field.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      '__v': version,
    };
  }
}

// Sleep Model
class Sleep {
  final String wakeupTime;
  final String dozeOffTime;

  Sleep({
    required this.wakeupTime,
    required this.dozeOffTime,
  });

  factory Sleep.fromJson(Map<String, dynamic> json) {
    return Sleep(
      wakeupTime: json['wakeupTime'],
      dozeOffTime: json['dozeOffTime'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'wakeupTime': wakeupTime,
      'dozeOffTime': dozeOffTime,
    };
  }
}

// Dynamic Field Model
class DynamicField {
  final String fieldName;
  final String fieldValue;
  final String id;

  DynamicField({
    required this.fieldName,
    required this.fieldValue,
    required this.id,
  });

  factory DynamicField.fromJson(Map<String, dynamic> json) {
    return DynamicField(
      fieldName: json['fieldName'],
      fieldValue: json['fieldValue'],
      id: json['_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fieldName': fieldName,
      'fieldValue': fieldValue,
      '_id': id,
    };
  }
}
