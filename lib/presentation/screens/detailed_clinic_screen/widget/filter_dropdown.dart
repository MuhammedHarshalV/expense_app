import 'package:flutter/material.dart';

class ExpenseSortDropdown extends StatelessWidget {
  final String selectedValue;
  final ValueChanged<String> onChanged;

  const ExpenseSortDropdown({
    super.key,
    required this.selectedValue,
    required this.onChanged,
  });

  static const List<String> sortOptions = [
    'Latest',
    'Oldest',
    'Highest Amount',
    'Lowest Amount',
  ];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.3),
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedValue,
          isDense: true,
          icon: Icon(
            Icons.keyboard_arrow_down,
            color: colorScheme.onSurface,
          ),
          items: sortOptions.map((value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(
                value,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) {
              onChanged(value);
            }
          },
        ),
      ),
    );
  }
}