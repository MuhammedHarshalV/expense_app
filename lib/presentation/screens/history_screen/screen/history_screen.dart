
import 'package:expense/controller/home_screen/home_screen_controller.dart';
import 'package:expense/presentation/screens/history_screen/widget/monthly_card.dart';
import 'package:expense/presentation/screens/home_screen/widget/profile_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeState = ref.watch(homeProvider);
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,

      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            automaticallyImplyLeading: false,
            pinned: true,
            floating: false,
            snap: false,
            // Snaps into full view when scrolling up
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
                SizedBox(width: 12),
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
          homeState.monthExpense.isEmpty
              ? SliverFillRemaining(
                  //  SliverFillRemaining fills all available space
                  // and centers the child
                  hasScrollBody: false,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Icon
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: const Color(0xFFEEF2FF),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Icon(
                            Icons.history_outlined,
                            size: 40,
                            color: Color(0xFF1A2980),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Title
                        Text(
                          'No history yet',
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurface.withValues(alpha: .7),
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Subtitle
                        Text(
                          'Your monthly summaries\nwill appear here',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurface.withValues(alpha: .3),
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : SliverPadding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 10,
                  ),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final data = homeState.monthExpense[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: MonthlySummaryCard(
                          month: data.date,
                          status: 'Reconciled',
                          totalSavings: data.income - data.expense,
                          score: calculateFinancialScore(
                            expense: data.expense,
                            income: data.income,
                          ),
                          onTap: () {},
                        ),
                      );
                    }, childCount: homeState.monthExpense.length),
                  ),
                ),
          const SliverToBoxAdapter(child: SizedBox(height: 80)),
        ],
      ),
    );
  }

  int calculateFinancialScore({required num income, required num expense}) {
    if (income <= 0) return 0;

    final savings = income - expense;
    final savingsRate = (savings / income) * 100;

    if (savingsRate >= 50) {
      return 100;
    } else if (savingsRate >= 40) {
      return 90;
    } else if (savingsRate >= 30) {
      return 80;
    } else if (savingsRate >= 20) {
      return 70;
    } else if (savingsRate >= 10) {
      return 55;
    } else if (savingsRate > 0) {
      return 40;
    } else if (savingsRate == 0) {
      return 25;
    } else {
      return 0;
    }
  }
}
