import 'package:expense/controller/history_screen_controller/history_screen_controller.dart';
import 'package:expense/controller/home_screen/home_screen_controller.dart';
import 'package:expense/controller/profile_screen_controller/profile_controller.dart';
import 'package:expense/core/storage/token_storage.dart';
import 'package:expense/core/themes/colors.dart';
import 'package:expense/presentation/common_widgets/glass_container.dart';
import 'package:expense/presentation/screens/profile_screen/widget/popup_dialog.dart';
import 'package:expense/presentation/screens/profile_screen/widget/profile_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileState = ref.watch(profileProvider);
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
                //ref.invalidate(profileProvider);
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

      body: profileState.isLoading
          ? Center(child: CircularProgressIndicator(color: AppColors.appBlue))
          : RefreshIndicator(
              color: AppColors.appBlue,
              onRefresh: () async {
                await profileController.fetchProfile();
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
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
                                  hintText: 'Enter Name',
                                  title: "Name",
                                  onSave: (value) {
                                    profileController.updateProfileApi(
                                      name: value,
                                      // ignore: use_build_context_synchronously
                                      context: context,
                                    );
                                  },
                                  initialValue:
                                      profileState.profileDetails?.userName ??
                                      "",
                                ),
                              );
                            },
                            label: 'Full Name',
                            value:
                                profileState.profileDetails?.userName ??
                                "No Name",
                            icon: Icons.person_outline,
                          ),

                          _ProfileInfo(
                            onFunction: () {
                              showDialog(
                                context: context,
                                builder: (context) => EditTextDialog(
                                  title: "Email",
                                  onSave: (value) {
                                    profileController.updateProfileApi(
                                      email: value,
                                      // ignore: use_build_context_synchronously
                                      context: context,
                                    );
                                  },
                                  initialValue:
                                      profileState.profileDetails?.userEmail ??
                                      "",
                                ),
                              );
                            },
                            label: 'Email',
                            value:
                                profileState.profileDetails?.userEmail ??
                                "No email",
                            icon: Icons.email_outlined,
                          ),

                          _ProfileInfo(
                            onFunction: null,
                            label: 'Phone',
                            value:
                                profileState.profileDetails?.userPhoneNumber ??
                                "No phone",
                            icon: Icons.phone_outlined,
                          ),

                          _ProfileInfo(
                            onFunction: () {
                              showDialog(
                                context: context,
                                builder: (context) => EditTextDialog(
                                  title: "Date of Birth",
                                  onSave: (value) {
                                    profileController.updateProfileApi(
                                      dateOfBirth: value,
                                      // ignore: use_build_context_synchronously
                                      context: context,
                                    );
                                  },
                                  initialValue:
                                      profileState
                                          .profileDetails
                                          ?.dateOfBirth ??
                                      "YY-MM-DD",
                                ),
                              );
                            },
                            label: 'Date of Birth',
                            value:
                                profileState.profileDetails?.dateOfBirth ??
                                "Not mentioned",
                            icon: Icons.calendar_today_outlined,
                          ),

                          _ProfileInfo(
                            onFunction: () {
                              showDialog(
                                context: context,
                                builder: (context) => EditTextDialog(
                                  title: "Gender",
                                  onSave: (value) {
                                    profileController.updateProfileApi(
                                      gender: value,
                                      // ignore: use_build_context_synchronously
                                      context: context,
                                    );
                                  },
                                  initialValue:
                                      profileState.profileDetails?.userGender ??
                                      "",
                                ),
                              );
                            },
                            label: 'Gender',
                            value:
                                profileState.profileDetails?.userGender ??
                                "Not mentioned",
                            icon: Icons.person_outline,
                          ),

                          _ProfileInfo(
                            label: 'Location',
                            value:
                                profileState.profileDetails?.userLocation ??
                                "Not mentioned",
                            icon: Icons.location_on_outlined,
                            showDivider: false,
                            onFunction: () {
                              showDialog(
                                context: context,
                                builder: (context) => EditTextDialog(
                                  title: "Location",
                                  onSave: (value) {
                                    profileController.updateProfileApi(
                                      location: value,
                                      // ignore: use_build_context_synchronously
                                      context: context,
                                    );
                                  },
                                  initialValue:
                                      profileState
                                          .profileDetails
                                          ?.userLocation ??
                                      "",
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
                                  profileState.profileDetails?.userAbout ??
                                      'No about',
                                  style: TextStyle(
                                    fontSize: 14,
                                    height: 1.5,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface
                                        .withValues(alpha: .7),
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
                                    profileController.updateProfileApi(
                                      about: value,
                                      // ignore: use_build_context_synchronously
                                      context: context,
                                    );
                                  },
                                  initialValue:
                                      profileState.profileDetails?.userAbout ??
                                      '',
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
                    SizedBox(height: 20),
                    InkWell(
                      splashColor: Colors.transparent,
                      focusColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => Dialog(
                            backgroundColor: Theme.of(
                              context,
                            ).scaffoldBackgroundColor,
                            insetPadding: EdgeInsets.symmetric(
                              horizontal: 24.w,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24.r),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(10.h),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // Delete icon

                                  // Title
                                  Text(
                                    'Logout',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 23.sp,
                                      fontWeight: FontWeight.w700,
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onSurface,
                                    ),
                                  ),

                                  SizedBox(height: 5.h),

                                  // Description
                                  Text.rich(
                                    TextSpan(
                                      children: [
                                        TextSpan(
                                          text: "Are you sure want to logout?",
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ],
                                    ),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      height: 1.5,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface
                                          .withValues(alpha: .60),
                                    ),
                                  ),

                                  SizedBox(height: 10.h),

                                  Row(
                                    children: [
                                      // Cancel
                                      Expanded(
                                        child: SizedBox(
                                          height: 50,
                                          child: ElevatedButton(
                                            onPressed: () {
                                              Navigator.pop(context, false);
                                            },
                                            style: ElevatedButton.styleFrom(
                                              elevation: 0,
                                              backgroundColor: Theme.of(context)
                                                  .colorScheme
                                                  .onSurface
                                                  .withValues(alpha: .06),
                                              foregroundColor: Theme.of(
                                                context,
                                              ).colorScheme.onSurface,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12.r),
                                              ),
                                            ),
                                            child: Text(
                                              'No',
                                              style: TextStyle(
                                                fontSize: 15.sp,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),

                                      SizedBox(width: 12.w),

                                      // Delete
                                      Expanded(
                                        child: SizedBox(
                                          height: 50,
                                          child: ElevatedButton(
                                            onPressed: () async {
                                              await TokenStorage.clear();
                                              ref.invalidate(homeProvider);
                                              ref.invalidate(
                                                expenseHistoryProvider,
                                              );
                                            },
                                            style: ElevatedButton.styleFrom(
                                              elevation: 0,
                                              backgroundColor: AppColors.appRed,
                                              foregroundColor: Colors.white,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12.r),
                                              ),
                                            ),
                                            child: Text(
                                              'Yes',
                                              style: TextStyle(
                                                fontSize: 15.sp,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.appRed, width: 2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.logout, color: AppColors.appRed),
                              Text(
                                'Logout',
                                style: TextStyle(
                                  color: AppColors.appRed,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
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
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: .4),
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
  final VoidCallback? onFunction;

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
              if (onFunction != null)
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
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: .2),
          ),
      ],
    );
  }
}
