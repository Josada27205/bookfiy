import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowColor.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: onTap,
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColors.surface,
        selectedItemColor: AppColors.primaryGreen,
        unselectedItemColor: AppColors.textSecondary,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        elevation: 0,
        selectedLabelStyle: TextStyle(
          fontSize: 12.sp,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: 12.sp,
          fontWeight: FontWeight.w400,
        ),
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined, size: 24.sp),
            activeIcon: Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: AppColors.primaryGreen.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(
                Icons.home,
                size: 24.sp,
                color: AppColors.primaryGreen,
              ),
            ),
            label: AppStrings.home,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore_outlined, size: 24.sp),
            activeIcon: Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: AppColors.primaryGreen.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(
                Icons.explore,
                size: 24.sp,
                color: AppColors.primaryGreen,
              ),
            ),
            label: AppStrings.discover,
          ),
          BottomNavigationBarItem(
            icon: Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(Icons.add, size: 24.sp, color: AppColors.textWhite),
            ),
            activeIcon: Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(12.r),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryGreen.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(Icons.add, size: 24.sp, color: AppColors.textWhite),
            ),
            label: AppStrings.write,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.library_books_outlined, size: 24.sp),
            activeIcon: Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: AppColors.primaryGreen.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(
                Icons.library_books,
                size: 24.sp,
                color: AppColors.primaryGreen,
              ),
            ),
            label: AppStrings.myLibrary,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline, size: 24.sp),
            activeIcon: Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: AppColors.primaryGreen.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(
                Icons.person,
                size: 24.sp,
                color: AppColors.primaryGreen,
              ),
            ),
            label: AppStrings.profile,
          ),
        ],
      ),
    );
  }
}
