import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:expense/apis/expense_related_api/delete_expense_api.dart';
import 'package:expense/apis/expense_related_api/edit__expense_api.dart';
import 'package:expense/controller/edit_expense_controller/edit_expense_state.dart';
import 'package:expense/core/services/image_helper/network_image_to_bytes.dart';
import 'package:expense/core/themes/colors.dart';
import 'package:expense/models/expense_related/all_expense_response_model.dart';

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/legacy.dart';
import 'package:image_picker/image_picker.dart';

class EditExpenseController extends StateNotifier<EditExpenseState> {
  EditExpenseController() : super(EditExpenseState());

  final TextEditingController amountController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  /// Load existing expense details
  void initializeExpense(Expense expense) {
    final amount = expense.expenseAmount?.toDouble() ?? 0.0;
    final description = expense.description ?? '';

    amountController.text = amount == 0 ? '' : amount.toStringAsFixed(2);

    descriptionController.text = description;

    state = state.copyWith(
      amount: amount,
      expenseCategory: expense.expenseType ?? 'Food & Lunch',
      expenseDate: expense.expenseDate ?? state.expenseDate,
      networkImageUrl: expense.billPhoto ?? '',
      description: description,
      clearSelectedImage: true,
    );
  }

  //delete expense api

  Future<bool> deleteExpense({
    required int clinicId,
    required BuildContext context,
    required int expId,
  }) async {
    try {
      final response = await DeleteExpenseApi.deleteExpenseApi(
        clinicId: clinicId,
        context: context,
        expId: expId,
      );
      if (response == true) {
        // ignore: use_build_context_synchronously
        Navigator.pop(context);
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              'Expense delete successfully',
              style: TextStyle(
                color: Colors.white,
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
      } else {
        Navigator.pop(context);
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              'Expense delete failed',
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
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  //edit expense api
  Future<bool> updateClinicApi({
    required BuildContext? context,
    required int clinicId,
    required int expId,
  }) async {
    try {
      state = state.copyWith(isLoading: true);
      final formData = await createExpenseFormData(
        date: state.expenseDate,
        amount: state.amount,
        description: descriptionController.text,
        category: state.expenseCategory,
        selectedImage: state.selectedImage,
        networkImageUrl: state.networkImageUrl,
      );

      final response = await UpdateExpenseApi.updateExpenseApi(
        body: formData,
        context: context,
        id: clinicId,
        expId: expId,
      );

      if (response != null && response['success'] == true && context != null) {
        if (!context.mounted) return true;

        // ignore: use_build_context_synchronously
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              'Expense updation successfully',
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
              'Expense updation failed',
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

  //form data creation
  Future<FormData> createExpenseFormData({
    required num amount,
    required String category,
    required String date,
    XFile? selectedImage,
    String? networkImageUrl,
    String? description,
  }) async {
    MultipartFile? billPhoto;

    // 1. User selected new image from gallery/camera
    if (selectedImage != null) {
      billPhoto = await MultipartFile.fromFile(
        selectedImage.path,
        filename: selectedImage.name,
      );
    }
    // 2. Existing searched clinic image
    else if (networkImageUrl != null && networkImageUrl.trim().isNotEmpty) {
      billPhoto = await networkImageToMultipart(networkImageUrl);
    }

    final formData = FormData.fromMap({
      'expense_amount': amount,
      'description': description,
      "expense_type": category,
      "expense_date": date,
      // ignore: use_null_aware_elements
      if (billPhoto != null) 'bill_photo': billPhoto,
    });

    return formData;
  }

  /// Common state update
  void updateState({
    double? amount,
    String? expenseCategory,
    String? expenseDate,

    String? description,
    bool? isLoading,
  }) {
    state = state.copyWith(
      amount: amount,
      expenseCategory: expenseCategory,
      expenseDate: expenseDate,

      description: description,
      isLoading: isLoading,
    );
  }

  /// Amount from TextField
  void updateAmount(String value) {
    final amount = double.tryParse(value) ?? 0.0;

    state = state.copyWith(amount: amount);
  }

  /// Increase amount
  void addAmount([double value = 100]) {
    final newAmount = state.amount + value;

    amountController.text = newAmount.toStringAsFixed(2);

    state = state.copyWith(amount: newAmount);
  }

  /// Decrease amount
  void minusAmount([double value = 100]) {
    final newAmount = (state.amount - value).clamp(0, double.infinity);

    amountController.text = newAmount.toStringAsFixed(2);

    state = state.copyWith(amount: newAmount.toDouble());
  }

  /// Change expense category
  void changeCategory(String category) {
    state = state.copyWith(expenseCategory: category);
  }

  /// Change expense date
  void changeDate(String date) {
    state = state.copyWith(expenseDate: date);
  }

  //select own image
  void ownImage(XFile image) {
    state = state.copyWith(clearNetworkImageUrl: true, selectedImage: image);
  }

  //delete photo
  void deletePhoto() {
    state = state.copyWith(
      clearNetworkImageUrl: true,
      clearSelectedImage: true,
    );
  }

  /// Change description
  void changeDescription(String value) {
    state = state.copyWith(description: value);
  }

  /// Loading
  void setLoading(bool value) {
    state = state.copyWith(isLoading: value);
  }

  /// Reset
  void reset() {
    amountController.clear();
    descriptionController.clear();

    state = EditExpenseState();
  }

  @override
  void dispose() {
    log('===== edit expense screen disposed =====');
    amountController.dispose();
    descriptionController.dispose();
    super.dispose();
  }
}

final editExpenseProvider =
    StateNotifierProvider.autoDispose<EditExpenseController, EditExpenseState>((
      ref,
    ) {
      return EditExpenseController();
    });
