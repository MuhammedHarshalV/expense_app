import 'package:expense/models/expense_related/all_expense_response_model.dart';

class ExpenseByDateState {
  final bool isLoading;
  final List<Expense> expenseList;
  final String startDate;
  final String endDate;

  const ExpenseByDateState({
    this.isLoading = false,
    this.expenseList = const [],
    this.startDate = '',
    this.endDate = '',
  });

  ExpenseByDateState copyWith({
    bool? isLoading,
    List<Expense>? expenseList,
    String? startDate,
    String? endDate,
  }) {
    return ExpenseByDateState(
      isLoading: isLoading ?? this.isLoading,
      expenseList: expenseList ?? this.expenseList,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
    );
  }
}
