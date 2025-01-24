class UserModel {
  String? stripeCustomerId;
  String? id;
  String? email;
  String? userType;
  String? fullName;
  String? username;
  String? bio;
  String? image;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? dob; // Change to String
  String? phoneNumber;
  String? gender;
  String? authProvider;

  UserModel({
    this.stripeCustomerId,
    this.id,
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
  });

  // Factory method to create a UserModel from a JSON map
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      stripeCustomerId: json['stripeCustomerId'],
      id: json['_id'],
      email: json['email'],
      authProvider: json['authProvider'],
      userType: json['userType'],
      fullName: json['fullName'],
      username: json['username'],
      bio: json['bio'],
      image: json['image'],
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      dob: json['dob'], // Keep it as String
      phoneNumber: json['phoneNumber'],
      gender: json['gender'],
    );
  }

  // Method to convert a UserModel to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'stripeCustomerId': stripeCustomerId,
      '_id': id,
      'email': email,
      'userType': userType,
      'fullName': fullName,
      'username': username,
      'bio': bio,
      'image': image,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'dob': dob, // Keep as String
      'phoneNumber': phoneNumber,
      'gender': gender,
      'authProvider': authProvider ?? 'email',
    };
  }
}
