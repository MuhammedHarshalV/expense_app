import 'package:expense/controller/expense_by_date_controller/expense_by_date_controller.dart';
import 'package:expense/core/themes/colors.dart';
import 'package:expense/presentation/common_widgets/common_appbar.dart';
import 'package:expense/presentation/screens/detailed_clinic_screen/widget/expense_item_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ExpenseByDateScreen extends ConsumerWidget {
  final int clinicId;
  final String startDate;
  final String endDate;
  const ExpenseByDateScreen({
    super.key,
    required this.clinicId,
    required this.startDate,
    required this.endDate,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final params = ExpenseByDateParams(
      clinicId: clinicId,
      startDate: startDate,
      endDate: endDate,
    );
    final expenseState = ref.watch(expenseByDateProvider(params));

    final expenseController = ref.read(expenseByDateProvider(params).notifier);
    // Dynamic Theme Detection
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Theme Color Palette

    final textMuted = isDark
        ? const Color(0xFF94A3B8)
        : const Color(0xFF64748B);

    if (expenseState.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return Scaffold(
      appBar: CommonAppBar(),
      body: SafeArea(
        child: RefreshIndicator(
          color: AppColors.appBlue,

          onRefresh: () async {
            await expenseController.refresh();
          },
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 10.h),
                  child: Center(
                    child: Text(
                      '$startDate - $endDate',
                      style: TextStyle(
                        fontFamily: "Notche",
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        color: textMuted,
                      ),
                    ),
                  ),
                ),
              ),

              // EXPENSE LIST
              if (expenseState.expenseList.isEmpty)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: Text(
                      'No expenses found',
                      style: TextStyle(
                        fontFamily: "Notche",
                        fontSize: 14.sp,
                        color: textMuted,
                      ),
                    ),
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final expense = expenseState.expenseList[index];

                      return ExpenseItemCard(
                        cliinicId: clinicId,
                        expense: expense,

                        categoryIcon: _getExpenseIcon(expense.expenseType),

                        footerText: expense.billPhoto != null
                            ? 'Bill Attached'
                            : 'No Bill',
                        footerIcon: expense.billPhoto != null
                            ? Icons.check_circle_outline
                            : Icons.receipt_long_outlined,
                        footerIconColor: expense.billPhoto != null
                            ? const Color(0xFF10B981)
                            : Colors.grey,
                      );
                    }, childCount: expenseState.expenseList.length),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getExpenseIcon(String? type) {
    switch (type) {
      case 'Fuel / Travel':
        return Icons.local_gas_station_outlined;

      case 'Food & Lunch':
        return Icons.restaurant_outlined;

      case 'Medical Demo':
        return Icons.medical_services_outlined;

      case 'Hotel / Stay':
        return Icons.hotel_outlined;

      case 'Stationery':
        return Icons.edit_note_outlined;

      case 'Other Expense':
        return Icons.receipt_long_outlined;

      default:
        return Icons.currency_rupee;
    }
  }
}
