// import 'package:cloud_firestore/cloud_firestore.dart';

// class ChatThreadModel {
//   DateTime? createdAt;
//   String? chatThreadId;
//   List<String>? participants;
//   String? chatType;
//   String? lastMessage;
//   String? lastMessageType;
//   DateTime? lastMessageTime;
//   bool? unSeenMessage;
//   List<String>? lastMessageSeenBy;
//   List<String>? likedBy;
//   List<String>? deletedBy;
//   String? receiverName;
//   String? receiverImage;
//   String? receiverID;

//   // Constructor
//   ChatThreadModel({
//     this.createdAt,
//     this.chatThreadId,
//     this.participants,
//     this.chatType,
//     this.lastMessage,
//     this.lastMessageType,
//     this.lastMessageTime,
//     this.unSeenMessage,
//     this.lastMessageSeenBy,
//     this.likedBy,
//     this.deletedBy,
//     this.receiverName,
//     this.receiverImage,
//     this.receiverID,
//   });

//   // toMap method
//   Map<String, dynamic> toMap() {
//     return {
//       'createdAt': createdAt?.toIso8601String(),
//       'chatThreadId': chatThreadId,
//       'participants': participants,
//       'chatType': chatType,
//       'lastMessage': lastMessage,
//       'lastMessageType': lastMessageType,
//       'lastMessageTime': lastMessageTime?.toIso8601String(),
//       'unSeenMessage': unSeenMessage,
//       'lastMessageSeenBy': lastMessageSeenBy,
//       'likedBy': likedBy,
//       'deletedBy': deletedBy,
//       'receiverName': receiverName,
//       'receiverImage': receiverImage,
//       'receiverID': receiverID,
//     };
//   }

//   // fromMap factory constructor
//   factory ChatThreadModel.fromMap(Map<String, dynamic> map) {
//     return ChatThreadModel(
//       createdAt:
//           map['createdAt'] != null ? DateTime.parse(map['createdAt']) : null,
//       chatThreadId: map['chatThreadId'],
//       participants: map['participants'] != null
//           ? List<String>.from(map['participants'])
//           : null,
//       chatType: map['chatType'],
//       lastMessage: map['lastMessage'],
//       lastMessageType: map['lastMessageType'],
//       lastMessageTime: map['lastMessageTime'] != null
//           ? (map['lastMessageTime'] as Timestamp).toDate()
//           : null,
//       unSeenMessage: map['unSeenMessage'],
//       lastMessageSeenBy: map['lastMessageSeenBy'] != null
//           ? List<String>.from(map['lastMessageSeenBy'])
//           : null,
//       likedBy:
//           map['likedBy'] != null ? List<String>.from(map['likedBy']) : null,
//       deletedBy:
//           map['deletedBy'] != null ? List<String>.from(map['deletedBy']) : null,
//       receiverName: map['receiverName'] ?? '',
//       receiverImage: map['receiverImage'] ?? '',
//       receiverID: map['receiverID'] ?? '',
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';

class ChatThreadModel {
  DateTime? createdAt;
  String? chatThreadId;
  List<String> participants;
  String? chatType;
  String? lastMessage;
  String? lastMessageType;
  DateTime? lastMessageTime;
  bool? unSeenMessage;
  List<String> lastMessageSeenBy;
  List<String> likedBy;
  List<String> deletedBy;
  String? receiverName;
  String? receiverImage;
  String? receiverID;

  // Constructor
  ChatThreadModel({
    this.createdAt,
    this.chatThreadId,
    required this.participants,
    this.chatType,
    this.lastMessage,
    this.lastMessageType,
    this.lastMessageTime,
    this.unSeenMessage,
    required this.lastMessageSeenBy,
    required this.likedBy,
    required this.deletedBy,
    this.receiverName,
    this.receiverImage,
    this.receiverID,
  });

  // Convert model to Firestore map
  Map<String, dynamic> toMap() {
    return {
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : null,
      'chatThreadId': chatThreadId,
      'participants': participants,
      'chatType': chatType,
      'lastMessage': lastMessage,
      'lastMessageType': lastMessageType,
      'lastMessageTime':
          lastMessageTime != null ? Timestamp.fromDate(lastMessageTime!) : null,
      'unSeenMessage': unSeenMessage,
      'lastMessageSeenBy': lastMessageSeenBy,
      'likedBy': likedBy,
      'deletedBy': deletedBy,
      'receiverName': receiverName,
      'receiverImage': receiverImage,
      'receiverID': receiverID,
    };
  }

  // Convert Firestore document to model
  factory ChatThreadModel.fromMap(DocumentSnapshot doc) {
    var map = doc.data() as Map<String, dynamic>?;

    if (map == null) {
      throw Exception("Document data is null");
    }

    return ChatThreadModel(
      createdAt: map['createdAt'] != null
          ? (map['createdAt'] is Timestamp
              ? (map['createdAt'] as Timestamp).toDate()
              : DateTime.parse(map['createdAt'] as String))
          : null,
      chatThreadId: map['chatThreadId'] as String?,
      participants: map['participants'] != null
          ? List<String>.from(map['participants'])
          : [],
      chatType: map['chatType'] as String?,
      lastMessage: map['lastMessage'] as String?,
      lastMessageType: map['lastMessageType'] as String?,
      lastMessageTime: map['lastMessageTime'] != null
          ? (map['lastMessageTime'] as Timestamp).toDate()
          : null,
      unSeenMessage: map['unSeenMessage'] as bool?,
      lastMessageSeenBy: map['lastMessageSeenBy'] != null
          ? List<String>.from(map['lastMessageSeenBy'])
          : [],
      likedBy: map['likedBy'] != null ? List<String>.from(map['likedBy']) : [],
      deletedBy:
          map['deletedBy'] != null ? List<String>.from(map['deletedBy']) : [],
      receiverName: map['receiverName'] as String?,
      receiverImage: map['receiverImage'] as String?,
      receiverID: map['receiverID'] as String?,
    );
  }
}
