class AllTherapist {
  final String? googleId;
  final String? facebookId;
  final String id;
  final String email;
  final String? otp;
  final DateTime? otpExpiry;
  final String userType;
  final String fullName;
  final String username;
  final DateTime? dob;
  final String? gender;
  final String? phoneNumber;
  final String? city;

  final String? bio;
  final String? image;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? stripeCustomerId;
  final String? stripeSubscriptionId;
  final String authProvider;
  final List<Relationship> relationships;

  AllTherapist({
    this.googleId,
    this.facebookId,
    required this.id,
    required this.email,
    this.otp,
    this.otpExpiry,
    required this.userType,
    required this.fullName,
    required this.username,
    this.dob,
    this.gender,
    this.phoneNumber,
    this.city,
    this.bio,
    this.image,
    required this.createdAt,
    required this.updatedAt,
    this.stripeCustomerId,
    this.stripeSubscriptionId,
    required this.authProvider,
    required this.relationships,
  });

  factory AllTherapist.fromJson(Map<String, dynamic> json) {
    return AllTherapist(
      googleId: json['googleId'],
      facebookId: json['facebookId'],
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
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      stripeCustomerId: json['stripeCustomerId'],
      stripeSubscriptionId: json['stripeSubscriptionId'],
      authProvider: json['authProvider'],
      relationships: (json['relationships'] as List<dynamic>)
          .map((e) => Relationship.fromJson(e))
          .toList(),
    );
  }
}

class Relationship {
  final String id;
  final Client clientId;
  final String therapistId;
  final DateTime createdAt;
  final DateTime updatedAt;

  Relationship({
    required this.id,
    required this.clientId,
    required this.therapistId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Relationship.fromJson(Map<String, dynamic> json) {
    return Relationship(
      id: json['_id'],
      clientId: Client.fromJson(json['clientId']),
      therapistId: json['therapistId'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}

class Client {
  final String? googleId;
  final String? facebookId;
  final String id;
  final String email;
  final String? otp;
  final DateTime? otpExpiry;
  final String userType;
  final String fullName;
  final String username;
  final String? bio;
  final String? image;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? stripeCustomerId;
  final String authProvider;
  final DateTime? dob;
  final String? phoneNumber;
  final String? gender;

  Client({
    this.googleId,
    this.facebookId,
    required this.id,
    required this.email,
    this.otp,
    this.otpExpiry,
    required this.userType,
    required this.fullName,
    required this.username,
    this.bio,
    this.image,
    required this.createdAt,
    required this.updatedAt,
    this.stripeCustomerId,
    required this.authProvider,
    this.dob,
    this.phoneNumber,
    this.gender,
  });

  factory Client.fromJson(Map<String, dynamic> json) {
    return Client(
      googleId: json['googleId'],
      facebookId: json['facebookId'],
      id: json['_id'],
      email: json['email'],
      otp: json['otp'],
      otpExpiry:
          json['otpExpiry'] != null ? DateTime.parse(json['otpExpiry']) : null,
      userType: json['userType'],
      fullName: json['fullName'],
      username: json['username'],
      bio: json['bio'],
      image: json['image'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      stripeCustomerId: json['stripeCustomerId'],
      authProvider: json['authProvider'],
      dob: json['dob'] != null ? DateTime.parse(json['dob']) : null,
      phoneNumber: json['phoneNumber'],
      gender: json['gender'],
    );
  }
}
