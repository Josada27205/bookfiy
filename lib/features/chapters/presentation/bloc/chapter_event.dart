part of 'chapter_bloc.dart';

abstract class ChapterEvent extends Equatable {
  const ChapterEvent();

  @override
  List<Object?> get props => [];
}

class CreateChapterRequested extends ChapterEvent {
  final String bookId;
  final String title;
  final String content;
  final String? authorNote;

  const CreateChapterRequested({
    required this.bookId,
    required this.title,
    required this.content,
    this.authorNote,
  });

  @override
  List<Object?> get props => [bookId, title, content, authorNote];
}

class GetChaptersRequested extends ChapterEvent {
  final String bookId;

  const GetChaptersRequested({required this.bookId});

  @override
  List<Object> get props => [bookId];
}

class UpdateChapterRequested extends ChapterEvent {
  final String bookId;
  final String chapterId;
  final String? title;
  final String? content;
  final String? authorNote;

  const UpdateChapterRequested({
    required this.bookId,
    required this.chapterId,
    this.title,
    this.content,
    this.authorNote,
  });

  @override
  List<Object?> get props => [bookId, chapterId, title, content, authorNote];
}

class DeleteChapterRequested extends ChapterEvent {
  final String bookId;
  final String chapterId;

  const DeleteChapterRequested({required this.bookId, required this.chapterId});

  @override
  List<Object> get props => [bookId, chapterId];
}

class PublishChapterRequested extends ChapterEvent {
  final String bookId;
  final String chapterId;

  const PublishChapterRequested({
    required this.bookId,
    required this.chapterId,
  });

  @override
  List<Object> get props => [bookId, chapterId];
}

class UnpublishChapterRequested extends ChapterEvent {
  final String bookId;
  final String chapterId;

  const UnpublishChapterRequested({
    required this.bookId,
    required this.chapterId,
  });

  @override
  List<Object> get props => [bookId, chapterId];
}

class LikeChapterRequested extends ChapterEvent {
  final String bookId;
  final String chapterId;

  const LikeChapterRequested({required this.bookId, required this.chapterId});

  @override
  List<Object> get props => [bookId, chapterId];
}

class UnlikeChapterRequested extends ChapterEvent {
  final String bookId;
  final String chapterId;

  const UnlikeChapterRequested({required this.bookId, required this.chapterId});

  @override
  List<Object> get props => [bookId, chapterId];
}

class WatchChaptersRequested extends ChapterEvent {
  final String bookId;

  const WatchChaptersRequested({required this.bookId});

  @override
  List<Object> get props => [bookId];
}

class ChaptersUpdated extends ChapterEvent {
  final List<Chapter> chapters;

  const ChaptersUpdated({required this.chapters});

  @override
  List<Object> get props => [chapters];
}
