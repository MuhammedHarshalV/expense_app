import 'dart:io';

import 'package:expense/controller/edit_expense_controller/edit_expense_controller.dart';
import 'package:expense/core/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

class EditBillPhotoCard extends ConsumerWidget {
  const EditBillPhotoCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expenseState = ref.watch(editExpenseProvider);
    final expenseController = ref.read(editExpenseProvider.notifier);
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Stack(
        children: [
          if (expenseState.networkImageUrl != null &&
              expenseState.networkImageUrl!.isNotEmpty)
            Image.network(
              expenseState.networkImageUrl!,
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
          else if (expenseState.selectedImage != null)
            Image.file(
              File(expenseState.selectedImage!.path),
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
                    Colors.black.withValues(alpha: 0.5),
                  ],
                ),
              ),
            ),
          ),
          if (expenseState.selectedImage != null ||
              (expenseState.networkImageUrl ?? '').trim().isNotEmpty)
            Positioned(
              top: 10,
              right: 10,
              child: InkWell(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                hoverColor: Colors.transparent,
                focusColor: Colors.transparent,
                onTap: () {
                  expenseController.deletePhoto();
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.6),
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
          if (expenseState.selectedImage != null ||
              (expenseState.networkImageUrl ?? '').trim().isNotEmpty)
            Positioned(
              bottom: 10,
              right: 12,
              child: InkWell(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                hoverColor: Colors.transparent,
                focusColor: Colors.transparent,
                onTap: () {
                  final imageUrl = expenseState.networkImageUrl;
                  final selectedImage = expenseState.selectedImage;

                  if (imageUrl != null && imageUrl.isNotEmpty) {
                    showZoomableImage(
                      context: context,
                      imageUrl: imageUrl,
                      selectedImage: null,
                    );
                  } else {
                    showZoomableImage(
                      context: context,
                      imageUrl: null,
                      selectedImage: selectedImage,
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
                          fontFamily: "Notche",
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
    required String? imageUrl,
    required XFile? selectedImage,
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
                child: imageUrl != null
                    ? Image.network(
                        imageUrl,
                        fit: BoxFit.contain,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) {
                            return child;
                          }

                          return const SizedBox(
                            height: 300,
                            child: Center(child: CircularProgressIndicator()),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return const SizedBox(
                            height: 300,
                            child: Center(
                              child: Icon(
                                Icons.broken_image_outlined,
                                size: 50,
                              ),
                            ),
                          );
                        },
                      )
                    : Image.file(File(selectedImage!.path)),
              ),
            ),
          ),
        );
      },
    );
  }
}
