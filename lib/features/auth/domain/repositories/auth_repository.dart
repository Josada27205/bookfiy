import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user.dart';

abstract class AuthRepository {
  Future<Either<Failure, User>> signIn({
    required String email,
    required String password,
  });

  Future<Either<Failure, User>> signUp({
    required String email,
    required String password,
    required String username,
    required String fullName,
  });

  Future<Either<Failure, void>> signOut();

  Future<Either<Failure, User>> getCurrentUser();

  Stream<User?> get authStateChanges;

  Future<Either<Failure, void>> resetPassword({required String email});

  Future<Either<Failure, void>> updatePassword({
    required String currentPassword,
    required String newPassword,
  });

  Future<Either<Failure, User>> updateProfile({
    String? fullName,
    String? bio,
    String? website,
    String? photoUrl,
    List<String>? favoriteGenres,
  });

  Future<Either<Failure, void>> deleteAccount();

  Future<Either<Failure, bool>> checkUsernameAvailability(String username);

  Future<Either<Failure, void>> sendEmailVerification();

  Future<Either<Failure, void>> reloadUser();
}
