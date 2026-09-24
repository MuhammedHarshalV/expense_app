import 'package:expense/controller/history_screen_controller/history_screen_controller.dart';
import 'package:expense/core/themes/colors.dart';
import 'package:expense/presentation/screens/history_screen/widget/clinic_details_card.dart';
import 'package:expense/presentation/screens/history_screen/widget/date_picker_container.dart';
import 'package:expense/presentation/screens/history_screen/widget/search_clinic_history.dart';
import 'package:expense/presentation/screens/history_screen/widget/total_expense_spend_card.dart';
import 'package:expense/presentation/screens/home_screen/widget/profile_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Theme Colors

    final primaryBlue = isDark
        ? const Color(0xFF3B82F6)
        : const Color(0xFF003399);
    final textPrimary = isDark
        ? const Color(0xFFF8FAFC)
        : const Color(0xFF0F172A);
    final textMuted = isDark
        ? const Color(0xFF94A3B8)
        : const Color(0xFF64748B);

    final historyController = ref.read(expenseHistoryProvider.notifier);
    final historyState = ref.watch(expenseHistoryProvider);

    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      body: SafeArea(
        top: false,
        bottom: false,
        child: RefreshIndicator(
          color: AppColors.appBlue,

          onRefresh: () async {
            await historyController.refresh();
          },
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                floating: true,
                pinned: false,
                snap: true,
                elevation: 4,
                shadowColor: Colors.black45,
                expandedHeight: 70.0, // Slightly taller for a premium feel
                backgroundColor:
                    Colors.transparent, // Required to show the gradient
                flexibleSpace: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFF1A2980), // Deep stylish blue
                        Color(0xFF26D0CE), // Vibrant teal
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    ),
                  ),
                ),
                title: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.account_balance_wallet,
                        color: Colors.white,
                        size: 24,
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
                actions: [ProfileIcon()],
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SearchClinicHistory(),
                      const SizedBox(height: 16),

                      DatePickerContainer(),
                      const SizedBox(height: 16),

                      // _buildFilterChips(primaryBlue),
                      //   const SizedBox(height: 20),
                      TotalExpenseSpendCard(),
                      const SizedBox(height: 24),

                      _buildSectionHeader(
                        textPrimary,
                        textMuted,
                        historyState.totalCount.toString(),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),

              if (historyState.isLoading || historyState.isSearchLoading)
                const SliverToBoxAdapter(
                  child: SizedBox(
                    height: 100,
                    child: Center(child: CircularProgressIndicator()),
                  ),
                )
              else if (historyState.expenseHistory.isEmpty)
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 100,
                    child: Center(
                      child: Text(
                        'No data found in this time range',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: textMuted,
                        ),
                      ),
                    ),
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final item = historyState.expenseHistory[index];

                      return ClinicDetailsCard(clinic: item);
                    }, childCount: historyState.expenseHistory.length),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget _buildFilterChips(Color primaryBlue) {
  //   return SingleChildScrollView(
  //     scrollDirection: Axis.horizontal,
  //     child: Row(
  //       children: [
  //         _buildChip(
  //           'All Facilities',
  //           isActive: true,
  //           primaryBlue: primaryBlue,
  //         ),
  //         const SizedBox(width: 8),
  //         _buildChip(
  //           'Approved Only',
  //           isActive: false,
  //           primaryBlue: primaryBlue,
  //         ),
  //         const SizedBox(width: 8),
  //         _buildChip(
  //           'Pending Review',
  //           isActive: false,
  //           primaryBlue: primaryBlue,
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // Widget _buildChip(
  //   String label, {
  //   required bool isActive,
  //   required Color primaryBlue,
  // }) {
  //   return Container(
  //     padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  //     decoration: BoxDecoration(
  //       color: isActive ? primaryBlue : Colors.white,
  //       borderRadius: BorderRadius.circular(20),
  //       border: Border.all(
  //         color: isActive ? primaryBlue : const Color(0xFFE2E8F0),
  //       ),
  //     ),
  //     child: Text(
  //       label,
  //       style: TextStyle(
  //         fontSize: 12,
  //         fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
  //         color: isActive ? Colors.white : const Color(0xFF64748B),
  //       ),
  //     ),
  //   );
  // }

  Widget _buildSectionHeader(Color textPrimary, Color textMuted, String count) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          'Matching Results',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
            color: textPrimary,
          ),
        ),
        Text(
          '$count Total Clinic\'s',
          style: TextStyle(
            fontSize: 11.sp,
            fontWeight: FontWeight.w600,
            color: textMuted,
          ),
        ),
      ],
    );
  }
}
