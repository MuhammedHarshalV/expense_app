import 'package:expense/controller/clinic_expense_details_controller/expense_details_controller.dart';
import 'package:expense/core/themes/colors.dart';
import 'package:expense/presentation/screens/add_expense_screen/screen/add_expense_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TopClinicCard extends ConsumerWidget {
  final int clinicId;
  const TopClinicCard({super.key, required this.clinicId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final clinicDetailsState = ref.watch(clinicDetailsProvider(clinicId));

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final surfaceColor = colorScheme.surface;
    final primaryColor = colorScheme.primary;
    final textMuted = colorScheme.onSurface.withValues(alpha: 0.6);
    colorScheme.outline.withValues(alpha: 0.25);

    return Container(
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.appBlack.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // _buildHeaderImage(primaryBlue),
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                child: (clinicDetailsState.clinicPhoto.trim().isEmpty)
                    ? Container(
                        height: 180.h,
                        width: double.infinity,
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withValues(alpha: .15),
                        child: Icon(
                          Icons.image,
                          size: 48.h,
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withValues(alpha: .5),
                        ),
                      )
                    : Image.network(
                        clinicDetailsState.clinicPhoto,
                        height: 180.h,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          height: 180.h,
                          width: double.infinity,
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withValues(alpha: .05),
                          child: Icon(
                            Icons.image,
                            size: 48.h,
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurface.withValues(alpha: .5),
                          ),
                        ),
                      ),
              ),
              // Gradient overlay
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        AppColors.appBlack.withValues(alpha: 0.3),
                      ],
                      stops: const [0.4, 1.0],
                    ),
                  ),
                ),
              ),

              // Top Chips
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.appBlack.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        size: 14.sp,
                        color: AppColors.appWhite,
                      ),
                      SizedBox(width: 4),
                      Text(
                        clinicDetailsState.clinicPlace,
                        style: TextStyle(
                          fontFamily: "Notche",
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.appWhite,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Title Text
              Positioned(
                bottom: 16,
                left: 16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      clinicDetailsState.clinicName,
                      style: TextStyle(
                        fontFamily: "Notche",
                        fontSize: 22.sp,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer.withValues(alpha: 0.25),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                  ),
                  border: Border.all(
                    color: colorScheme.primary.withValues(alpha: 0.15),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'TOTAL CLINIC SPEND',
                          style: TextStyle(
                            fontFamily: "Notche",
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w700,
                            color: textMuted,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '₹${clinicDetailsState.clinicTotalExp}',
                          style: TextStyle(
                            fontFamily: "Notche",
                            fontSize: 28.sp,
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.account_balance_wallet_outlined,
                        color: colorScheme.onPrimary,
                        size: 24,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                AddExpenseScreen(clinicId: clinicId),
                          ),
                        );
                      },
                      icon: const Icon(
                        Icons.add_circle_outline,
                        size: 18,
                        color: Colors.white,
                      ),
                      label: Text(
                        'Add Expense',
                        style: TextStyle(
                          fontFamily: "Notche",
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
