class RelationClientModel {
  final String? id;
  final Client? clientId;
  final String? therapistId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  RelationClientModel({
    this.id,
    this.clientId,
    this.therapistId,
    this.createdAt,
    this.updatedAt,
  });

  factory RelationClientModel.fromJson(Map<String, dynamic> json) {
    return RelationClientModel(
      id: json['_id'],
      clientId:
          json['clientId'] != null ? Client.fromJson(json['clientId']) : null,
      therapistId: json['therapistId'],
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'clientId': clientId?.toJson(),
      'therapistId': therapistId,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}

class Client {
  final String? id;
  final String? email;
  final String? authProvider;
  final String? googleId;
  final String? facebookId;
  final String? otp;
  final String? otpExpiry;
  final String? userType;
  final String? fullName;
  final String? username;
  final String? bio;
  final String? image;
  final String? stripeCustomerId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? dob;
  final String? gender;
  final String? phoneNumber;
  final String? deviceToken;

  Client({
    this.id,
    this.email,
    this.authProvider,
    this.googleId,
    this.facebookId,
    this.otp,
    this.otpExpiry,
    this.userType,
    this.fullName,
    this.username,
    this.bio,
    this.image,
    this.stripeCustomerId,
    this.createdAt,
    this.updatedAt,
    this.dob,
    this.gender,
    this.phoneNumber,
    this.deviceToken,
  });

  factory Client.fromJson(Map<String, dynamic> json) {
    return Client(
      id: json['_id'],
      email: json['email'],
      authProvider: json['authProvider'],
      googleId: json['googleId'],
      facebookId: json['facebookId'],
      otp: json['otp'],
      otpExpiry: json['otpExpiry'],
      userType: json['userType'],
      fullName: json['fullName'],
      username: json['username'],
      bio: json['bio'],
      image: json['image'],
      stripeCustomerId: json['stripeCustomerId'],
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      dob: json['dob'],
      gender: json['gender'],
      phoneNumber: json['phoneNumber'],
      deviceToken: json['deviceToken'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'email': email,
      'authProvider': authProvider,
      'googleId': googleId,
      'facebookId': facebookId,
      'otp': otp,
      'otpExpiry': otpExpiry,
      'userType': userType,
      'fullName': fullName,
      'username': username,
      'bio': bio,
      'image': image,
      'stripeCustomerId': stripeCustomerId,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'dob': dob,
      'gender': gender,
      'phoneNumber': phoneNumber,
      'deviceToken': deviceToken,
    };
  }
}

// class Relationships {
//   final List<Relationship>? relationships;

//   Relationships({this.relationships});

//   factory Relationships.fromJson(List<dynamic> jsonList) {
//     return Relationships(
//       relationships:
//           jsonList.map((json) => Relationship.fromJson(json)).toList(),
//     );
//   }

//   List<Map<String, dynamic>> toJson() {
//     return relationships
//             ?.map((relationship) => relationship.toJson())
//             .toList() ??
//         [];
//   }
// }
