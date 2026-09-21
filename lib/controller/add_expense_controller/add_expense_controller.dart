import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:expense/apis/expense_related_api/create_expense_api.dart';
import 'package:expense/controller/add_expense_controller/add_expense_state.dart';
import 'package:expense/core/themes/colors.dart';

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/legacy.dart';

class CreateExpenseController extends StateNotifier<CreateExpenseState> {
  CreateExpenseController() : super(CreateExpenseState());

  final TextEditingController amountController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  // add expense api
  Future<bool> createExpenseApi({
    required BuildContext? context,
    required int clinicId,
    required,
  }) async {
    try {
      state = state.copyWith(isLoading: true);
      final formData = await createClinicFormData(
        expenseAmount: state.amount,
        expenseType: state.expenseCategory,
        expenseDate: state.expenseDate,
        billPhoto: state.billImage.isEmpty ? null : state.billImage,
        description: state.description,
      );

      final response = await CreateExpenseApi.createExpenseApi(
        body: formData,
        context: context,
        clinicId: clinicId,
      );
      log('Create expense response: $response');

      if (response != null && response['success'] == true && context != null) {
        if (!context.mounted) return true;

        // ignore: use_build_context_synchronously
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              'Expense Added successfully',
              style: TextStyle(
                color: AppColors.appWhite,
                fontWeight: FontWeight.w500,
              ),
            ),
            backgroundColor: AppColors.appGreen,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            duration: const Duration(seconds: 2),
          ),
        );
        return true;
      } else if (context != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              'Expense Added failed',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
            backgroundColor: AppColors.appRed,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            duration: const Duration(seconds: 2),
          ),
        );
        return false;
      }
      // handle response
    } catch (e) {
      log(e.toString());
      return false;
    } finally {
      state = state.copyWith(isLoading: false);
    }
    return false;
  }

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

  //form data creation
  Future<FormData> createClinicFormData({
    required num expenseAmount,
    required String expenseType,
    String? billPhoto,
    String? description,
    String? expenseDate,
  }) async {
    MultipartFile? billPhotoConverted;

    // 1. User selected new image from gallery/camera
    if (billPhoto != null) {
      billPhotoConverted = await MultipartFile.fromFile(
        billPhoto,
        filename: "billPhoto",
      );
    }

    final formData = FormData.fromMap({
      'expense_amount': expenseAmount,
      'expense_type': expenseType,
      'expense_date': expenseDate,
      'description': description,

      if (billPhoto != null) 'bill_photo': billPhotoConverted,
    });

    return formData;
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
