import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/chapter.dart';

abstract class ChapterRepository {
  Future<Either<Failure, Chapter>> createChapter({
    required String bookId,
    required String title,
    required String content,
    String? authorNote,
  });

  Future<Either<Failure, Chapter>> getChapter({
    required String bookId,
    required String chapterId,
  });

  Future<Either<Failure, List<Chapter>>> getChapters(String bookId);

  Future<Either<Failure, Chapter>> updateChapter({
    required String bookId,
    required String chapterId,
    String? title,
    String? content,
    String? authorNote,
  });

  Future<Either<Failure, void>> publishChapter({
    required String bookId,
    required String chapterId,
  });

  Future<Either<Failure, void>> unpublishChapter({
    required String bookId,
    required String chapterId,
  });

  Future<Either<Failure, void>> deleteChapter({
    required String bookId,
    required String chapterId,
  });

  Future<Either<Failure, void>> reorderChapters({
    required String bookId,
    required List<String> chapterIds,
  });

  Future<Either<Failure, void>> incrementViewCount({
    required String bookId,
    required String chapterId,
  });

  Future<Either<Failure, void>> likeChapter({
    required String bookId,
    required String chapterId,
  });

  Future<Either<Failure, void>> unlikeChapter({
    required String bookId,
    required String chapterId,
  });

  Stream<Chapter> watchChapter({
    required String bookId,
    required String chapterId,
  });

  Stream<List<Chapter>> watchChapters(String bookId);
}
