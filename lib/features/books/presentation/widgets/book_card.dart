import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/formatters.dart';
import '../../domain/entities/book.dart';

class BookCard extends StatelessWidget {
  final Book book;
  final VoidCallback? onTap;
  final bool showAuthor;
  final bool showStats;

  const BookCard({
    super.key,
    required this.book,
    this.onTap,
    this.showAuthor = true,
    this.showStats = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 16.h),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowColor.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Book Cover
            Container(
              width: 100.w,
              height: 140.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16.r),
                  bottomLeft: Radius.circular(16.r),
                ),
                gradient: book.coverUrl == null
                    ? AppColors.primaryGradient
                    : null,
              ),
              child: book.coverUrl != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16.r),
                        bottomLeft: Radius.circular(16.r),
                      ),
                      child: CachedNetworkImage(
                        imageUrl: book.coverUrl!,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          decoration: const BoxDecoration(
                            gradient: AppColors.primaryGradient,
                          ),
                          child: const Center(
                            child: CircularProgressIndicator(
                              color: AppColors.textWhite,
                            ),
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          decoration: const BoxDecoration(
                            gradient: AppColors.primaryGradient,
                          ),
                          child: Icon(
                            Icons.book_rounded,
                            size: 40.sp,
                            color: AppColors.textWhite,
                          ),
                        ),
                      ),
                    )
                  : Center(
                      child: Icon(
                        Icons.book_rounded,
                        size: 40.sp,
                        color: AppColors.textWhite,
                      ),
                    ),
            ),

            // Book Info
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      book.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    if (showAuthor) ...[
                      SizedBox(height: 4.h),
                      Text(
                        'by ${book.authorName}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],

                    SizedBox(height: 8.h),

                    // Genres
                    Wrap(
                      spacing: 6.w,
                      runSpacing: 4.h,
                      children: book.genres.take(3).map((genre) {
                        return Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 2.h,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primaryGreen.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Text(
                            _formatGenre(genre),
                            style: TextStyle(
                              fontSize: 10.sp,
                              color: AppColors.primaryGreen,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        );
                      }).toList(),
                    ),

                    if (showStats) ...[
                      SizedBox(height: 12.h),
                      Row(
                        children: [
                          _buildStat(
                            Icons.menu_book_rounded,
                            '${book.chapterCount}',
                          ),
                          SizedBox(width: 16.w),
                          _buildStat(
                            Icons.remove_red_eye_outlined,
                            Formatters.formatNumber(book.viewCount),
                          ),
                          SizedBox(width: 16.w),
                          _buildStat(
                            Icons.favorite_outline,
                            Formatters.formatNumber(book.likeCount),
                          ),
                          const Spacer(),
                          if (book.status == BookStatus.published)
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
                          else if (book.status == BookStatus.completed)
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8.w,
                                vertical: 4.h,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.info.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              child: Text(
                                'Completed',
                                style: TextStyle(
                                  fontSize: 10.sp,
                                  color: AppColors.info,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
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

  String _formatGenre(BookGenre genre) {
    switch (genre) {
      case BookGenre.scienceFiction:
        return 'Sci-Fi';
      case BookGenre.nonFiction:
        return 'Non-Fiction';
      case BookGenre.selfHelp:
        return 'Self-Help';
      default:
        return genre.name
            .replaceAllMapped(
              RegExp(r'([A-Z])'),
              (match) => ' ${match.group(0)}',
            )
            .trim();
    }
  }
}
