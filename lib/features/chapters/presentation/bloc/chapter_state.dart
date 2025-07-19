part of 'chapter_bloc.dart';

abstract class ChapterState extends Equatable {
  const ChapterState();

  @override
  List<Object?> get props => [];
}

class ChapterInitial extends ChapterState {}

class ChapterLoading extends ChapterState {}

class ChapterCreated extends ChapterState {
  final Chapter chapter;

  const ChapterCreated({required this.chapter});

  @override
  List<Object> get props => [chapter];
}

class ChaptersLoaded extends ChapterState {
  final List<Chapter> chapters;

  const ChaptersLoaded({required this.chapters});

  @override
  List<Object> get props => [chapters];
}

class ChapterUpdated extends ChapterState {
  final Chapter chapter;

  const ChapterUpdated({required this.chapter});

  @override
  List<Object> get props => [chapter];
}

class ChapterDeleted extends ChapterState {}

class ChapterPublished extends ChapterState {}

class ChapterUnpublished extends ChapterState {}

class ChapterLiked extends ChapterState {
  final String chapterId;

  const ChapterLiked({required this.chapterId});

  @override
  List<Object> get props => [chapterId];
}

class ChapterUnliked extends ChapterState {
  final String chapterId;

  const ChapterUnliked({required this.chapterId});

  @override
  List<Object> get props => [chapterId];
}

class ChapterError extends ChapterState {
  final String message;

  const ChapterError({required this.message});

  @override
  List<Object> get props => [message];
}
