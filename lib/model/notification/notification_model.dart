class NotificationModel {
  final String? id;
  final String? userId;
  final RequestId? requestId;
  final String? type;
  final String? title;
  final String? body;
  final bool? read;
  final DateTime? createdAt;
  final int? v;

  NotificationModel({
    this.id,
    this.userId,
    this.requestId,
    this.type,
    this.title,
    this.body,
    this.read,
    this.createdAt,
    this.v,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['_id'],
      userId: json['userId'],
      requestId: json['requestId'] != null
          ? RequestId.fromJson(json['requestId'])
          : null,
      type: json['type'],
      title: json['title'],
      body: json['body'],
      read: json['read'],
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      v: json['__v'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'userId': userId,
      'requestId': requestId?.toJson(),
      'type': type,
      'title': title,
      'body': body,
      'read': read,
      'createdAt': createdAt?.toIso8601String(),
      '__v': v,
    };
  }
}

class RequestId {
  final String? id;
  final String? clientId;
  final String? therapistId;
  final String? status;
  final DateTime? createdAt;
  final int? v;

  RequestId({
    this.id,
    this.clientId,
    this.therapistId,
    this.status,
    this.createdAt,
    this.v,
  });

  factory RequestId.fromJson(Map<String, dynamic> json) {
    return RequestId(
      id: json['_id'],
      clientId: json['clientId'],
      therapistId: json['therapistId'],
      status: json['status'],
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      v: json['__v'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'clientId': clientId,
      'therapistId': therapistId,
      'status': status,
      'createdAt': createdAt?.toIso8601String(),
      '__v': v,
    };
  }
}
