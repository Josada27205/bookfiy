import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String email;
  final String username;
  final String fullName;
  final String? photoUrl;
  final String? bio;
  final String? website;
  final int followersCount;
  final int followingCount;
  final int booksCount;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<String> favoriteGenres;
  final bool isVerified;
  final bool isActive;

  const User({
    required this.id,
    required this.email,
    required this.username,
    required this.fullName,
    this.photoUrl,
    this.bio,
    this.website,
    this.followersCount = 0,
    this.followingCount = 0,
    this.booksCount = 0,
    required this.createdAt,
    required this.updatedAt,
    this.favoriteGenres = const [],
    this.isVerified = false,
    this.isActive = true,
  });

  User copyWith({
    String? id,
    String? email,
    String? username,
    String? fullName,
    String? photoUrl,
    String? bio,
    String? website,
    int? followersCount,
    int? followingCount,
    int? booksCount,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<String>? favoriteGenres,
    bool? isVerified,
    bool? isActive,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      username: username ?? this.username,
      fullName: fullName ?? this.fullName,
      photoUrl: photoUrl ?? this.photoUrl,
      bio: bio ?? this.bio,
      website: website ?? this.website,
      followersCount: followersCount ?? this.followersCount,
      followingCount: followingCount ?? this.followingCount,
      booksCount: booksCount ?? this.booksCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      favoriteGenres: favoriteGenres ?? this.favoriteGenres,
      isVerified: isVerified ?? this.isVerified,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  List<Object?> get props => [
    id,
    email,
    username,
    fullName,
    photoUrl,
    bio,
    website,
    followersCount,
    followingCount,
    booksCount,
    createdAt,
    updatedAt,
    favoriteGenres,
    isVerified,
    isActive,
  ];
}
