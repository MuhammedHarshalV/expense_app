import 'package:expense/controller/clinic_expense_details_controller/expense_details_controller.dart';
import 'package:expense/controller/edit_expense_controller/edit_expense_controller.dart';
import 'package:expense/core/themes/colors.dart';
import 'package:expense/models/expense_related/all_expense_response_model.dart';
import 'package:expense/presentation/common_widgets/expense_date_section.dart';
import 'package:expense/presentation/common_widgets/glass_container.dart';
import 'package:expense/presentation/common_widgets/title_field.dart';

import 'package:expense/presentation/screens/add_expense_screen/widget/expense_category_card.dart';
import 'package:expense/presentation/screens/edit_expense_screen/widget/edit_amount_card.dart';
import 'package:expense/presentation/screens/edit_expense_screen/widget/edit_bill_photo_card.dart';
import 'package:expense/presentation/screens/edit_expense_screen/widget/edit_description_card.dart';
import 'package:expense/presentation/screens/home_screen/widget/profile_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

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

      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 4,
        shadowColor: Colors.black45,
        backgroundColor: const Color(0xFF1A2980),

        title: Row(
          children: [
            InkWell(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: () {
                Navigator.pop(context);
              },
              child: GlassContainer(
                padding: const EdgeInsets.all(8),
                borderRadius: BorderRadius.circular(360),
                border: Border.all(color: AppColors.appWhite),
                child: Icon(
                  Icons.arrow_back_ios_new_sharp,
                  color: AppColors.appWhite,
                  size: 24,
                ),
              ),
            ),

            const SizedBox(width: 12),

            const Text(
              'FinanceTrack',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 22,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),

        actions: const [ProfileIcon()],

        // Gradient background
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF1A2980), Color(0xFF26D0CE)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          //
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FieldLabel(label: 'EXPENSE AMOUNT', isRequired: true),
                    SizedBox(height: 6),
                    EditAmountCard(),
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
                    FieldLabel(label: 'DATE OF EXPENSE', isRequired: true),
                    SizedBox(height: 6),
                    ExpenseDateSection(
                      date: expenseState.expenseDate,
                      onTap: () async {
                        final pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2020),
                          lastDate: DateTime.now(),
                        );

                        if (pickedDate != null) {
                          expenseController.updateState(
                            expenseDate: DateFormat(
                              'dd-MMM-yyyy',
                            ).format(pickedDate),
                          );
                        }
                      },
                    ),
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

                    FieldLabel(label: 'DESCRIPTION', isRequired: false),
                    const SizedBox(height: 6),
                    EditDescriptionCard(),
                    const SizedBox(height: 24),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () async {
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
