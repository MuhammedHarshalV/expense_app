import 'package:expense/controller/clinic_expense_details_controller/expense_details_controller.dart';
import 'package:expense/core/themes/colors.dart';
import 'package:expense/presentation/common_widgets/glass_container.dart';
import 'package:expense/presentation/screens/detailed_clinic_screen/widget/expense_item_card.dart';
import 'package:expense/presentation/screens/detailed_clinic_screen/widget/top_clinic_card.dart';
import 'package:expense/presentation/screens/home_screen/widget/profile_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ClinicDetailsScreen extends ConsumerWidget {
  final int clinicId;
  const ClinicDetailsScreen({super.key, required this.clinicId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(clinicDetailsProvider(clinicId));

    final controller = ref.read(clinicDetailsProvider(clinicId).notifier);
    // Dynamic Theme Detection
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Theme Color Palette

    final surfaceColor = isDark ? const Color(0xFF1E293B) : Colors.white;
    final primaryBlue = isDark
        ? const Color(0xFF60A5FA)
        : const Color(0xFF0044CC);
    final textPrimary = isDark
        ? const Color(0xFFF8FAFC)
        : const Color(0xFF0F172A);
    final textMuted = isDark
        ? const Color(0xFF94A3B8)
        : const Color(0xFF64748B);
    final borderColor = isDark
        ? const Color(0xFF334155)
        : const Color(0xFFE2E8F0);
    if (state.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return Scaffold(
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
        child: RefreshIndicator(
          color: AppColors.appBlue,

          onRefresh: () async {
            await controller.getClinicDetails();
          },
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // TOP CLINIC CARD
                      TopClinicCard(clinicId: clinicId),

                      const SizedBox(height: 24),

                      // ITEMIZED EXPENSES HEADER
                      _buildItemizedHeader(
                        isDark,
                        primaryBlue,
                        textPrimary,
                        surfaceColor,
                        borderColor,
                        selectedSort: state.filter,
                        onSortChanged: (value) {
                          controller.filterExpenses(value);
                        },
                        context: context,
                      ),

                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),

              // EXPENSE LIST
              if (state.expenses.isEmpty)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: Text(
                      'No expenses found',
                      style: TextStyle(fontSize: 14.sp, color: textMuted),
                    ),
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final expense = state.expenses[index];

                      return ExpenseItemCard(
                        expense: state.expenses[index],

                        category: expense.expenseType ?? '',
                        categoryIcon: _getExpenseIcon(expense.expenseType),

                        amount: '₹${expense.expenseAmount ?? 0}',
                        time: expense.expenseDate ?? '',
                        description: expense.description ?? '',
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
                    }, childCount: state.expenses.length),
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

  Widget _buildItemizedHeader(
    bool isDark,
    Color primaryBlue,
    Color textPrimary,
    Color surfaceColor,
    Color borderColor, {
    required String selectedSort,
    required ValueChanged<String> onSortChanged,
    required BuildContext context,
  }) {
    final List<String> sortOptions = [
      'Latest',
      'Oldest',
      'Highest Amount',
      'Lowest Amount',
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            'Expenses',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w800,
              color: textPrimary,
              height: 1.2,
            ),
          ),
        ),

        SizedBox(width: 12.w),

        Flexible(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: surfaceColor,
              border: Border.all(color: borderColor),
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: selectedSort,
                isDense: true,

                borderRadius: BorderRadius.circular(15.r),

                dropdownColor: Theme.of(context).colorScheme.surface,

                icon: Icon(
                  Icons.keyboard_arrow_down,
                  size: 18.sp,
                  color: textPrimary,
                ),

                items: sortOptions.map((value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.tune,
                          size: 14.sp,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        SizedBox(width: 6.w),
                        Text(
                          value,
                          style: TextStyle(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),

                onChanged: (value) {
                  if (value != null) {
                    onSortChanged(value);
                  }
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
