// class UserModel {
//   String? stripeCustomerId;
//   String? id;
//   String? email;
//   String? userType;
//   String? fullName;
//   String? username;
//   String? bio;
//   String? image;
//   DateTime? createdAt;
//   DateTime? updatedAt;
//   String? dob; // Change to String
//   String? phoneNumber;
//   String? gender;
//   String? authProvider;

//   UserModel({
//     this.stripeCustomerId,
//     this.id,
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
//   });

//   // Factory method to create a UserModel from a JSON map
//   factory UserModel.fromJson(Map<String, dynamic> json) {
//     return UserModel(
//       stripeCustomerId: json['stripeCustomerId'],
//       id: json['_id'],
//       email: json['email'],
//       authProvider: json['authProvider'],
//       userType: json['userType'],
//       fullName: json['fullName'],
//       username: json['username'],
//       bio: json['bio'],
//       image: json['image'],
//       createdAt:
//           json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
//       updatedAt:
//           json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
//       dob: json['dob'], // Keep it as String
//       phoneNumber: json['phoneNumber'],
//       gender: json['gender'],
//     );
//   }

//   // Method to convert a UserModel to a JSON map
//   Map<String, dynamic> toJson() {
//     return {
//       'stripeCustomerId': stripeCustomerId,
//       '_id': id,
//       'email': email,
//       'userType': userType,
//       'fullName': fullName,
//       'username': username,
//       'bio': bio,
//       'image': image,
//       'createdAt': createdAt?.toIso8601String(),
//       'updatedAt': updatedAt?.toIso8601String(),
//       'dob': dob, // Keep as String
//       'phoneNumber': phoneNumber,
//       'gender': gender,
//       'authProvider': authProvider ?? 'email',
//     };
//   }
// }

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

  UserModel({
    this.stripeCustomerId,
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
  });

  // Factory constructor to create an instance from JSON
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
      userType:
          json.containsKey('userType') ? json['userType'] as String? ?? '' : '',
      fullName:
          json.containsKey('fullName') ? json['fullName'] as String? ?? '' : '',
      username:
          json.containsKey('username') ? json['username'] as String? ?? '' : '',
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
      gender: json.containsKey('gender') ? json['gender'] as String? ?? '' : '',
      therapistId:
          json.containsKey('therapistId') && json['therapistId'] is List
              ? List<String>.from(json['therapistId'] as List)
              : [],
    );
  }

  // Method to convert instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'stripeCustomerId': stripeCustomerId,
      '_id': id,
      'deviceToken': deviceToken,
      'email': email,
      'userType': userType,
      'fullName': fullName,
      'username': username,
      'bio': bio,
      'image': image,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'dob': dob, // Keeping as String
      'phoneNumber': phoneNumber,
      'gender': gender,
      'authProvider': authProvider ?? 'email',
      'therapistId': therapistId ?? [], // Ensuring it’s not null
    };
  }
}
