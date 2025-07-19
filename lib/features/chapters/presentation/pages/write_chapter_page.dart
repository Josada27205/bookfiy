import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/validators.dart';
import '../../../auth/presentation/widgets/auth_text_field.dart';
import '../../../books/domain/entities/book.dart';
import '../../domain/entities/chapter.dart';
import '../bloc/chapter_bloc.dart';

class WriteChapterPage extends StatefulWidget {
  final Book book;
  final Chapter? chapter;

  const WriteChapterPage({super.key, required this.book, this.chapter});

  @override
  State<WriteChapterPage> createState() => _WriteChapterPageState();
}

class _WriteChapterPageState extends State<WriteChapterPage> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _authorNoteController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isDirty = false;

  @override
  void initState() {
    super.initState();

    if (widget.chapter != null) {
      _titleController.text = widget.chapter!.title;
      _contentController.text = widget.chapter!.content;
      _authorNoteController.text = widget.chapter!.authorNote ?? '';
    }

    // Listen for changes
    _titleController.addListener(_onContentChanged);
    _contentController.addListener(_onContentChanged);
    _authorNoteController.addListener(_onContentChanged);
  }

  void _onContentChanged() {
    if (!_isDirty) {
      setState(() => _isDirty = true);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _authorNoteController.dispose();
    super.dispose();
  }

  void _handleSave() {
    if (_formKey.currentState!.validate()) {
      final content = _contentController.text.trim();

      if (widget.chapter != null) {
        // Update existing chapter
        context.read<ChapterBloc>().add(
          UpdateChapterRequested(
            bookId: widget.book.id,
            chapterId: widget.chapter!.id,
            title: _titleController.text.trim(),
            content: content,
            authorNote: _authorNoteController.text.trim().isEmpty
                ? null
                : _authorNoteController.text.trim(),
          ),
        );
      } else {
        // Create new chapter
        context.read<ChapterBloc>().add(
          CreateChapterRequested(
            bookId: widget.book.id,
            title: _titleController.text.trim(),
            content: content,
            authorNote: _authorNoteController.text.trim().isEmpty
                ? null
                : _authorNoteController.text.trim(),
          ),
        );
      }
    }
  }

  Future<bool> _onWillPop() async {
    if (!_isDirty) return true;

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(AppStrings.areYouSure),
        content: const Text(AppStrings.discardChangesConfirmation),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text(AppStrings.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              AppStrings.discard,
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );

    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: BlocListener<ChapterBloc, ChapterState>(
        listener: (context, state) {
          if (state is ChapterCreated || state is ChapterUpdated) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state is ChapterCreated
                      ? 'Chapter created successfully'
                      : 'Chapter updated successfully',
                ),
                backgroundColor: AppColors.success,
              ),
            );
            Navigator.pop(context);
          } else if (state is ChapterError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.error,
              ),
            );
          }
        },
        child: Scaffold(
          backgroundColor: AppColors.backgroundWhite,
          appBar: AppBar(
            title: Text(
              widget.chapter != null
                  ? AppStrings.editChapter
                  : AppStrings.addChapter,
            ),
            backgroundColor: AppColors.surface,
            elevation: 0,
            actions: [
              BlocBuilder<ChapterBloc, ChapterState>(
                builder: (context, state) {
                  final isLoading = state is ChapterLoading;
                  return TextButton.icon(
                    onPressed: isLoading ? null : _handleSave,
                    icon: isLoading
                        ? SizedBox(
                            width: 16.w,
                            height: 16.h,
                            child: const CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          )
                        : const Icon(Icons.save),
                    label: Text(AppStrings.save),
                  );
                },
              ),
            ],
          ),
          body: Form(
            key: _formKey,
            child: Column(
              children: [
                // Title Field
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 24.w,
                    vertical: 16.h,
                  ),
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
                  child: AuthTextField(
                    controller: _titleController,
                    hintText: 'Enter chapter title',
                    labelText: AppStrings.chapterTitle,
                    prefixIcon: Icons.title,
                    validator: Validators.chapterTitle,
                  ),
                ),

                // Content Editor
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(16.w),
                    child: TextFormField(
                      controller: _contentController,
                      maxLines: null,
                      expands: true,
                      textAlignVertical: TextAlignVertical.top,
                      decoration: InputDecoration(
                        hintText: AppStrings.writeYourStory,
                        hintStyle: TextStyle(
                          color: AppColors.textHint,
                          fontSize: 16.sp,
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                      ),
                      style: TextStyle(
                        fontSize: 16.sp,
                        height: 1.8,
                        color: AppColors.textPrimary,
                        fontFamily: 'Noto Sans Thai', // Support Thai/Lao
                      ),
                      validator: Validators.chapterContent,
                    ),
                  ),
                ),

                // Author Note (Collapsible)
                ExpansionTile(
                  title: Text(
                    'Author\'s Note (Optional)',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  children: [
                    Padding(
                      padding: EdgeInsets.all(16.w),
                      child: AuthTextField(
                        controller: _authorNoteController,
                        hintText: 'Add a note for your readers...',
                        maxLines: 3,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
