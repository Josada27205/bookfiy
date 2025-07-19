import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.email,
    required super.username,
    required super.fullName,
    super.photoUrl,
    super.bio,
    super.website,
    super.followersCount,
    super.followingCount,
    super.booksCount,
    required super.createdAt,
    required super.updatedAt,
    super.favoriteGenres,
    super.isVerified,
    super.isActive,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      username: json['username'] as String,
      fullName: json['fullName'] as String,
      photoUrl: json['photoUrl'] as String?,
      bio: json['bio'] as String?,
      website: json['website'] as String?,
      followersCount: json['followersCount'] as int? ?? 0,
      followingCount: json['followingCount'] as int? ?? 0,
      booksCount: json['booksCount'] as int? ?? 0,
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      updatedAt: (json['updatedAt'] as Timestamp).toDate(),
      favoriteGenres:
          (json['favoriteGenres'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      isVerified: json['isVerified'] as bool? ?? false,
      isActive: json['isActive'] as bool? ?? true,
    );
  }

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel.fromJson({'id': doc.id, ...data});
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'username': username,
      'fullName': fullName,
      'photoUrl': photoUrl,
      'bio': bio,
      'website': website,
      'followersCount': followersCount,
      'followingCount': followingCount,
      'booksCount': booksCount,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'favoriteGenres': favoriteGenres,
      'isVerified': isVerified,
      'isActive': isActive,
    };
  }

  Map<String, dynamic> toFirestore() {
    final json = toJson();
    json.remove('id');
    return json;
  }

  factory UserModel.fromEntity(User user) {
    return UserModel(
      id: user.id,
      email: user.email,
      username: user.username,
      fullName: user.fullName,
      photoUrl: user.photoUrl,
      bio: user.bio,
      website: user.website,
      followersCount: user.followersCount,
      followingCount: user.followingCount,
      booksCount: user.booksCount,
      createdAt: user.createdAt,
      updatedAt: user.updatedAt,
      favoriteGenres: user.favoriteGenres,
      isVerified: user.isVerified,
      isActive: user.isActive,
    );
  }
}
