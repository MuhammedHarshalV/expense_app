import 'package:expense/presentation/common_widgets/image_container.dart';
import 'package:expense/presentation/screens/create_clinic_screen/widget/description_card.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ExpenseAddCard extends ConsumerWidget {
  const ExpenseAddCard({super.key});
  // PriorityType priority = PriorityType.medium;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionLabel('Clinic Photo', context),
          const SizedBox(height: 8),
          ImageContainer(
            state: null,
            controller: null,
            imagePurpose: 'Clinic photo',
          ),

          const SizedBox(height: 20),
          _buildSectionLabel('Description (Optional)', context),
          const SizedBox(height: 8),
          DescriptionCard(),
        ],
      ),
    );
  }

  Widget _buildSectionLabel(String text, BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: Theme.of(context).colorScheme.onSurface,
        fontSize: 13.sp,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
