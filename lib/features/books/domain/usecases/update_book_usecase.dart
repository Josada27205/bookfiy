import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/book.dart';
import '../repositories/book_repository.dart';

class UpdateBookUseCase implements UseCase<Book, UpdateBookParams> {
  final BookRepository repository;

  UpdateBookUseCase(this.repository);

  @override
  Future<Either<Failure, Book>> call(UpdateBookParams params) async {
    return await repository.updateBook(
      bookId: params.bookId,
      title: params.title,
      description: params.description,
      genres: params.genres,
      coverUrl: params.coverUrl,
      tags: params.tags,
      isAdult: params.isAdult,
    );
  }
}

class UpdateBookParams extends Equatable {
  final String bookId;
  final String? title;
  final String? description;
  final List<BookGenre>? genres;
  final String? coverUrl;
  final List<String>? tags;
  final bool? isAdult;

  const UpdateBookParams({
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
