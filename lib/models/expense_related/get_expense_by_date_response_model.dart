import 'package:expense/models/expense_related/all_expense_response_model.dart';

class GetExpenseByDateResponseModel {
  bool? success;
  String? message;
  String? startDate;
  String? endDate;
  List<Expense>? expenses;

  GetExpenseByDateResponseModel({
    this.success,
    this.message,
    this.startDate,
    this.endDate,
    this.expenses,
  });

  factory GetExpenseByDateResponseModel.fromJson(Map<String, dynamic> json) {
    return GetExpenseByDateResponseModel(
      success: json['success'],
      message: json['message'],
      startDate: json['start_date'],
      endDate: json['end_date'],
      expenses:
          (json['expenses'] as List?)
              ?.map((item) => Expense.fromJson(item as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}
