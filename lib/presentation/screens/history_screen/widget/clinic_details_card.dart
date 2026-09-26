
import 'package:expense/controller/history_screen_controller/history_screen_controller.dart';
import 'package:expense/models/expense_related/get_expense_history_response_model.dart';
import 'package:expense/presentation/screens/expense_history_by_date/screen/expense_by_date_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ClinicDetailsCard extends ConsumerWidget {
  final ExpenseHistory clinic;
  const ClinicDetailsCard({super.key, required this.clinic});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
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
    final primaryBlue = isDark
        ? const Color(0xFF60A5FA)
        : const Color(0xFF003399);

    final num totalSpend = clinic.totalSpend ?? 0;
    final num approvedAmount = clinic.approvedAmount ?? 0;
    final num pendingAmount = totalSpend - approvedAmount;

    final bool isSettled = totalSpend > 0 && pendingAmount <= 0;

    final expenseState = ref.watch(expenseHistoryProvider);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        children: [
          // Header: Icon, Name, Badge
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 40.h,
                width: 40.h,

                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF0F172A)
                      : const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: borderColor),
                  image: (clinic.clinicPhoto ?? '').trim().isNotEmpty
                      ? DecorationImage(
                          image: NetworkImage(clinic.clinicPhoto ?? ''),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: (clinic.clinicPhoto ?? '').trim().isNotEmpty
                    ? null
                    : Center(
                        child: Icon(
                          Icons.local_hospital_outlined,
                          size: 20.sp,
                          color: primaryBlue,
                        ),
                      ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      clinic.clinicName ?? '',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '• ${clinic.totalTransactionCount ?? 0} Claims',
                      style: TextStyle(fontSize: 11.sp, color: textMuted),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color:
                      ((clinic.approvedAmount ?? 0) == (clinic.totalSpend ?? 0))
                      ? const Color.fromARGB(255, 8, 208, 15)
                      : const Color(0xFF06B6D4).withValues(alpha: .15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  ((clinic.approvedAmount ?? 0) == (clinic.totalSpend ?? 0))
                      ? 'Complete'
                      : "Active",
                  style: TextStyle(
                    fontSize: 9.sp,
                    fontWeight: FontWeight.w700,
                    color:
                        ((clinic.approvedAmount ?? 0) ==
                            (clinic.totalSpend ?? 0))
                        ? const Color.fromARGB(255, 8, 208, 15)
                        : const Color(0xFF06B6D4),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Spend & Approved Metrics
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total Spend',
                    style: TextStyle(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w600,
                      color: textMuted,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '₹${clinic.totalSpend ?? 0}',
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w700,
                      color: textPrimary,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Approved',
                    style: TextStyle(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w600,
                      color: textMuted,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '₹${clinic.approvedAmount ?? 0}',
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w700,
                      color: primaryBlue,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Footer: Status Pill & View Receipts
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: isSettled
                      ? primaryBlue.withValues(alpha: 0.1)
                      : const Color(0xFFF59E0B).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    if (isSettled) ...[
                      Icon(Icons.check, size: 12.sp, color: primaryBlue),
                      const SizedBox(width: 4),
                    ] else ...[
                      Icon(
                        Icons.circle,
                        size: 6.sp,
                        color: isSettled
                            ? primaryBlue
                            : const Color(0xFFF59E0B),
                      ),
                      const SizedBox(width: 6),
                    ],
                    Text(
                      isSettled
                          ? '100% Settled'
                          : '₹$pendingAmount Under Review',
                      style: TextStyle(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w700,
                        color: isSettled
                            ? primaryBlue
                            : isSettled
                            ? primaryBlue
                            : const Color(0xFFF59E0B),
                      ),
                    ),
                  ],
                ),
              ),
              InkWell(
                splashColor: Colors.transparent,
                focusColor: Colors.transparent,
                highlightColor: Colors.transparent,
                hoverColor: Colors.transparent,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ExpenseByDateScreen(
                        clinicId: clinic.clinicId ?? 0,
                        startDate: expenseState.startDate,
                        endDate: expenseState.endDate,
                      ),
                    ),
                  );
                },
                child: Row(
                  children: [
                    Text(
                      'View ${clinic.totalTransactionCount ?? 0} Receipts',
                      style: TextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w600,
                        color: primaryBlue,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.arrow_circle_right_outlined,
                      size: 16.sp,
                      color: primaryBlue,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
