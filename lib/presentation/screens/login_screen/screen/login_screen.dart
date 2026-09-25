import 'dart:developer';

import 'package:expense/controller/login_controller/login_controller.dart';
import 'package:expense/core/errors/app_message.dart';
import 'package:expense/core/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginScreen extends ConsumerWidget {
  final bool? isRefreshExpired;
  const LoginScreen({super.key, this.isRefreshExpired});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loginController = ref.read(loginProvider.notifier);
    final loginState = ref.watch(loginProvider);

    return Scaffold(
      body: SafeArea(
        top: false,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                children: [
                  SizedBox(height: 30.h),

                  Container(
                    width: 64.h,
                    height: 64.h,
                    decoration: BoxDecoration(
                      color: AppColors.appBlue,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.appBlue.withOpacity(0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.receipt_long_rounded,
                      color: AppColors.appWhite,
                      size: 34.h,
                    ),
                  ),

                  SizedBox(height: 16.h),

                  Text(
                    'ExpensePro',
                    style: TextStyle(
                      fontSize: 26.sp,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF003D99),
                      letterSpacing: -0.5,
                    ),
                  ),

                  SizedBox(height: 32.h),
                  if (isRefreshExpired == true) ...[
                    Container(
                      margin: const EdgeInsets.only(bottom: 20),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(
                          0xFFFEF2F2,
                        ), // Light red alert background
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFFCA5A5)),
                      ),
                      child: Row(
                        children: const [
                          Icon(
                            Icons.info_outline_rounded,
                            color: Color(0xFFDC2626),
                            size: 20,
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Your session has expired. Please sign in again.',
                              style: TextStyle(
                                color: Color(0xFF991B1B),
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      //   color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Welcome Back Header
                        Text(
                          'Welcome Back',
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w700,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                        SizedBox(height: 6.h),
                        Text(
                          'Sign in to manage your clinic expenses',
                          style: TextStyle(
                            fontSize: 13,
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurface.withValues(alpha: .5),
                          ),
                        ),
                        SizedBox(height: 24.h),
                        Text(
                          'Base URL',
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w700,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        TextField(
                          controller: loginController.baseUrlController,
                          keyboardType: TextInputType.url,
                          textInputAction: TextInputAction.done,
                          autocorrect: false,
                          enableSuggestions: false,
                          decoration: InputDecoration(
                            prefixIcon: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(width: 14),
                                Icon(
                                  Icons.link,
                                  size: 20.h,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurface,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'URL',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSurface,
                                  ),
                                ),
                                SizedBox(width: 12),
                              ],
                            ),
                            hintText: 'Enter Base URL',
                            hintStyle: TextStyle(
                              color: Color(0xFF94A3B8),
                              fontSize: 14.sp,
                            ),
                            filled: true,
                            fillColor: Theme.of(
                              context,
                            ).colorScheme.onSurface.withValues(alpha: .1),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: Color(0xFFCBD5E1),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: AppColors.appBlue,
                                width: 1.5,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20.sp),

                        // Mobile Number Label & Input
                        Text(
                          'Mobile Number',
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w700,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        TextField(
                          controller: loginController.phoneController,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            prefixIcon: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(width: 14),
                                Icon(
                                  Icons.phone_android_rounded,
                                  size: 20.h,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurface,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  '+91',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSurface,
                                  ),
                                ),
                                SizedBox(width: 12),
                              ],
                            ),
                            hintText: 'Enter your number',
                            hintStyle: TextStyle(
                              color: Color(0xFF94A3B8),
                              fontSize: 14.sp,
                            ),
                            filled: true,
                            fillColor: Theme.of(
                              context,
                            ).colorScheme.onSurface.withValues(alpha: .1),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: Color(0xFFCBD5E1),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: AppColors.appBlue,
                                width: 1.5,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20.sp),

                        // Security PIN Label & Forgot PIN
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Security PIN',
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w700,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                AppMessage.show(
                                  context,
                                  'Please contact your administrator to retrieve or reset your PIN.',
                                );
                              },
                              child: Text(
                                'Forgot PIN?',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.appBlue,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8.h),

                        // Security PIN Input
                        TextField(
                          controller: loginController.pinController,
                          obscureText: loginState.isSee ? false : true,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.lock_outline_rounded,
                              size: 20,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                loginState.isSee
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                size: 20.sp,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                              onPressed: () {
                                log(loginState.isSee.toString());
                                loginController.updateState(
                                  isSee: !loginState.isSee,
                                );
                              },
                            ),
                            hintText: '• • • •',
                            hintStyle: TextStyle(
                              color: Color(0xFF94A3B8),
                              fontSize: 14.sp,
                              letterSpacing: 2,
                            ),
                            filled: true,
                            fillColor: Theme.of(
                              context,
                            ).colorScheme.onSurface.withValues(alpha: .1),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: Color(0xFFCBD5E1),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: AppColors.appBlue,
                                width: 1.5,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 24.h),

                        // Sign In Button with Outer Accent Border
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color: AppColors.appBlue.withOpacity(0.35),
                              width: 1.2,
                            ),
                          ),
                          child: ElevatedButton(
                            onPressed: () {
                              loginController.login(context: context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.appBlue,
                              foregroundColor: AppColors.appWhite,
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: loginState.isSubmit
                                ? SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: AppColors.appWhite,
                                    ),
                                  )
                                : const Text('Sign In'),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 30.h),
                ],
              ),
            );
          },
        ),
      ),

      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Having trouble? ',
                style: TextStyle(
                  fontSize: 13,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              GestureDetector(
                onTap: () {
                  AppMessage.show(
                    context,
                    'Please contact your administrator or Service team.',
                  );
                },
                child: const Row(
                  children: [
                    Text(
                      'Contact Support',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.appBlue,
                      ),
                    ),
                    SizedBox(width: 3),
                    Icon(
                      Icons.open_in_new_rounded,
                      size: 14,
                      color: AppColors.appBlue,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
