import 'package:expense/controller/edit_expense_controller/edit_expense_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EditDescriptionCard extends ConsumerWidget {
  const EditDescriptionCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref
        .read(editExpenseProvider.notifier)
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
                .read(editExpenseProvider.notifier)
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
            hintText: ref.watch(editExpenseProvider).description.isEmpty
                ? 'Add a note or tag...'
                : ref.watch(editExpenseProvider).description,
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
