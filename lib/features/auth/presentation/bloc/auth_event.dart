part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AuthCheckRequested extends AuthEvent {}

class AuthSignInRequested extends AuthEvent {
  final String email;
  final String password;

  const AuthSignInRequested({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}

class AuthSignUpRequested extends AuthEvent {
  final String email;
  final String password;
  final String username;
  final String fullName;

  const AuthSignUpRequested({
    required this.email,
    required this.password,
    required this.username,
    required this.fullName,
  });

  @override
  List<Object> get props => [email, password, username, fullName];
}

class AuthSignOutRequested extends AuthEvent {}

class AuthStateChanged extends AuthEvent {
  final User? user;

  const AuthStateChanged(this.user);

  @override
  List<Object?> get props => [user];
}

class AuthResetPasswordRequested extends AuthEvent {
  final String email;

  const AuthResetPasswordRequested({required this.email});

  @override
  List<Object> get props => [email];
}

class AuthUpdateProfileRequested extends AuthEvent {
  final String? fullName;
  final String? bio;
  final String? website;
  final String? photoUrl;
  final List<String>? favoriteGenres;

  const AuthUpdateProfileRequested({
    this.fullName,
    this.bio,
    this.website,
    this.photoUrl,
    this.favoriteGenres,
  });

  @override
  List<Object?> get props => [fullName, bio, website, photoUrl, favoriteGenres];
}
