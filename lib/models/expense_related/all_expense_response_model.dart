// To parse this JSON data, do
//
//     final allExpenseResponseModel = allExpenseResponseModelFromJson(jsonString);

import 'dart:convert';

AllClinicExpenseResponseModel allExpenseResponseModelFromJson(String str) =>
    AllClinicExpenseResponseModel.fromJson(json.decode(str));

String allExpenseResponseModelToJson(AllClinicExpenseResponseModel data) =>
    json.encode(data.toJson());

class AllClinicExpenseResponseModel {
  bool? success;
  String? message;
  ClinicExpDetails? data;

  AllClinicExpenseResponseModel({this.success, this.message, this.data});

  factory AllClinicExpenseResponseModel.fromJson(Map<String, dynamic> json) =>
      AllClinicExpenseResponseModel(
        success: json["success"],
        message: json["message"],
        data: json["data"] == null
            ? null
            : ClinicExpDetails.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data?.toJson(),
  };
}

class ClinicExpDetails {
  int? clinicId;
  String? clinicName;
  num? clinicTotalExp;
  String? clinicPlace;
  String? clinicPhoto;
  List<Expense>? expenses;

  ClinicExpDetails({
    this.clinicId,
    this.clinicName,
    this.clinicTotalExp,
    this.clinicPlace,
    this.clinicPhoto,
    this.expenses,
  });

  factory ClinicExpDetails.fromJson(Map<String, dynamic> json) =>
      ClinicExpDetails(
        clinicId: json["clinic_id"],
        clinicName: json["clinic_name"],
        clinicTotalExp: json["clinic_total_exp"],
        clinicPlace: json["clinic_place"],
        clinicPhoto: json["clinic_photo"],
        expenses: json["expenses"] == null
            ? []
            : List<Expense>.from(
                json["expenses"]!.map((x) => Expense.fromJson(x)),
              ),
      );

  Map<String, dynamic> toJson() => {
    "clinic_id": clinicId,
    "clinic_name": clinicName,
    "clinic_total_exp": clinicTotalExp,
    "clinic_place": clinicPlace,
    "clinic_photo": clinicPhoto,
    "expenses": expenses == null
        ? []
        : List<dynamic>.from(expenses!.map((x) => x.toJson())),
  };
}

class Expense {
  int? expenseId;
  int? clinicId;
  num? expenseAmount;
  String? expenseType;
  String? description;
  String? expenseDate;
  String? billPhoto;

  Expense({
    this.expenseId,
    this.clinicId,
    this.expenseAmount,
    this.expenseType,
    this.description,
    this.expenseDate,
    this.billPhoto,
  });

  factory Expense.fromJson(Map<String, dynamic> json) => Expense(
    expenseId: json["expense_id"],
    clinicId: json["clinic_id"],
    expenseAmount: json["expense_amount"],
    expenseType: json["expense_type"],
    description: json["description"],
    expenseDate: json["expense_date"],
    billPhoto: json["bill_photo"],
  );

  Map<String, dynamic> toJson() => {
    "expense_id": expenseId,
    "clinic_id": clinicId,
    "expense_amount": expenseAmount,
    "expense_type": expenseType,
    "description": description,
    "expense_date": expenseDate,
    "bill_photo": billPhoto,
  };
}
