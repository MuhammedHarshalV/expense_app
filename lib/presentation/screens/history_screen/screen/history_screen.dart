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

    final List<String> filters = ['Latest', 'Oldest', 'Largest', 'Smallest'];

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
          child: NotificationListener<ScrollNotification>(
            onNotification: (notification) {
              // Only check while scrolling

              if (notification.metrics.extentAfter < 200) {
                final state = ref.read(expenseHistoryProvider);

                // More pages available
                // AND pagination API isn't already running
                if (state.pageNumber < state.totalPages &&
                    !state.isPaginationLoading) {
                  historyController.getExpenseHistory(isPagination: true);
                }
              }

              return false;
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
                          fontFamily: "Notche",
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
                        const SizedBox(height: 16),
                        SizedBox(
                          height: 40,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            itemCount: filters.length,
                            itemBuilder: (context, index) {
                              final isSelected =
                                  historyState.filterIndex == index;

                              final isDark =
                                  Theme.of(context).brightness ==
                                  Brightness.dark;

                              return GestureDetector(
                                onTap: () {
                                  historyController.changeFilter(index);
                                },
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  margin: EdgeInsets.only(right: 10.w),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 22.w,
                                    vertical: 9.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? AppColors.appBlue
                                        : isDark
                                        ? Colors.grey.shade800
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(25.r),
                                    border: Border.all(
                                      color: isSelected
                                          ? AppColors.appBlue
                                          : isDark
                                          ? Colors.grey.shade700
                                          : Colors.grey.shade200,
                                    ),
                                    boxShadow: isDark
                                        ? null
                                        : [
                                            BoxShadow(
                                              color: Colors.black.withValues(
                                                alpha: 0.06,
                                              ),
                                              blurRadius: 6,
                                              offset: const Offset(0, 2),
                                            ),
                                          ],
                                  ),
                                  child: Center(
                                    child: Text(
                                      filters[index],
                                      style: TextStyle(
                                        fontFamily: "Notche",
                                        fontSize: 13.sp,
                                        fontWeight: FontWeight.w600,
                                        color: isSelected
                                            ? Colors.white
                                            : isDark
                                            ? Colors.white70
                                            : Colors.black87,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
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
                            fontFamily: "Notche",
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
                SliverToBoxAdapter(child: SizedBox(height: 70)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(Color textPrimary, Color textMuted, String count) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          'Matching Results',
          style: TextStyle(
            fontFamily: "Notche",
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
            color: textPrimary,
          ),
        ),
        Text(
          '$count Total Clinic\'s',
          style: TextStyle(
            fontFamily: "Notche",
            fontSize: 11.sp,
            fontWeight: FontWeight.w600,
            color: textMuted,
          ),
        ),
      ],
    );
  }
}
