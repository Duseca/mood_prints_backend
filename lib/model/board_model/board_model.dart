class BoardModel {
  final String? userId;
  final DateTime? date;
  final int? stressLevel;
  final List<String>? emotions;
  final String? note;
  final List<String>? photos;
  final Sleep? sleep;
  final List<DynamicField>? dynamicFields;
  final String? id;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? version;

  BoardModel({
    this.userId,
    this.date,
    this.stressLevel,
    this.emotions,
    this.note,
    this.photos,
    this.sleep,
    this.dynamicFields,
    this.id,
    this.createdAt,
    this.updatedAt,
    this.version,
  });

  factory BoardModel.fromJson(Map<String, dynamic> json) {
    return BoardModel(
      userId: json['userId'],
      date: json['date'] != null ? DateTime.parse(json['date']) : null,
      stressLevel: json['stressLevel'],
      emotions:
          json['emotions'] != null ? List<String>.from(json['emotions']) : null,
      note: json['note'],
      photos: json['photos'] != null ? List<String>.from(json['photos']) : null,
      sleep: json['sleep'] != null ? Sleep.fromJson(json['sleep']) : null,
      dynamicFields: json['dynamicFields'] != null
          ? (json['dynamicFields'] as List)
              .map((field) => DynamicField.fromJson(field))
              .toList()
          : null,
      id: json['_id'],
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      version: json['__v'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'date': date?.toIso8601String(),
      'stressLevel': stressLevel,
      'emotions': emotions,
      'note': note,
      'photos': photos,
      'sleep': sleep?.toJson(),
      'dynamicFields': dynamicFields?.map((field) => field.toJson()).toList(),
      '_id': id,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      '__v': version,
    };
  }
}

class Sleep {
  final String? wakeupTime;
  final String? dozeOffTime;

  Sleep({
    this.wakeupTime,
    this.dozeOffTime,
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

class DynamicField {
  final String? fieldName;
  final String? fieldValue;
  final String? id;

  DynamicField({
    this.fieldName,
    this.fieldValue,
    this.id,
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
