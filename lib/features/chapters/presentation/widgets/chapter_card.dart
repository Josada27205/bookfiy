import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/formatters.dart';
import '../../domain/entities/chapter.dart';

class ChapterCard extends StatelessWidget {
  final Chapter chapter;
  final bool isOwner;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const ChapterCard({
    super.key,
    required this.chapter,
    required this.isOwner,
    this.onTap,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 16.h),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowColor.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Chapter Number
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 6.h,
                  ),
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text(
                    Formatters.formatChapterNumber(chapter.chapterNumber),
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textWhite,
                    ),
                  ),
                ),
                const Spacer(),

                // Status Badge
                if (chapter.status == ChapterStatus.published)
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.success.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Text(
                      'Published',
                      style: TextStyle(
                        fontSize: 10.sp,
                        color: AppColors.success,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  )
                else
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.warning.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Text(
                      'Draft',
                      style: TextStyle(
                        fontSize: 10.sp,
                        color: AppColors.warning,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                if (isOwner) ...[
                  SizedBox(width: 8.w),
                  PopupMenuButton<String>(
                    icon: Icon(
                      Icons.more_vert,
                      size: 20.sp,
                      color: AppColors.textSecondary,
                    ),
                    onSelected: (value) {
                      switch (value) {
                        case 'edit':
                          onEdit?.call();
                          break;
                        case 'delete':
                          onDelete?.call();
                          break;
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'edit',
                        child: Text('Edit Chapter'),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Text(
                          'Delete Chapter',
                          style: TextStyle(color: AppColors.error),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
            SizedBox(height: 12.h),

            // Stats Row
            Row(
              children: [
                _buildStat(
                  Icons.notes,
                  Formatters.formatWordCount(chapter.wordCount),
                ),
                SizedBox(width: 16.w),
                _buildStat(
                  Icons.remove_red_eye_outlined,
                  Formatters.formatNumber(chapter.viewCount),
                ),
                SizedBox(width: 16.w),
                _buildStat(
                  Icons.favorite_outline,
                  Formatters.formatNumber(chapter.likeCount),
                ),
                const Spacer(),
                Text(
                  Formatters.formatRelativeTime(chapter.updatedAt),
                  style: TextStyle(fontSize: 12.sp, color: AppColors.textHint),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStat(IconData icon, String value) {
    return Row(
      children: [
        Icon(icon, size: 14.sp, color: AppColors.textSecondary),
        SizedBox(width: 4.w),
        Text(
          value,
          style: TextStyle(fontSize: 12.sp, color: AppColors.textSecondary),
        ),
      ],
    );
  }
}
