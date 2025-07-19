part of 'book_bloc.dart';

abstract class BookEvent extends Equatable {
  const BookEvent();

  @override
  List<Object?> get props => [];
}

class CreateBookRequested extends BookEvent {
  final String title;
  final String description;
  final List<BookGenre> genres;
  final String? coverUrl;
  final List<String>? tags;
  final bool isAdult;

  const CreateBookRequested({
    required this.title,
    required this.description,
    required this.genres,
    this.coverUrl,
    this.tags,
    this.isAdult = false,
  });

  @override
  List<Object?> get props => [
    title,
    description,
    genres,
    coverUrl,
    tags,
    isAdult,
  ];
}

class GetBooksRequested extends BookEvent {
  final GetBooksParams params;

  const GetBooksRequested({required this.params});

  @override
  List<Object> get props => [params];
}

class UpdateBookRequested extends BookEvent {
  final String bookId;
  final String? title;
  final String? description;
  final List<BookGenre>? genres;
  final String? coverUrl;
  final List<String>? tags;
  final bool? isAdult;

  const UpdateBookRequested({
    required this.bookId,
    this.title,
    this.description,
    this.genres,
    this.coverUrl,
    this.tags,
    this.isAdult,
  });

  @override
  List<Object?> get props => [
    bookId,
    title,
    description,
    genres,
    coverUrl,
    tags,
    isAdult,
  ];
}

class DeleteBookRequested extends BookEvent {
  final String bookId;

  const DeleteBookRequested({required this.bookId});

  @override
  List<Object> get props => [bookId];
}

class PublishBookRequested extends BookEvent {
  final String bookId;

  const PublishBookRequested({required this.bookId});

  @override
  List<Object> get props => [bookId];
}

class UnpublishBookRequested extends BookEvent {
  final String bookId;

  const UnpublishBookRequested({required this.bookId});

  @override
  List<Object> get props => [bookId];
}

class LikeBookRequested extends BookEvent {
  final String bookId;

  const LikeBookRequested({required this.bookId});

  @override
  List<Object> get props => [bookId];
}

class UnlikeBookRequested extends BookEvent {
  final String bookId;

  const UnlikeBookRequested({required this.bookId});

  @override
  List<Object> get props => [bookId];
}

class RateBookRequested extends BookEvent {
  final String bookId;
  final double rating;

  const RateBookRequested({required this.bookId, required this.rating});

  @override
  List<Object> get props => [bookId, rating];
}

class WatchUserBooksRequested extends BookEvent {
  final String userId;

  const WatchUserBooksRequested({required this.userId});

  @override
  List<Object> get props => [userId];
}

class UserBooksUpdated extends BookEvent {
  final List<Book> books;

  const UserBooksUpdated({required this.books});

  @override
  List<Object> get props => [books];
}

class IncrementViewCountRequested extends BookEvent {
  final String bookId;

  const IncrementViewCountRequested({required this.bookId});

  @override
  List<Object> get props => [bookId];
}
