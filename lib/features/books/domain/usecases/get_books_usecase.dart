import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/book.dart';
import '../repositories/book_repository.dart';

class GetBooksUseCase implements UseCase<List<Book>, GetBooksParams> {
  final BookRepository repository;

  GetBooksUseCase(this.repository);

  @override
  Future<Either<Failure, List<Book>>> call(GetBooksParams params) async {
    switch (params.type) {
      case GetBooksType.userBooks:
        return await repository.getUserBooks(params.userId!);
      case GetBooksType.published:
        return await repository.getPublishedBooks(
          limit: params.limit,
          lastDocumentId: params.lastDocumentId,
        );
      case GetBooksType.trending:
        return await repository.getTrendingBooks(limit: params.limit);
      case GetBooksType.recentlyUpdated:
        return await repository.getRecentlyUpdatedBooks(
          limit: params.limit,
          lastDocumentId: params.lastDocumentId,
        );
      case GetBooksType.liked:
        return await repository.getLikedBooks();
      case GetBooksType.byGenre:
        return await repository.getBooksByGenre(
          params.genre!,
          limit: params.limit,
          lastDocumentId: params.lastDocumentId,
        );
      case GetBooksType.search:
        return await repository.searchBooks(
          query: params.query,
          genres: params.genres,
          status: params.status,
          limit: params.limit,
        );
    }
  }
}

enum GetBooksType {
  userBooks,
  published,
  trending,
  recentlyUpdated,
  liked,
  byGenre,
  search,
}

class GetBooksParams extends Equatable {
  final GetBooksType type;
  final String? userId;
  final String? query;
  final List<BookGenre>? genres;
  final BookGenre? genre;
  final BookStatus? status;
  final int limit;
  final String? lastDocumentId;

  const GetBooksParams({
    required this.type,
    this.userId,
    this.query,
    this.genres,
    this.genre,
    this.status,
    this.limit = 20,
    this.lastDocumentId,
  });

  @override
  List<Object?> get props => [
    type,
    userId,
    query,
    genres,
    genre,
    status,
    limit,
    lastDocumentId,
  ];
}
