import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/formatters.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../chapters/presentation/pages/chapter_list_page.dart';
import '../../domain/entities/book.dart';
import '../bloc/book_bloc.dart';

class BookDetailPage extends StatefulWidget {
  final Book book;

  const BookDetailPage({super.key, required this.book});

  @override
  State<BookDetailPage> createState() => _BookDetailPageState();
}

class _BookDetailPageState extends State<BookDetailPage> {
  late Book _book;
  bool _isLiked = false;

  @override
  void initState() {
    super.initState();
    _book = widget.book;
    _checkIfLiked();
    _incrementViewCount();
  }

  void _checkIfLiked() async {
    // TODO: Check if book is liked
  }

  void _incrementViewCount() {
    context.read<BookBloc>().add(IncrementViewCountRequested(bookId: _book.id));
  }

  bool get _isOwner {
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated) {
      return authState.user.id == _book.authorId;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<BookBloc, BookState>(
      listener: (context, state) {
        if (state is BookLiked && state.bookId == _book.id) {
          setState(() => _isLiked = true);
        } else if (state is BookUnliked && state.bookId == _book.id) {
          setState(() => _isLiked = false);
        }
      },
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            // App Bar with Cover
            SliverAppBar(
              expandedHeight: 300.h,
              pinned: true,
              backgroundColor: AppColors.primaryGreen,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: AppColors.textWhite),
                onPressed: () {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
              ),
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Cover Image
                    if (_book.coverUrl != null)
                      CachedNetworkImage(
                        imageUrl: _book.coverUrl!,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          decoration: const BoxDecoration(
                            gradient: AppColors.primaryGradient,
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          decoration: const BoxDecoration(
                            gradient: AppColors.primaryGradient,
                          ),
                          child: Icon(
                            Icons.book_rounded,
                            size: 80.sp,
                            color: AppColors.textWhite.withOpacity(0.5),
                          ),
                        ),
                      )
                    else
                      Container(
                        decoration: const BoxDecoration(
                          gradient: AppColors.primaryGradient,
                        ),
                        child: Icon(
                          Icons.book_rounded,
                          size: 80.sp,
                          color: AppColors.textWhite.withOpacity(0.5),
                        ),
                      ),

                    // Gradient Overlay
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.7),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                if (_isOwner)
                  PopupMenuButton<String>(
                    icon: const Icon(
                      Icons.more_vert,
                      color: AppColors.textWhite,
                    ),
                    onSelected: (value) {
                      switch (value) {
                        case 'edit':
                          // TODO: Navigate to edit page
                          break;
                        case 'delete':
                          _showDeleteDialog();
                          break;
                        case 'publish':
                          context.read<BookBloc>().add(
                            PublishBookRequested(bookId: _book.id),
                          );
                          break;
                        case 'unpublish':
                          context.read<BookBloc>().add(
                            UnpublishBookRequested(bookId: _book.id),
                          );
                          break;
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'edit',
                        child: Text('Edit Book'),
                      ),
                      if (_book.status == BookStatus.draft)
                        const PopupMenuItem(
                          value: 'publish',
                          child: Text('Publish Book'),
                        )
                      else if (_book.status == BookStatus.published)
                        const PopupMenuItem(
                          value: 'unpublish',
                          child: Text('Unpublish Book'),
                        ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Text(
                          'Delete Book',
                          style: TextStyle(color: AppColors.error),
                        ),
                      ),
                    ],
                  ),
              ],
            ),

            // Book Details
            SliverToBoxAdapter(
              child: Container(
                padding: EdgeInsets.all(24.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title and Author
                    Text(
                      _book.title,
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'by ${_book.authorName}',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    SizedBox(height: 16.h),

                    // Stats Row
                    Row(
                      children: [
                        _buildStat(
                          Icons.menu_book_rounded,
                          '${_book.chapterCount} Chapters',
                        ),
                        SizedBox(width: 24.w),
                        _buildStat(
                          Icons.remove_red_eye_outlined,
                          '${Formatters.formatNumber(_book.viewCount)} Views',
                        ),
                        SizedBox(width: 24.w),
                        _buildStat(
                          Icons.star_rounded,
                          _book.rating > 0
                              ? _book.rating.toStringAsFixed(1)
                              : 'N/A',
                        ),
                      ],
                    ),
                    SizedBox(height: 24.h),

                    // Action Buttons
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ChapterListPage(book: _book),
                                ),
                              );
                            },
                            icon: const Icon(Icons.play_arrow_rounded),
                            label: Text(
                              _book.chapterCount > 0
                                  ? AppStrings.continueReading
                                  : AppStrings.startReading,
                            ),
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 12.h),
                            ),
                          ),
                        ),
                        SizedBox(width: 12.w),
                        IconButton(
                          onPressed: () {
                            if (_isLiked) {
                              context.read<BookBloc>().add(
                                UnlikeBookRequested(bookId: _book.id),
                              );
                            } else {
                              context.read<BookBloc>().add(
                                LikeBookRequested(bookId: _book.id),
                              );
                            }
                          },
                          icon: Icon(
                            _isLiked ? Icons.favorite : Icons.favorite_outline,
                            color: _isLiked ? AppColors.error : null,
                          ),
                          style: IconButton.styleFrom(
                            backgroundColor: AppColors.surfaceVariant,
                            padding: EdgeInsets.all(12.w),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 24.h),

                    // Genres
                    Wrap(
                      spacing: 8.w,
                      runSpacing: 8.h,
                      children: _book.genres.map((genre) {
                        return Chip(
                          label: Text(_formatGenre(genre)),
                          backgroundColor: AppColors.primaryGreen.withOpacity(
                            0.1,
                          ),
                          labelStyle: TextStyle(
                            color: AppColors.primaryGreen,
                            fontSize: 12.sp,
                          ),
                        );
                      }).toList(),
                    ),
                    SizedBox(height: 24.h),

                    // Description
                    Text(
                      'Description',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    Text(
                      _book.description,
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(height: 1.6),
                    ),
                    SizedBox(height: 24.h),

                    // Tags
                    if (_book.tags.isNotEmpty) ...[
                      Text(
                        'Tags',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      SizedBox(height: 12.h),
                      Wrap(
                        spacing: 8.w,
                        runSpacing: 8.h,
                        children: _book.tags.map((tag) {
                          return Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12.w,
                              vertical: 6.h,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.surfaceVariant,
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                            child: Text(
                              '#$tag',
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          );
                        }).toList(),
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
        Icon(icon, size: 18.sp, color: AppColors.textSecondary),
        SizedBox(width: 6.w),
        Text(
          value,
          style: TextStyle(fontSize: 14.sp, color: AppColors.textPrimary),
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

  void _showDeleteDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(AppStrings.areYouSure),
        content: const Text(AppStrings.deleteBookConfirmation),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(AppStrings.cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<BookBloc>().add(
                DeleteBookRequested(bookId: _book.id),
              );
              Navigator.pop(context);
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
