import 'dart:developer';

import 'package:expense/apis/expense_related_api/get_expense_by_date_api.dart';
import 'package:expense/controller/expense_by_date_controller/expense_by_date_state.dart';

import 'package:flutter_riverpod/legacy.dart';

class ExpenseByDateController extends StateNotifier<ExpenseByDateState> {
  final int clinicId;
  final String startDate;
  final String endDate;

  ExpenseByDateController({
    required this.clinicId,
    required this.startDate,
    required this.endDate,
  }) : super(const ExpenseByDateState()) {
    getExpensesByDate();
  }

  Future<void> getExpensesByDate() async {
    if (state.isLoading) return;

    state = state.copyWith(isLoading: true);

    try {
      final response = await GetExpenseByDateApi.getExpenseByDateApi(
        clinicId: clinicId,
        startDate: startDate,
        endDate: endDate,
      );

      if (!mounted) return;

      state = state.copyWith(expenseList: response?.expenses ?? []);

      log('Expense count: ${state.expenseList.length}');
    } catch (e, stackTrace) {
      log('Get expenses by date error: $e', stackTrace: stackTrace);
    } finally {
      if (mounted) {
        state = state.copyWith(isLoading: false);
      }
    }
  }

  Future<void> refresh() async {
    await getExpensesByDate();
  }

  @override
  void dispose() {
    log('===== expense by date screen disposed =====');
    super.dispose();
  }
}

final expenseByDateProvider = StateNotifierProvider.autoDispose
    .family<ExpenseByDateController, ExpenseByDateState, ExpenseByDateParams>((
      ref,
      params,
    ) {
      return ExpenseByDateController(
        clinicId: params.clinicId,
        startDate: params.startDate,
        endDate: params.endDate,
      );
    });

class ExpenseByDateParams {
  final int clinicId;
  final String startDate;
  final String endDate;

  const ExpenseByDateParams({
    required this.clinicId,
    required this.startDate,
    required this.endDate,
  });

  @override
  bool operator ==(Object other) {
    return other is ExpenseByDateParams &&
        other.clinicId == clinicId &&
        other.startDate == startDate &&
        other.endDate == endDate;
  }

  @override
  int get hashCode => Object.hash(clinicId, startDate, endDate);
}
