import 'package:expense/controller/device_details_controller/device_details_controller.dart';
import 'package:expense/core/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DeviceRequestCard extends ConsumerWidget {
  const DeviceRequestCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(deviceDetailsProvider);
    final controller = ref.read(deviceDetailsProvider.notifier);

    final isDark = Theme.of(context).brightness == Brightness.dark;

    final cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;

    final titleColor = isDark ? AppColors.appWhite : AppColors.appBlack;

    final subTitleColor = isDark ? Colors.white60 : Colors.black54;

    final infoBackgroundColor = isDark
        ? const Color(0xFF292929)
        : const Color(0xFFF9FAFB);

    final borderColor = isDark ? Colors.white12 : Colors.grey.shade200;

    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: borderColor),
        boxShadow: isDark
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10.r,
                  offset: Offset(0, 4.h),
                ),
              ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Pending authorization
          Row(
            children: [
              Container(
                width: 8.r,
                height: 8.r,
                decoration: const BoxDecoration(
                  color: Color(0xFF00668C),
                  shape: BoxShape.circle,
                ),
              ),

              SizedBox(width: 8.w),

              Text(
                'PENDING AUTHORIZATION',
                style: TextStyle(
                  color: const Color(0xFF00668C),
                  fontSize: 10.sp,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),

          SizedBox(height: 12.h),

          /// Title
          Text(
            'New Login Request Detected',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              color: titleColor,
            ),
          ),

          SizedBox(height: 8.h),

          /// Description
          Text(
            'A new mobile device is attempting to access '
            'your corporate ExpensePro vault.',
            style: TextStyle(
              fontSize: 12.sp,
              color: subTitleColor,
              height: 1.4,
            ),
          ),

          SizedBox(height: 16.h),

          /// Information / warning
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(12.r),
            decoration: BoxDecoration(
              color: infoBackgroundColor,
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(color: borderColor),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.info_outline,
                  color: isDark ? Colors.orangeAccent : Colors.brown,
                  size: 16.r,
                ),

                SizedBox(width: 8.w),

                Expanded(
                  child: Text(
                    "If you didn't initiate this request, "
                    "tap Reject immediately to protect your credentials.",
                    style: TextStyle(
                      color: subTitleColor,
                      fontSize: 11.sp,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 20.h),

          /// Buttons
          Row(
            children: [
              /// Reject
              Expanded(
                child: SizedBox(
                  height: 40.h,
                  child: ElevatedButton.icon(
                    onPressed: state.isReject
                        ? null
                        : () async {
                            await controller.rejectRequest();
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isDark
                          ? const Color(0xFF4A1D27)
                          : const Color(0xFFFFE4E6),
                      foregroundColor: isDark
                          ? const Color(0xFFFF8A9A)
                          : const Color(0xFFE11D48),
                      disabledBackgroundColor: isDark
                          ? const Color(0xFF352126)
                          : const Color(0xFFF5E7E9),
                      elevation: 0,
                      padding: EdgeInsets.symmetric(horizontal: 8.w),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    icon: state.isReject
                        ? SizedBox(
                            width: 16.r,
                            height: 16.r,
                            child: const CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          )
                        : Icon(Icons.block, size: 16.r),
                    label: Text(
                      'Reject',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 12.sp,
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(width: 12.w),

              /// Allow
              Expanded(
                child: SizedBox(
                  height: 40.h,
                  child: ElevatedButton.icon(
                    onPressed: state.isAccept
                        ? null
                        : () async {
                            await controller.acceptRequest();
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF003399),
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: const Color(
                        0xFF003399,
                      ).withValues(alpha: 0.5),
                      elevation: 0,
                      padding: EdgeInsets.symmetric(horizontal: 8.w),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    icon: state.isAccept
                        ? SizedBox(
                            width: 16.r,
                            height: 16.r,
                            child: const CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Icon(Icons.check_circle_outline, size: 16.r),
                    label: Text(
                      'Allow Device',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 12.sp,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
