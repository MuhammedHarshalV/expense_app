
import 'package:expense/core/themes/colors.dart';
import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

class MonthlySummaryCard extends StatelessWidget {
  final String month;
  final String status;
  final num totalSavings;
  final int score;
  final VoidCallback? onTap;

  const MonthlySummaryCard({
    super.key,
    required this.month,
    required this.status,
    required this.totalSavings,
    required this.score,
    this.onTap,
  });

  //  Status color
  Color get _statusColor {
    switch (status.toLowerCase()) {
      case 'reconciled':
        return const Color(0xFF0D7377);
      case 'pending':
        return const Color(0xFFBA7517);
      case 'overdue':
        return const Color(0xFFA32D2D);
      default:
        return Colors.grey;
    }
  }

  //  Score bar color
  Color get _scoreColor {
    if (score >= 80) return const Color(0xFF0D7377);
    if (score >= 50) return const Color(0xFFBA7517);
    return const Color(0xFFA32D2D);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: .5),
            width: 0.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.2),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header row ──
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Calendar icon box
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEEF2FF),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.calendar_month_outlined,
                    color: Color(0xFF3B5BDB),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),

                // Month + Status
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        month,
                        style: TextStyle(
                          fontSize: 17.sp,
                          fontWeight: FontWeight.w700,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Status: $status',
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: _statusColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),

                // Arrow icon
                if (onTap != null)
                  Icon(
                    Icons.chevron_right,
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: .5),
                    size: 22.sp,
                  ),
              ],
            ),

            const SizedBox(height: 16),
            Divider(
              height: 1,
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: .1),
            ),
            const SizedBox(height: 14),

            // ── Total Savings ──
            Text(
              'Total Savings',
              style: TextStyle(
                fontSize: 12.sp,
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: .7),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '₹${totalSavings.toStringAsFixed(2).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}',
              style: TextStyle(
                fontSize: 22.sp,
                fontWeight: FontWeight.w700,
                color: totalSavings < 0 ? AppColors.appRed : AppColors.appGreen,
              ),
            ),

            const SizedBox(height: 14),

            // ── Score ──
            Text(
              'Score',
              style: TextStyle(
                fontSize: 12.sp,
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: .7),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                // Progress bar
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: LinearProgressIndicator(
                      value: score / 100,
                      minHeight: 8.h,
                      backgroundColor: Theme.of(
                        context,
                      ).colorScheme.onSurface.withValues(alpha: .2),
                      valueColor: AlwaysStoppedAnimation<Color>(_scoreColor),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                // Score text
                Text(
                  '$score/100',
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: _scoreColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
