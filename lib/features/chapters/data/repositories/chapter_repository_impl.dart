import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/chapter.dart';
import '../../domain/repositories/chapter_repository.dart';
import '../datasources/chapter_remote_datasource.dart';

class ChapterRepositoryImpl implements ChapterRepository {
  final ChapterRemoteDataSource remoteDataSource;

  ChapterRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, Chapter>> createChapter({
    required String bookId,
    required String title,
    required String content,
    String? authorNote,
  }) async {
    try {
      final chapter = await remoteDataSource.createChapter(
        bookId: bookId,
        title: title,
        content: content,
        authorNote: authorNote,
      );
      return Right(chapter);
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
  Future<Either<Failure, Chapter>> getChapter({
    required String bookId,
    required String chapterId,
  }) async {
    try {
      final chapter = await remoteDataSource.getChapter(
        bookId: bookId,
        chapterId: chapterId,
      );
      return Right(chapter);
    } on NotFoundException catch (e) {
      return Left(NotFoundFailure(message: e.message ?? 'Chapter not found'));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message ?? 'Server error occurred'));
    } catch (e) {
      return Left(ServerFailure(message: 'An unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, List<Chapter>>> getChapters(String bookId) async {
    try {
      final chapters = await remoteDataSource.getChapters(bookId);
      return Right(chapters);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message ?? 'Server error occurred'));
    } catch (e) {
      return Left(ServerFailure(message: 'An unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, Chapter>> updateChapter({
    required String bookId,
    required String chapterId,
    String? title,
    String? content,
    String? authorNote,
  }) async {
    try {
      final chapter = await remoteDataSource.updateChapter(
        bookId: bookId,
        chapterId: chapterId,
        title: title,
        content: content,
        authorNote: authorNote,
      );
      return Right(chapter);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message ?? 'Server error occurred'));
    } catch (e) {
      return Left(ServerFailure(message: 'An unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, void>> publishChapter({
    required String bookId,
    required String chapterId,
  }) async {
    try {
      await remoteDataSource.publishChapter(
        bookId: bookId,
        chapterId: chapterId,
      );
      return const Right(null);
    } on ServerException catch (e) {
      return Left(
        ServerFailure(message: e.message ?? 'Failed to publish chapter'),
      );
    } catch (e) {
      return Left(ServerFailure(message: 'An unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, void>> unpublishChapter({
    required String bookId,
    required String chapterId,
  }) async {
    try {
      await remoteDataSource.unpublishChapter(
        bookId: bookId,
        chapterId: chapterId,
      );
      return const Right(null);
    } on ServerException catch (e) {
      return Left(
        ServerFailure(message: e.message ?? 'Failed to unpublish chapter'),
      );
    } catch (e) {
      return Left(ServerFailure(message: 'An unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteChapter({
    required String bookId,
    required String chapterId,
  }) async {
    try {
      await remoteDataSource.deleteChapter(
        bookId: bookId,
        chapterId: chapterId,
      );
      return const Right(null);
    } on ServerException catch (e) {
      return Left(
        ServerFailure(message: e.message ?? 'Failed to delete chapter'),
      );
    } catch (e) {
      return Left(ServerFailure(message: 'An unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, void>> reorderChapters({
    required String bookId,
    required List<String> chapterIds,
  }) async {
    try {
      await remoteDataSource.reorderChapters(
        bookId: bookId,
        chapterIds: chapterIds,
      );
      return const Right(null);
    } on ServerException catch (e) {
      return Left(
        ServerFailure(message: e.message ?? 'Failed to reorder chapters'),
      );
    } catch (e) {
      return Left(ServerFailure(message: 'An unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, void>> incrementViewCount({
    required String bookId,
    required String chapterId,
  }) async {
    try {
      await remoteDataSource.incrementViewCount(
        bookId: bookId,
        chapterId: chapterId,
      );
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
  Future<Either<Failure, void>> likeChapter({
    required String bookId,
    required String chapterId,
  }) async {
    try {
      await remoteDataSource.likeChapter(bookId: bookId, chapterId: chapterId);
      return const Right(null);
    } on AuthException catch (e) {
      return Left(
        AuthFailure(
          message: e.message ?? 'Authentication failed',
          code: e.code,
        ),
      );
    } on ServerException catch (e) {
      return Left(
        ServerFailure(message: e.message ?? 'Failed to like chapter'),
      );
    } catch (e) {
      return Left(ServerFailure(message: 'An unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, void>> unlikeChapter({
    required String bookId,
    required String chapterId,
  }) async {
    try {
      await remoteDataSource.unlikeChapter(
        bookId: bookId,
        chapterId: chapterId,
      );
      return const Right(null);
    } on AuthException catch (e) {
      return Left(
        AuthFailure(
          message: e.message ?? 'Authentication failed',
          code: e.code,
        ),
      );
    } on ServerException catch (e) {
      return Left(
        ServerFailure(message: e.message ?? 'Failed to unlike chapter'),
      );
    } catch (e) {
      return Left(ServerFailure(message: 'An unexpected error occurred'));
    }
  }

  @override
  Stream<Chapter> watchChapter({
    required String bookId,
    required String chapterId,
  }) {
    return remoteDataSource.watchChapter(bookId: bookId, chapterId: chapterId);
  }

  @override
  Stream<List<Chapter>> watchChapters(String bookId) {
    return remoteDataSource.watchChapters(bookId);
  }
}
