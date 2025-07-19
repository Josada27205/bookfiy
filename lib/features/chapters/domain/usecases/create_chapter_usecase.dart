import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/chapter.dart';
import '../repositories/chapter_repository.dart';

class CreateChapterUseCase implements UseCase<Chapter, CreateChapterParams> {
  final ChapterRepository repository;

  CreateChapterUseCase(this.repository);

  @override
  Future<Either<Failure, Chapter>> call(CreateChapterParams params) async {
    return await repository.createChapter(
      bookId: params.bookId,
      title: params.title,
      content: params.content,
      authorNote: params.authorNote,
    );
  }
}

class CreateChapterParams extends Equatable {
  final String bookId;
  final String title;
  final String content;
  final String? authorNote;

  const CreateChapterParams({
    required this.bookId,
    required this.title,
    required this.content,
    this.authorNote,
  });

  @override
  List<Object?> get props => [bookId, title, content, authorNote];
}
