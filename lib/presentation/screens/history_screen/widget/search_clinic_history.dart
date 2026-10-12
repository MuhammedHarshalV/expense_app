import 'package:expense/controller/history_screen_controller/history_screen_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchClinicHistory extends ConsumerWidget {
  SearchClinicHistory({super.key});

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

    return Container(
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      child: TextField(
        controller: historyController.searchController,
        onChanged: (value) {
          historyController.onSearchChanged(value);
        },
        onTapOutside: (_) {
          FocusManager.instance.primaryFocus?.unfocus();
        },

        style: TextStyle(
          fontFamily: "Notche",
          color: textPrimary,
          fontSize: 13,
        ),
        decoration: InputDecoration(
          hintText: 'Search clinic/hospital/lab names...',
          hintStyle: TextStyle(color: textMuted, fontSize: 13),
          prefixIcon: Icon(Icons.search, size: 18, color: textMuted),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }
}
