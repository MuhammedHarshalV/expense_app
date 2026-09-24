// To parse this JSON data, do
//
//     final getExpenseHistoryResponseModel = getExpenseHistoryResponseModelFromJson(jsonString);

import 'dart:convert';

GetExpenseHistoryResponseModel getExpenseHistoryResponseModelFromJson(
  String str,
) => GetExpenseHistoryResponseModel.fromJson(json.decode(str));

String getExpenseHistoryResponseModelToJson(
  GetExpenseHistoryResponseModel data,
) => json.encode(data.toJson());

class GetExpenseHistoryResponseModel {
  bool? success;
  String? message;
  num? totalSpend;
  num? approvedAmount;
  int? page;
  int? limit;
  int? totalCount;
  int? totalPages;
  List<ExpenseHistory>? data;

  GetExpenseHistoryResponseModel({
    this.success,
    this.message,
    this.totalSpend,
    this.approvedAmount,
    this.page,
    this.limit,
    this.totalCount,
    this.totalPages,
    this.data,
  });

  factory GetExpenseHistoryResponseModel.fromJson(Map<String, dynamic> json) =>
      GetExpenseHistoryResponseModel(
        success: json["success"],
        message: json["message"],
        totalSpend: json["total_spend"],
        approvedAmount: json["approved_amount"],
        page: json["page"],
        limit: json["limit"],
        totalCount: json["total_count"],
        totalPages: json["total_pages"],
        data: json["data"] == null
            ? []
            : List<ExpenseHistory>.from(
                json["data"]!.map((x) => ExpenseHistory.fromJson(x)),
              ),
      );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "total_spend": totalSpend,
    "approved_amount": approvedAmount,
    "page": page,
    "limit": limit,
    "total_count": totalCount,
    "total_pages": totalPages,
    "data": data == null
        ? []
        : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class ExpenseHistory {
  int? clinicId;
  String? clinicName;
  String? clinicPhoto;
  int? totalTransactionCount;
  num? totalSpend;
  num? approvedAmount;
  DateTime? lastTransactionDate;

  ExpenseHistory({
    this.clinicId,
    this.clinicName,
    this.clinicPhoto,
    this.totalTransactionCount,
    this.totalSpend,
    this.approvedAmount,
    this.lastTransactionDate,
  });

  factory ExpenseHistory.fromJson(Map<String, dynamic> json) => ExpenseHistory(
    clinicId: json["clinic_id"],
    clinicName: json["clinic_name"],
    clinicPhoto: json["clinic_photo"],
    totalTransactionCount: json["total_transaction_count"],
    totalSpend: json["total_spend"],
    approvedAmount: json["approved_amount"],
    lastTransactionDate: json["last_transaction_date"] == null
        ? null
        : DateTime.parse(json["last_transaction_date"]),
  );

  Map<String, dynamic> toJson() => {
    "clinic_id": clinicId,
    "clinic_name": clinicName,
    "clinic_photo": clinicPhoto,
    "total_transaction_count": totalTransactionCount,
    "total_spend": totalSpend,
    "approved_amount": approvedAmount,
    "last_transaction_date": lastTransactionDate?.toIso8601String(),
  };
}
