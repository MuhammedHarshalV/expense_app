

import 'package:expense/models/daily_expense_income_model.dart';
import 'package:expense/models/monthly_expense_model.dart';

class HomeState {
  final bool isLoading;
  final bool isSensex;
  final List<ExpenseHiveModel> expenseList;
  final List<MonthlyExpenseModel> monthExpense;
  final num monthlyIncome;
  final num monthlyExpense;
  final num currentBalance;
  final num sensex;
  final num nifty;
  final num gold;
  final num silver;
  final List<num> monthGraph;

  const HomeState({
    this.isLoading = false,
    this.isSensex = false,
    this.expenseList = const [],
    this.monthlyIncome = 0,
    this.monthlyExpense = 0,
    this.currentBalance = 0,
    this.sensex = 0,
    this.nifty = 0,
    this.gold = 0,
    this.silver = 0,
    this.monthGraph = const [],
    this.monthExpense = const [],
  });

  HomeState copyWith({
    bool? isLoading,
    List<ExpenseHiveModel>? expenseList,
    List<num>? monthGraph,
    num? monthlyIncome,
    num? monthlyExpense,
    num? currentBalance,
    num? sensex,
    num? nifty,
    num? gold,
    num? silver,
    bool? isSensex,
    List<MonthlyExpenseModel>? monthExpense,
  }) {
    return HomeState(
      isLoading: isLoading ?? this.isLoading,
      expenseList: expenseList ?? this.expenseList,
      monthlyIncome: monthlyIncome ?? this.monthlyIncome,
      monthlyExpense: monthlyExpense ?? this.monthlyExpense,
      currentBalance: currentBalance ?? this.currentBalance,
      sensex: sensex ?? this.sensex,
      nifty: nifty ?? this.nifty,
      gold: gold ?? this.gold,
      silver: silver ?? this.silver,
      isSensex: isSensex ?? this.isSensex,
      monthGraph: monthGraph ?? this.monthGraph,
      monthExpense: monthExpense ?? this.monthExpense,
    );
  }
}
