import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, User>> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final user = await remoteDataSource.signIn(
        email: email,
        password: password,
      );
      return Right(user);
    } on AuthException catch (e) {
      return Left(
        AuthFailure(
          message: e.message ?? 'Authentication failed',
          code: e.code,
        ),
      );
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message ?? 'Server error occurred'));
    } catch (e) {
      return Left(ServerFailure(message: 'An unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, User>> signUp({
    required String email,
    required String password,
    required String username,
    required String fullName,
  }) async {
    try {
      final user = await remoteDataSource.signUp(
        email: email,
        password: password,
        username: username,
        fullName: fullName,
      );
      return Right(user);
    } on AuthException catch (e) {
      return Left(
        AuthFailure(
          message: e.message ?? 'Authentication failed',
          code: e.code,
        ),
      );
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message ?? 'Server error occurred'));
    } catch (e) {
      return Left(ServerFailure(message: 'An unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      await remoteDataSource.signOut();
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message ?? 'Sign out failed'));
    } catch (e) {
      return Left(ServerFailure(message: 'An unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, User>> getCurrentUser() async {
    try {
      final user = await remoteDataSource.getCurrentUser();
      return Right(user);
    } on AuthException catch (e) {
      return Left(
        AuthFailure(message: e.message ?? 'Not authenticated', code: e.code),
      );
    } on NotFoundException catch (e) {
      return Left(NotFoundFailure(message: e.message ?? 'User not found'));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message ?? 'Server error occurred'));
    } catch (e) {
      return Left(ServerFailure(message: 'An unexpected error occurred'));
    }
  }

  @override
  Stream<User?> get authStateChanges {
    return remoteDataSource.authStateChanges;
  }

  @override
  Future<Either<Failure, void>> resetPassword({required String email}) async {
    try {
      await remoteDataSource.resetPassword(email: email);
      return const Right(null);
    } on AuthException catch (e) {
      return Left(
        AuthFailure(
          message: e.message ?? 'Password reset failed',
          code: e.code,
        ),
      );
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message ?? 'Server error occurred'));
    } catch (e) {
      return Left(ServerFailure(message: 'An unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, void>> updatePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      await remoteDataSource.updatePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
      );
      return const Right(null);
    } on AuthException catch (e) {
      return Left(
        AuthFailure(
          message: e.message ?? 'Password update failed',
          code: e.code,
        ),
      );
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message ?? 'Server error occurred'));
    } catch (e) {
      return Left(ServerFailure(message: 'An unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, User>> updateProfile({
    String? fullName,
    String? bio,
    String? website,
    String? photoUrl,
    List<String>? favoriteGenres,
  }) async {
    try {
      final user = await remoteDataSource.updateProfile(
        fullName: fullName,
        bio: bio,
        website: website,
        photoUrl: photoUrl,
        favoriteGenres: favoriteGenres,
      );
      return Right(user);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message ?? 'Profile update failed'));
    } catch (e) {
      return Left(ServerFailure(message: 'An unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteAccount() async {
    try {
      await remoteDataSource.deleteAccount();
      return const Right(null);
    } on AuthException catch (e) {
      return Left(
        AuthFailure(
          message: e.message ?? 'Account deletion failed',
          code: e.code,
        ),
      );
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message ?? 'Server error occurred'));
    } catch (e) {
      return Left(ServerFailure(message: 'An unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, bool>> checkUsernameAvailability(
    String username,
  ) async {
    try {
      final isAvailable = await remoteDataSource.checkUsernameAvailability(
        username,
      );
      return Right(isAvailable);
    } on ServerException catch (e) {
      return Left(
        ServerFailure(message: e.message ?? 'Failed to check username'),
      );
    } catch (e) {
      return Left(ServerFailure(message: 'An unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, void>> sendEmailVerification() async {
    try {
      await remoteDataSource.sendEmailVerification();
      return const Right(null);
    } on AuthException catch (e) {
      return Left(
        AuthFailure(
          message: e.message ?? 'Failed to send verification email',
          code: e.code,
        ),
      );
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message ?? 'Server error occurred'));
    } catch (e) {
      return Left(ServerFailure(message: 'An unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, void>> reloadUser() async {
    try {
      await remoteDataSource.reloadUser();
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message ?? 'Failed to reload user'));
    } catch (e) {
      return Left(ServerFailure(message: 'An unexpected error occurred'));
    }
  }
}
