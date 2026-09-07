import 'package:expense/controller/home_screen/home_screen_controller.dart';
import 'package:expense/core/themes/colors.dart';
import 'package:expense/presentation/common_widgets/glass_container.dart';
import 'package:expense/presentation/screens/profile_screen/screen/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileIcon extends ConsumerWidget {
  const ProfileIcon({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ProfileScreen()),
          );
        },
        child: GlassContainer(
          width: 40,
          height: 40,

          border: Border.all(color: AppColors.appWhite, width: 1.5),
          borderRadius: BorderRadius.circular(360),
          color: Colors.white.withValues(alpha: 0.15),
          child: ClipOval(
            child: Icon(
              Icons.person_2_outlined,
              color: AppColors.appWhite,
              size: 20,
            ),
          ),
        ),
      ),
    );
  }
}
