import 'dart:developer';

import 'package:expense/controller/history_screen_controller/history_screen_state.dart';
import 'package:expense/models/monthly_expense_model.dart';


import 'package:flutter_riverpod/legacy.dart';
import 'package:hive/hive.dart';

class MonthlyExpenseController extends StateNotifier<MonthlyExpenseState> {
  MonthlyExpenseController() : super(const MonthlyExpenseState()) {
    fetchMonthlyDetails();
  }

  static const String boxName = "monthly_expense_box";

  /// Save one month
  Future<void> saveMonth(MonthlyExpenseModel model) async {
    final box = await Hive.openBox(boxName);

    // Check if this month already exists
    final alreadyExists = box.values.any((e) {
      final data = Map<String, dynamic>.from(e);
      return data['date'] == model.date;
    });

    if (alreadyExists) {
      log("${model.date} already exists. Skipping save.");
      return;
    }

    await box.add(model.toMap());
    log('''
MonthlyExpenseModel
-----------------------
Date    : ${model.date}
Income  : ${model.income}
Expense : ${model.expense}
''');

    await fetchMonthlyDetails();
  }

  /// Read all months
  Future<void> fetchMonthlyDetails() async {
    state = state.copyWith(isLoading: true);

    try {
      final box = await Hive.openBox(boxName);

      final List<MonthlyExpenseModel> list = box.values
          .map((e) => MonthlyExpenseModel.fromMap(Map<String, dynamic>.from(e)))
          .toList();

      state = state.copyWith(monthlyList: list);
    } catch (e) {
      log(e.toString());
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  //difference calculating function
  String compareMonthlyAmount({
    required num previousMonth,
    required num currentMonth,
  }) {
    if (previousMonth == 0 && currentMonth == 0) {
      return "No Change";
    }

    if (previousMonth == 0) {
      return "New";
    }

    final difference = currentMonth - previousMonth;
    final percentage = ((difference.abs() / previousMonth) * 100);

    if (difference > 0) {
      return "${percentage.toStringAsFixed(1)}% Increase";
    } else if (difference < 0) {
      return "${percentage.toStringAsFixed(1)}% Decrease";
    } else {
      return "Stable with last month";
    }
  }

  @override
  void dispose() {
    log('====== monthly controller disposed ======');
    super.dispose();
  }
}

final monthlyExpenseProvider =
    StateNotifierProvider.autoDispose<
      MonthlyExpenseController,
      MonthlyExpenseState
    >((ref) => MonthlyExpenseController());
