class TherapistDetailModel {
  final String? email;
  final String? authProvider;
  final String? googleId;
  final String? facebookId;
  final String? otp;
  final DateTime? otpExpiry;
  final String? userType;
  final String? fullName;
  final String? username;
  final String? dob; // Converted from DateTime to String
  final String? gender;
  final String? phoneNumber;
  final String? city;
  final String? country;
  final String? state;
  final String? bio;
  final String? image;
  final String? stripeCustomerId;
  final String? deviceToken;
  final String? id;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? version;

  TherapistDetailModel({
    this.email,
    this.authProvider,
    this.googleId,
    this.facebookId,
    this.otp,
    this.otpExpiry,
    this.userType,
    this.fullName,
    this.username,
    this.dob,
    this.gender,
    this.phoneNumber,
    this.city,
    this.country,
    this.state,
    this.bio,
    this.image,
    this.stripeCustomerId,
    this.deviceToken,
    this.id,
    this.createdAt,
    this.updatedAt,
    this.version,
  });

  factory TherapistDetailModel.fromJson(Map<String, dynamic> json) {
    return TherapistDetailModel(
      email: json['email'] as String?,
      authProvider: json['authProvider'] as String?,
      googleId: json['googleId'] as String?,
      facebookId: json['facebookId'] as String?,
      otp: json['otp'] as String?,
      otpExpiry: json['otpExpiry'] != null
          ? DateTime.tryParse(json['otpExpiry'] as String)
          : null,
      userType: json['userType'] as String?,
      fullName: json['fullName'] as String?,
      username: json['username'] as String?,
      dob: json['dob'] as String?, // Now a String
      gender: json['gender'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      city: json['city'] as String?,
      state: json['state'] as String?,
      country: json['country'] as String?,
      bio: json['bio'] as String?,
      image: json['image'] as String?,
      stripeCustomerId: json['stripeCustomerId'] as String?,
      deviceToken: json['deviceToken'] as String?,
      id: json['_id'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String)
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'] as String)
          : null,
      version: json['__v'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'authProvider': authProvider,
      'googleId': googleId,
      'facebookId': facebookId,
      'otp': otp,
      'otpExpiry': otpExpiry?.toIso8601String(),
      'userType': userType,
      'fullName': fullName,
      'username': username,
      'dob': dob, // Already a String
      'gender': gender,
      'phoneNumber': phoneNumber,
      'city': city,
      'country': country,
      'state': state,
      'bio': bio,
      'image': image,
      'stripeCustomerId': stripeCustomerId,
      'deviceToken': deviceToken,
      '_id': id,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      '__v': version,
    };
  }
}
