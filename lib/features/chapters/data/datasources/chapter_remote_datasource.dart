import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

import '../../../../core/errors/exceptions.dart';
import '../../domain/entities/chapter.dart';
import '../models/chapter_model.dart';

abstract class ChapterRemoteDataSource {
  Future<ChapterModel> createChapter({
    required String bookId,
    required String title,
    required String content,
    String? authorNote,
  });

  Future<ChapterModel> getChapter({
    required String bookId,
    required String chapterId,
  });

  Future<List<ChapterModel>> getChapters(String bookId);

  Future<ChapterModel> updateChapter({
    required String bookId,
    required String chapterId,
    String? title,
    String? content,
    String? authorNote,
  });

  Future<void> publishChapter({
    required String bookId,
    required String chapterId,
  });

  Future<void> unpublishChapter({
    required String bookId,
    required String chapterId,
  });

  Future<void> deleteChapter({
    required String bookId,
    required String chapterId,
  });

  Future<void> reorderChapters({
    required String bookId,
    required List<String> chapterIds,
  });

  Future<void> incrementViewCount({
    required String bookId,
    required String chapterId,
  });

  Future<void> likeChapter({required String bookId, required String chapterId});

  Future<void> unlikeChapter({
    required String bookId,
    required String chapterId,
  });

  Stream<ChapterModel> watchChapter({
    required String bookId,
    required String chapterId,
  });

  Stream<List<ChapterModel>> watchChapters(String bookId);
}

class ChapterRemoteDataSourceImpl implements ChapterRemoteDataSource {
  final FirebaseFirestore _firestore;
  final firebase_auth.FirebaseAuth _auth;

  ChapterRemoteDataSourceImpl({
    required FirebaseFirestore firestore,
    required firebase_auth.FirebaseAuth auth,
  }) : _firestore = firestore,
       _auth = auth;

  String get _currentUserId {
    final user = _auth.currentUser;
    if (user == null) {
      throw const AuthException(message: 'No user logged in');
    }
    return user.uid;
  }

  int _countWords(String text) {
    return text
        .trim()
        .split(RegExp(r'\s+'))
        .where((word) => word.isNotEmpty)
        .length;
  }

  @override
  Future<ChapterModel> createChapter({
    required String bookId,
    required String title,
    required String content,
    String? authorNote,
  }) async {
    try {
      // Get current chapter count
      final chaptersSnapshot = await _firestore
          .collection('books')
          .doc(bookId)
          .collection('chapters')
          .get();

      final chapterNumber = chaptersSnapshot.docs.length + 1;
      final wordCount = _countWords(content);
      final now = DateTime.now();

      final chapterData = {
        'bookId': bookId,
        'title': title,
        'content': content,
        'chapterNumber': chapterNumber,
        'status': ChapterStatus.draft.name,
        'wordCount': wordCount,
        'viewCount': 0,
        'likeCount': 0,
        'commentCount': 0,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
        'publishedAt': null,
        'authorNote': authorNote,
      };

      final docRef = await _firestore
          .collection('books')
          .doc(bookId)
          .collection('chapters')
          .add(chapterData);

      // Update book's chapter count and total word count
      await _firestore.collection('books').doc(bookId).update({
        'chapterCount': FieldValue.increment(1),
        'totalWordCount': FieldValue.increment(wordCount),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      return await getChapter(bookId: bookId, chapterId: docRef.id);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<ChapterModel> getChapter({
    required String bookId,
    required String chapterId,
  }) async {
    try {
      final doc = await _firestore
          .collection('books')
          .doc(bookId)
          .collection('chapters')
          .doc(chapterId)
          .get();

      if (!doc.exists) {
        throw const NotFoundException('Chapter not found');
      }

      return ChapterModel.fromFirestore(doc);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<ChapterModel>> getChapters(String bookId) async {
    try {
      final querySnapshot = await _firestore
          .collection('books')
          .doc(bookId)
          .collection('chapters')
          .orderBy('chapterNumber')
          .get();

      return querySnapshot.docs
          .map((doc) => ChapterModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<ChapterModel> updateChapter({
    required String bookId,
    required String chapterId,
    String? title,
    String? content,
    String? authorNote,
  }) async {
    try {
      final updates = <String, dynamic>{
        'updatedAt': FieldValue.serverTimestamp(),
      };

      int? wordCountDiff;

      if (title != null) updates['title'] = title;
      if (authorNote != null) updates['authorNote'] = authorNote;

      if (content != null) {
        updates['content'] = content;
        final newWordCount = _countWords(content);
        updates['wordCount'] = newWordCount;

        // Get old word count
        final oldChapter = await getChapter(
          bookId: bookId,
          chapterId: chapterId,
        );
        wordCountDiff = newWordCount - oldChapter.wordCount;
      }

      await _firestore
          .collection('books')
          .doc(bookId)
          .collection('chapters')
          .doc(chapterId)
          .update(updates);

      // Update book's total word count if content changed
      if (wordCountDiff != null) {
        await _firestore.collection('books').doc(bookId).update({
          'totalWordCount': FieldValue.increment(wordCountDiff),
          'updatedAt': FieldValue.serverTimestamp(),
        });
      }

      return await getChapter(bookId: bookId, chapterId: chapterId);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> publishChapter({
    required String bookId,
    required String chapterId,
  }) async {
    try {
      await _firestore
          .collection('books')
          .doc(bookId)
          .collection('chapters')
          .doc(chapterId)
          .update({
            'status': ChapterStatus.published.name,
            'publishedAt': FieldValue.serverTimestamp(),
            'updatedAt': FieldValue.serverTimestamp(),
          });

      // Update book's updated time
      await _firestore.collection('books').doc(bookId).update({
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> unpublishChapter({
    required String bookId,
    required String chapterId,
  }) async {
    try {
      await _firestore
          .collection('books')
          .doc(bookId)
          .collection('chapters')
          .doc(chapterId)
          .update({
            'status': ChapterStatus.draft.name,
            'publishedAt': null,
            'updatedAt': FieldValue.serverTimestamp(),
          });
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> deleteChapter({
    required String bookId,
    required String chapterId,
  }) async {
    try {
      // Get chapter for word count
      final chapter = await getChapter(bookId: bookId, chapterId: chapterId);

      // Delete chapter
      await _firestore
          .collection('books')
          .doc(bookId)
          .collection('chapters')
          .doc(chapterId)
          .delete();

      // Update book's chapter count and total word count
      await _firestore.collection('books').doc(bookId).update({
        'chapterCount': FieldValue.increment(-1),
        'totalWordCount': FieldValue.increment(-chapter.wordCount),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      // Reorder remaining chapters
      final remainingChapters = await getChapters(bookId);
      final batch = _firestore.batch();

      for (int i = 0; i < remainingChapters.length; i++) {
        if (remainingChapters[i].chapterNumber != i + 1) {
          batch.update(
            _firestore
                .collection('books')
                .doc(bookId)
                .collection('chapters')
                .doc(remainingChapters[i].id),
            {'chapterNumber': i + 1},
          );
        }
      }

      await batch.commit();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> reorderChapters({
    required String bookId,
    required List<String> chapterIds,
  }) async {
    try {
      final batch = _firestore.batch();

      for (int i = 0; i < chapterIds.length; i++) {
        batch.update(
          _firestore
              .collection('books')
              .doc(bookId)
              .collection('chapters')
              .doc(chapterIds[i]),
          {'chapterNumber': i + 1},
        );
      }

      await batch.commit();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> incrementViewCount({
    required String bookId,
    required String chapterId,
  }) async {
    try {
      await _firestore
          .collection('books')
          .doc(bookId)
          .collection('chapters')
          .doc(chapterId)
          .update({'viewCount': FieldValue.increment(1)});
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> likeChapter({
    required String bookId,
    required String chapterId,
  }) async {
    try {
      final userId = _currentUserId;

      final batch = _firestore.batch();

      // Add to user's liked chapters
      batch.set(
        _firestore
            .collection('users')
            .doc(userId)
            .collection('likedChapters')
            .doc('${bookId}_$chapterId'),
        {
          'bookId': bookId,
          'chapterId': chapterId,
          'likedAt': FieldValue.serverTimestamp(),
        },
      );

      // Increment chapter's like count
      batch.update(
        _firestore
            .collection('books')
            .doc(bookId)
            .collection('chapters')
            .doc(chapterId),
        {'likeCount': FieldValue.increment(1)},
      );

      await batch.commit();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> unlikeChapter({
    required String bookId,
    required String chapterId,
  }) async {
    try {
      final userId = _currentUserId;

      final batch = _firestore.batch();

      // Remove from user's liked chapters
      batch.delete(
        _firestore
            .collection('users')
            .doc(userId)
            .collection('likedChapters')
            .doc('${bookId}_$chapterId'),
      );

      // Decrement chapter's like count
      batch.update(
        _firestore
            .collection('books')
            .doc(bookId)
            .collection('chapters')
            .doc(chapterId),
        {'likeCount': FieldValue.increment(-1)},
      );

      await batch.commit();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Stream<ChapterModel> watchChapter({
    required String bookId,
    required String chapterId,
  }) {
    return _firestore
        .collection('books')
        .doc(bookId)
        .collection('chapters')
        .doc(chapterId)
        .snapshots()
        .map((doc) {
          if (!doc.exists) {
            throw const NotFoundException('Chapter not found');
          }
          return ChapterModel.fromFirestore(doc);
        });
  }

  @override
  Stream<List<ChapterModel>> watchChapters(String bookId) {
    return _firestore
        .collection('books')
        .doc(bookId)
        .collection('chapters')
        .orderBy('chapterNumber')
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => ChapterModel.fromFirestore(doc))
              .toList();
        });
  }
}
