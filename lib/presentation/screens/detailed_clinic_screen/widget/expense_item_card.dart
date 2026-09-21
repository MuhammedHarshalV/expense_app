import 'package:expense/models/expense_related/all_expense_response_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ExpenseItemCard extends ConsumerWidget {
  final Expense expense;

  final String category;
  final IconData categoryIcon;

  final String amount;
  final String time;
  final String description;
  final String footerText;
  final IconData footerIcon;
  final Color footerIconColor;

  const ExpenseItemCard({
    super.key,

    required this.expense,
    required this.category,
    required this.categoryIcon,

    required this.amount,
    required this.time,
    required this.description,
    required this.footerText,
    required this.footerIcon,
    required this.footerIconColor,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;

    final surfaceColor = colorScheme.surface;
    final textPrimary = colorScheme.onSurface;
    final textMuted = colorScheme.onSurface.withValues(alpha: 0.6);
    final borderColor = colorScheme.outline.withValues(alpha: 0.25);
    final primaryBlue = colorScheme.primary;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
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
                              category,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w600,
                                color: textMuted,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 8),
                  ],
                ),

                const SizedBox(height: 6),

                // Amount + Date
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        amount,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w800,
                          color: primaryBlue,
                        ),
                      ),
                    ),

                    const SizedBox(width: 8),

                    Text(
                      time,
                      style: TextStyle(fontSize: 10.sp, color: textMuted),
                    ),
                  ],
                ),

                const SizedBox(height: 6),

                Text(
                  description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
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
                        style: TextStyle(fontSize: 10.sp, color: textMuted),
                      ),
                    ),

                    SizedBox(width: 8.w),

                    Icon(
                      Icons.file_download_outlined,
                      size: 16.sp,
                      color: textMuted,
                    ),

                    SizedBox(width: 12.w),

                    Icon(Icons.edit_outlined, size: 16.sp, color: textMuted),

                    SizedBox(width: 12.w),

                    Icon(Icons.delete_outline, size: 16.sp, color: textMuted),
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
