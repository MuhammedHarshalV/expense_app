
import 'package:expense/models/monthly_expense_model.dart';

class MonthlyExpenseState {
  final List<MonthlyExpenseModel> monthlyList;
  final bool isLoading;

  const MonthlyExpenseState({
    this.monthlyList = const [],
    this.isLoading = false,
  });

  MonthlyExpenseState copyWith({
    List<MonthlyExpenseModel>? monthlyList,
    bool? isLoading,
  }) {
    return MonthlyExpenseState(
      monthlyList: monthlyList ?? this.monthlyList,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
