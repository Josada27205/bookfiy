import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

import '../../../../core/errors/exceptions.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> signIn({required String email, required String password});

  Future<UserModel> signUp({
    required String email,
    required String password,
    required String username,
    required String fullName,
  });

  Future<void> signOut();

  Future<UserModel> getCurrentUser();

  Stream<UserModel?> get authStateChanges;

  Future<void> resetPassword({required String email});

  Future<void> updatePassword({
    required String currentPassword,
    required String newPassword,
  });

  Future<UserModel> updateProfile({
    String? fullName,
    String? bio,
    String? website,
    String? photoUrl,
    List<String>? favoriteGenres,
  });

  Future<void> deleteAccount();

  Future<bool> checkUsernameAvailability(String username);

  Future<void> sendEmailVerification();

  Future<void> reloadUser();

  Future<String?> uploadProfilePhoto(File photo);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final firebase_auth.FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;

  AuthRemoteDataSourceImpl({
    required firebase_auth.FirebaseAuth firebaseAuth,
    required FirebaseFirestore firestore,
    required FirebaseStorage storage,
  }) : _firebaseAuth = firebaseAuth,
       _firestore = firestore,
       _storage = storage;

  @override
  Future<UserModel> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user == null) {
        throw const AuthException(message: 'Sign in failed');
      }

      final userDoc = await _firestore
          .collection('users')
          .doc(credential.user!.uid)
          .get();

      if (!userDoc.exists) {
        throw const NotFoundException('User data not found');
      }

      return UserModel.fromFirestore(userDoc);
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw AuthException(message: e.message, code: e.code);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<UserModel> signUp({
    required String email,
    required String password,
    required String username,
    required String fullName,
  }) async {
    try {
      // Check username availability
      final isAvailable = await checkUsernameAvailability(username);
      if (!isAvailable) {
        throw const AuthException(message: 'Username already taken');
      }

      // Create auth user
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user == null) {
        throw const AuthException(message: 'Sign up failed');
      }

      // Create user document
      final now = DateTime.now();
      final user = UserModel(
        id: credential.user!.uid,
        email: email,
        username: username,
        fullName: fullName,
        createdAt: now,
        updatedAt: now,
      );

      await _firestore
          .collection('users')
          .doc(credential.user!.uid)
          .set(user.toFirestore());

      // Create username document for uniqueness
      await _firestore.collection('usernames').doc(username).set({
        'userId': credential.user!.uid,
        'createdAt': FieldValue.serverTimestamp(),
      });

      // Send verification email
      await sendEmailVerification();

      return user;
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw AuthException(message: e.message, code: e.code);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<UserModel> getCurrentUser() async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null) {
        throw const AuthException(message: 'No user logged in');
      }

      final userDoc = await _firestore.collection('users').doc(user.uid).get();

      if (!userDoc.exists) {
        throw const NotFoundException('User data not found');
      }

      return UserModel.fromFirestore(userDoc);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Stream<UserModel?> get authStateChanges {
    return _firebaseAuth.authStateChanges().asyncMap((user) async {
      if (user == null) return null;

      final userDoc = await _firestore.collection('users').doc(user.uid).get();

      if (!userDoc.exists) return null;

      return UserModel.fromFirestore(userDoc);
    });
  }

  @override
  Future<void> resetPassword({required String email}) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw AuthException(message: e.message, code: e.code);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> updatePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null) {
        throw const AuthException(message: 'No user logged in');
      }

      // Re-authenticate user
      final credential = firebase_auth.EmailAuthProvider.credential(
        email: user.email!,
        password: currentPassword,
      );

      await user.reauthenticateWithCredential(credential);
      await user.updatePassword(newPassword);
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw AuthException(message: e.message, code: e.code);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<UserModel> updateProfile({
    String? fullName,
    String? bio,
    String? website,
    String? photoUrl,
    List<String>? favoriteGenres,
  }) async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null) {
        throw const AuthException(message: 'No user logged in');
      }

      final updates = <String, dynamic>{
        'updatedAt': FieldValue.serverTimestamp(),
      };

      if (fullName != null) updates['fullName'] = fullName;
      if (bio != null) updates['bio'] = bio;
      if (website != null) updates['website'] = website;
      if (photoUrl != null) updates['photoUrl'] = photoUrl;
      if (favoriteGenres != null) updates['favoriteGenres'] = favoriteGenres;

      await _firestore.collection('users').doc(user.uid).update(updates);

      return getCurrentUser();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> deleteAccount() async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null) {
        throw const AuthException(message: 'No user logged in');
      }

      // Delete user data
      await _firestore.collection('users').doc(user.uid).delete();

      // Delete auth account
      await user.delete();
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw AuthException(message: e.message, code: e.code);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<bool> checkUsernameAvailability(String username) async {
    try {
      final doc = await _firestore.collection('usernames').doc(username).get();
      return !doc.exists;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> sendEmailVerification() async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null) {
        throw const AuthException(message: 'No user logged in');
      }

      await user.sendEmailVerification();
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw AuthException(message: e.message, code: e.code);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> reloadUser() async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null) {
        throw const AuthException(message: 'No user logged in');
      }

      await user.reload();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<String?> uploadProfilePhoto(File photo) async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null) {
        throw const AuthException(message: 'No user logged in');
      }

      final ref = _storage.ref().child('users/${user.uid}/profile.jpg');
      final uploadTask = await ref.putFile(
        photo,
        SettableMetadata(contentType: 'image/jpeg'),
      );

      return await uploadTask.ref.getDownloadURL();
    } catch (e) {
      throw StorageException(e.toString());
    }
  }
}
