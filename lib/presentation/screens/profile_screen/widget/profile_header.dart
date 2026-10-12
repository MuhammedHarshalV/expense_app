import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:expense/controller/profile_screen_controller/profile_controller.dart';
import 'package:expense/core/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileHeader extends ConsumerWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileState = ref.watch(profileProvider);

    final originalImageUrl =
        profileState.profileDetails?.userProfilePhoto ?? '';

    final imageUrl = originalImageUrl.isNotEmpty
        ? '$originalImageUrl?v=${profileState.imageVersion}'
        : '';
    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            InkWell(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              hoverColor: Colors.transparent,
              focusColor: Colors.transparent,
              onTap: () {
                final imageUrl = profileState.profileDetails?.userProfilePhoto;

                if (imageUrl != null && imageUrl.isNotEmpty) {
                  showZoomableImage(context: context, imageUrl: imageUrl);
                }
              },
              child: Container(
                width: 105,
                height: 105,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey.shade200,
                  border: Border.all(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: .3),
                    width: 4,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withValues(alpha: .10),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: ClipOval(
                  child: CachedNetworkImage(
                    imageUrl: imageUrl,
                    width: 105.h,
                    height: 105.h,
                    fit: BoxFit.cover,

                    placeholder: (context, url) {
                      return const Center(
                        child: SizedBox(
                          height: 25,
                          width: 25,
                          child: CircularProgressIndicator(
                            color: AppColors.appBlue,
                          ),
                        ),
                      );
                    },

                    errorWidget: (context, url, error) {
                      log('Network image error: $error');

                      return const Icon(Icons.person, size: 50);
                    },
                  ),
                ),
              ),
            ),
            // Edit image button
            // Positioned(
            //   right: -2,
            //   bottom: 0,
            //   child: InkWell(
            //     onTap: () async {
            //       final XFile? image = await ImageHelper.pickImage(
            //         context: context,
            //       );
            //       if (image == null) return;

            //       //  Step 4 — Save to controller

            //       profilecontroller.updateProfileApi(
            //         photoPath: image.path,
            //         // ignore: use_build_context_synchronously
            //         context: context,
            //         isPhoto: true,
            //       );
            //     },
            //     child: Container(
            //       width: 32.h,
            //       height: 32.h,
            //       decoration: BoxDecoration(
            //         color: Colors.blueAccent,

            //         shape: BoxShape.circle,
            //         border: Border.all(
            //           color: Theme.of(context).scaffoldBackgroundColor,
            //           width: 2.h,
            //         ),
            //       ),
            //       child: Icon(
            //         Icons.camera_alt_outlined,
            //         size: 15.h,
            //         color: Theme.of(context).scaffoldBackgroundColor,
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),

        const SizedBox(height: 14),

        Text(
          profileState.profileDetails?.userName ?? 'No Name',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: "Notche",
            fontSize: 21.sp,
            fontWeight: FontWeight.w800,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),

        const SizedBox(height: 4),

        Text(
          profileState.profileDetails?.userAbout ?? "No Description",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: "Notche",
            fontSize: 14,
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: .5),
          ),
        ),
      ],
    );
  }

  void showZoomableImage({
    required BuildContext context,
    required String imageUrl,
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
                child: Image.network(
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
                        child: Icon(Icons.broken_image_outlined, size: 50),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
