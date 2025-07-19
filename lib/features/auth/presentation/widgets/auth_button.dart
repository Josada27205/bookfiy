import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';

class AuthButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isOutlined;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? textColor;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;

  const AuthButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.isOutlined = false,
    this.icon,
    this.backgroundColor,
    this.textColor,
    this.width,
    this.height,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final buttonHeight = height ?? 56.h;
    final buttonWidth = width ?? double.infinity;

    if (isOutlined) {
      return Container(
        height: buttonHeight,
        width: buttonWidth,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          gradient: onPressed != null ? AppColors.primaryGradient : null,
        ),
        child: Padding(
          padding: EdgeInsets.all(2.r),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.backgroundWhite,
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: OutlinedButton(
              onPressed: isLoading ? null : onPressed,
              style: OutlinedButton.styleFrom(
                foregroundColor: textColor ?? AppColors.primaryGreen,
                side: BorderSide.none,
                padding:
                    padding ??
                    EdgeInsets.symmetric(horizontal: 24.w, vertical: 14.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
              child: _buildChild(isOutlined: true),
            ),
          ),
        ),
      );
    }

    return Container(
      height: buttonHeight,
      width: buttonWidth,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        gradient: onPressed != null && backgroundColor == null
            ? AppColors.primaryGradient
            : null,
        color: backgroundColor,
        boxShadow: onPressed != null
            ? [
                BoxShadow(
                  color: (backgroundColor ?? AppColors.primaryGreen)
                      .withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: textColor ?? AppColors.textWhite,
          shadowColor: Colors.transparent,
          padding:
              padding ?? EdgeInsets.symmetric(horizontal: 24.w, vertical: 14.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
        child: _buildChild(),
      ),
    );
  }

  Widget _buildChild({bool isOutlined = false}) {
    if (isLoading) {
      return SizedBox(
        width: 24.w,
        height: 24.h,
        child: CircularProgressIndicator(
          strokeWidth: 2.5,
          valueColor: AlwaysStoppedAnimation<Color>(
            isOutlined ? AppColors.primaryGreen : AppColors.textWhite,
          ),
        ),
      );
    }

    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 20.sp),
          SizedBox(width: 8.w),
          Text(
            text,
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
          ),
        ],
      );
    }

    return Text(
      text,
      style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
    );
  }
}
