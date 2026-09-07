import 'package:expense/controller/home_screen/home_screen_controller.dart';
import 'package:expense/core/themes/colors.dart';
import 'package:expense/presentation/screens/home_screen/widget/clinic_details_card.dart';
import 'package:expense/presentation/screens/home_screen/widget/expense_income_card.dart';

import 'package:expense/presentation/screens/home_screen/widget/profile_icon.dart';
import 'package:expense/presentation/screens/home_screen/widget/weeks_trend_card.dart';
import 'package:expense/presentation/screens/monthly_all_transaction/screen/monthly_all_transaction_screen.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeState = ref.watch(homeProvider);
    final homeController = ref.read(homeProvider.notifier);

    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      body: CustomScrollView(
        slivers: [
          // HIDING TOP APP BAR
          SliverAppBar(
            floating: true, // Makes it appear as soon as you scroll up
            pinned: false, // Ensures it scrolls out of view completely
            snap: true, // Snaps into full view when scrolling up
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
          // BODY CONTENT
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10.h),

                  Text(
                    'Today, ${DateFormat('d MMM yyyy').format(DateTime.now())}',

                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontSize: 26.sp,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  SizedBox(height: 10.h),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Recent Transactions',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            sliver: SliverList.separated(
              itemCount: 10,
              separatorBuilder: (context, index) {
                return const SizedBox(height: 10);
              },
              itemBuilder: (context, index) {
                return ClinicExpenseCard(
                  name: 'Al Salama Clinic',
                  place: 'Malappuram',
                  imageUrl: 'http://172.16.16.10:1024/api/clinic/6/photo',
                  totalAmount: '₹840',
                  totalPending: '₹320',
                  advanceAmount: '₹600',
                  onEdit: () {},
                  onDelete: () {},
                  onAddExpense: () {},
                  onViewDetails: () {},
                );
              },
            ),
          ),

          SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }
}
