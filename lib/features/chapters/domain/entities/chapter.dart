import 'package:equatable/equatable.dart';

enum ChapterStatus { draft, published }

class Chapter extends Equatable {
  final String id;
  final String bookId;
  final String title;
  final String content;
  final int chapterNumber;
  final ChapterStatus status;
  final int wordCount;
  final int viewCount;
  final int likeCount;
  final int commentCount;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? publishedAt;
  final String? authorNote;

  const Chapter({
    required this.id,
    required this.bookId,
    required this.title,
    required this.content,
    required this.chapterNumber,
    this.status = ChapterStatus.draft,
    this.wordCount = 0,
    this.viewCount = 0,
    this.likeCount = 0,
    this.commentCount = 0,
    required this.createdAt,
    required this.updatedAt,
    this.publishedAt,
    this.authorNote,
  });

  Chapter copyWith({
    String? id,
    String? bookId,
    String? title,
    String? content,
    int? chapterNumber,
    ChapterStatus? status,
    int? wordCount,
    int? viewCount,
    int? likeCount,
    int? commentCount,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? publishedAt,
    String? authorNote,
  }) {
    return Chapter(
      id: id ?? this.id,
      bookId: bookId ?? this.bookId,
      title: title ?? this.title,
      content: content ?? this.content,
      chapterNumber: chapterNumber ?? this.chapterNumber,
      status: status ?? this.status,
      wordCount: wordCount ?? this.wordCount,
      viewCount: viewCount ?? this.viewCount,
      likeCount: likeCount ?? this.likeCount,
      commentCount: commentCount ?? this.commentCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      publishedAt: publishedAt ?? this.publishedAt,
      authorNote: authorNote ?? this.authorNote,
    );
  }

  @override
  List<Object?> get props => [
    id,
    bookId,
    title,
    content,
    chapterNumber,
    status,
    wordCount,
    viewCount,
    likeCount,
    commentCount,
    createdAt,
    updatedAt,
    publishedAt,
    authorNote,
  ];
}
