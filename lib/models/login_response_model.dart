// To parse this JSON data, do
//
//     final loginResponseModel = loginResponseModelFromJson(jsonString);

import 'dart:convert';

LoginResponseModel loginResponseModelFromJson(String str) =>
    LoginResponseModel.fromJson(json.decode(str));

String loginResponseModelToJson(LoginResponseModel data) =>
    json.encode(data.toJson());

class LoginResponseModel {
  bool? success;
  String? message;
  String? accessToken;
  String? refreshToken;
  Data? data;

  LoginResponseModel({
    this.success,
    this.message,
    this.accessToken,
    this.refreshToken,
    this.data,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) =>
      LoginResponseModel(
        success: json["success"],
        message: json["message"],
        accessToken: json["access_token"],
        refreshToken: json["refresh_token"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "access_token": accessToken,
    "refresh_token": refreshToken,
    "data": data?.toJson(),
  };
}

class Data {
  int? userEmpKey;
  String? userName;
  String? userPhoneNumber;
  String? userEmail;
  String? dateOfBirth;
  String? userLocation;
  String? userAbout;
  String? userGender;
  bool? isAdmin;
  String? profilePhotoUrl;

  Data({
    this.userEmpKey,
    this.userName,
    this.userPhoneNumber,
    this.userEmail,
    this.dateOfBirth,
    this.userLocation,
    this.userAbout,
    this.userGender,
    this.isAdmin,
    this.profilePhotoUrl,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    userEmpKey: json["user_emp_key"],
    userName: json["user_name"],
    userPhoneNumber: json["user_phone_number"],
    userEmail: json["user_email"],
    dateOfBirth: json["date_of_birth"],
    userLocation: json["user_location"],
    userAbout: json["user_about"],
    userGender: json["user_gender"],
    isAdmin: json["is_admin"],
    profilePhotoUrl: json["profile_photo_url"],
  );

  Map<String, dynamic> toJson() => {
    "user_emp_key": userEmpKey,
    "user_name": userName,
    "user_phone_number": userPhoneNumber,
    "user_email": userEmail,
    "date_of_birth": dateOfBirth,
    "user_location": userLocation,
    "user_about": userAbout,
    "user_gender": userGender,
    "is_admin": isAdmin,
    "profile_photo_url": profilePhotoUrl,
  };
}
