import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  DateTime? sentAt;
  String? sentBy;
  String? messageId;
  String? senderName;
  String? messageType;
  String? senderProfileImage;
  String? textMessage;
  String? pictureMedia;
  bool? isSeen;
  List<String>? deletedBy;
  List<String>? seenBy;

  // Constructor
  MessageModel({
    this.sentAt,
    this.sentBy,
    this.messageId,
    this.senderName,
    this.messageType,
    this.senderProfileImage,
    this.textMessage,
    this.pictureMedia,
    this.isSeen,
    this.deletedBy,
    this.seenBy,
  });

  // Converts a MessageModel object to a map
  Map<String, dynamic> toMap() {
    return {
      'sentAt': sentAt?.toIso8601String(),
      'sentBy': sentBy,
      'messageId': messageId,
      'senderName': senderName,
      'messageType': messageType,
      'senderProfileImage': senderProfileImage,
      'textMessage': textMessage,
      'pictureMedia': pictureMedia ?? '',
      'isSeen': isSeen,
      'deletedBy': deletedBy,
      'seenBy': seenBy,
    };
  }

  // Creates a MessageModel object from a map
  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      sentAt: map['sentAt'] != null
          ? (map['sentAt'] is Timestamp
              ? (map['sentAt'] as Timestamp).toDate()
              : DateTime.parse(map['sentAt']))
          : null,
      sentBy: map['sentBy'],
      messageId: map['messageId'],
      senderName: map['senderName'],
      messageType: map['messageType'],
      senderProfileImage: map['senderProfileImage'],
      textMessage: map['textMessage'],
      pictureMedia: map['pictureMedia'],
      isSeen: map['isSeen'],
      deletedBy:
          map['deletedBy'] != null ? List<String>.from(map['deletedBy']) : null,
      seenBy: map['seenBy'] != null ? List<String>.from(map['seenBy']) : null,
    );
  }
}
