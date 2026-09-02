import 'dart:developer';


import 'package:expense/controller/create_expense_controller/create_expense_state.dart';
import 'package:expense/models/daily_expense_income_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

class CreateExpenseController extends StateNotifier<CreateExpenseState> {
  CreateExpenseController() : super(const CreateExpenseState());
  //save to hive
  Future<void> saveExpenseOrIncome() async {
    try {
      state = state.copyWith(isSubmit: true);
      String boxName = "expense_box";
      final box = await Hive.openBox(boxName);
      final expense = ExpenseHiveModel(
        transactionType: state.transactionType.isEmpty
            ? 'Expense'
            : state.transactionType,
        category: state.category.isEmpty
            ? (state.transactionType.isEmpty ||
                      state.transactionType == 'Expense')
                  ? 'Food'
                  : 'Salary'
            : state.category,
        priority: state.priority.isEmpty ? 'Low' : state.priority,
        description: state.description,
        amount: state.amount,
        createdAt:
            //'04-02-2026',
            DateFormat('dd-MM-yyyy').format(DateTime.now()),
      );
      await box.add(expense.toMap());
      log('''
ExpenseHiveModel
--------------------------
Transaction : ${expense.transactionType}
Category    : ${expense.category}
Priority    : ${expense.priority}
Description : ${expense.description}
Amount      : ${expense.amount}
Created At  : ${expense.createdAt}
''');
    } catch (e) {
      log(e.toString());
    } finally {
      state = state.copyWith(isSubmit: false);
    }
  }

  //update from hive
  Future<void> updateExpenseOrIncome({
    required int index,
    String? transactionType,
    String? category,
    String? priority,
    String? description,
    num? amount,
  }) async {
    final box = await Hive.openBox("expense_box");

    final oldData = Map<String, dynamic>.from(box.getAt(index));

    oldData['transactionType'] = transactionType ?? oldData['transactionType'];

    oldData['category'] =
        category ??
        (state.category.isEmpty
            ? (state.transactionType.isEmpty ||
                      state.transactionType == 'Expense')
                  ? 'Food'
                  : 'Salary'
            : state.category);

    oldData['priority'] = priority ?? oldData['priority'];

    oldData['description'] = description ?? oldData['description'];

    oldData['amount'] = amount ?? oldData['amount'];
    final hiveIndex = box.length - 1 - index;
    await box.putAt(hiveIndex, oldData);
    log('''
===== Update DATA =====
Transaction : ${oldData['transactionType']}
Category    : ${oldData['category']}
Priority    : ${oldData['priority']}
Description : ${oldData['description']}
Amount      : ${oldData['amount']}
Created At  : ${oldData['createdAt']}
''');
  }

  void updateState({
    String? transactionType,
    String? category,
    String? desc,
    bool? isSubmit,
    String? priority,
    num? amount,
  }) {
    // Update TextEditingControllers
    if (desc != null) {
      descriptionController.text = desc;
    }

    if (amount != null) {
      amountController.text = amount.toString();
    }
    state = state.copyWith(
      transactionType: transactionType,
      category: category,
      description: desc,
      isSubmit: isSubmit,
      priority: priority,
      amount: amount,
    );
  }

  final descriptionController = TextEditingController();
  final amountController = TextEditingController();

  void reset() {
    descriptionController.clear();
    amountController.clear();
    state = const CreateExpenseState();
  }

  @override
  void dispose() {
    log('====== create screen disposed ======');
    super.dispose();
  }
}

final createExpensePrrovider =
    StateNotifierProvider<CreateExpenseController, CreateExpenseState>(
      (ref) => CreateExpenseController(),
    );
