import 'dart:math';

import 'package:flutter/material.dart';

class SpendingTrendsCard extends StatelessWidget {
  /// Dynamic list of data points for the bar chart
  final List<num> data;

  /// The descriptive text shown below the chart
  final String summaryText;

  const SpendingTrendsCard({
    super.key,
    required this.data,
    required this.summaryText,
  });

  @override
  Widget build(BuildContext context) {
    // Find the maximum value in the data list to scale the bars proportionally
    final num maxValue = data.isEmpty ? 1.0 : data.reduce(max);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Theme.of(context).colorScheme.onSurface),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header Text
          Text(
            'Spending Trends',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 28),

          // Dynamic Bar Chart
          SizedBox(
            height: 120, // Fixed height for the chart area
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(data.length, (index) {
                final value = data[index];

                // Identify if this is the highest bar to apply the dark color
                final isHighest = value == maxValue && value > 0;

                // Calculate height percentage (0.0 to 1.0)
                final heightFactor = maxValue == 0 ? 0.0 : value / maxValue;

                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6.0),
                    child: FractionallySizedBox(
                      heightFactor: heightFactor,
                      alignment: Alignment.bottomCenter,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeOut,
                        decoration: BoxDecoration(
                          color: isHighest
                              ? Theme.of(context).colorScheme.onSurface
                              : const Color(
                                  0xFFCBD5E1,
                                ), // Light grey for others
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
          const SizedBox(height: 28),

          // Dynamic Summary Text
          Text(
            summaryText,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontSize: 14,
              fontWeight: FontWeight.w500,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
