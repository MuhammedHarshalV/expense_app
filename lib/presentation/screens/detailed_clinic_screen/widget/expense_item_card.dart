import 'package:expense/controller/clinic_expense_details_controller/expense_details_controller.dart';
import 'package:expense/controller/edit_expense_controller/edit_expense_controller.dart';
import 'package:expense/controller/expense_by_date_controller/expense_by_date_controller.dart';
import 'package:expense/controller/history_screen_controller/history_screen_controller.dart';
import 'package:expense/controller/home_screen/home_screen_controller.dart';
import 'package:expense/core/themes/colors.dart';
import 'package:expense/models/expense_related/all_expense_response_model.dart';
import 'package:expense/presentation/screens/edit_expense_screen/screen/edit_expense_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class ExpenseItemCard extends ConsumerWidget {
  final Expense expense;
  final int cliinicId;
  final IconData categoryIcon;

  final String footerText;
  final IconData footerIcon;
  final Color footerIconColor;

  const ExpenseItemCard({
    super.key,

    required this.expense,

    required this.categoryIcon,

    required this.footerText,
    required this.footerIcon,
    required this.footerIconColor,
    required this.cliinicId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final expenseController = ref.read(editExpenseProvider.notifier);
    final colorScheme = Theme.of(context).colorScheme;

    final textPrimary = colorScheme.onSurface;
    final textMuted = colorScheme.onSurface.withValues(alpha: 0.6);

    final primaryBlue = colorScheme.primary;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorScheme.primary.withValues(alpha: 0.15)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Receipt image
          Container(
            width: 70.h,
            height: 90.h,
            decoration: BoxDecoration(
              color: colorScheme.onSurface.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(8),
              image:
                  expense.billPhoto != null &&
                      (expense.billPhoto ?? ''.trim()).isNotEmpty
                  ? DecorationImage(
                      image: NetworkImage(expense.billPhoto ?? ''),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: Center(
              child:
                  expense.billPhoto != null &&
                      (expense.billPhoto ?? ''.trim()).isNotEmpty
                  ? null
                  : Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.4),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.image_not_supported_outlined,
                        color: Colors.white,
                        size: 18.sp,
                      ),
                    ),
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Category + Status
                Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Icon(categoryIcon, size: 14.sp, color: primaryBlue),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              expense.expenseType ?? '',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontFamily: "Notche",
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w600,
                                color: textMuted,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (expense.approvedAmount != 0 &&
                        expense.approvedAmount != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 8, 208, 15),

                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'Complete',
                          style: TextStyle(
                            fontFamily: "Notche",
                            fontSize: 9.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColors.appWhite,
                          ),
                        ),
                      ),
                  ],
                ),

                const SizedBox(height: 6),

                // Amount + Date
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        '₹${expense.expenseAmount ?? 0}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: "Notche",
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w800,
                          color: primaryBlue,
                        ),
                      ),
                    ),

                    const SizedBox(width: 8),

                    Text(
                      expense.expenseDate != null
                          ? DateFormat(
                              'yyyy-MMM-dd',
                            ).format(DateTime.parse(expense.expenseDate!))
                          : '',
                      style: TextStyle(
                        fontFamily: "Notche",
                        fontSize: 10.sp,
                        color: textMuted,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 6),

                Text(
                  expense.description ?? '',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: "Notche",
                    fontSize: 12.sp,
                    color: textPrimary,
                    height: 1.3,
                  ),
                ),

                const SizedBox(height: 12),

                // Footer
                Row(
                  children: [
                    Icon(footerIcon, size: 12.sp, color: footerIconColor),

                    SizedBox(width: 4.w),

                    Expanded(
                      child: Text(
                        footerText,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: "Notche",
                          fontSize: 10.sp,
                          color: textMuted,
                        ),
                      ),
                    ),

                    SizedBox(width: 8.w),

                    // Icon(
                    //   Icons.file_download_outlined,
                    //   size: 20.sp,
                    //   color: textMuted,
                    // ),

                    // SizedBox(width: 12.w),
                    if (expense.approvedAmount == 0 ||
                        expense.approvedAmount == null)
                      InkWell(
                        highlightColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditExpenseScreen(
                                expense: expense,
                                clinicId: cliinicId,
                              ),
                            ),
                          );
                        },
                        child: Icon(
                          Icons.edit_outlined,
                          size: 20.sp,
                          color: textMuted,
                        ),
                      ),

                    if (expense.approvedAmount == 0 ||
                        expense.approvedAmount == null)
                      SizedBox(width: 12.w),

                    if (expense.approvedAmount == 0 ||
                        expense.approvedAmount == null)
                      InkWell(
                        highlightColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => Dialog(
                              backgroundColor: Theme.of(
                                context,
                              ).scaffoldBackgroundColor,
                              insetPadding: EdgeInsets.symmetric(
                                horizontal: 24.w,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24.r),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(10.h),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    // Delete icon
                                    Container(
                                      height: 50.h,
                                      width: 50.h,
                                      decoration: BoxDecoration(
                                        color: AppColors.appRed.withValues(
                                          alpha: .20,
                                        ),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        Icons.delete_outline_rounded,
                                        color: AppColors.appRed,
                                        size: 25.sp,
                                      ),
                                    ),

                                    SizedBox(height: 10.h),

                                    // Title
                                    Text(
                                      'Delete this Expense?',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontFamily: "Notche",
                                        fontSize: 23.sp,
                                        fontWeight: FontWeight.w700,
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.onSurface,
                                      ),
                                    ),

                                    SizedBox(height: 5.h),

                                    // Description
                                    Text.rich(
                                      TextSpan(
                                        children: [
                                          const TextSpan(
                                            text:
                                                'This will permanently delete this ',
                                          ),
                                          TextSpan(
                                            text:
                                                expense.expenseType ??
                                                'expense',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          const TextSpan(
                                            text:
                                                ' expense record. This action can\'t be undone.',
                                          ),
                                        ],
                                      ),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontFamily: "Notche",
                                        fontSize: 14.sp,
                                        height: 1.5,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface
                                            .withValues(alpha: .60),
                                      ),
                                    ),

                                    SizedBox(height: 10.h),

                                    Row(
                                      children: [
                                        // Cancel
                                        Expanded(
                                          child: SizedBox(
                                            height: 50,
                                            child: ElevatedButton(
                                              onPressed: () {
                                                Navigator.pop(context, false);
                                              },
                                              style: ElevatedButton.styleFrom(
                                                elevation: 0,
                                                backgroundColor:
                                                    Theme.of(context)
                                                        .colorScheme
                                                        .onSurface
                                                        .withValues(alpha: .06),
                                                foregroundColor: Theme.of(
                                                  context,
                                                ).colorScheme.onSurface,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                        12.r,
                                                      ),
                                                ),
                                              ),
                                              child: Text(
                                                'Cancel',
                                                style: TextStyle(
                                                  fontFamily: "Notche",
                                                  fontSize: 15.sp,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),

                                        SizedBox(width: 12.w),

                                        // Delete
                                        Expanded(
                                          child: SizedBox(
                                            height: 50,
                                            child: ElevatedButton(
                                              onPressed: () async {
                                                final result =
                                                    await expenseController
                                                        .deleteExpense(
                                                          clinicId: cliinicId,
                                                          context: context,
                                                          expId:
                                                              expense
                                                                  .expenseId ??
                                                              0,
                                                        );
                                                if (result == true) {
                                                  ref
                                                      .read(
                                                        clinicDetailsProvider(
                                                          cliinicId,
                                                        ).notifier,
                                                      )
                                                      .getClinicDetails();
                                                  final params = ExpenseByDateParams(
                                                    clinicId: cliinicId,
                                                    startDate: ref
                                                        .watch(
                                                          expenseHistoryProvider,
                                                        )
                                                        .startDate,
                                                    endDate: ref
                                                        .watch(
                                                          expenseHistoryProvider,
                                                        )
                                                        .endDate,
                                                  );
                                                  ref
                                                      .read(
                                                        expenseByDateProvider(
                                                          params,
                                                        ).notifier,
                                                      )
                                                      .refresh();

                                                  ref
                                                      .read(
                                                        homeProvider.notifier,
                                                      )
                                                      .getAllclinics(
                                                        page: 1,
                                                        context: context,
                                                      );
                                                }
                                              },
                                              style: ElevatedButton.styleFrom(
                                                elevation: 0,
                                                backgroundColor:
                                                    AppColors.appRed,
                                                foregroundColor: Colors.white,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                        12.r,
                                                      ),
                                                ),
                                              ),
                                              child: Text(
                                                'Delete',
                                                style: TextStyle(
                                                  fontFamily: "Notche",
                                                  fontSize: 15.sp,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                        child: Icon(
                          Icons.delete_outline,
                          size: 20.sp,
                          color: textMuted,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
