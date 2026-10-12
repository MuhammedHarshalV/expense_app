import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ExpenseDateSection extends ConsumerWidget {
  final String date;
  final VoidCallback? onTap;

  const ExpenseDateSection({super.key, required this.date, this.onTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      hoverColor: Colors.transparent,
      focusColor: Colors.transparent,
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: .05),
          border: Border.all(
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: .15),
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(
              Icons.calendar_today_outlined,
              size: 18.h,
              color: Theme.of(context).colorScheme.primary,
            ),
            SizedBox(width: 12),
            Text(
              date,
              style: TextStyle(
                fontFamily: "Notche",
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            Spacer(),
            Icon(
              Icons.edit_calendar_outlined,
              size: 18.h,
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: .5),
            ),
          ],
        ),
      ),
    );
  }
}
