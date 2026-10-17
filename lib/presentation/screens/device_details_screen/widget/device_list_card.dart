import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DeviceItem extends ConsumerWidget {
  final String name;
  final String subtitle;
  final bool isCurrentDevice;
  final IconData iconData;
  final IconData actionIcon;
  final VoidCallback? onAction;

  const DeviceItem({
    super.key,
    required this.name,
    required this.subtitle,
    this.isCurrentDevice = false,
    required this.iconData,
    required this.actionIcon,
    this.onAction,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: isCurrentDevice
              ? isDark
                    ? const Color(0xFF00668C).withValues(alpha: 0.25)
                    : const Color.fromARGB(255, 166, 217, 252)
              : isDark
              ? Colors.white.withValues(alpha: 0.08)
              : Colors.grey.shade200,
          width: 2,
        ),
        boxShadow: isDark
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 6.r,
                  offset: Offset(0, 2.h),
                ),
              ],
      ),
      child: Row(
        children: [
          /// Device Icon
          ClipRRect(
            borderRadius: BorderRadius.circular(8.r),
            child: Container(
              width: 48.r,
              height: 48.r,
              alignment: Alignment.center,
              color: isDark
                  ? Colors.white.withValues(alpha: 0.08)
                  : Colors.grey.shade100,
              child: Icon(
                iconData,
                size: 25.r,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),

          SizedBox(width: 14.w),

          /// Device Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14.sp,
                    color: theme.colorScheme.onSurface,
                  ),
                ),

                SizedBox(height: 5.h),

                if (isCurrentDevice)
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 7.w,
                          vertical: 3.h,
                        ),
                        decoration: BoxDecoration(
                          color: isDark
                              ? const Color(0xFF00668C).withValues(alpha: 0.25)
                              : const Color(0xFFE0F2FE),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Text(
                          'This Device',
                          style: TextStyle(
                            color: isDark
                                ? const Color(0xFF7DD3FC)
                                : const Color(0xFF00668C),
                            fontSize: 9.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),

                      SizedBox(width: 5.w),

                      Text(
                        '•',
                        style: TextStyle(
                          color: theme.colorScheme.onSurfaceVariant,
                          fontSize: 10.sp,
                        ),
                      ),

                      SizedBox(width: 5.w),

                      Expanded(
                        child: Text(
                          subtitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: theme.colorScheme.onSurfaceVariant,
                            fontSize: 10.sp,
                          ),
                        ),
                      ),
                    ],
                  )
                else
                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: theme.colorScheme.onSurfaceVariant,
                      fontSize: 11.sp,
                    ),
                  ),
              ],
            ),
          ),

          SizedBox(width: 8.w),

          /// Action Button
          if (!isCurrentDevice)
            InkWell(
              onTap: onAction,
              borderRadius: BorderRadius.circular(20.r),
              child: Padding(
                padding: EdgeInsets.all(6.r),
                child: Icon(
                  actionIcon,
                  size: 20.r,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
