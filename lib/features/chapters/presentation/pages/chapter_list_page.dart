import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/formatters.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../books/domain/entities/book.dart';
import '../bloc/chapter_bloc.dart';
import '../widgets/chapter_card.dart';
import 'write_chapter_page.dart';
import 'chapter_detail_page.dart';

class ChapterListPage extends StatefulWidget {
  final Book book;

  const ChapterListPage({super.key, required this.book});

  @override
  State<ChapterListPage> createState() => _ChapterListPageState();
}

class _ChapterListPageState extends State<ChapterListPage> {
  @override
  void initState() {
    super.initState();
    _loadChapters();
  }

  void _loadChapters() {
    context.read<ChapterBloc>().add(
      GetChaptersRequested(bookId: widget.book.id),
    );
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
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: Text(widget.book.title),
        centerTitle: true,
        backgroundColor: AppColors.surface,
        elevation: 0,
        actions: [
          if (_isOwner)
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WriteChapterPage(book: widget.book),
                  ),
                ).then((_) => _loadChapters());
              },
              icon: Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(Icons.add, color: AppColors.textWhite, size: 20.sp),
              ),
            ),
        ],
      ),
      body: BlocBuilder<ChapterBloc, ChapterState>(
        builder: (context, state) {
          if (state is ChapterLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ChaptersLoaded) {
            if (state.chapters.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.library_books_outlined,
                      size: 80.sp,
                      color: AppColors.textHint,
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      AppStrings.noChaptersYet,
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(color: AppColors.textSecondary),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      _isOwner
                          ? AppStrings.addYourFirstChapter
                          : 'The author hasn\'t added any chapters yet',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textHint,
                      ),
                    ),
                    if (_isOwner) ...[
                      SizedBox(height: 24.h),
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  WriteChapterPage(book: widget.book),
                            ),
                          ).then((_) => _loadChapters());
                        },
                        icon: const Icon(Icons.add),
                        label: const Text(AppStrings.addChapter),
                      ),
                    ],
                  ],
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () async {
                _loadChapters();
              },
              color: AppColors.primaryGreen,
              child: ListView.builder(
                padding: EdgeInsets.all(24.w),
                itemCount: state.chapters.length,
                itemBuilder: (context, index) {
                  final chapter = state.chapters[index];
                  return ChapterCard(
                    chapter: chapter,
                    isOwner: _isOwner,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChapterDetailPage(
                            book: widget.book,
                            chapter: chapter,
                          ),
                        ),
                      );
                    },
                    onEdit: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => WriteChapterPage(
                            book: widget.book,
                            chapter: chapter,
                          ),
                        ),
                      ).then((_) => _loadChapters());
                    },
                    onDelete: () {
                      _showDeleteDialog(chapter.id);
                    },
                  );
                },
              ),
            );
          } else if (state is ChapterError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 80.sp,
                    color: AppColors.error,
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    AppStrings.somethingWentWrong,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    state.message,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 24.h),
                  ElevatedButton(
                    onPressed: _loadChapters,
                    child: const Text('Try Again'),
                  ),
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: _isOwner
          ? FloatingActionButton.extended(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WriteChapterPage(book: widget.book),
                  ),
                ).then((_) => _loadChapters());
              },
              backgroundColor: AppColors.primaryGreen,
              icon: const Icon(Icons.add),
              label: const Text(AppStrings.addChapter),
            )
          : null,
    );
  }

  void _showDeleteDialog(String chapterId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(AppStrings.areYouSure),
        content: const Text(AppStrings.deleteChapterConfirmation),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(AppStrings.cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<ChapterBloc>().add(
                DeleteChapterRequested(
                  bookId: widget.book.id,
                  chapterId: chapterId,
                ),
              );
            },
            child: Text(
              AppStrings.delete,
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }
}
