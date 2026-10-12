import 'package:expense/controller/bottom_nav_controller/bottom_nav_controller.dart';
import 'package:expense/core/themes/colors.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BottomNavItems extends ConsumerWidget {
  final IconData icon;
  final String title;
  final int index;
  final VoidCallback? onTap;

  const BottomNavItems({
    super.key,
    required this.icon,
    required this.title,
    required this.index,
    this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(
      bottomNavProvider.select((state) => state.currentIndex == index),
    );

    return Expanded(
      flex: selected ? 2 : 1,
      child: GestureDetector(
        onTap: () {
          if (onTap != null) {
            onTap!();
          } else {
            ref.read(bottomNavProvider.notifier).changeIndex(index);
          }
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          width: selected ? 110 : 60,
          height: 35.h,
          margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 8.w),
          decoration: BoxDecoration(
            color: selected ? AppColors.appBottomNavColor : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Theme.of(context).colorScheme.onSurface),
              if (selected) ...[
                const SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontFamily: "Notche",
                    color: Theme.of(context).colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
