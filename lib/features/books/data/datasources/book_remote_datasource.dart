import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

import '../../../../core/errors/exceptions.dart';
import '../../domain/entities/book.dart';
import '../models/book_model.dart';

abstract class BookRemoteDataSource {
  Future<BookModel> createBook({
    required String title,
    required String description,
    required List<BookGenre> genres,
    String? coverUrl,
    List<String>? tags,
    bool isAdult = false,
  });

  Future<BookModel> getBook(String bookId);

  Future<List<BookModel>> getUserBooks(String userId);

  Future<List<BookModel>> getPublishedBooks({
    int limit = 20,
    String? lastDocumentId,
  });

  Future<List<BookModel>> searchBooks({
    String? query,
    List<BookGenre>? genres,
    BookStatus? status,
    int limit = 20,
  });

  Future<BookModel> updateBook({
    required String bookId,
    String? title,
    String? description,
    List<BookGenre>? genres,
    String? coverUrl,
    List<String>? tags,
    bool? isAdult,
  });

  Future<void> publishBook(String bookId);

  Future<void> unpublishBook(String bookId);

  Future<void> completeBook(String bookId);

  Future<void> deleteBook(String bookId);

  Future<void> incrementViewCount(String bookId);

  Future<void> likeBook(String bookId);

  Future<void> unlikeBook(String bookId);

  Future<bool> isBookLiked(String bookId);

  Future<List<BookModel>> getLikedBooks();

  Future<List<BookModel>> getBooksByGenre(
    BookGenre genre, {
    int limit = 20,
    String? lastDocumentId,
  });

  Future<List<BookModel>> getTrendingBooks({int limit = 20});

  Future<List<BookModel>> getRecentlyUpdatedBooks({
    int limit = 20,
    String? lastDocumentId,
  });

  Future<void> rateBook({required String bookId, required double rating});

  Stream<BookModel> watchBook(String bookId);

  Stream<List<BookModel>> watchUserBooks(String userId);

  Future<String?> uploadBookCover(File cover);
}

class BookRemoteDataSourceImpl implements BookRemoteDataSource {
  final FirebaseFirestore _firestore;
  final firebase_auth.FirebaseAuth _auth;
  final FirebaseStorage _storage;

  BookRemoteDataSourceImpl({
    required FirebaseFirestore firestore,
    required firebase_auth.FirebaseAuth auth,
    required FirebaseStorage storage,
  }) : _firestore = firestore,
       _auth = auth,
       _storage = storage;

  String get _currentUserId {
    final user = _auth.currentUser;
    if (user == null) {
      throw const AuthException(message: 'No user logged in');
    }
    return user.uid;
  }

  @override
  Future<BookModel> createBook({
    required String title,
    required String description,
    required List<BookGenre> genres,
    String? coverUrl,
    List<String>? tags,
    bool isAdult = false,
  }) async {
    try {
      final userId = _currentUserId;

      // Get user data for author name
      final userDoc = await _firestore.collection('users').doc(userId).get();
      if (!userDoc.exists) {
        throw const NotFoundException('User not found');
      }

      final userData = userDoc.data()!;
      final now = DateTime.now();

      final bookData = {
        'title': title,
        'description': description,
        'authorId': userId,
        'authorName': userData['fullName'] ?? userData['username'],
        'coverUrl': coverUrl,
        'chapterIds': [],
        'genres': genres.map((e) => e.name).toList(),
        'status': BookStatus.draft.name,
        'viewCount': 0,
        'likeCount': 0,
        'commentCount': 0,
        'chapterCount': 0,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
        'publishedAt': null,
        'completedAt': null,
        'language': 'en',
        'tags': tags ?? [],
        'isAdult': isAdult,
        'totalWordCount': 0,
        'rating': 0.0,
        'ratingCount': 0,
      };

      final docRef = await _firestore.collection('books').add(bookData);

      // Update user's book count
      await _firestore.collection('users').doc(userId).update({
        'booksCount': FieldValue.increment(1),
      });

      final createdBook = await getBook(docRef.id);
      return createdBook;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<BookModel> getBook(String bookId) async {
    try {
      final doc = await _firestore.collection('books').doc(bookId).get();

      if (!doc.exists) {
        throw const NotFoundException('Book not found');
      }

      return BookModel.fromFirestore(doc);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<BookModel>> getUserBooks(String userId) async {
    try {
      final querySnapshot = await _firestore
          .collection('books')
          .where('authorId', isEqualTo: userId)
          .orderBy('updatedAt', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => BookModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<BookModel>> getPublishedBooks({
    int limit = 20,
    String? lastDocumentId,
  }) async {
    try {
      Query query = _firestore
          .collection('books')
          .where('status', isEqualTo: BookStatus.published.name)
          .orderBy('updatedAt', descending: true)
          .limit(limit);

      if (lastDocumentId != null) {
        final lastDoc = await _firestore
            .collection('books')
            .doc(lastDocumentId)
            .get();
        if (lastDoc.exists) {
          query = query.startAfterDocument(lastDoc);
        }
      }

      final querySnapshot = await query.get();
      return querySnapshot.docs
          .map((doc) => BookModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<BookModel>> searchBooks({
    String? query,
    List<BookGenre>? genres,
    BookStatus? status,
    int limit = 20,
  }) async {
    try {
      Query firestoreQuery = _firestore.collection('books');

      if (status != null) {
        firestoreQuery = firestoreQuery.where('status', isEqualTo: status.name);
      }

      if (genres != null && genres.isNotEmpty) {
        firestoreQuery = firestoreQuery.where(
          'genres',
          arrayContainsAny: genres.map((e) => e.name).toList(),
        );
      }

      firestoreQuery = firestoreQuery.limit(limit);

      final querySnapshot = await firestoreQuery.get();
      var books = querySnapshot.docs
          .map((doc) => BookModel.fromFirestore(doc))
          .toList();

      // Client-side filtering for title/description search
      if (query != null && query.isNotEmpty) {
        final searchQuery = query.toLowerCase();
        books = books.where((book) {
          return book.title.toLowerCase().contains(searchQuery) ||
              book.description.toLowerCase().contains(searchQuery) ||
              book.tags.any((tag) => tag.toLowerCase().contains(searchQuery));
        }).toList();
      }

      return books;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<BookModel> updateBook({
    required String bookId,
    String? title,
    String? description,
    List<BookGenre>? genres,
    String? coverUrl,
    List<String>? tags,
    bool? isAdult,
  }) async {
    try {
      final updates = <String, dynamic>{
        'updatedAt': FieldValue.serverTimestamp(),
      };

      if (title != null) updates['title'] = title;
      if (description != null) updates['description'] = description;
      if (genres != null)
        updates['genres'] = genres.map((e) => e.name).toList();
      if (coverUrl != null) updates['coverUrl'] = coverUrl;
      if (tags != null) updates['tags'] = tags;
      if (isAdult != null) updates['isAdult'] = isAdult;

      await _firestore.collection('books').doc(bookId).update(updates);

      return await getBook(bookId);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> publishBook(String bookId) async {
    try {
      await _firestore.collection('books').doc(bookId).update({
        'status': BookStatus.published.name,
        'publishedAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> unpublishBook(String bookId) async {
    try {
      await _firestore.collection('books').doc(bookId).update({
        'status': BookStatus.draft.name,
        'publishedAt': null,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> completeBook(String bookId) async {
    try {
      await _firestore.collection('books').doc(bookId).update({
        'status': BookStatus.completed.name,
        'completedAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> deleteBook(String bookId) async {
    try {
      final userId = _currentUserId;

      // Delete all chapters
      final chaptersSnapshot = await _firestore
          .collection('books')
          .doc(bookId)
          .collection('chapters')
          .get();

      for (final doc in chaptersSnapshot.docs) {
        await doc.reference.delete();
      }

      // Delete book
      await _firestore.collection('books').doc(bookId).delete();

      // Update user's book count
      await _firestore.collection('users').doc(userId).update({
        'booksCount': FieldValue.increment(-1),
      });
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> incrementViewCount(String bookId) async {
    try {
      await _firestore.collection('books').doc(bookId).update({
        'viewCount': FieldValue.increment(1),
      });
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> likeBook(String bookId) async {
    try {
      final userId = _currentUserId;

      final batch = _firestore.batch();

      // Add to user's liked books
      batch.set(
        _firestore
            .collection('users')
            .doc(userId)
            .collection('likedBooks')
            .doc(bookId),
        {'likedAt': FieldValue.serverTimestamp()},
      );

      // Increment book's like count
      batch.update(_firestore.collection('books').doc(bookId), {
        'likeCount': FieldValue.increment(1),
      });

      await batch.commit();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> unlikeBook(String bookId) async {
    try {
      final userId = _currentUserId;

      final batch = _firestore.batch();

      // Remove from user's liked books
      batch.delete(
        _firestore
            .collection('users')
            .doc(userId)
            .collection('likedBooks')
            .doc(bookId),
      );

      // Decrement book's like count
      batch.update(_firestore.collection('books').doc(bookId), {
        'likeCount': FieldValue.increment(-1),
      });

      await batch.commit();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<bool> isBookLiked(String bookId) async {
    try {
      final userId = _currentUserId;

      final doc = await _firestore
          .collection('users')
          .doc(userId)
          .collection('likedBooks')
          .doc(bookId)
          .get();

      return doc.exists;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<BookModel>> getLikedBooks() async {
    try {
      final userId = _currentUserId;

      final likedBooksSnapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('likedBooks')
          .orderBy('likedAt', descending: true)
          .get();

      final bookIds = likedBooksSnapshot.docs.map((doc) => doc.id).toList();

      if (bookIds.isEmpty) {
        return [];
      }

      // Get books in batches (Firestore limit is 10 for 'whereIn')
      final books = <BookModel>[];
      for (var i = 0; i < bookIds.length; i += 10) {
        final batch = bookIds.skip(i).take(10).toList();
        final booksSnapshot = await _firestore
            .collection('books')
            .where(FieldPath.documentId, whereIn: batch)
            .get();

        books.addAll(
          booksSnapshot.docs.map((doc) => BookModel.fromFirestore(doc)),
        );
      }

      return books;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<BookModel>> getBooksByGenre(
    BookGenre genre, {
    int limit = 20,
    String? lastDocumentId,
  }) async {
    try {
      Query query = _firestore
          .collection('books')
          .where('genres', arrayContains: genre.name)
          .where('status', isEqualTo: BookStatus.published.name)
          .orderBy('likeCount', descending: true)
          .limit(limit);

      if (lastDocumentId != null) {
        final lastDoc = await _firestore
            .collection('books')
            .doc(lastDocumentId)
            .get();
        if (lastDoc.exists) {
          query = query.startAfterDocument(lastDoc);
        }
      }

      final querySnapshot = await query.get();
      return querySnapshot.docs
          .map((doc) => BookModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<BookModel>> getTrendingBooks({int limit = 20}) async {
    try {
      // Simplified query while waiting for index
      final querySnapshot = await _firestore
          .collection('books')
          .where('status', isEqualTo: BookStatus.published.name)
          .orderBy('updatedAt', descending: true)
          .limit(limit)
          .get();

      return querySnapshot.docs
          .map((doc) => BookModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<BookModel>> getRecentlyUpdatedBooks({
    int limit = 20,
    String? lastDocumentId,
  }) async {
    try {
      Query query = _firestore
          .collection('books')
          .where('status', isEqualTo: BookStatus.published.name)
          .orderBy('updatedAt', descending: true)
          .limit(limit);

      if (lastDocumentId != null) {
        final lastDoc = await _firestore
            .collection('books')
            .doc(lastDocumentId)
            .get();
        if (lastDoc.exists) {
          query = query.startAfterDocument(lastDoc);
        }
      }

      final querySnapshot = await query.get();
      return querySnapshot.docs
          .map((doc) => BookModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> rateBook({
    required String bookId,
    required double rating,
  }) async {
    try {
      final userId = _currentUserId;

      // Check if user already rated
      final existingRating = await _firestore
          .collection('books')
          .doc(bookId)
          .collection('ratings')
          .doc(userId)
          .get();

      final batch = _firestore.batch();

      if (existingRating.exists) {
        // Update existing rating
        final oldRating = existingRating.data()!['rating'] as num;

        batch.update(
          _firestore
              .collection('books')
              .doc(bookId)
              .collection('ratings')
              .doc(userId),
          {'rating': rating, 'updatedAt': FieldValue.serverTimestamp()},
        );

        // Update book's average rating
        final bookDoc = await _firestore.collection('books').doc(bookId).get();
        final bookData = bookDoc.data()!;
        final currentRating = bookData['rating'] as num;
        final ratingCount = bookData['ratingCount'] as int;

        final newAverage =
            ((currentRating * ratingCount) - oldRating + rating) / ratingCount;

        batch.update(_firestore.collection('books').doc(bookId), {
          'rating': newAverage,
        });
      } else {
        // Add new rating
        batch.set(
          _firestore
              .collection('books')
              .doc(bookId)
              .collection('ratings')
              .doc(userId),
          {
            'rating': rating,
            'userId': userId,
            'createdAt': FieldValue.serverTimestamp(),
          },
        );

        // Update book's average rating
        final bookDoc = await _firestore.collection('books').doc(bookId).get();
        final bookData = bookDoc.data()!;
        final currentRating = bookData['rating'] as num;
        final ratingCount = bookData['ratingCount'] as int;

        final newAverage =
            ((currentRating * ratingCount) + rating) / (ratingCount + 1);

        batch.update(_firestore.collection('books').doc(bookId), {
          'rating': newAverage,
          'ratingCount': FieldValue.increment(1),
        });
      }

      await batch.commit();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Stream<BookModel> watchBook(String bookId) {
    return _firestore.collection('books').doc(bookId).snapshots().map((doc) {
      if (!doc.exists) {
        throw const NotFoundException('Book not found');
      }
      return BookModel.fromFirestore(doc);
    });
  }

  @override
  Stream<List<BookModel>> watchUserBooks(String userId) {
    return _firestore
        .collection('books')
        .where('authorId', isEqualTo: userId)
        .orderBy('updatedAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => BookModel.fromFirestore(doc))
              .toList();
        });
  }

  @override
  Future<String?> uploadBookCover(File cover) async {
    try {
      final userId = _currentUserId;
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final ref = _storage.ref().child('books/$userId/covers/$timestamp.jpg');

      final uploadTask = await ref.putFile(
        cover,
        SettableMetadata(contentType: 'image/jpeg'),
      );

      return await uploadTask.ref.getDownloadURL();
    } catch (e) {
      throw StorageException(e.toString());
    }
  }
}
