import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  final String? code;

  const Failure({required this.message, this.code});

  @override
  List<Object?> get props => [message, code];
}

class ServerFailure extends Failure {
  const ServerFailure({required super.message, super.code});
}

class CacheFailure extends Failure {
  const CacheFailure({required super.message, super.code});
}

class NetworkFailure extends Failure {
  const NetworkFailure({required super.message, super.code});
}

class AuthFailure extends Failure {
  const AuthFailure({required super.message, super.code});
}

class ValidationFailure extends Failure {
  final Map<String, String>? errors;

  const ValidationFailure({required super.message, super.code, this.errors});

  @override
  List<Object?> get props => [message, code, errors];
}

class NotFoundFailure extends Failure {
  const NotFoundFailure({required super.message, super.code});
}

class PermissionFailure extends Failure {
  const PermissionFailure({required super.message, super.code});
}

class StorageFailure extends Failure {
  const StorageFailure({required super.message, super.code});
}
