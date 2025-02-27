class RelationTherapistModel {
  final String? id;
  final String? clientId;
  final Therapist? therapist;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  RelationTherapistModel({
    this.id,
    this.clientId,
    this.therapist,
    this.createdAt,
    this.updatedAt,
  });

  factory RelationTherapistModel.fromJson(Map<String, dynamic> json) {
    return RelationTherapistModel(
      id: json['_id'],
      clientId: json['clientId'],
      therapist: json['therapistId'] != null
          ? Therapist.fromJson(json['therapistId'])
          : null,
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'clientId': clientId,
      'therapistId': therapist?.toJson(),
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}

class Therapist {
  final String? googleId;
  final String? facebookId;
  final String? deviceToken;
  final String? id;
  final String? email;
  final String? otp;
  final DateTime? otpExpiry;
  final String? userType;
  final String? fullName;
  final String? username;
  final DateTime? dob;
  final String? gender;
  final String? phoneNumber;
  final String? city;
  final String? bio;
  final String? image;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? stripeCustomerId;
  final String? stripeSubscriptionId;
  final String? authProvider;

  Therapist({
    this.googleId,
    this.facebookId,
    this.deviceToken,
    this.id,
    this.email,
    this.otp,
    this.otpExpiry,
    this.userType,
    this.fullName,
    this.username,
    this.dob,
    this.gender,
    this.phoneNumber,
    this.city,
    this.bio,
    this.image,
    this.createdAt,
    this.updatedAt,
    this.stripeCustomerId,
    this.stripeSubscriptionId,
    this.authProvider,
  });

  factory Therapist.fromJson(Map<String, dynamic> json) {
    return Therapist(
      googleId: json['googleId'],
      facebookId: json['facebookId'],
      deviceToken: json['deviceToken'],
      id: json['_id'],
      email: json['email'],
      otp: json['otp'],
      otpExpiry:
          json['otpExpiry'] != null ? DateTime.parse(json['otpExpiry']) : null,
      userType: json['userType'],
      fullName: json['fullName'],
      username: json['username'],
      dob: json['dob'] != null ? DateTime.parse(json['dob']) : null,
      gender: json['gender'],
      phoneNumber: json['phoneNumber'],
      city: json['city'],
      bio: json['bio'],
      image: json['image'],
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      stripeCustomerId: json['stripeCustomerId'],
      stripeSubscriptionId: json['stripeSubscriptionId'],
      authProvider: json['authProvider'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'googleId': googleId,
      'facebookId': facebookId,
      'deviceToken': deviceToken,
      '_id': id,
      'email': email,
      'otp': otp,
      'otpExpiry': otpExpiry?.toIso8601String(),
      'userType': userType,
      'fullName': fullName,
      'username': username,
      'dob': dob?.toIso8601String(),
      'gender': gender,
      'phoneNumber': phoneNumber,
      'city': city,
      'bio': bio,
      'image': image,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'stripeCustomerId': stripeCustomerId,
      'stripeSubscriptionId': stripeSubscriptionId,
      'authProvider': authProvider,
    };
  }
}
