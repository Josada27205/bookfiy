import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/formatters.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../books/domain/entities/book.dart';
import '../../../books/domain/usecases/get_books_usecase.dart';
import '../../../books/presentation/bloc/book_bloc.dart';
import '../../../books/presentation/pages/book_detail_page.dart';
import '../../../books/presentation/pages/search_page.dart';

class EnhancedHomePage extends StatefulWidget {
  const EnhancedHomePage({super.key});

  @override
  State<EnhancedHomePage> createState() => _EnhancedHomePageState();
}

class _EnhancedHomePageState extends State<EnhancedHomePage> {
  final CarouselSliderControllerImpl _carouselController =
      CarouselSliderControllerImpl();
  List<Book> _trendingBooks = [];
  List<Book> _recentBooks = [];
  Map<BookGenre, List<Book>> _booksByGenre = {};

  @override
  void initState() {
    super.initState();
    _loadBooks();
  }

  void _loadBooks() {
    // Load trending books
    context.read<BookBloc>().add(
      const GetBooksRequested(
        params: GetBooksParams(type: GetBooksType.trending, limit: 10),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthBloc>().state;
    final userName = authState is AuthAuthenticated
        ? authState.user.fullName.split(' ')[0]
        : 'ผู้อ่าน';

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: BlocListener<BookBloc, BookState>(
        listener: (context, state) {
          if (state is BooksLoaded) {
            setState(() {
              _trendingBooks = state.books.take(5).toList();
              _recentBooks = state.books.skip(5).toList();

              // Group books by genre
              _booksByGenre.clear();
              for (final book in state.books) {
                for (final genre in book.genres) {
                  _booksByGenre.putIfAbsent(genre, () => []).add(book);
                }
              }
            });
          }
        },
        child: CustomScrollView(
          slivers: [
            // App Bar
            SliverAppBar(
              floating: true,
              backgroundColor: AppColors.surface,
              elevation: 0,
              title: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8.w),
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Icon(
                      Icons.book_rounded,
                      size: 20.sp,
                      color: AppColors.textWhite,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ສະບາຍດີ, $userName 👋',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      Text(
                        'ມາອ່ານຫຍັງດີມື້ນີ?',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SearchPage(),
                      ),
                    );
                  },
                  icon: Icon(
                    Icons.search_rounded,
                    color: AppColors.primaryGreen,
                    size: 28.sp,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    // TODO: Navigate to notifications
                  },
                  icon: Stack(
                    children: [
                      Icon(
                        Icons.notifications_outlined,
                        color: AppColors.textPrimary,
                        size: 28.sp,
                      ),
                      Positioned(
                        right: 0,
                        top: 0,
                        child: Container(
                          width: 8.w,
                          height: 8.h,
                          decoration: const BoxDecoration(
                            color: AppColors.error,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Content
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Banner Carousel
                  if (_trendingBooks.isNotEmpty) ...[
                    SizedBox(height: 20.h),
                    _buildBannerCarousel(),
                  ],

                  // Quick Categories
                  SizedBox(height: 24.h),
                  _buildQuickCategories(),

                  // Recent Updates
                  if (_recentBooks.isNotEmpty) ...[
                    SizedBox(height: 32.h),
                    _buildSectionHeader('ອັບເດດລ່າສຸດ 🆕', () {}),
                    SizedBox(height: 16.h),
                    _buildHorizontalBookList(_recentBooks),
                  ],

                  // Books by Genre
                  ..._booksByGenre.entries.map((entry) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 32.h),
                        _buildSectionHeader(_getGenreTitle(entry.key), () {
                          // TODO: Navigate to genre page
                        }),
                        SizedBox(height: 16.h),
                        _buildHorizontalBookList(entry.value.take(10).toList()),
                      ],
                    );
                  }).toList(),

                  SizedBox(height: 100.h), // Bottom padding
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBannerCarousel() {
    return CarouselSlider.builder(
      carouselController: _carouselController,
      itemCount: _trendingBooks.length,
      options: CarouselOptions(
        height: 200.h,
        viewportFraction: 0.9,
        enlargeCenterPage: true,
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 5),
        onPageChanged: (index, reason) {
          setState(() {});
        },
      ),
      itemBuilder: (context, index, realIndex) {
        final book = _trendingBooks[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BookDetailPage(book: book),
              ),
            );
          },
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 4.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.r),
              boxShadow: [
                BoxShadow(
                  color: AppColors.shadowColor.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Background Image
                ClipRRect(
                  borderRadius: BorderRadius.circular(20.r),
                  child: book.coverUrl != null
                      ? CachedNetworkImage(
                          imageUrl: book.coverUrl!,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Shimmer.fromColors(
                            baseColor: AppColors.surfaceVariant,
                            highlightColor: AppColors.surface,
                            child: Container(color: AppColors.surfaceVariant),
                          ),
                        )
                      : Container(
                          decoration: const BoxDecoration(
                            gradient: AppColors.primaryGradient,
                          ),
                        ),
                ),

                // Gradient Overlay
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.r),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.8),
                      ],
                    ),
                  ),
                ),

                // Content
                Positioned(
                  bottom: 20.h,
                  left: 20.w,
                  right: 20.w,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primaryGreen,
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Text(
                          '🔥 ກຳລັງຮິດ',
                          style: TextStyle(
                            fontSize: 10.sp,
                            color: AppColors.textWhite,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        book.title,
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textWhite,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        'ໂດຍ ${book.authorName}',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: AppColors.textWhite.withOpacity(0.9),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildQuickCategories() {
    final categories = [
      {'icon': '💕', 'title': 'ໂລແມນຕິກ', 'genre': BookGenre.romance},
      {'icon': '🔮', 'title': 'ແຟນຕາຊີນ', 'genre': BookGenre.fantasy},
      {'icon': '🔍', 'title': 'ສືບສວນ', 'genre': BookGenre.mystery},
      {'icon': '😱', 'title': 'ສະຍອງຂວັນ', 'genre': BookGenre.horror},
      {'icon': '🚀', 'title': 'ໄຊໄຟ', 'genre': BookGenre.scienceFiction},
      {'icon': '🎭', 'title': 'ດຣາມ່າ', 'genre': BookGenre.drama},
    ];

    return Container(
      height: 100.h,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return GestureDetector(
            onTap: () {
              // TODO: Navigate to genre page
            },
            child: Container(
              width: 80.w,
              margin: EdgeInsets.only(right: 12.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 60.w,
                    height: 60.h,
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      borderRadius: BorderRadius.circular(16.r),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primaryGreen.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        category['icon'] as String,
                        style: TextStyle(fontSize: 28.sp),
                      ),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    category['title'] as String,
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(String title, VoidCallback onSeeAll) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          TextButton(
            onPressed: onSeeAll,
            child: Text(
              'ເບິ່ງທັງໝົດ',
              style: TextStyle(
                fontSize: 14.sp,
                color: AppColors.primaryGreen,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHorizontalBookList(List<Book> books) {
    return SizedBox(
      height: 240.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemCount: books.length,
        itemBuilder: (context, index) {
          final book = books[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BookDetailPage(book: book),
                ),
              );
            },
            child: Container(
              width: 140.w,
              margin: EdgeInsets.only(right: 12.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Book Cover
                  Container(
                    height: 180.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.r),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.shadowColor.withOpacity(0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12.r),
                      child: book.coverUrl != null
                          ? CachedNetworkImage(
                              imageUrl: book.coverUrl!,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Shimmer.fromColors(
                                baseColor: AppColors.surfaceVariant,
                                highlightColor: AppColors.surface,
                                child: Container(
                                  color: AppColors.surfaceVariant,
                                ),
                              ),
                            )
                          : Container(
                              decoration: const BoxDecoration(
                                gradient: AppColors.primaryGradient,
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.book_rounded,
                                  size: 40.sp,
                                  color: AppColors.textWhite,
                                ),
                              ),
                            ),
                    ),
                  ),
                  SizedBox(height: 8.h),

                  // Title
                  Text(
                    book.title,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4.h),

                  // Stats
                  Row(
                    children: [
                      Icon(
                        Icons.remove_red_eye_outlined,
                        size: 12.sp,
                        color: AppColors.textHint,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        Formatters.formatNumber(book.viewCount),
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: AppColors.textHint,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Icon(
                        Icons.favorite_outline,
                        size: 12.sp,
                        color: AppColors.textHint,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        Formatters.formatNumber(book.likeCount),
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: AppColors.textHint,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  String _getGenreTitle(BookGenre genre) {
    switch (genre) {
      case BookGenre.fiction:
        return 'ນິຍາຍທົ່ວໄປ 📚';
      case BookGenre.romance:
        return 'ໂລແມນຕິກ 💕';
      case BookGenre.fantasy:
        return 'ແນ 🔮';
      case BookGenre.mystery:
        return 'ลึกลับสืบสวน 🔍';
      case BookGenre.horror:
        return 'สยองขวัญ 😱';
      case BookGenre.scienceFiction:
        return 'ไซไฟ 🚀';
      case BookGenre.thriller:
        return 'ระทึกขวัญ 💥';
      case BookGenre.drama:
        return 'ดราม่า 🎭';
      case BookGenre.adventure:
        return 'ผจญภัย ⚔️';
      case BookGenre.poetry:
        return 'กวีนิพนธ์ 🖋️';
      case BookGenre.historical:
        return 'ประวัติศาสตร์ 📜';
      case BookGenre.selfHelp:
        return 'พัฒนาตนเอง 🌱';
      case BookGenre.biography:
        return 'ชีวประวัติ 👤';
      case BookGenre.nonFiction:
        return 'สารคดี 📖';
      case BookGenre.other:
        return 'อื่นๆ 📝';
    }
  }
}
