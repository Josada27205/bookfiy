import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/chapter.dart';
import '../repositories/chapter_repository.dart';

class GetChaptersUseCase implements UseCase<List<Chapter>, GetChaptersParams> {
  final ChapterRepository repository;

  GetChaptersUseCase(this.repository);

  @override
  Future<Either<Failure, List<Chapter>>> call(GetChaptersParams params) async {
    return await repository.getChapters(params.bookId);
  }
}

class GetChaptersParams extends Equatable {
  final String bookId;

  const GetChaptersParams({required this.bookId});

  @override
  List<Object> get props => [bookId];
}
