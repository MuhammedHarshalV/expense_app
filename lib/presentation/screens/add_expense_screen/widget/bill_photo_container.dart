import 'dart:io';

import 'package:expense/controller/add_expense_controller/add_expense_controller.dart';

import 'package:expense/core/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BillPhotoContainer extends ConsumerWidget {
  const BillPhotoContainer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expenseState = ref.watch(createExpenseProvider);
    final expenseController = ref.read(createExpenseProvider.notifier);
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Stack(
        children: [
          if (expenseState.billImage.isNotEmpty)
            Image.file(
              File(expenseState.billImage),
              height: 180.h,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                height: 180.h,
                width: double.infinity,
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: .05),
                child: Icon(
                  Icons.image,
                  size: 48.h,
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: .5),
                ),
              ),
            )
          else
            Container(
              height: 180.h,
              width: double.infinity,
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: .15),
              child: Icon(
                Icons.image,
                size: 48.h,
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: .5),
              ),
            ),

          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.transparent,
                    Colors.black.withOpacity(0.5),
                  ],
                ),
              ),
            ),
          ),
          if (expenseState.billImage.isNotEmpty)
            Positioned(
              top: 10,
              right: 10,
              child: InkWell(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                hoverColor: Colors.transparent,
                focusColor: Colors.transparent,
                onTap: () {
                  expenseController.updateState(billImage: '');
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Icon(
                    Icons.delete,
                    color: AppColors.appRed,
                    size: 20.h,
                  ),
                ),
              ),
            ),

          if (expenseState.billImage.isNotEmpty)
            Positioned(
              bottom: 10,
              right: 12,
              child: InkWell(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                hoverColor: Colors.transparent,
                focusColor: Colors.transparent,
                onTap: () {
                  if (expenseState.billImage.isNotEmpty) {
                    showZoomableImage(
                      context: context,

                      selectedImage: expenseState.billImage,
                    );
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.camera_alt_outlined,
                        color: AppColors.appBlack,
                        size: 14,
                      ),
                      SizedBox(width: 4),
                      Text(
                        'view',
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w700,
                          color: AppColors.appBlack,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  void showZoomableImage({
    required BuildContext context,

    required String selectedImage,
  }) {
    showDialog(
      context: context,
      barrierColor: Theme.of(
        context,
      ).colorScheme.onSurface.withValues(alpha: 0.8),
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(20),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Theme.of(context).scaffoldBackgroundColor,
                width: 3,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(17),
              child: InteractiveViewer(
                minScale: 1,
                maxScale: 5,
                panEnabled: true,
                scaleEnabled: true,
                child: Image.file(File(selectedImage)),
              ),
            ),
          ),
        );
      },
    );
  }
}
