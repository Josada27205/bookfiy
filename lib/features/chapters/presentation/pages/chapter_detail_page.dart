import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/formatters.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../books/domain/entities/book.dart';
import '../../domain/entities/chapter.dart';
import '../bloc/chapter_bloc.dart';

class ChapterDetailPage extends StatefulWidget {
  final Book book;
  final Chapter chapter;

  const ChapterDetailPage({
    super.key,
    required this.book,
    required this.chapter,
  });

  @override
  State<ChapterDetailPage> createState() => _ChapterDetailPageState();
}

class _ChapterDetailPageState extends State<ChapterDetailPage> {
  late Chapter _chapter;
  bool _isLiked = false;

  @override
  void initState() {
    super.initState();
    _chapter = widget.chapter;
    _checkIfLiked();
    _incrementViewCount();
  }

  void _checkIfLiked() async {
    // TODO: Check if chapter is liked
  }

  void _incrementViewCount() {
    // TODO: Increment view count
  }

  bool get _isOwner {
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated) {
      return authState.user.id == widget.book.authorId;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ChapterBloc, ChapterState>(
      listener: (context, state) {
        if (state is ChapterLiked && state.chapterId == _chapter.id) {
          setState(() => _isLiked = true);
        } else if (state is ChapterUnliked && state.chapterId == _chapter.id) {
          setState(() => _isLiked = false);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.backgroundWhite,
        appBar: AppBar(
          backgroundColor: AppColors.surface,
          elevation: 0,
          title: Column(
            children: [
              Text(
                widget.book.title,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.textSecondary,
                ),
              ),
              Text(
                Formatters.formatChapterNumber(_chapter.chapterNumber),
                style: TextStyle(fontSize: 12.sp, color: AppColors.textHint),
              ),
            ],
          ),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () {
                if (_isLiked) {
                  context.read<ChapterBloc>().add(
                    UnlikeChapterRequested(
                      bookId: widget.book.id,
                      chapterId: _chapter.id,
                    ),
                  );
                } else {
                  context.read<ChapterBloc>().add(
                    LikeChapterRequested(
                      bookId: widget.book.id,
                      chapterId: _chapter.id,
                    ),
                  );
                }
              },
              icon: Icon(
                _isLiked ? Icons.favorite : Icons.favorite_outline,
                color: _isLiked ? AppColors.error : AppColors.textSecondary,
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Chapter Header
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(24.w),
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.shadowColor.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _chapter.title,
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(
                            color: AppColors.textWhite,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    SizedBox(height: 12.h),
                    Row(
                      children: [
                        _buildHeaderStat(
                          Icons.notes,
                          Formatters.formatWordCount(_chapter.wordCount),
                        ),
                        SizedBox(width: 24.w),
                        _buildHeaderStat(
                          Icons.remove_red_eye_outlined,
                          '${Formatters.formatNumber(_chapter.viewCount)} views',
                        ),
                        SizedBox(width: 24.w),
                        _buildHeaderStat(
                          Icons.favorite_outline,
                          '${Formatters.formatNumber(_chapter.likeCount)} likes',
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'Published ${Formatters.formatRelativeTime(_chapter.publishedAt ?? _chapter.createdAt)}',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: AppColors.textWhite.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
              ),

              // Author's Note (if any)
              if (_chapter.authorNote != null &&
                  _chapter.authorNote!.isNotEmpty)
                Container(
                  margin: EdgeInsets.all(24.w),
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceVariant,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: AppColors.primaryGreen.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.note,
                            size: 16.sp,
                            color: AppColors.primaryGreen,
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            'Author\'s Note',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primaryGreen,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        _chapter.authorNote!,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: AppColors.textSecondary,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),

              // Chapter Content
              Padding(
                padding: EdgeInsets.all(24.w),
                child: Text(
                  _chapter.content,
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: AppColors.textPrimary,
                    height: 1.8,
                  ),
                ),
              ),

              // Chapter Navigation
              Container(
                padding: EdgeInsets.all(24.w),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.shadowColor.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, -4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // TODO: Previous Chapter Button
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: null, // TODO: Navigate to previous chapter
                        icon: const Icon(Icons.arrow_back),
                        label: const Text('Previous'),
                      ),
                    ),
                    SizedBox(width: 16.w),
                    // TODO: Next Chapter Button
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: null, // TODO: Navigate to next chapter
                        icon: const Icon(Icons.arrow_forward),
                        label: const Text('Next'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryGreen,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderStat(IconData icon, String value) {
    return Row(
      children: [
        Icon(icon, size: 16.sp, color: AppColors.textWhite.withOpacity(0.9)),
        SizedBox(width: 6.w),
        Text(
          value,
          style: TextStyle(
            fontSize: 14.sp,
            color: AppColors.textWhite.withOpacity(0.9),
          ),
        ),
      ],
    );
  }
}
