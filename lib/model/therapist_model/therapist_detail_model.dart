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

  final String? emergencyEmail;
  final String? emergencyName;
  final String? emergencyPhone;
  final String? signatureText;

  TherapistDetailModel(
      {this.email,
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
      this.emergencyEmail,
      this.emergencyName,
      this.emergencyPhone,
      this.signatureText});

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
        emergencyEmail: json["emergencyEmail"] as String?,
        emergencyName: json["emergencyName"] as String?,
        emergencyPhone: json["emergencyPhone"] as String?,
        signatureText: json["signatureText"] as String?);
  }

  Map<String, dynamic> toJson() {
    return {
      if (email != null) 'email': email,
      if (authProvider != null) 'authProvider': authProvider,
      if (googleId != null) 'googleId': googleId,
      if (facebookId != null) 'facebookId': facebookId,
      if (otp != null) 'otp': otp,
      if (otpExpiry != null) 'otpExpiry': otpExpiry?.toIso8601String(),
      if (userType != null) 'userType': userType,
      if (fullName != null) 'fullName': fullName,
      if (username != null) 'username': username,
      if (dob != null) 'dob': dob, // Already a String
      if (gender != null) 'gender': gender,
      if (phoneNumber != null) 'phoneNumber': phoneNumber,
      if (city != null) 'city': city,
      if (country != null) 'country': country,
      if (state != null) 'state': state,
      if (bio != null) 'bio': bio,
      if (image != null) 'image': image,
      if (stripeCustomerId != null) 'stripeCustomerId': stripeCustomerId,
      if (deviceToken != null) 'deviceToken': deviceToken,
      if (id != null) '_id': id,
      if (createdAt != null) 'createdAt': createdAt?.toIso8601String(),
      if (updatedAt != null) 'updatedAt': updatedAt?.toIso8601String(),
      if (version != null) '__v': version,
      if (emergencyEmail != null) 'emargencyEmail': emergencyEmail,
      if (emergencyPhone != null) "emergencyPhone": emergencyPhone,
      if (emergencyName != null) 'emergencyName': emergencyName,
      if (signatureText != null) 'signatureText': signatureText,
    };
  }
}
