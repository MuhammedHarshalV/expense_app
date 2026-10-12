import 'package:expense/controller/history_screen_controller/history_screen_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DatePickerContainer extends ConsumerWidget {
  const DatePickerContainer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Theme Colors

    final surfaceColor = isDark ? const Color(0xFF1E293B) : Colors.white;

    final textPrimary = isDark
        ? const Color(0xFFF8FAFC)
        : const Color(0xFF0F172A);
    final textMuted = isDark
        ? const Color(0xFF94A3B8)
        : const Color(0xFF64748B);
    final borderColor = isDark
        ? const Color(0xFF334155)
        : const Color(0xFFE2E8F0);
    final historyController = ref.read(expenseHistoryProvider.notifier);
    final historyState = ref.read(expenseHistoryProvider);

    return InkWell(
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      hoverColor: Colors.transparent,
      focusColor: Colors.transparent,
      onTap: () async {
        await historyController.pickStartDate(context);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: surfaceColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: const Color(0xFFEFF6FF),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(
                Icons.calendar_today_outlined,
                size: 16.sp,
                color: Color(0xFF003399),
              ),
            ),
            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'PERIOD',
                    style: TextStyle(
                      fontFamily: "Notche",
                      fontSize: 9.sp,
                      fontWeight: FontWeight.w700,
                      color: textMuted,
                      letterSpacing: 0.5,
                    ),
                  ),
                  Text(
                    '${historyState.startDate} - ${historyState.endDate}',
                    style: TextStyle(
                      fontFamily: "Notche",
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: textPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
