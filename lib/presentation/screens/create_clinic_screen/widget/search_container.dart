import 'package:expense/controller/create_clinics_controller/create_clinic_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:expense/core/themes/colors.dart';

class SearchClinicCard extends ConsumerWidget {
  const SearchClinicCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final clinicState = ref.watch(createClinicProvider);
    final clinicController = ref.read(createClinicProvider.notifier);

    final borderColor = Theme.of(
      context,
    ).colorScheme.onSurface.withValues(alpha: .15);

    return Container(
      // padding: EdgeInsets.all(14.h),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        // borderRadius: BorderRadius.circular(16),
        // border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'SEARCH EXISTING CLINICS',
            style: TextStyle(
              fontFamily: "Notche",
              fontSize: 11.sp,
              fontWeight: FontWeight.w700,
              color: Theme.of(context).colorScheme.onSurface,
              letterSpacing: 0.4,
            ),
          ),

          SizedBox(height: 8.h),

          TextFormField(
            controller: clinicController.searchController,
            onChanged: clinicController.onSearchChanged,
            decoration: InputDecoration(
              hintText: 'Search clinics or hospitals...',
              hintStyle: TextStyle(
                fontSize: 13.sp,
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: .5),
              ),
              prefixIcon: Icon(
                Icons.search,
                size: 20,
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: .35),
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 10.w,
                vertical: 10.h,
              ),
              filled: true,
              fillColor: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: .05),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: borderColor),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: borderColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: AppColors.appBlue, width: 1.5),
              ),
            ),
          ),

          // SEARCH LOADING
          if (clinicState.isLoading)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 15.h),
              child: Center(
                child: SizedBox(
                  height: 22.h,
                  width: 22.h,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.appBlue,
                  ),
                ),
              ),
            ),

          // DROPDOWN
          if (!clinicState.isLoading && clinicState.clinicDetails.isNotEmpty)
            Container(
              margin: EdgeInsets.only(top: 5.h),
              constraints: BoxConstraints(maxHeight: 250.h),
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: borderColor),
                boxShadow: [
                  BoxShadow(
                    color: borderColor,
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: NotificationListener<ScrollNotification>(
                onNotification: (ScrollNotification notification) {
                  if (notification.metrics.extentAfter < 100) {
                    final currentState = ref.read(createClinicProvider);

                    if (!currentState.isPaginationLoading &&
                        currentState.page < currentState.totalPages) {
                      clinicController.searchClinic(
                        search: clinicController.searchController.text,
                        page: currentState.page + 1,
                      );
                    }
                  }

                  return false;
                },
                child: ListView.separated(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  itemCount: clinicState.clinicDetails.length,
                  separatorBuilder: (_, __) =>
                      Divider(height: 1, color: borderColor),
                  itemBuilder: (context, index) {
                    final clinic = clinicState.clinicDetails[index];
                    if (index == clinicState.clinicDetails.length) {
                      return Padding(
                        padding: EdgeInsets.all(12.h),
                        child: Center(
                          child: SizedBox(
                            width: 20.w,
                            height: 20.w,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColors.appBlue,
                            ),
                          ),
                        ),
                      );
                    }
                    return InkWell(
                      onTap: () {
                        clinicController.selectSearchedClinic(clinic);
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 10.h,
                        ),
                        child: Row(
                          children: [
                            Container(
                              height: 38.h,
                              width: 38.h,
                              decoration: BoxDecoration(
                                color: AppColors.appBlue.withValues(alpha: .08),
                                borderRadius: BorderRadius.circular(8),
                                image: (clinic.clinicPhoto ?? '').isEmpty
                                    ? null
                                    : DecorationImage(
                                        image: NetworkImage(
                                          clinic.clinicPhoto ?? '',
                                        ),
                                        fit: BoxFit.cover,
                                      ),
                              ),
                              child: (clinic.clinicPhoto ?? '').isEmpty
                                  ? Icon(
                                      Icons.local_hospital_outlined,
                                      color: AppColors.appBlue,
                                      size: 20.sp,
                                    )
                                  : null,
                            ),

                            SizedBox(width: 10.w),

                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    clinic.clinicName ?? '',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontFamily: "Notche",
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w600,
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onSurface,
                                    ),
                                  ),

                                  SizedBox(height: 3.h),

                                  if ((clinic.clinicPlace ?? '').isNotEmpty)
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.location_on_outlined,
                                          size: 13.sp,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurface
                                              .withValues(alpha: .5),
                                        ),

                                        SizedBox(width: 3.w),

                                        Expanded(
                                          child: Text(
                                            clinic.clinicPlace ?? '',
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontFamily: "Notche",
                                              fontSize: 11.sp,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onSurface
                                                  .withValues(alpha: .6),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                ],
                              ),
                            ),

                            Icon(
                              Icons.chevron_right,
                              size: 20.sp,
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurface.withValues(alpha: .4),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }
}
