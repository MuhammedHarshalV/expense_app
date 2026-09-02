import 'dart:developer';



import 'package:expense/controller/home_screen/home_screen_state.dart';
import 'package:expense/core/services/dio_services/api_services.dart';
import 'package:expense/core/services/net_work_services/connection_checking.dart';
import 'package:expense/models/daily_expense_income_model.dart';
import 'package:expense/models/monthly_expense_model.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:hive/hive.dart';

class HomeController extends StateNotifier<HomeState> {
  HomeController() : super(const HomeState());

  Future<void> fetchExpenses() async {
    state = state.copyWith(isLoading: true);
    String boxName = "expense_box";
    final box = await Hive.openBox(boxName);

    final List<ExpenseHiveModel> expenses = box.values
        .map((e) => ExpenseHiveModel.fromMap(Map<String, dynamic>.from(e)))
        .toList();
    num monthlyIncome = 0;
    num monthlyExpense = 0;
    for (final expense in expenses) {
      if (expense.transactionType.toLowerCase() == 'expense') {
        monthlyExpense += expense.amount;
      } else {
        monthlyIncome += expense.amount;
      }
    }

    state = state.copyWith(
      expenseList: expenses.reversed.toList(),
      isLoading: false,
      monthlyExpense: monthlyExpense,
      monthlyIncome: monthlyIncome,
      currentBalance: monthlyIncome - monthlyExpense,
    );

    bool connection = await InternetChecker.hasConnection();
    if (connection == false) {
      return;
    }
    fetchSensex();
    monthlyGraphSetting();
  }

  //sensex and more fetching
  Future<void> fetchSensex() async {
    try {
      state = state.copyWith(isSensex: true);
      final sensex = await GetApiServices.callApi(
        url: 'https://query1.finance.yahoo.com/v8/finance/chart/%5EBSESN',
      );
      state = state.copyWith(
        sensex:
            (sensex["chart"]["result"][0]["meta"]["regularMarketPrice"] ?? 0),
      );
      final nifty50 = await GetApiServices.callApi(
        url: 'https://query1.finance.yahoo.com/v8/finance/chart/%5ENSEI',
      );
      state = state.copyWith(
        nifty:
            (nifty50["chart"]["result"][0]["meta"]["regularMarketPrice"] ?? 0),
      );
      final silver = await GetApiServices.callApi(
        url: 'https://query1.finance.yahoo.com/v8/finance/chart/SI=F',
      );
      final silverUsd =
          silver['chart']["result"][0]["meta"]["regularMarketPrice"] ?? 0;
      const num troyOuncePerKg = 32.1507466;

      final num usdToInr = 95.28; // preferably fetch this dynamically

      final num silverInrPerKg = (silverUsd * troyOuncePerKg) * usdToInr;
      final silverPrice = num.parse(silverInrPerKg.toStringAsFixed(2));
      state = state.copyWith(silver: silverPrice);

      final gold = await GetApiServices.callApi(
        url: 'https://query1.finance.yahoo.com/v8/finance/chart/GC=F',
      );
      num goldUSA =
          gold['chart']['result'][0]['meta']['regularMarketPrice'] ?? 0;
      num oneGram = num.parse((goldUSA / 31.1035).toStringAsFixed(2));
      // num oneGramINR = num.parse((oneGram * 95.19).toStringAsFixed(2));

      state = state.copyWith(gold: oneGram);
    } catch (e) {
      log(e.toString());
    } finally {
      state = state.copyWith(isSensex: false);
    }
  }

  //monthly graph amount setting
  Future<void> monthlyGraphSetting() async {
    const String boxName = "monthly_expense_box";

    final box = await Hive.openBox(boxName);

    // Read all saved expenses
    final List<dynamic> allExpenses = box.values.toList();

    // Take only the latest 7 months
    final List<dynamic> lastSeven = allExpenses.length > 7
        ? allExpenses.sublist(allExpenses.length - 7)
        : allExpenses;

    // Create 7 values, filling missing months with 0
    final List<num> expenseValues = List<num>.filled(7, 0);

    for (int i = 0; i < lastSeven.length; i++) {
      final data = lastSeven[i];

      expenseValues[7 - lastSeven.length + i] = (data['expense'] ?? 0) as num;
    }

    // Find highest expense
    final num highestExpense = expenseValues.isEmpty
        ? 0
        : expenseValues.reduce((a, b) => a > b ? a : b);

    // Convert to percentage
    final List<num> percentageValues = expenseValues.map((expense) {
      if (highestExpense == 0) {
        return 5;
      }

      if (expense == 0) {
        return 5; // minimum visible indicator
      }

      return (expense / highestExpense) * 100;
    }).toList();

    // Read all saved expenses

    final List<MonthlyExpenseModel> monthExpense = box.values
        .map((item) => MonthlyExpenseModel.fromMap(item))
        .toList();
    state = state.copyWith(monthExpense: monthExpense);
    state = state.copyWith(monthGraph: percentageValues);
  }

  //trend percentage setting
  String getSpendingTrend(List<MonthlyExpenseModel> monthExpense) {
    if (monthExpense.length < 2) {
      return 'Not enough data to identify spending trend';
    }

    final previous = monthExpense[monthExpense.length - 2];
    final current = monthExpense[monthExpense.length - 1];

    final previousExpense = previous.expense;
    final currentExpense = current.expense;

    // Previous month was 0
    if (previousExpense == 0) {
      if (currentExpense == 0) {
        return 'No spending in ${current.date}';
      }

      return 'You spent more in ${current.date} compared to ${previous.date}';
    }

    final percentage =
        ((currentExpense - previousExpense).abs() / previousExpense) * 100;

    final percent = percentage.toStringAsFixed(0);

    if (currentExpense > previousExpense) {
      return 'You spent $percent% more in ${current.date} compared to ${previous.date}';
    }

    if (currentExpense < previousExpense) {
      return 'You spent $percent% less in ${current.date} compared to ${previous.date}';
    }

    return 'Your spending was the same in ${current.date} & ${previous.date}';
  }

  //delete expense
  Future<void> deleteExpense(int index) async {
    String boxName = "expense_box";

    final box = await Hive.openBox(boxName);
    final hiveIndex = box.length - 1 - index;
    await box.deleteAt(hiveIndex);
    await fetchExpenses();
  }
}

final homeProvider = StateNotifierProvider<HomeController, HomeState>(
  (ref) => HomeController()..fetchExpenses(),
);
