import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:expense/controller/profile_screen_controller/profile_controller.dart';
import 'package:expense/core/services/image_helper/image_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class ProfileHeader extends ConsumerWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileState = ref.watch(profileProvider);
    final profilecontroller = ref.read(profileProvider.notifier);
    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
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
                  imageUrl: 'http://172.16.16.10:1024/api/users/3/photo',
                  width: 105,
                  height: 105,
                  fit: BoxFit.cover,

                  placeholder: (context, url) {
                    return const Center(child: CircularProgressIndicator());
                  },

                  errorWidget: (context, url, error) {
                    log('Network image error: $error');

                    return const Icon(Icons.person, size: 50);
                  },
                ),
              ),
            ),
            // Edit image button
            Positioned(
              right: -2,
              bottom: 0,
              child: InkWell(
                onTap: () async {
                  final XFile? image = await ImageHelper.pickImage(
                    context: context,
                  );
                  if (image == null) return;

                  //  Step 4 — Save to controller
                  profilecontroller.updateProfileImage(image.path);
                },
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: Colors.blueAccent,

                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      width: 2,
                    ),
                  ),
                  child: Icon(
                    Icons.edit,
                    size: 15,
                    color: Theme.of(context).scaffoldBackgroundColor,
                  ),
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 14),

        Text(
          profileState.name,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 21,
            fontWeight: FontWeight.w800,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),

        const SizedBox(height: 4),

        Text(
          profileState.bio,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: .5),
          ),
        ),
      ],
    );
  }
}
