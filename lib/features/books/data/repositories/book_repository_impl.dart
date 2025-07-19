import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/book.dart';
import '../../domain/repositories/book_repository.dart';
import '../datasources/book_remote_datasource.dart';

class BookRepositoryImpl implements BookRepository {
  final BookRemoteDataSource remoteDataSource;

  BookRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, Book>> createBook({
    required String title,
    required String description,
    required List<BookGenre> genres,
    String? coverUrl,
    List<String>? tags,
    bool isAdult = false,
  }) async {
    try {
      final book = await remoteDataSource.createBook(
        title: title,
        description: description,
        genres: genres,
        coverUrl: coverUrl,
        tags: tags,
        isAdult: isAdult,
      );
      return Right(book);
    } on AuthException catch (e) {
      return Left(
        AuthFailure(
          message: e.message ?? 'Authentication failed',
          code: e.code,
        ),
      );
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message ?? 'Server error occurred'));
    } catch (e) {
      return Left(ServerFailure(message: 'An unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, Book>> getBook(String bookId) async {
    try {
      final book = await remoteDataSource.getBook(bookId);
      return Right(book);
    } on NotFoundException catch (e) {
      return Left(NotFoundFailure(message: e.message ?? 'Book not found'));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message ?? 'Server error occurred'));
    } catch (e) {
      return Left(ServerFailure(message: 'An unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, List<Book>>> getUserBooks(String userId) async {
    try {
      final books = await remoteDataSource.getUserBooks(userId);
      return Right(books);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message ?? 'Server error occurred'));
    } catch (e) {
      return Left(ServerFailure(message: 'An unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, List<Book>>> getPublishedBooks({
    int limit = 20,
    String? lastDocumentId,
  }) async {
    try {
      final books = await remoteDataSource.getPublishedBooks(
        limit: limit,
        lastDocumentId: lastDocumentId,
      );
      return Right(books);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message ?? 'Server error occurred'));
    } catch (e) {
      return Left(ServerFailure(message: 'An unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, List<Book>>> searchBooks({
    String? query,
    List<BookGenre>? genres,
    BookStatus? status,
    int limit = 20,
  }) async {
    try {
      final books = await remoteDataSource.searchBooks(
        query: query,
        genres: genres,
        status: status,
        limit: limit,
      );
      return Right(books);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message ?? 'Server error occurred'));
    } catch (e) {
      return Left(ServerFailure(message: 'An unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, Book>> updateBook({
    required String bookId,
    String? title,
    String? description,
    List<BookGenre>? genres,
    String? coverUrl,
    List<String>? tags,
    bool? isAdult,
  }) async {
    try {
      final book = await remoteDataSource.updateBook(
        bookId: bookId,
        title: title,
        description: description,
        genres: genres,
        coverUrl: coverUrl,
        tags: tags,
        isAdult: isAdult,
      );
      return Right(book);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message ?? 'Server error occurred'));
    } catch (e) {
      return Left(ServerFailure(message: 'An unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, void>> publishBook(String bookId) async {
    try {
      await remoteDataSource.publishBook(bookId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(
        ServerFailure(message: e.message ?? 'Failed to publish book'),
      );
    } catch (e) {
      return Left(ServerFailure(message: 'An unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, void>> unpublishBook(String bookId) async {
    try {
      await remoteDataSource.unpublishBook(bookId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(
        ServerFailure(message: e.message ?? 'Failed to unpublish book'),
      );
    } catch (e) {
      return Left(ServerFailure(message: 'An unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, void>> completeBook(String bookId) async {
    try {
      await remoteDataSource.completeBook(bookId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(
        ServerFailure(message: e.message ?? 'Failed to complete book'),
      );
    } catch (e) {
      return Left(ServerFailure(message: 'An unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteBook(String bookId) async {
    try {
      await remoteDataSource.deleteBook(bookId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message ?? 'Failed to delete book'));
    } catch (e) {
      return Left(ServerFailure(message: 'An unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, void>> incrementViewCount(String bookId) async {
    try {
      await remoteDataSource.incrementViewCount(bookId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(
        ServerFailure(message: e.message ?? 'Failed to update view count'),
      );
    } catch (e) {
      return Left(ServerFailure(message: 'An unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, void>> likeBook(String bookId) async {
    try {
      await remoteDataSource.likeBook(bookId);
      return const Right(null);
    } on AuthException catch (e) {
      return Left(
        AuthFailure(
          message: e.message ?? 'Authentication failed',
          code: e.code,
        ),
      );
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message ?? 'Failed to like book'));
    } catch (e) {
      return Left(ServerFailure(message: 'An unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, void>> unlikeBook(String bookId) async {
    try {
      await remoteDataSource.unlikeBook(bookId);
      return const Right(null);
    } on AuthException catch (e) {
      return Left(
        AuthFailure(
          message: e.message ?? 'Authentication failed',
          code: e.code,
        ),
      );
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message ?? 'Failed to unlike book'));
    } catch (e) {
      return Left(ServerFailure(message: 'An unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, bool>> isBookLiked(String bookId) async {
    try {
      final isLiked = await remoteDataSource.isBookLiked(bookId);
      return Right(isLiked);
    } on AuthException catch (e) {
      return Left(
        AuthFailure(
          message: e.message ?? 'Authentication failed',
          code: e.code,
        ),
      );
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message ?? 'Server error occurred'));
    } catch (e) {
      return Left(ServerFailure(message: 'An unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, List<Book>>> getLikedBooks() async {
    try {
      final books = await remoteDataSource.getLikedBooks();
      return Right(books);
    } on AuthException catch (e) {
      return Left(
        AuthFailure(
          message: e.message ?? 'Authentication failed',
          code: e.code,
        ),
      );
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message ?? 'Server error occurred'));
    } catch (e) {
      return Left(ServerFailure(message: 'An unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, List<Book>>> getBooksByGenre(
    BookGenre genre, {
    int limit = 20,
    String? lastDocumentId,
  }) async {
    try {
      final books = await remoteDataSource.getBooksByGenre(
        genre,
        limit: limit,
        lastDocumentId: lastDocumentId,
      );
      return Right(books);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message ?? 'Server error occurred'));
    } catch (e) {
      return Left(ServerFailure(message: 'An unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, List<Book>>> getTrendingBooks({int limit = 20}) async {
    try {
      final books = await remoteDataSource.getTrendingBooks(limit: limit);
      return Right(books);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message ?? 'Server error occurred'));
    } catch (e) {
      return Left(ServerFailure(message: 'An unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, List<Book>>> getRecentlyUpdatedBooks({
    int limit = 20,
    String? lastDocumentId,
  }) async {
    try {
      final books = await remoteDataSource.getRecentlyUpdatedBooks(
        limit: limit,
        lastDocumentId: lastDocumentId,
      );
      return Right(books);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message ?? 'Server error occurred'));
    } catch (e) {
      return Left(ServerFailure(message: 'An unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, void>> rateBook({
    required String bookId,
    required double rating,
  }) async {
    try {
      await remoteDataSource.rateBook(bookId: bookId, rating: rating);
      return const Right(null);
    } on AuthException catch (e) {
      return Left(
        AuthFailure(
          message: e.message ?? 'Authentication failed',
          code: e.code,
        ),
      );
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message ?? 'Failed to rate book'));
    } catch (e) {
      return Left(ServerFailure(message: 'An unexpected error occurred'));
    }
  }

  @override
  Stream<Book> watchBook(String bookId) {
    return remoteDataSource.watchBook(bookId);
  }

  @override
  Stream<List<Book>> watchUserBooks(String userId) {
    return remoteDataSource.watchUserBooks(userId);
  }
}
