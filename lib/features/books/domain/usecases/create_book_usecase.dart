import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/book.dart';
import '../repositories/book_repository.dart';

class CreateBookUseCase implements UseCase<Book, CreateBookParams> {
  final BookRepository repository;

  CreateBookUseCase(this.repository);

  @override
  Future<Either<Failure, Book>> call(CreateBookParams params) async {
    return await repository.createBook(
      title: params.title,
      description: params.description,
      genres: params.genres,
      coverUrl: params.coverUrl,
      tags: params.tags,
      isAdult: params.isAdult,
    );
  }
}

class CreateBookParams extends Equatable {
  final String title;
  final String description;
  final List<BookGenre> genres;
  final String? coverUrl;
  final List<String>? tags;
  final bool isAdult;

  const CreateBookParams({
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
