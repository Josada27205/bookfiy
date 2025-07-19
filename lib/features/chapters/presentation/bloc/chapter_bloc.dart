import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/chapter.dart';
import '../../domain/repositories/chapter_repository.dart';
import '../../domain/usecases/create_chapter_usecase.dart';
import '../../domain/usecases/get_chapters_usecase.dart';

part 'chapter_event.dart';
part 'chapter_state.dart';

class ChapterBloc extends Bloc<ChapterEvent, ChapterState> {
  final CreateChapterUseCase createChapterUseCase;
  final GetChaptersUseCase getChaptersUseCase;
  final ChapterRepository chapterRepository;

  StreamSubscription<List<Chapter>>? _chaptersSubscription;

  ChapterBloc({
    required this.createChapterUseCase,
    required this.getChaptersUseCase,
    required this.chapterRepository,
  }) : super(ChapterInitial()) {
    on<CreateChapterRequested>(_onCreateChapterRequested);
    on<GetChaptersRequested>(_onGetChaptersRequested);
    on<UpdateChapterRequested>(_onUpdateChapterRequested);
    on<DeleteChapterRequested>(_onDeleteChapterRequested);
    on<PublishChapterRequested>(_onPublishChapterRequested);
    on<UnpublishChapterRequested>(_onUnpublishChapterRequested);
    on<LikeChapterRequested>(_onLikeChapterRequested);
    on<UnlikeChapterRequested>(_onUnlikeChapterRequested);
    on<WatchChaptersRequested>(_onWatchChaptersRequested);
    on<ChaptersUpdated>(_onChaptersUpdated);
  }

  Future<void> _onCreateChapterRequested(
    CreateChapterRequested event,
    Emitter<ChapterState> emit,
  ) async {
    emit(ChapterLoading());

    final result = await createChapterUseCase(
      CreateChapterParams(
        bookId: event.bookId,
        title: event.title,
        content: event.content,
        authorNote: event.authorNote,
      ),
    );

    result.fold(
      (failure) => emit(ChapterError(message: failure.message)),
      (chapter) => emit(ChapterCreated(chapter: chapter)),
    );
  }

  Future<void> _onGetChaptersRequested(
    GetChaptersRequested event,
    Emitter<ChapterState> emit,
  ) async {
    emit(ChapterLoading());

    final result = await getChaptersUseCase(
      GetChaptersParams(bookId: event.bookId),
    );

    result.fold(
      (failure) => emit(ChapterError(message: failure.message)),
      (chapters) => emit(ChaptersLoaded(chapters: chapters)),
    );
  }

  Future<void> _onUpdateChapterRequested(
    UpdateChapterRequested event,
    Emitter<ChapterState> emit,
  ) async {
    emit(ChapterLoading());

    final result = await chapterRepository.updateChapter(
      bookId: event.bookId,
      chapterId: event.chapterId,
      title: event.title,
      content: event.content,
      authorNote: event.authorNote,
    );

    result.fold(
      (failure) => emit(ChapterError(message: failure.message)),
      (chapter) => emit(ChapterUpdated(chapter: chapter)),
    );
  }

  Future<void> _onDeleteChapterRequested(
    DeleteChapterRequested event,
    Emitter<ChapterState> emit,
  ) async {
    emit(ChapterLoading());

    final result = await chapterRepository.deleteChapter(
      bookId: event.bookId,
      chapterId: event.chapterId,
    );

    result.fold(
      (failure) => emit(ChapterError(message: failure.message)),
      (_) => emit(ChapterDeleted()),
    );
  }

  Future<void> _onPublishChapterRequested(
    PublishChapterRequested event,
    Emitter<ChapterState> emit,
  ) async {
    emit(ChapterLoading());

    final result = await chapterRepository.publishChapter(
      bookId: event.bookId,
      chapterId: event.chapterId,
    );

    result.fold(
      (failure) => emit(ChapterError(message: failure.message)),
      (_) => emit(ChapterPublished()),
    );
  }

  Future<void> _onUnpublishChapterRequested(
    UnpublishChapterRequested event,
    Emitter<ChapterState> emit,
  ) async {
    emit(ChapterLoading());

    final result = await chapterRepository.unpublishChapter(
      bookId: event.bookId,
      chapterId: event.chapterId,
    );

    result.fold(
      (failure) => emit(ChapterError(message: failure.message)),
      (_) => emit(ChapterUnpublished()),
    );
  }

  Future<void> _onLikeChapterRequested(
    LikeChapterRequested event,
    Emitter<ChapterState> emit,
  ) async {
    final result = await chapterRepository.likeChapter(
      bookId: event.bookId,
      chapterId: event.chapterId,
    );

    result.fold(
      (failure) => emit(ChapterError(message: failure.message)),
      (_) => emit(ChapterLiked(chapterId: event.chapterId)),
    );
  }

  Future<void> _onUnlikeChapterRequested(
    UnlikeChapterRequested event,
    Emitter<ChapterState> emit,
  ) async {
    final result = await chapterRepository.unlikeChapter(
      bookId: event.bookId,
      chapterId: event.chapterId,
    );

    result.fold(
      (failure) => emit(ChapterError(message: failure.message)),
      (_) => emit(ChapterUnliked(chapterId: event.chapterId)),
    );
  }

  void _onWatchChaptersRequested(
    WatchChaptersRequested event,
    Emitter<ChapterState> emit,
  ) {
    _chaptersSubscription?.cancel();
    _chaptersSubscription = chapterRepository
        .watchChapters(event.bookId)
        .listen((chapters) => add(ChaptersUpdated(chapters: chapters)));
  }

  void _onChaptersUpdated(ChaptersUpdated event, Emitter<ChapterState> emit) {
    emit(ChaptersLoaded(chapters: event.chapters));
  }

  @override
  Future<void> close() {
    _chaptersSubscription?.cancel();
    return super.close();
  }
}
