import 'dart:developer';

import 'package:expense/controller/bottom_nav_controller/bottom_nav_controller.dart';
import 'package:expense/presentation/common_widgets/glass_container.dart';
import 'package:expense/presentation/screens/bottom_nav_screen/widget/bottom_nav_items.dart';
import 'package:expense/presentation/screens/create_screen/screen/create_screen.dart';
import 'package:expense/presentation/screens/history_screen/screen/history_screen.dart';
import 'package:expense/presentation/screens/home_screen/screen/home_screen.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BottomNavScreen extends ConsumerWidget {
  const BottomNavScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    log('rebuild nav screen');

    final index = ref.watch(bottomNavProvider.select((e) => e.currentIndex));

    final pages = const [HomeScreen(), SizedBox(), HistoryScreen()];

    return SafeArea(
      top: false,
      child: Scaffold(
        extendBody: true,
        extendBodyBehindAppBar: true,
        body: IndexedStack(index: index, children: pages),
        bottomNavigationBar: GlassContainer(
          blur: 10,
          margin: EdgeInsets.only(bottom: 10.h, left: 30.h, right: 30.h),
          child: Row(
            children: [
              BottomNavItems(icon: Icons.home, title: "Home", index: 0),

              BottomNavItems(
                icon: Icons.add_circle_outline,
                title: "Create",
                index: 1,
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AddClinicScreen()),
                  );

                  // When returning from Create
                  ref.read(bottomNavProvider.notifier).changeIndex(0);
                },
              ),
              BottomNavItems(
                icon: Icons.leaderboard_outlined,
                title: "History",
                index: 2,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
