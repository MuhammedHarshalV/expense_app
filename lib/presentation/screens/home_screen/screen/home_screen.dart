import 'package:expense/controller/home_screen/home_screen_controller.dart';
import 'package:expense/core/themes/colors.dart';
import 'package:expense/presentation/screens/add_expense_screen/screen/add_expense_screen.dart';
import 'package:expense/presentation/screens/detailed_clinic_screen/screen/clinic_details_screen.dart';
import 'package:expense/presentation/screens/edit_clinic_screen/screen/edit_clinic_screen.dart';

import 'package:expense/presentation/screens/home_screen/widget/clinic_details_card.dart';

import 'package:expense/presentation/screens/home_screen/widget/profile_icon.dart';
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
      body: homeState.isLoading
          ? Center(child: CircularProgressIndicator(color: AppColors.appBlue))
          : RefreshIndicator(
              color: AppColors.appBlue,

              onRefresh: () async {
                await homeController.getAllclinics(page: 1);
              },
              child: NotificationListener<ScrollNotification>(
                onNotification: (notification) {
                  // Only check while scrolling

                  if (notification.metrics.extentAfter < 200) {
                    final state = ref.read(homeProvider);

                    // More pages available
                    // AND pagination API isn't already running
                    if (state.page < state.totalPages &&
                        !state.isPaginationLoading) {
                      homeController.getAllclinics(page: state.page + 1);
                    }
                  }

                  return false;
                },
                child: CustomScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  slivers: [
                    // HIDING TOP APP BAR
                    SliverAppBar(
                      floating:
                          true, // Makes it appear as soon as you scroll up
                      pinned:
                          false, // Ensures it scrolls out of view completely
                      snap: true, // Snaps into full view when scrolling up
                      elevation: 4,
                      shadowColor: Colors.black45,
                      expandedHeight:
                          70.0, // Slightly taller for a premium feel
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
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSurface,
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
                    homeState.clinicList.isEmpty
                        ? SliverFillRemaining(
                            hasScrollBody: false,
                            child: Center(
                              child: Text(
                                'No clinics found.',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurface.withValues(alpha: .5),
                                ),
                              ),
                            ),
                          )
                        : SliverPadding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            sliver: SliverList.separated(
                              itemCount: homeState.clinicList.length,
                              separatorBuilder: (context, index) {
                                return const SizedBox(height: 10);
                              },
                              itemBuilder: (context, index) {
                                final clinic = homeState.clinicList[index];
                                return ClinicExpenseCard(
                                  name: clinic.clinicName ?? '',
                                  place: clinic.clinicPlace ?? '',
                                  imageUrl: clinic.clinicPhoto == null
                                      ? ''
                                      : '${clinic.clinicPhoto}?v=${homeState.imageVersion}',
                                  totalAmount: '₹${clinic.clinicTotalExp}',

                                  onEdit: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            EditClinicScreen(clinic: clinic),
                                      ),
                                    );
                                  },
                                  onDelete: () {
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
                                          borderRadius: BorderRadius.circular(
                                            24.r,
                                          ),
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
                                                  color: AppColors.appRed
                                                      .withValues(alpha: .20),
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
                                                'Delete this clinic?',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
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
                                                          'This will permanently remove ',
                                                    ),
                                                    TextSpan(
                                                      text:
                                                          clinic.clinicName ??
                                                          '',
                                                      style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.w700,
                                                      ),
                                                    ),
                                                    const TextSpan(
                                                      text:
                                                          ' and its expense records. '
                                                          'This can\'t be undone.',
                                                    ),
                                                  ],
                                                ),
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
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
                                                          Navigator.pop(
                                                            context,
                                                            false,
                                                          );
                                                        },
                                                        style: ElevatedButton.styleFrom(
                                                          elevation: 0,
                                                          backgroundColor:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .onSurface
                                                                  .withValues(
                                                                    alpha: .06,
                                                                  ),
                                                          foregroundColor:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .onSurface,
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
                                                            fontSize: 15.sp,
                                                            fontWeight:
                                                                FontWeight.w700,
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
                                                          await homeController
                                                              .deleteClinic(
                                                                clinicId:
                                                                    clinic
                                                                        .clinicId ??
                                                                    0,
                                                                context:
                                                                    context,
                                                              );
                                                        },
                                                        style: ElevatedButton.styleFrom(
                                                          elevation: 0,
                                                          backgroundColor:
                                                              AppColors.appRed,
                                                          foregroundColor:
                                                              Colors.white,
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
                                                            fontSize: 15.sp,
                                                            fontWeight:
                                                                FontWeight.w700,
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
                                  onAddExpense: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => AddExpenseScreen(
                                          clinicId: clinic.clinicId ?? 0,
                                        ),
                                      ),
                                    );
                                  },
                                  onViewDetails: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ClinicDetailsScreen(
                                              clinicId: clinic.clinicId ?? 0,
                                            ),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          ),

                    if (homeState.isPaginationLoading)
                      SliverToBoxAdapter(child: SizedBox(height: 20)),
                    if (homeState.isPaginationLoading)
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: SizedBox(
                            child: Center(
                              child: CircularProgressIndicator(
                                color: AppColors.appBlue,
                              ),
                            ),
                          ),
                        ),
                      ),
                    SliverToBoxAdapter(child: SizedBox(height: 100.h)),
                  ],
                ),
              ),
            ),
    );
  }
}
