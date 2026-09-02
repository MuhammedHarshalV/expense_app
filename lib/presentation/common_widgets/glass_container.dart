import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GlassContainer extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final BorderRadius? borderRadius;
  final double blur;
  final Color color;
  final Border? border;

  // For custom border sides (top, bottom, left, right)
  final BorderSide? topBorder;
  final BorderSide? bottomBorder;
  final BorderSide? leftBorder;
  final BorderSide? rightBorder;

  const GlassContainer({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.borderRadius,
    this.blur = 10.0,
    this.color = const Color(0x40FFFFFF), // 25% white opacity
    this.border,
    this.topBorder,
    this.bottomBorder,
    this.leftBorder,
    this.rightBorder,
  });

  @override
  Widget build(BuildContext context) {
    // Create custom border if individual sides are specified
    Border? finalBorder = border;
    if (topBorder != null ||
        bottomBorder != null ||
        leftBorder != null ||
        rightBorder != null) {
      finalBorder = Border(
        top: topBorder ?? BorderSide.none,
        bottom: bottomBorder ?? BorderSide.none,
        left: leftBorder ?? BorderSide.none,
        right: rightBorder ?? BorderSide.none,
      );
    }

    return Container(
      width: width,
      height: height,
      margin: margin,
      child: ClipRRect(
        borderRadius: borderRadius ?? BorderRadius.circular(16.r),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: Container(
            padding: padding,
            decoration: BoxDecoration(
              color: color,
              borderRadius: borderRadius ?? BorderRadius.circular(16.r),
              border: finalBorder,
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
