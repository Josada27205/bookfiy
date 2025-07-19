import 'package:equatable/equatable.dart';

enum BookStatus { draft, published, completed, archived }

enum BookGenre {
  fiction,
  nonFiction,
  romance,
  mystery,
  fantasy,
  scienceFiction,
  thriller,
  horror,
  poetry,
  drama,
  adventure,
  historical,
  selfHelp,
  biography,
  other,
}

class Book extends Equatable {
  final String id;
  final String title;
  final String description;
  final String authorId;
  final String authorName;
  final String? coverUrl;
  final List<String> chapterIds;
  final List<BookGenre> genres;
  final BookStatus status;
  final int viewCount;
  final int likeCount;
  final int commentCount;
  final int chapterCount;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? publishedAt;
  final DateTime? completedAt;
  final String? language;
  final List<String> tags;
  final bool isAdult;
  final int totalWordCount;
  final double rating;
  final int ratingCount;

  const Book({
    required this.id,
    required this.title,
    required this.description,
    required this.authorId,
    required this.authorName,
    this.coverUrl,
    this.chapterIds = const [],
    this.genres = const [],
    this.status = BookStatus.draft,
    this.viewCount = 0,
    this.likeCount = 0,
    this.commentCount = 0,
    this.chapterCount = 0,
    required this.createdAt,
    required this.updatedAt,
    this.publishedAt,
    this.completedAt,
    this.language = 'en',
    this.tags = const [],
    this.isAdult = false,
    this.totalWordCount = 0,
    this.rating = 0.0,
    this.ratingCount = 0,
  });

  Book copyWith({
    String? id,
    String? title,
    String? description,
    String? authorId,
    String? authorName,
    String? coverUrl,
    List<String>? chapterIds,
    List<BookGenre>? genres,
    BookStatus? status,
    int? viewCount,
    int? likeCount,
    int? commentCount,
    int? chapterCount,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? publishedAt,
    DateTime? completedAt,
    String? language,
    List<String>? tags,
    bool? isAdult,
    int? totalWordCount,
    double? rating,
    int? ratingCount,
  }) {
    return Book(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      authorId: authorId ?? this.authorId,
      authorName: authorName ?? this.authorName,
      coverUrl: coverUrl ?? this.coverUrl,
      chapterIds: chapterIds ?? this.chapterIds,
      genres: genres ?? this.genres,
      status: status ?? this.status,
      viewCount: viewCount ?? this.viewCount,
      likeCount: likeCount ?? this.likeCount,
      commentCount: commentCount ?? this.commentCount,
      chapterCount: chapterCount ?? this.chapterCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      publishedAt: publishedAt ?? this.publishedAt,
      completedAt: completedAt ?? this.completedAt,
      language: language ?? this.language,
      tags: tags ?? this.tags,
      isAdult: isAdult ?? this.isAdult,
      totalWordCount: totalWordCount ?? this.totalWordCount,
      rating: rating ?? this.rating,
      ratingCount: ratingCount ?? this.ratingCount,
    );
  }

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    authorId,
    authorName,
    coverUrl,
    chapterIds,
    genres,
    status,
    viewCount,
    likeCount,
    commentCount,
    chapterCount,
    createdAt,
    updatedAt,
    publishedAt,
    completedAt,
    language,
    tags,
    isAdult,
    totalWordCount,
    rating,
    ratingCount,
  ];
}
