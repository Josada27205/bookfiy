import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/book.dart';

abstract class BookRepository {
  Future<Either<Failure, Book>> createBook({
    required String title,
    required String description,
    required List<BookGenre> genres,
    String? coverUrl,
    List<String>? tags,
    bool isAdult = false,
  });

  Future<Either<Failure, Book>> getBook(String bookId);

  Future<Either<Failure, List<Book>>> getUserBooks(String userId);

  Future<Either<Failure, List<Book>>> getPublishedBooks({
    int limit = 20,
    String? lastDocumentId,
  });

  Future<Either<Failure, List<Book>>> searchBooks({
    String? query,
    List<BookGenre>? genres,
    BookStatus? status,
    int limit = 20,
  });

  Future<Either<Failure, Book>> updateBook({
    required String bookId,
    String? title,
    String? description,
    List<BookGenre>? genres,
    String? coverUrl,
    List<String>? tags,
    bool? isAdult,
  });

  Future<Either<Failure, void>> publishBook(String bookId);

  Future<Either<Failure, void>> unpublishBook(String bookId);

  Future<Either<Failure, void>> completeBook(String bookId);

  Future<Either<Failure, void>> deleteBook(String bookId);

  Future<Either<Failure, void>> incrementViewCount(String bookId);

  Future<Either<Failure, void>> likeBook(String bookId);

  Future<Either<Failure, void>> unlikeBook(String bookId);

  Future<Either<Failure, bool>> isBookLiked(String bookId);

  Future<Either<Failure, List<Book>>> getLikedBooks();

  Future<Either<Failure, List<Book>>> getBooksByGenre(
    BookGenre genre, {
    int limit = 20,
    String? lastDocumentId,
  });

  Future<Either<Failure, List<Book>>> getTrendingBooks({int limit = 20});

  Future<Either<Failure, List<Book>>> getRecentlyUpdatedBooks({
    int limit = 20,
    String? lastDocumentId,
  });

  Future<Either<Failure, void>> rateBook({
    required String bookId,
    required double rating,
  });

  Stream<Book> watchBook(String bookId);

  Stream<List<Book>> watchUserBooks(String userId);
}
