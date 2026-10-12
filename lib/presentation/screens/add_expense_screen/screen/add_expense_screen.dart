import 'package:expense/controller/add_expense_controller/add_expense_controller.dart';
import 'package:expense/controller/home_screen/home_screen_controller.dart';
import 'package:expense/core/themes/colors.dart';
import 'package:expense/presentation/common_widgets/common_appbar.dart';
import 'package:expense/presentation/common_widgets/expense_date_section.dart';

import 'package:expense/presentation/common_widgets/title_field.dart';
import 'package:expense/presentation/screens/add_expense_screen/widget/amount_card.dart';
import 'package:expense/presentation/screens/add_expense_screen/widget/bill_photo_container.dart';
import 'package:expense/presentation/screens/add_expense_screen/widget/description_card.dart';
import 'package:expense/presentation/screens/add_expense_screen/widget/expense_category_card.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class AddExpenseScreen extends ConsumerWidget {
  final int clinicId;
  const AddExpenseScreen({super.key, required this.clinicId});

  // Theme Colors matching the image
  static const Color primaryBlue = Color(0xFF0052CC);

  //

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expenseState = ref.watch(createExpenseProvider);
    final expenseController = ref.read(createExpenseProvider.notifier);
    final homeController = ref.read(homeProvider.notifier);

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
                    AmountCard(),
                    const SizedBox(height: 24),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        FieldLabel(label: 'BILL ATTACHMENT', isRequired: false),
                        if (expenseState.billImage.isNotEmpty)
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
                    BillPhotoContainer(),
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
                                expenseController.updateState(
                                  billImage: image.path,
                                );
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
                                expenseController.updateState(
                                  billImage: image.path,
                                );
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    FieldLabel(label: 'DESCRIPTION', isRequired: false),
                    const SizedBox(height: 6),
                    DescriptionCard(),
                    const SizedBox(height: 24),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          final result = await expenseController
                              .createExpenseApi(
                                context: context,
                                clinicId: clinicId,
                              );
                          if (result == true) {
                            homeController.getAllclinics(page: 1);
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
                                'Save & Submit Expense',
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
