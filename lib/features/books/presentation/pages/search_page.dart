import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../domain/entities/book.dart';
import '../../domain/usecases/get_books_usecase.dart';
import '../bloc/book_bloc.dart';
import '../widgets/book_card.dart';
import 'book_detail_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _searchController = TextEditingController();
  final _focusNode = FocusNode();
  List<BookGenre> _selectedGenres = [];

  @override
  void initState() {
    super.initState();
    _focusNode.requestFocus();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _performSearch() {
    final query = _searchController.text.trim();
    if (query.isNotEmpty || _selectedGenres.isNotEmpty) {
      context.read<BookBloc>().add(
        GetBooksRequested(
          params: GetBooksParams(
            type: GetBooksType.search,
            query: query,
            genres: _selectedGenres,
            status: BookStatus.published,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: TextField(
          controller: _searchController,
          focusNode: _focusNode,
          onSubmitted: (_) => _performSearch(),
          decoration: InputDecoration(
            hintText: 'ค้นหาหนังสือ...',
            hintStyle: TextStyle(color: AppColors.textHint, fontSize: 16.sp),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(horizontal: 16.w),
          ),
          style: TextStyle(fontSize: 16.sp, color: AppColors.textPrimary),
        ),
        actions: [
          IconButton(
            onPressed: _performSearch,
            icon: Icon(Icons.search, color: AppColors.primaryGreen),
          ),
        ],
      ),
      body: Column(
        children: [
          // Genre Filter
          Container(
            height: 50.h,
            padding: EdgeInsets.symmetric(vertical: 8.h),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              itemCount: BookGenre.values.length,
              itemBuilder: (context, index) {
                final genre = BookGenre.values[index];
                final isSelected = _selectedGenres.contains(genre);
                return Padding(
                  padding: EdgeInsets.only(right: 8.w),
                  child: FilterChip(
                    label: Text(_formatGenre(genre)),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          _selectedGenres.add(genre);
                        } else {
                          _selectedGenres.remove(genre);
                        }
                      });
                      _performSearch();
                    },
                    selectedColor: AppColors.primaryGreen,
                    backgroundColor: AppColors.surfaceVariant,
                    labelStyle: TextStyle(
                      color: isSelected
                          ? AppColors.textWhite
                          : AppColors.textPrimary,
                      fontSize: 12.sp,
                    ),
                  ),
                );
              },
            ),
          ),

          // Search Results
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
                            Icons.search_off,
                            size: 80.sp,
                            color: AppColors.textHint,
                          ),
                          SizedBox(height: 16.h),
                          Text(
                            'ไม่พบหนังสือที่ค้นหา',
                            style: Theme.of(context).textTheme.headlineSmall
                                ?.copyWith(color: AppColors.textSecondary),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            'ลองค้นหาด้วยคำอื่น',
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(color: AppColors.textHint),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: EdgeInsets.all(16.w),
                    itemCount: state.books.length,
                    itemBuilder: (context, index) {
                      final book = state.books[index];
                      return BookCard(
                        book: book,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BookDetailPage(book: book),
                            ),
                          );
                        },
                      );
                    },
                  );
                }

                return Center(
                  child: Text(
                    'เริ่มค้นหาหนังสือที่คุณชอบ',
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: AppColors.textHint,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  String _formatGenre(BookGenre genre) {
    switch (genre) {
      case BookGenre.fiction:
        return 'นิยาย';
      case BookGenre.nonFiction:
        return 'สารคดี';
      case BookGenre.romance:
        return 'โรแมนติก';
      case BookGenre.mystery:
        return 'ลึกลับ';
      case BookGenre.fantasy:
        return 'แฟนตาซี';
      case BookGenre.scienceFiction:
        return 'ไซไฟ';
      case BookGenre.thriller:
        return 'ระทึกขวัญ';
      case BookGenre.horror:
        return 'สยองขวัญ';
      case BookGenre.poetry:
        return 'กวีนิพนธ์';
      case BookGenre.drama:
        return 'ดราม่า';
      case BookGenre.adventure:
        return 'ผจญภัย';
      case BookGenre.historical:
        return 'ประวัติศาสตร์';
      case BookGenre.selfHelp:
        return 'พัฒนาตนเอง';
      case BookGenre.biography:
        return 'ชีวประวัติ';
      case BookGenre.other:
        return 'อื่นๆ';
    }
  }
}
