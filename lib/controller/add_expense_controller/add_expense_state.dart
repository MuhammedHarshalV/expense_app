import 'package:intl/intl.dart';

class CreateExpenseState {
  final double amount;
  final String expenseCategory;
  final String expenseDate;
  final String billImage;
  final String description;
  final bool isLoading;

  CreateExpenseState({
    this.amount = 0.0,
    this.expenseCategory = 'Food & Lunch',
    String? expenseDate,
    this.billImage = '',
    this.description = '',
    this.isLoading = false,
  }) : expenseDate =
           expenseDate ?? DateFormat('dd-MMM-yyyy').format(DateTime.now());

  CreateExpenseState copyWith({
    double? amount,
    String? expenseCategory,
    String? expenseDate,
    String? billImage,
    String? description,
    bool? isLoading,
  }) {
    return CreateExpenseState(
      amount: amount ?? this.amount,
      expenseCategory: expenseCategory ?? this.expenseCategory,
      expenseDate: expenseDate ?? this.expenseDate,
      billImage: billImage ?? this.billImage,
      description: description ?? this.description,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
