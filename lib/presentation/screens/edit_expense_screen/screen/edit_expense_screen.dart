import 'package:expense/controller/clinic_expense_details_controller/expense_details_controller.dart';
import 'package:expense/controller/edit_expense_controller/edit_expense_controller.dart';
import 'package:expense/core/themes/colors.dart';
import 'package:expense/models/expense_related/all_expense_response_model.dart';
import 'package:expense/presentation/common_widgets/common_appbar.dart';
import 'package:expense/presentation/common_widgets/expense_date_section.dart';

import 'package:expense/presentation/common_widgets/title_field.dart';

import 'package:expense/presentation/screens/add_expense_screen/widget/expense_category_card.dart';
import 'package:expense/presentation/screens/edit_expense_screen/widget/edit_amount_card.dart';
import 'package:expense/presentation/screens/edit_expense_screen/widget/edit_bill_photo_card.dart';
import 'package:expense/presentation/screens/edit_expense_screen/widget/edit_description_card.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

class EditExpenseScreen extends ConsumerStatefulWidget {
  final int clinicId;
  final Expense expense;
  const EditExpenseScreen({
    super.key,
    required this.expense,
    required this.clinicId,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EditExpenseScreenState();
}

class _EditExpenseScreenState extends ConsumerState<EditExpenseScreen> {
  static Color primaryBlue = Color(0xFF0052CC);
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      ref.read(editExpenseProvider.notifier).initializeExpense(widget.expense);
    });
  }

  @override
  Widget build(BuildContext context) {
    final expenseState = ref.watch(editExpenseProvider);
    final expenseController = ref.read(editExpenseProvider.notifier);

    return Scaffold(
      extendBody: true,

      appBar: CommonAppBar(),
      body: SafeArea(
        child: Column(
          //
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 10,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FieldLabel(label: 'DATE OF EXPENSE', isRequired: true),
                    SizedBox(height: 6),
                    ExpenseDateSection(
                      date: expenseState.expenseDate.isNotEmpty
                          ? expenseState.expenseDate
                          : '',
                      onTap: () {
                        // final pickedDate = await showDatePicker(
                        //   context: context,
                        //   initialDate: DateTime.now(),
                        //   firstDate: DateTime(2020),
                        //   lastDate: DateTime.now(),
                        // );

                        // if (pickedDate != null) {
                        //   expenseController.updateState(
                        //     expenseDate: DateFormat(
                        //       'dd-MMM-yyyy',
                        //     ).format(pickedDate),
                        //   );
                        // }
                      },
                    ),
                    const SizedBox(height: 24),
                    FieldLabel(label: 'EXPENSE CATEGORY', isRequired: true),
                    SizedBox(height: 6),
                    ExpenseCategoryGrid(
                      selectedCategory: expenseState.expenseCategory,
                      onCategorySelected: (value) {
                        expenseController.updateState(expenseCategory: value);
                      },
                    ),
                    const SizedBox(height: 24),
                    FieldLabel(label: 'EXPENSE AMOUNT', isRequired: true),
                    SizedBox(height: 6),
                    EditAmountCard(),
                    const SizedBox(height: 24),
                    FieldLabel(label: 'DESCRIPTION', isRequired: false),
                    const SizedBox(height: 6),
                    EditDescriptionCard(),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        FieldLabel(label: 'BILL ATTACHMENT', isRequired: false),
                        if (expenseState.selectedImage != null ||
                            (expenseState.networkImageUrl ?? '')
                                .trim()
                                .isNotEmpty)
                          Row(
                            children: const [
                              Icon(
                                Icons.check_circle,
                                size: 14,
                                color: Color(0xFF10B981),
                              ),
                              SizedBox(width: 4),
                              Text(
                                'Photo Selected',
                                style: TextStyle(
                                  fontFamily: "Notche",
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF10B981),
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    EditBillPhotoCard(),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: _buildOutlineActionButton(
                            context: context,
                            icon: Icons.camera_alt_outlined,
                            label: 'Click Camera',
                            onTap: () async {
                              final ImagePicker picker = ImagePicker();
                              final image = await picker.pickImage(
                                source: ImageSource.camera,
                                preferredCameraDevice: CameraDevice.rear,
                                // imageQuality: 85,
                                // maxWidth: 1000,
                                // maxHeight: 1000,
                              );
                              if (image != null) {
                                expenseController.ownImage(image);
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _buildOutlineActionButton(
                            context: context,
                            icon: Icons.photo_library_outlined,
                            label: 'Choose Gallery',
                            onTap: () async {
                              final ImagePicker picker = ImagePicker();
                              final image = await picker.pickImage(
                                source: ImageSource.gallery,
                                // imageQuality: 85,
                                // maxWidth: 1000,
                                // maxHeight: 1000,
                              );
                              if (image != null) {
                                expenseController.ownImage(image);
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: expenseState.isLoading
                            ? null
                            : () async {
                                final result = await expenseController
                                    .updateClinicApi(
                                      context: context,
                                      expId: widget.expense.expenseId ?? 0,
                                      clinicId: widget.clinicId,
                                    );
                                if (result == true) {
                                  ref
                                      .read(
                                        clinicDetailsProvider(
                                          widget.clinicId,
                                        ).notifier,
                                      )
                                      .getClinicDetails();
                                }
                              },
                        icon: expenseState.isLoading
                            ? null
                            : Icon(
                                Icons.check_circle_outline,
                                color: AppColors.appWhite,
                                size: 20,
                              ),
                        label: expenseState.isLoading
                            ? SizedBox(
                                height: 20,
                                width: 20,
                                child: Center(
                                  child: CircularProgressIndicator(
                                    color: AppColors.appWhite,
                                  ),
                                ),
                              )
                            : Text(
                                'Save & Update Expense',
                                style: TextStyle(
                                  fontFamily: "Notche",
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.appWhite,
                                ),
                              ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryBlue,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _buildOutlineActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required BuildContext context,
  }) {
    return OutlinedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 16, color: primaryBlue),
      label: Text(
        label,
        style: TextStyle(
          fontFamily: "Notche",
          fontSize: 12.5.h,
          fontWeight: FontWeight.w600,
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
      style: OutlinedButton.styleFrom(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        padding: const EdgeInsets.symmetric(vertical: 12),
        side: BorderSide(
          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: .15),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
