// To parse this JSON data, do
//
//     final logedDeviceDetailsResponseModel = logedDeviceDetailsResponseModelFromJson(jsonString);

import 'dart:convert';

LogedDeviceDetailsResponseModel logedDeviceDetailsResponseModelFromJson(
  String str,
) => LogedDeviceDetailsResponseModel.fromJson(json.decode(str));

String logedDeviceDetailsResponseModelToJson(
  LogedDeviceDetailsResponseModel data,
) => json.encode(data.toJson());

class LogedDeviceDetailsResponseModel {
  bool? success;
  String? message;
  List<Datum>? data;

  LogedDeviceDetailsResponseModel({this.success, this.message, this.data});

  factory LogedDeviceDetailsResponseModel.fromJson(Map<String, dynamic> json) =>
      LogedDeviceDetailsResponseModel(
        success: json["success"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data == null
        ? []
        : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class Datum {
  String? deviceId;
  String? deviceName;

  Datum({this.deviceId, this.deviceName});

  factory Datum.fromJson(Map<String, dynamic> json) =>
      Datum(deviceId: json["device_id"], deviceName: json["device_name"]);

  Map<String, dynamic> toJson() => {
    "device_id": deviceId,
    "device_name": deviceName,
  };
}
