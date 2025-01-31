import 'package:cloud_firestore/cloud_firestore.dart';

class ChatThreadModel {
  DateTime? createdAt;
  String? chatThreadId;
  List<String>? participants;
  String? chatType;
  String? lastMessage;
  String? lastMessageType;
  DateTime? lastMessageTime;
  bool? unSeenMessage;
  List<String>? lastMessageSeenBy;
  List<String>? likedBy;
  List<String>? deletedBy;
  String? receiverName;
  String? receiverImage;
  String? receiverID;

  // Constructor
  ChatThreadModel({
    this.createdAt,
    this.chatThreadId,
    this.participants,
    this.chatType,
    this.lastMessage,
    this.lastMessageType,
    this.lastMessageTime,
    this.unSeenMessage,
    this.lastMessageSeenBy,
    this.likedBy,
    this.deletedBy,
    this.receiverName,
    this.receiverImage,
    this.receiverID,
  });

  // toMap method
  Map<String, dynamic> toMap() {
    return {
      'createdAt': createdAt?.toIso8601String(),
      'chatThreadId': chatThreadId,
      'participants': participants,
      'chatType': chatType,
      'lastMessage': lastMessage,
      'lastMessageType': lastMessageType,
      'lastMessageTime': lastMessageTime?.toIso8601String(),
      'unSeenMessage': unSeenMessage,
      'lastMessageSeenBy': lastMessageSeenBy,
      'likedBy': likedBy,
      'deletedBy': deletedBy,
      'receiverName': receiverName,
      'receiverImage': receiverImage,
      'receiverID': receiverID,
    };
  }

  // fromMap factory constructor
  factory ChatThreadModel.fromMap(Map<String, dynamic> map) {
    return ChatThreadModel(
      createdAt:
          map['createdAt'] != null ? DateTime.parse(map['createdAt']) : null,
      chatThreadId: map['chatThreadId'],
      participants: map['participants'] != null
          ? List<String>.from(map['participants'])
          : null,
      chatType: map['chatType'],
      lastMessage: map['lastMessage'],
      lastMessageType: map['lastMessageType'],
      lastMessageTime: map['lastMessageTime'] != null
          ? (map['lastMessageTime'] as Timestamp).toDate()
          : null,
      unSeenMessage: map['unSeenMessage'],
      lastMessageSeenBy: map['lastMessageSeenBy'] != null
          ? List<String>.from(map['lastMessageSeenBy'])
          : null,
      likedBy:
          map['likedBy'] != null ? List<String>.from(map['likedBy']) : null,
      deletedBy:
          map['deletedBy'] != null ? List<String>.from(map['deletedBy']) : null,
      receiverName: map['receiverName'] ?? '',
      receiverImage: map['receiverImage'] ?? '',
      receiverID: map['receiverID'] ?? '',
    );
  }
}
