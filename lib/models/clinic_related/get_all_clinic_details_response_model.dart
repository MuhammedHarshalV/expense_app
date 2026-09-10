// To parse this JSON data, do
//
//     final getAllClinicsDetailsResponseModel = getAllClinicsDetailsResponseModelFromJson(jsonString);

import 'dart:convert';

GetAllClinicsDetailsResponseModel getAllClinicsDetailsResponseModelFromJson(
  String str,
) => GetAllClinicsDetailsResponseModel.fromJson(json.decode(str));

String getAllClinicsDetailsResponseModelToJson(
  GetAllClinicsDetailsResponseModel data,
) => json.encode(data.toJson());

class GetAllClinicsDetailsResponseModel {
  bool? success;
  String? message;
  Pagination? pagination;
  List<Datum>? data;

  GetAllClinicsDetailsResponseModel({
    this.success,
    this.message,
    this.pagination,
    this.data,
  });

  factory GetAllClinicsDetailsResponseModel.fromJson(
    Map<String, dynamic> json,
  ) => GetAllClinicsDetailsResponseModel(
    success: json["success"],
    message: json["message"],
    pagination: json["pagination"] == null
        ? null
        : Pagination.fromJson(json["pagination"]),
    data: json["data"] == null
        ? []
        : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "pagination": pagination?.toJson(),
    "data": data == null
        ? []
        : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class Datum {
  int? clinicId;
  String? clinicName;
  String? clinicPlace;
  num? clinicTotalExp;
  int? userId;
  String? clinicPhoto;

  Datum({
    this.clinicId,
    this.clinicName,
    this.clinicPlace,
    this.clinicTotalExp,
    this.userId,
    this.clinicPhoto,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    clinicId: json["clinic_id"],
    clinicName: json["clinic_name"],
    clinicPlace: json["clinic_place"],
    clinicTotalExp: json["clinic_total_exp"],
    userId: json["user_id"],
    clinicPhoto: json["clinic_photo"],
  );

  Map<String, dynamic> toJson() => {
    "clinic_id": clinicId,
    "clinic_name": clinicName,
    "clinic_place": clinicPlace,
    "clinic_total_exp": clinicTotalExp,
    "user_id": userId,
    "clinic_photo": clinicPhoto,
  };
}

class Pagination {
  int? totalCount;
  int? currentPage;
  int? totalPages;
  int? limit;

  Pagination({this.totalCount, this.currentPage, this.totalPages, this.limit});

  factory Pagination.fromJson(Map<String, dynamic> json) => Pagination(
    totalCount: json["total_count"],
    currentPage: json["current_page"],
    totalPages: json["total_pages"],
    limit: json["limit"],
  );

  Map<String, dynamic> toJson() => {
    "total_count": totalCount,
    "current_page": currentPage,
    "total_pages": totalPages,
    "limit": limit,
  };
}
