import 'package:expense/controller/add_expense_controller/add_expense_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DescriptionCard extends ConsumerWidget {
  const DescriptionCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref
        .read(createExpenseProvider.notifier)
        .descriptionController;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: .15),
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TapRegion(
        onTapOutside: (_) {
          FocusScope.of(context).unfocus();
        },
        child: TextField(
          controller: controller,
          onChanged: (value) {
            ref
                .read(createExpenseProvider.notifier)
                .updateState(description: value);
          },
          maxLines: 5,
          style: TextStyle(
            fontFamily: "Notche",
            color: Theme.of(context).colorScheme.onSurface,
            fontSize: 15.sp,
          ),
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: ref.watch(createExpenseProvider).description.isEmpty
                ? 'Add a note or tag...'
                : ref.watch(createExpenseProvider).description,
            hintStyle: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontSize: 15.sp,
            ),
          ),
        ),
      ),
    );
  }
}
