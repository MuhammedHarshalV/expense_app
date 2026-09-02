
import 'package:expense/controller/history_screen_controller/history_screen_controller.dart';
import 'package:expense/controller/home_screen/home_screen_controller.dart';
import 'package:expense/core/themes/colors.dart';
import 'package:expense/presentation/common_widgets/glass_container.dart';
import 'package:expense/presentation/screens/home_screen/widget/expense_income_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MonthlyAllTransactionScreen extends ConsumerWidget {
  const MonthlyAllTransactionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeState = ref.watch(homeProvider);
    final monthlyController = ref.read(monthlyExpenseProvider.notifier);
    final monthlyState = ref.watch(monthlyExpenseProvider);

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
                InkWell(
                  focusColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  hoverColor: Colors.transparent,
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
            actions: [
              GlassContainer(
                border: Border.all(color: AppColors.appWhite),
                borderRadius: BorderRadius.circular(360),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    spacing: 10,
                    children: [
                      GestureDetector(
                        onTap: () {},
                        child: Icon(
                          Icons.person_2_outlined,
                          color: AppColors.appWhite,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 15),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border(
                    left: BorderSide(color: AppColors.appGreen, width: 5),
                    right: BorderSide(color: AppColors.appGreen, width: .2),
                    top: BorderSide(color: AppColors.appGreen, width: .2),
                    bottom: BorderSide(color: AppColors.appGreen, width: .2),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        spacing: 10,
                        children: [
                          Icon(
                            Icons.payments_outlined,
                            color: AppColors.appGreen,
                            size: 30,
                          ),
                          Text(
                            'TOTAL INCOME',
                            style: TextStyle(
                              color: AppColors.appGreen,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              height: 1,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        '₹ ${homeState.monthlyIncome}',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        monthlyController.compareMonthlyAmount(
                          currentMonth: homeState.monthlyIncome,
                          previousMonth: monthlyState.monthlyList.isNotEmpty
                              ? monthlyState.monthlyList.last.income == 0
                                    ? 0
                                    : monthlyState.monthlyList.last.income
                              : 0,
                        ),
                        style: TextStyle(
                          color: AppColors.appGreen,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          height: 1,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border(
                    left: BorderSide(color: AppColors.appRed, width: 5),
                    right: BorderSide(color: AppColors.appRed, width: .2),
                    top: BorderSide(color: AppColors.appRed, width: .2),
                    bottom: BorderSide(color: AppColors.appRed, width: .2),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        spacing: 10,
                        children: [
                          Icon(
                            Icons.shopping_cart_outlined,
                            color: AppColors.appRed,
                            size: 30,
                          ),
                          Text(
                            'TOTAL EXPENSES',
                            style: TextStyle(
                              color: AppColors.appRed,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              height: 1,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        '₹ ${homeState.monthlyExpense}',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        monthlyController.compareMonthlyAmount(
                          currentMonth: homeState.monthlyExpense,
                          previousMonth: monthlyState.monthlyList.isNotEmpty
                              ? monthlyState.monthlyList.last.expense == 0
                                    ? 0
                                    : monthlyState.monthlyList.last.expense
                              : 0,
                        ),
                        style: TextStyle(
                          color: AppColors.appRed,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          height: 1,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            sliver: SliverList.separated(
              itemBuilder: (context, index) => ExpenseIncomeCards(index: index),
              // ignore: unnecessary_underscores
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemCount: homeState.expenseList.length,
            ),
          ),
        ],
      ),
    );
  }
}
