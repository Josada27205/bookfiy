import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/book.dart';
import '../../domain/repositories/book_repository.dart';
import '../../domain/usecases/create_book_usecase.dart';
import '../../domain/usecases/get_books_usecase.dart';
import '../../domain/usecases/update_book_usecase.dart';

part 'book_event.dart';
part 'book_state.dart';

class BookBloc extends Bloc<BookEvent, BookState> {
  final CreateBookUseCase createBookUseCase;
  final GetBooksUseCase getBooksUseCase;
  final UpdateBookUseCase updateBookUseCase;
  final BookRepository bookRepository;

  StreamSubscription<List<Book>>? _userBooksSubscription;

  BookBloc({
    required this.createBookUseCase,
    required this.getBooksUseCase,
    required this.updateBookUseCase,
    required this.bookRepository,
  }) : super(BookInitial()) {
    on<CreateBookRequested>(_onCreateBookRequested);
    on<GetBooksRequested>(_onGetBooksRequested);
    on<UpdateBookRequested>(_onUpdateBookRequested);
    on<DeleteBookRequested>(_onDeleteBookRequested);
    on<PublishBookRequested>(_onPublishBookRequested);
    on<UnpublishBookRequested>(_onUnpublishBookRequested);
    on<LikeBookRequested>(_onLikeBookRequested);
    on<UnlikeBookRequested>(_onUnlikeBookRequested);
    on<RateBookRequested>(_onRateBookRequested);
    on<WatchUserBooksRequested>(_onWatchUserBooksRequested);
    on<UserBooksUpdated>(_onUserBooksUpdated);
    on<IncrementViewCountRequested>(_onIncrementViewCountRequested);
  }

  Future<void> _onCreateBookRequested(
    CreateBookRequested event,
    Emitter<BookState> emit,
  ) async {
    emit(BookLoading());

    final result = await createBookUseCase(
      CreateBookParams(
        title: event.title,
        description: event.description,
        genres: event.genres,
        coverUrl: event.coverUrl,
        tags: event.tags,
        isAdult: event.isAdult,
      ),
    );

    result.fold(
      (failure) => emit(BookError(message: failure.message)),
      (book) => emit(BookCreated(book: book)),
    );
  }

  Future<void> _onGetBooksRequested(
    GetBooksRequested event,
    Emitter<BookState> emit,
  ) async {
    emit(BookLoading());

    final result = await getBooksUseCase(event.params);

    result.fold(
      (failure) => emit(BookError(message: failure.message)),
      (books) => emit(
        BooksLoaded(
          books: books,
          hasReachedMax: books.length < event.params.limit,
        ),
      ),
    );
  }

  Future<void> _onUpdateBookRequested(
    UpdateBookRequested event,
    Emitter<BookState> emit,
  ) async {
    emit(BookLoading());

    final result = await updateBookUseCase(
      UpdateBookParams(
        bookId: event.bookId,
        title: event.title,
        description: event.description,
        genres: event.genres,
        coverUrl: event.coverUrl,
        tags: event.tags,
        isAdult: event.isAdult,
      ),
    );

    result.fold(
      (failure) => emit(BookError(message: failure.message)),
      (book) => emit(BookUpdated(book: book)),
    );
  }

  Future<void> _onDeleteBookRequested(
    DeleteBookRequested event,
    Emitter<BookState> emit,
  ) async {
    emit(BookLoading());

    final result = await bookRepository.deleteBook(event.bookId);

    result.fold(
      (failure) => emit(BookError(message: failure.message)),
      (_) => emit(BookDeleted()),
    );
  }

  Future<void> _onPublishBookRequested(
    PublishBookRequested event,
    Emitter<BookState> emit,
  ) async {
    emit(BookLoading());

    final result = await bookRepository.publishBook(event.bookId);

    result.fold(
      (failure) => emit(BookError(message: failure.message)),
      (_) => emit(BookPublished()),
    );
  }

  Future<void> _onUnpublishBookRequested(
    UnpublishBookRequested event,
    Emitter<BookState> emit,
  ) async {
    emit(BookLoading());

    final result = await bookRepository.unpublishBook(event.bookId);

    result.fold(
      (failure) => emit(BookError(message: failure.message)),
      (_) => emit(BookUnpublished()),
    );
  }

  Future<void> _onLikeBookRequested(
    LikeBookRequested event,
    Emitter<BookState> emit,
  ) async {
    final result = await bookRepository.likeBook(event.bookId);

    result.fold(
      (failure) => emit(BookError(message: failure.message)),
      (_) => emit(BookLiked(bookId: event.bookId)),
    );
  }

  Future<void> _onUnlikeBookRequested(
    UnlikeBookRequested event,
    Emitter<BookState> emit,
  ) async {
    final result = await bookRepository.unlikeBook(event.bookId);

    result.fold(
      (failure) => emit(BookError(message: failure.message)),
      (_) => emit(BookUnliked(bookId: event.bookId)),
    );
  }

  Future<void> _onRateBookRequested(
    RateBookRequested event,
    Emitter<BookState> emit,
  ) async {
    final result = await bookRepository.rateBook(
      bookId: event.bookId,
      rating: event.rating,
    );

    result.fold(
      (failure) => emit(BookError(message: failure.message)),
      (_) => emit(BookRated(bookId: event.bookId, rating: event.rating)),
    );
  }

  void _onWatchUserBooksRequested(
    WatchUserBooksRequested event,
    Emitter<BookState> emit,
  ) {
    _userBooksSubscription?.cancel();
    _userBooksSubscription = bookRepository
        .watchUserBooks(event.userId)
        .listen((books) => add(UserBooksUpdated(books: books)));
  }

  void _onUserBooksUpdated(UserBooksUpdated event, Emitter<BookState> emit) {
    emit(UserBooksLoaded(books: event.books));
  }

  Future<void> _onIncrementViewCountRequested(
    IncrementViewCountRequested event,
    Emitter<BookState> emit,
  ) async {
    await bookRepository.incrementViewCount(event.bookId);
  }

  @override
  Future<void> close() {
    _userBooksSubscription?.cancel();
    return super.close();
  }
}
