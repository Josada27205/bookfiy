import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/validators.dart';
import '../../../auth/presentation/widgets/auth_text_field.dart';
import '../../../auth/presentation/widgets/auth_button.dart';
import '../../domain/entities/book.dart';

class BookForm extends StatefulWidget {
  final Book? book;
  final Function(
    String title,
    String description,
    List<BookGenre> genres,
    String? coverPath,
    List<String> tags,
    bool isAdult,
  )
  onSubmit;
  final bool isLoading;

  const BookForm({
    super.key,
    this.book,
    required this.onSubmit,
    this.isLoading = false,
  });

  @override
  State<BookForm> createState() => _BookFormState();
}

class _BookFormState extends State<BookForm> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _tagsController = TextEditingController();

  final List<BookGenre> _selectedGenres = [];
  bool _isAdult = false;
  File? _coverImage;
  final _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    if (widget.book != null) {
      _titleController.text = widget.book!.title;
      _descriptionController.text = widget.book!.description;
      _selectedGenres.addAll(widget.book!.genres);
      _tagsController.text = widget.book!.tags.join(', ');
      _isAdult = widget.book!.isAdult;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _tagsController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxHeight: 1080,
        maxWidth: 720,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _coverImage = File(image.path);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to pick image: ${e.toString()}'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      if (_selectedGenres.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select at least one genre'),
            backgroundColor: AppColors.error,
          ),
        );
        return;
      }

      final tags = _tagsController.text
          .split(',')
          .map((tag) => tag.trim())
          .where((tag) => tag.isNotEmpty)
          .toList();

      widget.onSubmit(
        _titleController.text.trim(),
        _descriptionController.text.trim(),
        _selectedGenres,
        _coverImage?.path,
        tags,
        _isAdult,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Cover Image
          Center(
            child: GestureDetector(
              onTap: _pickImage,
              child: Container(
                width: 150.w,
                height: 200.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.r),
                  gradient: _coverImage == null && widget.book?.coverUrl == null
                      ? AppColors.primaryGradient
                      : null,
                  image: _coverImage != null
                      ? DecorationImage(
                          image: FileImage(_coverImage!),
                          fit: BoxFit.cover,
                        )
                      : widget.book?.coverUrl != null
                      ? DecorationImage(
                          image: NetworkImage(widget.book!.coverUrl!),
                          fit: BoxFit.cover,
                        )
                      : null,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.shadowColor.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: (_coverImage == null && widget.book?.coverUrl == null)
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add_photo_alternate_outlined,
                            size: 40.sp,
                            color: AppColors.textWhite,
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            'Add Cover',
                            style: TextStyle(
                              color: AppColors.textWhite,
                              fontSize: 14.sp,
                            ),
                          ),
                        ],
                      )
                    : null,
              ),
            ),
          ),
          SizedBox(height: 24.h),

          // Title
          AuthTextField(
            controller: _titleController,
            hintText: 'Enter book title',
            labelText: AppStrings.bookTitle,
            prefixIcon: Icons.title,
            validator: Validators.bookTitle,
            textInputAction: TextInputAction.next,
          ),
          SizedBox(height: 16.h),

          // Description
          AuthTextField(
            controller: _descriptionController,
            hintText: 'Enter book description',
            labelText: AppStrings.bookDescription,
            prefixIcon: Icons.description_outlined,
            validator: Validators.bookDescription,
            maxLines: 4,
            textInputAction: TextInputAction.next,
          ),
          SizedBox(height: 16.h),

          // Genres
          Text(
            'Genres',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8.h),
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: BookGenre.values.map((genre) {
              final isSelected = _selectedGenres.contains(genre);
              return ChoiceChip(
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
                },
                selectedColor: AppColors.primaryGreen,
                backgroundColor: AppColors.surfaceVariant,
                labelStyle: TextStyle(
                  color: isSelected
                      ? AppColors.textWhite
                      : AppColors.textPrimary,
                  fontSize: 12.sp,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.r),
                ),
              );
            }).toList(),
          ),
          SizedBox(height: 16.h),

          // Tags
          AuthTextField(
            controller: _tagsController,
            hintText: 'Enter tags separated by commas',
            labelText: 'Tags',
            prefixIcon: Icons.label_outline,
            textInputAction: TextInputAction.done,
          ),
          SizedBox(height: 16.h),

          // Adult Content Switch
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.warning_amber_rounded,
                      color: AppColors.warning,
                      size: 20.sp,
                    ),
                    SizedBox(width: 12.w),
                    Text(
                      'Adult Content',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ],
                ),
                Switch(
                  value: _isAdult,
                  onChanged: (value) {
                    setState(() {
                      _isAdult = value;
                    });
                  },
                  activeColor: AppColors.primaryGreen,
                ),
              ],
            ),
          ),
          SizedBox(height: 32.h),

          // Submit Button
          AuthButton(
            text: widget.book == null ? AppStrings.createBook : 'Update Book',
            onPressed: _handleSubmit,
            isLoading: widget.isLoading,
          ),
        ],
      ),
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
