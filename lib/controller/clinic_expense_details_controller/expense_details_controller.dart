import 'dart:developer';

import 'package:expense/apis/expense_related_api/get_all_expense_api.dart';
import 'package:expense/controller/clinic_expense_details_controller/expense_details_state.dart';

import 'package:expense/models/expense_related/all_expense_response_model.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:intl/intl.dart';

class ClinicDetailsController extends StateNotifier<ClinicDetailsState> {
  final int clinicId;

  ClinicDetailsController({required this.clinicId})
    : super(const ClinicDetailsState()) {
    getClinicDetails();
  }

  Future<void> getClinicDetails() async {
    state = state.copyWith(isLoading: true);

    try {
      final AllClinicExpenseResponseModel response =
          await GetAllExpenseApi.getAllExpenseApi(clinicId: clinicId);

      if (response.success == true && response.data != null) {
        final data = response.data;
        state = state.copyWith(
          clinicId: data?.clinicId ?? 0,
          clinicName: data?.clinicName ?? '',
          clinicTotalExp: data?.clinicTotalExp ?? 0,
          clinicPlace: data?.clinicPlace ?? '',
          clinicPhoto: data?.clinicPhoto ?? '',
          expenses: data?.expenses ?? [],
        );
      }
    } catch (e) {
      log('Get clinic details error: $e');
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  //filter expense
  void filterExpenses(String filter) {
    final List<Expense> filteredList = [...state.expenses];

    switch (filter) {
      case 'Latest':
        filteredList.sort((a, b) {
          final dateA = _parseExpenseDate(a.expenseDate);
          final dateB = _parseExpenseDate(b.expenseDate);

          return dateB.compareTo(dateA);
        });
        break;

      case 'Oldest':
        filteredList.sort((a, b) {
          final dateA = _parseExpenseDate(a.expenseDate);
          final dateB = _parseExpenseDate(b.expenseDate);

          return dateA.compareTo(dateB);
        });
        break;

      case 'Highest Amount':
        filteredList.sort((a, b) {
          final amountA = a.expenseAmount ?? 0;
          final amountB = b.expenseAmount ?? 0;

          return amountB.compareTo(amountA);
        });
        break;

      case 'Lowest Amount':
        filteredList.sort((a, b) {
          final amountA = a.expenseAmount ?? 0;
          final amountB = b.expenseAmount ?? 0;

          return amountA.compareTo(amountB);
        });
        break;
    }

    state = state.copyWith(expenses: filteredList, filter: filter);
  }

  DateTime _parseExpenseDate(String? date) {
    if (date == null || date.trim().isEmpty) {
      return DateTime(1970);
    }

    try {
      return DateFormat('dd-MMM-yyyy').parse(date);
    } catch (_) {
      return DateTime(1970);
    }
  }

  void updateState({
    bool? isLoading,
    int? clinicId,
    String? clinicName,
    double? clinicTotalExp,
    String? clinicPlace,
    String? clinicPhoto,
    List<Expense>? expenses,
  }) {
    state = state.copyWith(
      isLoading: isLoading,
      clinicId: clinicId,
      clinicName: clinicName,
      clinicTotalExp: clinicTotalExp,
      clinicPlace: clinicPlace,
      clinicPhoto: clinicPhoto,
      expenses: expenses,
    );
  }

  @override
  void dispose() {
    log('===== clinic details Screen disposed =====');
    super.dispose();
  }
}

final clinicDetailsProvider = StateNotifierProvider.autoDispose
    .family<ClinicDetailsController, ClinicDetailsState, int>((ref, clinicId) {
      return ClinicDetailsController(clinicId: clinicId);
    });
