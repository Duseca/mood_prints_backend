class UserModel {
  final String? stripeCustomerId;
  final String? id;
  final String? deviceToken;
  final String? email;
  final String? userType;
  final String? fullName;
  final String? username;
  final String? bio;
  final String? image;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? dob; // Keeping as String
  final String? phoneNumber;
  final String? gender;
  final String? authProvider;
  final List<String>? therapistId; // Added therapistId list

  // 🔹 New variables
  final bool? authorizeTherapistAccess;
  final bool? authorizeMoodPrintsAccess;
  final DateTime? authorizationDateTime;

  final String? emergencyEmail;
  final String? emergencyName;
  final String? emergencyPhone;
  final String? signatureText;

  UserModel(
      {this.stripeCustomerId,
      this.id,
      this.deviceToken,
      this.email,
      this.userType,
      this.fullName,
      this.username,
      this.bio,
      this.image,
      this.createdAt,
      this.updatedAt,
      this.dob,
      this.phoneNumber,
      this.gender,
      this.authProvider,
      this.therapistId,

      // 🔹 New variables
      this.authorizeTherapistAccess,
      this.authorizeMoodPrintsAccess,
      this.authorizationDateTime,
      this.emergencyEmail,
      this.emergencyName,
      this.emergencyPhone,
      this.signatureText});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
        stripeCustomerId: json.containsKey('stripeCustomerId')
            ? json['stripeCustomerId'] as String? ?? ''
            : '',
        id: json.containsKey('_id') ? json['_id'] as String? ?? '' : '',
        deviceToken: json.containsKey('deviceToken')
            ? json['deviceToken'] as String? ?? ''
            : '',
        email: json.containsKey('email') ? json['email'] as String? ?? '' : '',
        authProvider: json.containsKey('authProvider')
            ? json['authProvider'] as String? ?? 'email'
            : 'email',
        userType: json.containsKey('userType')
            ? json['userType'] as String? ?? ''
            : '',
        fullName: json.containsKey('fullName')
            ? json['fullName'] as String? ?? ''
            : '',
        username: json.containsKey('username')
            ? json['username'] as String? ?? ''
            : '',
        bio: json.containsKey('bio') ? json['bio'] as String? ?? '' : '',
        image: json.containsKey('image') ? json['image'] as String? ?? '' : '',
        createdAt: json.containsKey('createdAt') && json['createdAt'] != null
            ? DateTime.tryParse(json['createdAt']) ?? DateTime(1970, 1, 1)
            : DateTime(1970, 1, 1),
        updatedAt: json.containsKey('updatedAt') && json['updatedAt'] != null
            ? DateTime.tryParse(json['updatedAt']) ?? DateTime(1970, 1, 1)
            : DateTime(1970, 1, 1),
        dob: json.containsKey('dob') ? json['dob'] as String? ?? '' : '',
        phoneNumber: json.containsKey('phoneNumber')
            ? json['phoneNumber'] as String? ?? ''
            : '',
        gender:
            json.containsKey('gender') ? json['gender'] as String? ?? '' : '',
        therapistId:
            json.containsKey('therapistId') && json['therapistId'] is List
                ? List<String>.from(json['therapistId'] as List)
                : [],

        // 🔹 New variables
        authorizeTherapistAccess: json['authorizeTherapistAccess'] as bool?,
        authorizeMoodPrintsAccess: json['authorizeMoodPrintsAccess'] as bool?,
        authorizationDateTime: json['authorizationDateTime'] != null
            ? DateTime.tryParse(json['authorizationDateTime'])
            : null,
        emergencyEmail: json["emergencyEmail"] as String?,
        emergencyName: json["emergencyName"] as String?,
        emergencyPhone: json["emergencyPhone"] as String?,
        signatureText: json["signatureText"] as String?);
  }

  Map<String, dynamic> toJson() {
    return {
      if (stripeCustomerId != null) 'stripeCustomerId': stripeCustomerId,
      if (id != null) '_id': id,
      if (deviceToken != null) 'deviceToken': deviceToken,
      if (email != null) 'email': email,
      if (userType != null) 'userType': userType,
      if (fullName != null) 'fullName': fullName,
      if (username != null) 'username': username,
      if (bio != null) 'bio': bio,
      if (image != null) 'image': image,
      if (createdAt != null) 'createdAt': createdAt?.toIso8601String(),
      if (updatedAt != null) 'updatedAt': updatedAt?.toIso8601String(),
      if (dob != null) 'dob': dob,
      if (phoneNumber != null) 'phoneNumber': phoneNumber,
      if (gender != null) 'gender': gender,
      if (authProvider != null) 'authProvider': authProvider ?? 'email',
      if (therapistId != null) 'therapistId': therapistId ?? [],

      // 🔹 New variables
      if (authorizeMoodPrintsAccess != null)
        'authorizeTherapistAccess': authorizeTherapistAccess,
      if (authorizeMoodPrintsAccess != null)
        'authorizeMoodPrintsAccess': authorizeMoodPrintsAccess,
      if (authorizationDateTime != null)
        'authorizationDateTime': authorizationDateTime?.toIso8601String(),
      if (emergencyEmail != null) 'emargencyEmail': emergencyEmail,
      if (emergencyPhone != null) "emergencyPhone": emergencyPhone,
      if (emergencyName != null) 'emergencyName': emergencyName,
      if (signatureText != null) 'signatureText': signatureText
    };
  }
}

// class UserModel {
//   final String? stripeCustomerId;
//   final String? id;
//   final String? deviceToken;
//   final String? email;
//   final String? userType;
//   final String? fullName;
//   final String? username;
//   final String? bio;
//   final String? image;
//   final DateTime? createdAt;
//   final DateTime? updatedAt;
//   final String? dob; // Keeping as String
//   final String? phoneNumber;
//   final String? gender;
//   final String? authProvider;
//   final List<String>? therapistId; // Added therapistId list

//   UserModel({
//     this.stripeCustomerId,
//     this.id,
//     this.deviceToken,
//     this.email,
//     this.userType,
//     this.fullName,
//     this.username,
//     this.bio,
//     this.image,
//     this.createdAt,
//     this.updatedAt,
//     this.dob,
//     this.phoneNumber,
//     this.gender,
//     this.authProvider,
//     this.therapistId,
//   });

//   // Factory constructor to create an instance from JSON
//   factory UserModel.fromJson(Map<String, dynamic> json) {
//     return UserModel(
//       stripeCustomerId: json.containsKey('stripeCustomerId')
//           ? json['stripeCustomerId'] as String? ?? ''
//           : '',
//       id: json.containsKey('_id') ? json['_id'] as String? ?? '' : '',
//       deviceToken: json.containsKey('deviceToken')
//           ? json['deviceToken'] as String? ?? ''
//           : '',
//       email: json.containsKey('email') ? json['email'] as String? ?? '' : '',
//       authProvider: json.containsKey('authProvider')
//           ? json['authProvider'] as String? ?? 'email'
//           : 'email',
//       userType:
//           json.containsKey('userType') ? json['userType'] as String? ?? '' : '',
//       fullName:
//           json.containsKey('fullName') ? json['fullName'] as String? ?? '' : '',
//       username:
//           json.containsKey('username') ? json['username'] as String? ?? '' : '',
//       bio: json.containsKey('bio') ? json['bio'] as String? ?? '' : '',
//       image: json.containsKey('image') ? json['image'] as String? ?? '' : '',
//       createdAt: json.containsKey('createdAt') && json['createdAt'] != null
//           ? DateTime.tryParse(json['createdAt']) ?? DateTime(1970, 1, 1)
//           : DateTime(1970, 1, 1),
//       updatedAt: json.containsKey('updatedAt') && json['updatedAt'] != null
//           ? DateTime.tryParse(json['updatedAt']) ?? DateTime(1970, 1, 1)
//           : DateTime(1970, 1, 1),
//       dob: json.containsKey('dob') ? json['dob'] as String? ?? '' : '',
//       phoneNumber: json.containsKey('phoneNumber')
//           ? json['phoneNumber'] as String? ?? ''
//           : '',
//       gender: json.containsKey('gender') ? json['gender'] as String? ?? '' : '',
//       therapistId:
//           json.containsKey('therapistId') && json['therapistId'] is List
//               ? List<String>.from(json['therapistId'] as List)
//               : [],
//     );
//   }

//   // Method to convert instance to JSON
//   Map<String, dynamic> toJson() {
//     return {
//       'stripeCustomerId': stripeCustomerId,
//       '_id': id,
//       'deviceToken': deviceToken,
//       'email': email,
//       'userType': userType,
//       'fullName': fullName,
//       'username': username,
//       'bio': bio,
//       'image': image,
//       'createdAt': createdAt?.toIso8601String(),
//       'updatedAt': updatedAt?.toIso8601String(),
//       'dob': dob, // Keeping as String
//       'phoneNumber': phoneNumber,
//       'gender': gender,
//       'authProvider': authProvider ?? 'email',
//       'therapistId': therapistId ?? [], // Ensuring it’s not null
//     };
//   }
// }
