// To parse this JSON data, do
//
//     final getProfileDetailsResponseModel = getProfileDetailsResponseModelFromJson(jsonString);

import 'dart:convert';

GetProfileDetailsResponseModel getProfileDetailsResponseModelFromJson(
  String str,
) => GetProfileDetailsResponseModel.fromJson(json.decode(str));

String getProfileDetailsResponseModelToJson(
  GetProfileDetailsResponseModel data,
) => json.encode(data.toJson());

class GetProfileDetailsResponseModel {
  bool? success;
  String? message;
  ProfileDetails? data;

  GetProfileDetailsResponseModel({this.success, this.message, this.data});

  factory GetProfileDetailsResponseModel.fromJson(Map<String, dynamic> json) =>
      GetProfileDetailsResponseModel(
        success: json["success"],
        message: json["message"],
        data: json["data"] == null
            ? null
            : ProfileDetails.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data?.toJson(),
  };
}

class ProfileDetails {
  int? userEmpKey;
  String? userName;
  String? userPhoneNumber;
  String? userProfilePhoto;
  int? userPin;
  bool? isAdmin;
  String? userEmail;
  String? dateOfBirth;
  String? userLocation;
  String? userAbout;
  String? userGender;

  ProfileDetails({
    this.userEmpKey,
    this.userName,
    this.userPhoneNumber,
    this.userProfilePhoto,
    this.userPin,
    this.isAdmin,
    this.userEmail,
    this.dateOfBirth,
    this.userLocation,
    this.userAbout,
    this.userGender,
  });

  factory ProfileDetails.fromJson(Map<String, dynamic> json) => ProfileDetails(
    userEmpKey: json["user_emp_key"],
    userName: json["user_name"],
    userPhoneNumber: json["user_phone_number"],
    userProfilePhoto: json["user_profile_photo"],
    userPin: json["user_pin"],
    isAdmin: json["is_admin"],
    userEmail: json["user_email"],
    dateOfBirth: json["date_of_birth"],
    userLocation: json["user_location"],
    userAbout: json["user_about"],
    userGender: json["user_gender"],
  );

  Map<String, dynamic> toJson() => {
    "user_emp_key": userEmpKey,
    "user_name": userName,
    "user_phone_number": userPhoneNumber,
    "user_profile_photo": userProfilePhoto,
    "user_pin": userPin,
    "is_admin": isAdmin,
    "user_email": userEmail,
    "date_of_birth": dateOfBirth,
    "user_location": userLocation,
    "user_about": userAbout,
    "user_gender": userGender,
  };
}
