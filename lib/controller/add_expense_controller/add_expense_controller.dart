import 'dart:developer';

import 'package:expense/controller/add_expense_controller/add_expense_state.dart';

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/legacy.dart';

class CreateExpenseController extends StateNotifier<CreateExpenseState> {
  CreateExpenseController() : super(CreateExpenseState());

  final TextEditingController amountController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  void updateState({
    double? amount,
    String? expenseCategory,
    String? expenseDate,
    String? billImage,
    String? description,
    bool? isLoading,
  }) {
    state = state.copyWith(
      amount: amount,
      expenseCategory: expenseCategory,
      expenseDate: expenseDate,
      billImage: billImage,
      description: description,
      isLoading: isLoading,
    );
  }

  void addAmount(double amount) {
    final currentAmount = double.tryParse(amountController.text.trim()) ?? 0.0;

    final newAmount = currentAmount + amount;

    amountController.text = newAmount.toStringAsFixed(2);

    state = state.copyWith(amount: newAmount);
  }

  void reset() {
    amountController.clear();
    descriptionController.clear();

    state = CreateExpenseState();
  }

  @override
  void dispose() {
    amountController.dispose();
    descriptionController.dispose();
    log('===== create expense screen disposed =====');
    super.dispose();
  }
}

final createExpenseProvider =
    StateNotifierProvider.autoDispose<
      CreateExpenseController,
      CreateExpenseState
    >((ref) => CreateExpenseController());
