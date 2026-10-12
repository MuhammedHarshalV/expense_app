import 'package:expense/controller/history_screen_controller/history_screen_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TotalExpenseSpendCard extends ConsumerWidget {
  const TotalExpenseSpendCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Theme Colors

    final surfaceColor = isDark ? const Color(0xFF1E293B) : Colors.white;
    final primaryBlue = isDark
        ? const Color(0xFF3B82F6)
        : const Color(0xFF003399);
    final textPrimary = isDark
        ? const Color(0xFFF8FAFC)
        : const Color(0xFF0F172A);
    final textMuted = isDark
        ? const Color(0xFF94A3B8)
        : const Color(0xFF64748B);
    final borderColor = isDark
        ? const Color(0xFF334155)
        : const Color(0xFFE2E8F0);

    final historyState = ref.watch(expenseHistoryProvider);
    final int approvedPercentage = historyState.totalSpend > 0
        ? ((historyState.approvedAmount / historyState.totalSpend) * 100)
              .round()
        : 0;

    final double progressValue = historyState.totalSpend > 0
        ? (historyState.approvedAmount / historyState.totalSpend)
              .toDouble()
              .clamp(0.0, 1.0)
        : 0.0;
    return Container(
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
        ],
      ),
      child: Column(
        children: [
          // Metrics Row
          SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total Spend',
                        style: TextStyle(
                          fontFamily: "Notche",
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w600,
                          color: textMuted,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '₹${historyState.totalSpend}',
                        style: TextStyle(
                          fontFamily: "Notche",
                          fontSize: 24.sp,
                          fontWeight: FontWeight.w800,
                          color: textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '₹${historyState.totalCount} Clinics',
                        style: TextStyle(
                          fontFamily: "Notche",
                          fontSize: 10.sp,
                          color: textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: primaryBlue.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Approved',
                              style: TextStyle(
                                fontFamily: "Notche",
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w600,
                                color: textMuted,
                              ),
                            ),
                            Icon(
                              Icons.check_circle_outline,
                              size: 14.sp,
                              color: primaryBlue,
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '₹${historyState.approvedAmount}',
                          style: TextStyle(
                            fontFamily: "Notche",
                            fontSize: 24.sp,
                            fontWeight: FontWeight.w800,
                            color: primaryBlue,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '$approvedPercentage % reimbursed',
                          style: TextStyle(
                            fontFamily: "Notche",
                            fontSize: 10.sp,
                            color: textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Pending Banner
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF7ED),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFFFEDD5)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.pending_actions,
                      size: 14.sp,
                      color: Color(0xFFC2410C),
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Under Review / Pending',
                      style: TextStyle(
                        fontFamily: "Notche",
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFC2410C),
                      ),
                    ),
                  ],
                ),
                Text(
                  '₹${historyState.totalSpend - historyState.approvedAmount}',
                  style: TextStyle(
                    fontFamily: "Notche",
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFFC2410C),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Progress Bar
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Settlement Clearance Rate',
                      style: TextStyle(
                        fontFamily: "Notche",
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w600,
                        color: textMuted,
                      ),
                    ),
                    Text(
                      '$approvedPercentage %',
                      style: TextStyle(
                        fontFamily: "Notche",
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w700,
                        color: primaryBlue,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: progressValue,
                    backgroundColor: isDark
                        ? const Color(0xFF334155)
                        : const Color(0xFFE2E8F0),
                    valueColor: AlwaysStoppedAnimation<Color>(primaryBlue),
                    minHeight: 6,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
