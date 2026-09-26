import 'package:expense/controller/create_clinics_controller/create_clinic_controller.dart';
import 'package:expense/controller/home_screen/home_screen_controller.dart';

import 'package:expense/core/themes/colors.dart';
import 'package:expense/presentation/common_widgets/common_appbar.dart';

import 'package:expense/presentation/screens/create_clinic_screen/widget/photo_container.dart';
import 'package:expense/presentation/screens/create_clinic_screen/widget/search_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

class AddClinicScreen extends ConsumerWidget {
  const AddClinicScreen({super.key});

  static const Color primaryBlue = Color(0xFF0052CC);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final clinicState = ref.watch(createClinicProvider);
    final clinicController = ref.read(createClinicProvider.notifier);

    return Scaffold(
      extendBody: true,

      appBar: CommonAppBar(),
      body: SafeArea(
        child: Column(
          children: [
            // Top App Bar

            // Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 10,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 16.h),

                    // Search Existing Clinics Card
                    SearchClinicCard(),
                    SizedBox(height: 20.h),

                    // Section Divider
                    Row(
                      children: [
                        Expanded(
                          child: Divider(
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurface.withValues(alpha: .15),
                            thickness: 1,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Text(
                            'OR ENTER DETAILS MANUALLY',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.6,
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurface.withValues(alpha: .55),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurface.withValues(alpha: .15),
                            thickness: 1,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 18.h),

                    // Clinic Name Field
                    _buildFieldLabel(
                      'CLINIC NAME',
                      isRequired: true,
                      context: context,
                    ),
                    SizedBox(height: 6),

                    TextFormField(
                      controller: clinicController.nameController,
                      onChanged: clinicController.onNameChanged,
                      style: TextStyle(
                        fontSize: 13.h,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      decoration: InputDecoration(
                        hint: Text(
                          'clinic name ...',
                          style: TextStyle(
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurface.withValues(alpha: .5),
                          ),
                        ),
                        prefixIcon: Icon(
                          Icons.apartment_rounded,
                          size: 20.h,
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withValues(alpha: .35),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
                        filled: true,
                        fillColor: Theme.of(
                          context,
                        ).colorScheme.onSurface.withValues(alpha: .05),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurface.withValues(alpha: .15),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurface.withValues(alpha: .15),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Official medical practice or hospital registered title.',
                      style: TextStyle(
                        fontSize: 11,
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withValues(alpha: .5),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Place / Location Field
                    _buildFieldLabel(
                      'PLACE',
                      isRequired: false,
                      context: context,
                    ),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: clinicController.placeController,
                      onChanged: clinicController.onPlaceChanged,
                      style: TextStyle(
                        fontSize: 13.5.h,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      decoration: InputDecoration(
                        hint: Text(
                          'Enter place...',
                          style: TextStyle(
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurface.withValues(alpha: .35),
                          ),
                        ),
                        prefixIcon: Icon(
                          Icons.location_on_outlined,
                          size: 20,
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withValues(alpha: .5),
                        ),

                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
                        filled: true,
                        fillColor: Theme.of(
                          context,
                        ).colorScheme.onSurface.withValues(alpha: .05),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurface.withValues(alpha: .15),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurface.withValues(alpha: .15),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Clinic Photo Section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildFieldLabel(
                          'CLINIC PHOTO',
                          //  isRequired: true,
                          context: context,
                        ),
                        if (clinicState.selectedImage != null ||
                            clinicState.networkImageUrl != null)
                          Row(
                            children: [
                              Icon(
                                Icons.check_circle,
                                size: 14,
                                color: Color(0xFF10B981),
                              ),
                              SizedBox(width: 4),
                              Text(
                                'Photo Selected',
                                style: TextStyle(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF10B981),
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    PhotoContainer(),
                    const SizedBox(height: 10),

                    // Photo Action Buttons
                    Row(
                      children: [
                        Expanded(
                          child: _buildOutlineActionButton(
                            context: context,
                            icon: Icons.camera_alt_outlined,
                            label: 'Click Camera',
                            onTap: () async {
                              final ImagePicker picker = ImagePicker();
                              final image = await picker.pickImage(
                                source: ImageSource.camera,
                                preferredCameraDevice: CameraDevice.rear,
                                // imageQuality: 85,
                                // maxWidth: 1000,
                                // maxHeight: 1000,
                              );
                              if (image != null) {
                                clinicController.ownImage(image);
                              }
                              // ignore: use_build_context_synchronously
                              //  Navigator.pop(context, image);
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _buildOutlineActionButton(
                            context: context,
                            icon: Icons.photo_library_outlined,
                            label: 'Choose Gallery',
                            onTap: () async {
                              final ImagePicker picker = ImagePicker();
                              final image = await picker.pickImage(
                                source: ImageSource.gallery,
                                // imageQuality: 85,
                                // maxWidth: 1000,
                                // maxHeight: 1000,
                              );
                              if (image != null) {
                                clinicController.ownImage(image);
                              }
                            },
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Save Button with Dashed Ring
                    CustomPaint(
                      painter: _DashedBorderPainter(
                        color: primaryBlue.withValues(alpha: 0.5),
                        strokeWidth: 1.5,
                        dashLength: 4,
                        dashSpace: 3,
                        borderRadius: 14,
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(3),
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            final bool result = await clinicController
                                .createClinicApi(context: context);
                            if (result) {
                              ref
                                  .read(homeProvider.notifier)
                                  .getAllclinics(page: 1);
                            }
                          },
                          icon: clinicState.isSubmit
                              ? null
                              : Icon(
                                  Icons.domain_add_rounded,
                                  size: 20,
                                  color: Colors.white,
                                ),
                          label: clinicState.isSubmit
                              ? SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      color: AppColors.appWhite,
                                    ),
                                  ),
                                )
                              : Text(
                                  'Save & Register Clinic',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryBlue,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(11),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Cancel & Return Button
                    CustomPaint(
                      painter: _DashedBorderPainter(
                        color: primaryBlue.withValues(alpha: 0.55),
                        strokeWidth: 1.5,
                        dashLength: 4,
                        dashSpace: 3,
                        borderRadius: 12,
                      ),
                      child: SizedBox(
                        width: double.infinity,
                        child: TextButton(
                          onPressed: () => Navigator.of(context).maybePop(),
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 13),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            'Cancel & Return',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurface.withValues(alpha: .5),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- SUB-WIDGETS ---

  static Widget _buildFieldLabel(
    String label, {
    bool isRequired = false,
    required BuildContext context,
  }) {
    return RichText(
      text: TextSpan(
        text: label,
        style: TextStyle(
          fontSize: 11.sp,
          fontWeight: FontWeight.w700,
          color: Theme.of(context).colorScheme.onSurface,
          letterSpacing: 0.3,
        ),
        children: [
          if (isRequired)
            const TextSpan(
              text: ' *',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
        ],
      ),
    );
  }

  static Widget _buildOutlineActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required BuildContext context,
  }) {
    return OutlinedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 16, color: primaryBlue),
      label: Text(
        label,
        style: TextStyle(
          fontSize: 12.5.h,
          fontWeight: FontWeight.w600,
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
      style: OutlinedButton.styleFrom(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        padding: const EdgeInsets.symmetric(vertical: 12),
        side: BorderSide(
          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: .15),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}

// Custom Painter for all dashed & dotted borders across the screen
class _DashedBorderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double dashLength;
  final double dashSpace;
  final double borderRadius;

  _DashedBorderPainter({
    required this.color,
    required this.strokeWidth,
    required this.dashLength,
    required this.dashSpace,
    required this.borderRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final rrect = RRect.fromRectAndRadius(
      Offset.zero & size,
      Radius.circular(borderRadius),
    );
    final path = Path()..addRRect(rrect);

    for (final metric in path.computeMetrics()) {
      var distance = 0.0;
      while (distance < metric.length) {
        final next = distance + dashLength;
        canvas.drawPath(
          metric.extractPath(
            distance,
            next > metric.length ? metric.length : next,
          ),
          paint,
        );
        distance += dashLength + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashedBorderPainter oldDelegate) => false;
}
