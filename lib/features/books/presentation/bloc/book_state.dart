part of 'book_bloc.dart';

abstract class BookState extends Equatable {
  const BookState();

  @override
  List<Object?> get props => [];
}

class BookInitial extends BookState {}

class BookLoading extends BookState {}

class BookCreated extends BookState {
  final Book book;

  const BookCreated({required this.book});

  @override
  List<Object> get props => [book];
}

class BooksLoaded extends BookState {
  final List<Book> books;
  final bool hasReachedMax;

  const BooksLoaded({required this.books, this.hasReachedMax = false});

  @override
  List<Object> get props => [books, hasReachedMax];
}

class UserBooksLoaded extends BookState {
  final List<Book> books;

  const UserBooksLoaded({required this.books});

  @override
  List<Object> get props => [books];
}

class BookUpdated extends BookState {
  final Book book;

  const BookUpdated({required this.book});

  @override
  List<Object> get props => [book];
}

class BookDeleted extends BookState {}

class BookPublished extends BookState {}

class BookUnpublished extends BookState {}

class BookLiked extends BookState {
  final String bookId;

  const BookLiked({required this.bookId});

  @override
  List<Object> get props => [bookId];
}

class BookUnliked extends BookState {
  final String bookId;

  const BookUnliked({required this.bookId});

  @override
  List<Object> get props => [bookId];
}

class BookRated extends BookState {
  final String bookId;
  final double rating;

  const BookRated({required this.bookId, required this.rating});

  @override
  List<Object> get props => [bookId, rating];
}

class BookError extends BookState {
  final String message;

  const BookError({required this.message});

  @override
  List<Object> get props => [message];
}
