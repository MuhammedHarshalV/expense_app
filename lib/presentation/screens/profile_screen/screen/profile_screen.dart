
import 'package:expense/controller/profile_screen_controller/profile_controller.dart';
import 'package:expense/core/themes/colors.dart';
import 'package:expense/presentation/common_widgets/glass_container.dart';
import 'package:expense/presentation/screens/profile_screen/widget/name_dialog.dart';
import 'package:expense/presentation/screens/profile_screen/widget/profile_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileProvider);
    final profileController = ref.read(profileProvider.notifier);
  

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            InkWell(
              focusColor: Colors.transparent,
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              hoverColor: Colors.transparent,
              onTap: () {
                Navigator.pop(context);
                ref.invalidate(profileProvider);
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
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 22,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
        toolbarHeight: 70.0,
        elevation: 0,
        foregroundColor: Colors.white,

        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF1A2980), Color(0xFF26D0CE)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10),
            ),
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            ProfileHeader(),
//
            const SizedBox(height: 24),

            // ─────────────────────────
            // PERSONAL INFORMATION
            // ─────────────────────────
            _SectionCard(
              title: 'Personal Information',
              child: Column(
                children: [
                  _ProfileInfo(
                    onFunction: () {
                      showDialog(
                        context: context,
                        builder: (context) => EditTextDialog(
                          title: "Name",
                          onSave: (value) {
                            profileController.updateProfile(name: value);
                          },
                          initialValue: profile.name,
                        ),
                      );
                    },
                    label: 'Full Name',
                    value: profile.name,
                    icon: Icons.person_outline,
                  ),

                  _ProfileInfo(
                    onFunction: () {
                      showDialog(
                        context: context,
                        builder: (context) => EditTextDialog(
                          title: "Email",
                          onSave: (value) {
                            profileController.updateProfile(email: value);
                          },
                          initialValue: profile.email,
                        ),
                      );
                    },
                    label: 'Email',
                    value: profile.email,
                    icon: Icons.email_outlined,
                  ),

                  _ProfileInfo(
                    onFunction: () {
                      showDialog(
                        context: context,
                        builder: (context) => EditTextDialog(
                          title: "Phone",
                          onSave: (value) {
                            profileController.updateProfile(phone: value);
                          },
                          initialValue: profile.phone,
                        ),
                      );
                    },
                    label: 'Phone',
                    value: profile.phone,
                    icon: Icons.phone_outlined,
                  ),

                  _ProfileInfo(
                    onFunction: () {
                      showDialog(
                        context: context,
                        builder: (context) => EditTextDialog(
                          title: "Date of Birth",
                          onSave: (value) {
                            profileController.updateProfile(dateOfBirth: value);
                          },
                          initialValue: profile.dateOfBirth,
                        ),
                      );
                    },
                    label: 'Date of Birth',
                    value: profile.dateOfBirth,
                    icon: Icons.calendar_today_outlined,
                  ),

                  _ProfileInfo(
                    onFunction: () {
                      showDialog(
                        context: context,
                        builder: (context) => EditTextDialog(
                          title: "Gender",
                          onSave: (value) {
                            profileController.updateProfile(gender: value);
                          },
                          initialValue: profile.gender,
                        ),
                      );
                    },
                    label: 'Gender',
                    value: profile.gender,
                    icon: Icons.person_outline,
                  ),

                  _ProfileInfo(
                    label: 'Location',
                    value: profile.location,
                    icon: Icons.location_on_outlined,
                    showDivider: false,
                    onFunction: () {
                      showDialog(
                        context: context,
                        builder: (context) => EditTextDialog(
                          title: "Location",
                          onSave: (value) {
                            profileController.updateProfile(location: value);
                          },
                          initialValue: profile.location,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ─────────────────────────
            // ABOUT
            // ─────────────────────────
            _SectionCard(
              title: 'About',
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          profile.bio,
                          style: TextStyle(
                            fontSize: 14,
                            height: 1.5,
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurface.withValues(alpha: .7),
                          ),
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => EditTextDialog(
                          title: "About",
                          onSave: (value) {
                            profileController.updateProfile(bio: value);
                          },
                          initialValue: profile.bio,
                        ),
                      );
                    },
                    child: Icon(
                      Icons.edit,
                      size: 20,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final Widget child;

  const _SectionCard({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: .4),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),

          const SizedBox(height: 14),

          child,
        ],
      ),
    );
  }
}

class _ProfileInfo extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final bool showDivider;
  final VoidCallback onFunction;

  const _ProfileInfo({
    required this.label,
    required this.value,
    required this.icon,
    this.showDivider = true,
    required this.onFunction,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 9),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                icon,
                size: 20,
                color: Theme.of(context).colorScheme.primary,
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    const SizedBox(height: 3),

                    Text(
                      value.isEmpty ? '-' : value,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: onFunction,
                child: Icon(
                  Icons.edit,
                  size: 20,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
        ),

        if (showDivider)
          Divider(
            height: 1,
            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: .2),
          ),
      ],
    );
  }
}
