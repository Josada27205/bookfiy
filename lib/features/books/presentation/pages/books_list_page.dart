import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../domain/usecases/get_books_usecase.dart';
import '../bloc/book_bloc.dart';
import '../widgets/book_card.dart';
import 'book_detail_page.dart';
import 'search_page.dart';

class BooksListPage extends StatefulWidget {
  const BooksListPage({super.key});

  @override
  State<BooksListPage> createState() => _BooksListPageState();
}

class _BooksListPageState extends State<BooksListPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadBooks();
  }

  void _loadBooks() {
    context.read<BookBloc>().add(
      const GetBooksRequested(
        params: GetBooksParams(type: GetBooksType.trending, limit: 20),
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: EdgeInsets.all(24.w),
              decoration: BoxDecoration(
                color: AppColors.surface,
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'สวัสดี 👋',
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(color: AppColors.textSecondary),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            'ค้นพบเรื่องราวที่น่าทึ่ง',
                            style: Theme.of(context).textTheme.headlineSmall
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SearchPage(),
                            ),
                          );
                        },
                        icon: Container(
                          padding: EdgeInsets.all(8.w),
                          decoration: BoxDecoration(
                            gradient: AppColors.primaryGradient,
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Icon(
                            Icons.search,
                            color: AppColors.textWhite,
                            size: 24.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h),
                  // Tabs
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.backgroundGrey,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: TabBar(
                      controller: _tabController,
                      indicator: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      indicatorSize: TabBarIndicatorSize.tab,
                      labelColor: AppColors.textWhite,
                      unselectedLabelColor: AppColors.textSecondary,
                      labelStyle: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                      ),
                      tabs: const [
                        Tab(text: 'กำลังฮิต 🔥'),
                        Tab(text: 'ล่าสุด ✨'),
                        Tab(text: 'ยอดนิยม ⭐'),
                      ],
                      onTap: (index) {
                        switch (index) {
                          case 0:
                            context.read<BookBloc>().add(
                              const GetBooksRequested(
                                params: GetBooksParams(
                                  type: GetBooksType.trending,
                                  limit: 20,
                                ),
                              ),
                            );
                            break;
                          case 1:
                            context.read<BookBloc>().add(
                              const GetBooksRequested(
                                params: GetBooksParams(
                                  type: GetBooksType.recentlyUpdated,
                                  limit: 20,
                                ),
                              ),
                            );
                            break;
                          case 2:
                            context.read<BookBloc>().add(
                              const GetBooksRequested(
                                params: GetBooksParams(
                                  type: GetBooksType.published,
                                  limit: 20,
                                ),
                              ),
                            );
                            break;
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),

            // Books List
            Expanded(
              child: BlocBuilder<BookBloc, BookState>(
                builder: (context, state) {
                  if (state is BookLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is BooksLoaded) {
                    if (state.books.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.book_outlined,
                              size: 80.sp,
                              color: AppColors.textHint,
                            ),
                            SizedBox(height: 16.h),
                            Text(
                              AppStrings.noBooksYet,
                              style: Theme.of(context).textTheme.headlineSmall
                                  ?.copyWith(color: AppColors.textSecondary),
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              'Be the first to write a story!',
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(color: AppColors.textHint),
                            ),
                          ],
                        ),
                      );
                    }

                    return RefreshIndicator(
                      onRefresh: () async {
                        _loadBooks();
                      },
                      color: AppColors.primaryGreen,
                      child: ListView.builder(
                        padding: EdgeInsets.all(24.w),
                        itemCount: state.books.length,
                        itemBuilder: (context, index) {
                          final book = state.books[index];
                          return BookCard(
                            book: book,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      BookDetailPage(book: book),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    );
                  } else if (state is BookError) {
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
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(color: AppColors.textSecondary),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 24.h),
                          ElevatedButton(
                            onPressed: _loadBooks,
                            child: const Text('Try Again'),
                          ),
                        ],
                      ),
                    );
                  }

                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
