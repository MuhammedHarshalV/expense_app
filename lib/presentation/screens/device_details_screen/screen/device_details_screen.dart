import 'package:expense/controller/device_details_controller/device_details_controller.dart';
import 'package:expense/core/themes/colors.dart';
import 'package:expense/presentation/common_widgets/common_appbar.dart';
import 'package:expense/presentation/screens/device_details_screen/widget/accept_card.dart';
import 'package:expense/presentation/screens/device_details_screen/widget/device_list_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DeviceDetailsScreen extends ConsumerWidget {
  const DeviceDetailsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final deviceState = ref.watch(deviceDetailsProvider);
    final deviceController = ref.read(deviceDetailsProvider.notifier);
    return Scaffold(
      extendBody: true,
      appBar: CommonAppBar(),
      body: deviceState.isLoading
          ? Center(child: CircularProgressIndicator(color: AppColors.appBlue))
          : RefreshIndicator(
              color: AppColors.appBlue,
              onRefresh: () async {
                await deviceController.init();
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Pending Authorization Card
                    if (deviceState.isRequestFetch) DeviceRequestCard(),

                    if (deviceState.isRequestFetch) SizedBox(height: 32.h),

                    // Authorized Devices Section Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Authorized Devices',
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),

                            SizedBox(width: 8.w),

                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 6.w,
                                vertical: 2.h,
                              ),
                              decoration: BoxDecoration(
                                color: Theme.of(
                                  context,
                                ).colorScheme.surfaceContainerHighest,
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              child: Text(
                                '${deviceState.deviceList.length}',
                                style: TextStyle(
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ),
                          ],
                        ),

                        TextButton.icon(
                          onPressed: () async {
                            await deviceController.getDeviceDetailsRefresh();
                          },
                          icon: Icon(
                            Icons.refresh,
                            size: 14.r,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          label: Text(
                            deviceState.isRefresh ? 'Waiting...' : "Refresh",
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12.h),
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: deviceState.deviceList.length,
                      separatorBuilder: (context, index) {
                        return SizedBox(height: 12.h);
                      },
                      itemBuilder: (context, index) {
                        final device = deviceState.deviceList[index];

                        return DeviceItem(
                          name: device.deviceName ?? 'Unknown Device',
                          subtitle: device.deviceId ?? '',
                          isCurrentDevice:
                              deviceState.currentDeviceId ==
                                  (device.deviceId ?? '')
                              ? true
                              : false,
                          iconData: Icons.smartphone,
                          actionIcon: Icons.logout,
                          onAction: () {
                            showModalBottomSheet(
                              context: context,
                              backgroundColor: Colors.transparent,
                              isScrollControlled: true,
                              builder: (bottomSheetContext) {
                                final theme = Theme.of(bottomSheetContext);

                                return Container(
                                  padding: EdgeInsets.fromLTRB(
                                    20.w,
                                    20.h,
                                    20.w,
                                    25.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: theme.colorScheme.surface,
                                    borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(20.r),
                                    ),
                                  ),
                                  child: SafeArea(
                                    top: false,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        /// Top indicator
                                        Container(
                                          width: 40.w,
                                          height: 4.h,
                                          decoration: BoxDecoration(
                                            color: theme.colorScheme.onSurface
                                                .withValues(alpha: 0.15),
                                            borderRadius: BorderRadius.circular(
                                              10.r,
                                            ),
                                          ),
                                        ),

                                        SizedBox(height: 20.h),

                                        /// Icon
                                        Container(
                                          width: 52.r,
                                          height: 52.r,
                                          decoration: BoxDecoration(
                                            color: Colors.red.withValues(
                                              alpha: 0.10,
                                            ),
                                            shape: BoxShape.circle,
                                          ),
                                          child: Icon(
                                            Icons.logout_rounded,
                                            size: 25.r,
                                            color: Colors.red,
                                          ),
                                        ),

                                        SizedBox(height: 14.h),

                                        Text(
                                          'Remove Device?',
                                          style: TextStyle(
                                            fontSize: 18.sp,
                                            fontWeight: FontWeight.w700,
                                            color: theme.colorScheme.onSurface,
                                          ),
                                        ),

                                        SizedBox(height: 8.h),

                                        Text(
                                          'Do you want to remove ${device.deviceName ?? 'this device'} from your authorized devices?',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 12.sp,
                                            height: 1.4,
                                            color: theme
                                                .colorScheme
                                                .onSurfaceVariant,
                                          ),
                                        ),

                                        SizedBox(height: 24.h),

                                        Row(
                                          children: [
                                            /// Cancel
                                            Expanded(
                                              child: SizedBox(
                                                height: 45.h,
                                                child: OutlinedButton(
                                                  onPressed: () {
                                                    Navigator.pop(
                                                      bottomSheetContext,
                                                    );
                                                  },
                                                  style: OutlinedButton.styleFrom(
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            10.r,
                                                          ),
                                                    ),
                                                  ),
                                                  child: Text(
                                                    'Cancel',
                                                    style: TextStyle(
                                                      fontSize: 13.sp,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),

                                            SizedBox(width: 12.w),

                                            /// Remove
                                            Expanded(
                                              child: SizedBox(
                                                height: 45.h,
                                                child: ElevatedButton(
                                                  onPressed: () async {
                                                    final bool result =
                                                        await deviceController
                                                            .logoutApi(
                                                              context: context,
                                                              deviceId:
                                                                  device
                                                                      .deviceId ??
                                                                  '',
                                                            );

                                                    if (result == true) {
                                                      if (!context.mounted)
                                                        return;

                                                      Navigator.pop(
                                                        bottomSheetContext,
                                                      );

                                                      if (!context.mounted)
                                                        return;

                                                      ScaffoldMessenger.of(
                                                        context,
                                                      ).showSnackBar(
                                                        SnackBar(
                                                          content: Text(
                                                            'Device removed successfully',
                                                            style: TextStyle(
                                                              fontSize: 12.sp,
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                            ),
                                                          ),
                                                          backgroundColor:
                                                              Colors.green,
                                                          behavior:
                                                              SnackBarBehavior
                                                                  .floating,
                                                          margin:
                                                              EdgeInsets.all(
                                                                12.r,
                                                              ),
                                                          shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                  10.r,
                                                                ),
                                                          ),
                                                          duration:
                                                              const Duration(
                                                                seconds: 2,
                                                              ),
                                                        ),
                                                      );
                                                    }
                                                  },
                                                  style: ElevatedButton.styleFrom(
                                                    backgroundColor: Colors.red,
                                                    foregroundColor:
                                                        Colors.white,
                                                    elevation: 0,
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            10.r,
                                                          ),
                                                    ),
                                                  ),
                                                  child: Text(
                                                    'Yes, Remove',
                                                    style: TextStyle(
                                                      fontSize: 13.sp,
                                                      fontWeight:
                                                          FontWeight.w600,
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
                                );
                              },
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
