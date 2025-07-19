import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../bloc/book_bloc.dart';
import '../widgets/book_form.dart';
import 'book_detail_page.dart';

class CreateBookPage extends StatelessWidget {
  const CreateBookPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<BookBloc, BookState>(
      listener: (context, state) {
        if (state is BookCreated) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppStrings.bookCreatedSuccessfully),
              backgroundColor: AppColors.success,
            ),
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => BookDetailPage(book: state.book),
            ),
          );
        } else if (state is BookError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.error,
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.backgroundLight,
        appBar: AppBar(
          title: const Text(AppStrings.createBook),
          centerTitle: true,
          backgroundColor: AppColors.surface,
          elevation: 0,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(24.w),
            child: BlocBuilder<BookBloc, BookState>(
              builder: (context, state) {
                return BookForm(
                  onSubmit:
                      (
                        title,
                        description,
                        genres,
                        coverPath,
                        tags,
                        isAdult,
                      ) async {
                        // TODO: Upload cover image if provided
                        context.read<BookBloc>().add(
                          CreateBookRequested(
                            title: title,
                            description: description,
                            genres: genres,
                            coverUrl: null, // Will be updated after upload
                            tags: tags,
                            isAdult: isAdult,
                          ),
                        );
                      },
                  isLoading: state is BookLoading,
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
