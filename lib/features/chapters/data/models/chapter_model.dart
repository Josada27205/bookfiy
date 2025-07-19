import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/chapter.dart';

class ChapterModel extends Chapter {
  const ChapterModel({
    required super.id,
    required super.bookId,
    required super.title,
    required super.content,
    required super.chapterNumber,
    super.status,
    super.wordCount,
    super.viewCount,
    super.likeCount,
    super.commentCount,
    required super.createdAt,
    required super.updatedAt,
    super.publishedAt,
    super.authorNote,
  });

  factory ChapterModel.fromJson(Map<String, dynamic> json) {
    return ChapterModel(
      id: json['id'] as String,
      bookId: json['bookId'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      chapterNumber: json['chapterNumber'] as int,
      status: ChapterStatus.values.firstWhere(
        (status) => status.name == json['status'],
        orElse: () => ChapterStatus.draft,
      ),
      wordCount: json['wordCount'] as int? ?? 0,
      viewCount: json['viewCount'] as int? ?? 0,
      likeCount: json['likeCount'] as int? ?? 0,
      commentCount: json['commentCount'] as int? ?? 0,
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      updatedAt: (json['updatedAt'] as Timestamp).toDate(),
      publishedAt: json['publishedAt'] != null
          ? (json['publishedAt'] as Timestamp).toDate()
          : null,
      authorNote: json['authorNote'] as String?,
    );
  }

  factory ChapterModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ChapterModel.fromJson({'id': doc.id, ...data});
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'bookId': bookId,
      'title': title,
      'content': content,
      'chapterNumber': chapterNumber,
      'status': status.name,
      'wordCount': wordCount,
      'viewCount': viewCount,
      'likeCount': likeCount,
      'commentCount': commentCount,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'publishedAt': publishedAt != null
          ? Timestamp.fromDate(publishedAt!)
          : null,
      'authorNote': authorNote,
    };
  }

  Map<String, dynamic> toFirestore() {
    final json = toJson();
    json.remove('id');
    return json;
  }

  factory ChapterModel.fromEntity(Chapter chapter) {
    return ChapterModel(
      id: chapter.id,
      bookId: chapter.bookId,
      title: chapter.title,
      content: chapter.content,
      chapterNumber: chapter.chapterNumber,
      status: chapter.status,
      wordCount: chapter.wordCount,
      viewCount: chapter.viewCount,
      likeCount: chapter.likeCount,
      commentCount: chapter.commentCount,
      createdAt: chapter.createdAt,
      updatedAt: chapter.updatedAt,
      publishedAt: chapter.publishedAt,
      authorNote: chapter.authorNote,
    );
  }
}
