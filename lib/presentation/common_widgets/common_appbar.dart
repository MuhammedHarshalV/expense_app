import 'dart:developer';

import 'package:expense/core/themes/colors.dart';
import 'package:expense/presentation/common_widgets/glass_container.dart';
import 'package:expense/presentation/screens/home_screen/widget/profile_icon.dart';
import 'package:flutter/material.dart';

class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CommonAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      elevation: 4,
      shadowColor: Colors.black45,
      backgroundColor: const Color(0xFF1A2980),

      title: Row(
        children: [
          InkWell(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () {
              final canPop = Navigator.of(context).canPop();

              log('Can pop: $canPop');

              if (canPop) {
                Navigator.of(context).pop();
              }
            },
            child: GlassContainer(
              padding: const EdgeInsets.all(8),
              borderRadius: BorderRadius.circular(360),
              border: Border.all(color: AppColors.appWhite),
              child: Icon(
                Icons.arrow_back_ios_new_sharp,
                color: AppColors.appWhite,
                size: 24,
              ),
            ),
          ),

          const SizedBox(width: 12),

          const Text(
            'FinanceTrack',
            style: TextStyle(
              fontFamily: "Notche",
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 22,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),

      actions: const [ProfileIcon()],

      // Gradient background
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1A2980), Color(0xFF26D0CE)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
