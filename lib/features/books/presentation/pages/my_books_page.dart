import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:readawwrite_clone/features/books/presentation/pages/create_book_page.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../domain/usecases/get_books_usecase.dart';
import '../bloc/book_bloc.dart';
import '../widgets/book_card.dart';
import 'book_detail_page.dart';

class MyBooksPage extends StatefulWidget {
  const MyBooksPage({super.key});

  @override
  State<MyBooksPage> createState() => _MyBooksPageState();
}

class _MyBooksPageState extends State<MyBooksPage> {
  @override
  void initState() {
    super.initState();
    _loadMyBooks();
  }

  void _loadMyBooks() {
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated) {
      context.read<BookBloc>().add(
        GetBooksRequested(
          params: GetBooksParams(
            type: GetBooksType.userBooks,
            userId: authState.user.id,
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
        title: const Text(AppStrings.myBooks),
        centerTitle: true,
        backgroundColor: AppColors.surface,
        elevation: 0,
      ),
      body: BlocBuilder<BookBloc, BookState>(
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
                      'You haven\'t written any books yet',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(color: AppColors.textSecondary),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'Start writing your first story!',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textHint,
                      ),
                    ),
                    SizedBox(height: 24.h),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CreateBookPage(),
                          ),
                        ).then((_) => _loadMyBooks());
                      },
                      icon: const Icon(Icons.add),
                      label: const Text(AppStrings.createBook),
                    ),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () async {
                _loadMyBooks();
              },
              color: AppColors.primaryGreen,
              child: ListView.builder(
                padding: EdgeInsets.all(24.w),
                itemCount: state.books.length,
                itemBuilder: (context, index) {
                  final book = state.books[index];
                  return BookCard(
                    book: book,
                    showAuthor: false,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BookDetailPage(book: book),
                        ),
                      ).then((_) => _loadMyBooks());
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
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 24.h),
                  ElevatedButton(
                    onPressed: _loadMyBooks,
                    child: const Text('Try Again'),
                  ),
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
