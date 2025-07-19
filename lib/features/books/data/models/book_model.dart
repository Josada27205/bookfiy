import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/book.dart';

class BookModel extends Book {
  const BookModel({
    required super.id,
    required super.title,
    required super.description,
    required super.authorId,
    required super.authorName,
    super.coverUrl,
    super.chapterIds,
    super.genres,
    super.status,
    super.viewCount,
    super.likeCount,
    super.commentCount,
    super.chapterCount,
    required super.createdAt,
    required super.updatedAt,
    super.publishedAt,
    super.completedAt,
    super.language,
    super.tags,
    super.isAdult,
    super.totalWordCount,
    super.rating,
    super.ratingCount,
  });

  factory BookModel.fromJson(Map<String, dynamic> json) {
    return BookModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      authorId: json['authorId'] as String,
      authorName: json['authorName'] as String,
      coverUrl: json['coverUrl'] as String?,
      chapterIds:
          (json['chapterIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      genres:
          (json['genres'] as List<dynamic>?)
              ?.map(
                (e) => BookGenre.values.firstWhere(
                  (genre) => genre.name == e,
                  orElse: () => BookGenre.other,
                ),
              )
              .toList() ??
          [],
      status: BookStatus.values.firstWhere(
        (status) => status.name == json['status'],
        orElse: () => BookStatus.draft,
      ),
      viewCount: json['viewCount'] as int? ?? 0,
      likeCount: json['likeCount'] as int? ?? 0,
      commentCount: json['commentCount'] as int? ?? 0,
      chapterCount: json['chapterCount'] as int? ?? 0,
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      updatedAt: (json['updatedAt'] as Timestamp).toDate(),
      publishedAt: json['publishedAt'] != null
          ? (json['publishedAt'] as Timestamp).toDate()
          : null,
      completedAt: json['completedAt'] != null
          ? (json['completedAt'] as Timestamp).toDate()
          : null,
      language: json['language'] as String? ?? 'en',
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
          [],
      isAdult: json['isAdult'] as bool? ?? false,
      totalWordCount: json['totalWordCount'] as int? ?? 0,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      ratingCount: json['ratingCount'] as int? ?? 0,
    );
  }

  factory BookModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return BookModel.fromJson({'id': doc.id, ...data});
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'authorId': authorId,
      'authorName': authorName,
      'coverUrl': coverUrl,
      'chapterIds': chapterIds,
      'genres': genres.map((e) => e.name).toList(),
      'status': status.name,
      'viewCount': viewCount,
      'likeCount': likeCount,
      'commentCount': commentCount,
      'chapterCount': chapterCount,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'publishedAt': publishedAt != null
          ? Timestamp.fromDate(publishedAt!)
          : null,
      'completedAt': completedAt != null
          ? Timestamp.fromDate(completedAt!)
          : null,
      'language': language,
      'tags': tags,
      'isAdult': isAdult,
      'totalWordCount': totalWordCount,
      'rating': rating,
      'ratingCount': ratingCount,
    };
  }

  Map<String, dynamic> toFirestore() {
    final json = toJson();
    json.remove('id');
    return json;
  }

  factory BookModel.fromEntity(Book book) {
    return BookModel(
      id: book.id,
      title: book.title,
      description: book.description,
      authorId: book.authorId,
      authorName: book.authorName,
      coverUrl: book.coverUrl,
      chapterIds: book.chapterIds,
      genres: book.genres,
      status: book.status,
      viewCount: book.viewCount,
      likeCount: book.likeCount,
      commentCount: book.commentCount,
      chapterCount: book.chapterCount,
      createdAt: book.createdAt,
      updatedAt: book.updatedAt,
      publishedAt: book.publishedAt,
      completedAt: book.completedAt,
      language: book.language,
      tags: book.tags,
      isAdult: book.isAdult,
      totalWordCount: book.totalWordCount,
      rating: book.rating,
      ratingCount: book.ratingCount,
    );
  }
}
