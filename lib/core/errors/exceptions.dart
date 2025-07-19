class ServerException implements Exception {
  final String? message;

  const ServerException([this.message]);
}

class CacheException implements Exception {
  final String? message;

  const CacheException([this.message]);
}

class NetworkException implements Exception {
  final String? message;

  const NetworkException([this.message]);
}

class AuthException implements Exception {
  final String? message;
  final String? code;

  const AuthException({this.message, this.code});
}

class ValidationException implements Exception {
  final String? message;
  final Map<String, String>? errors;

  const ValidationException({this.message, this.errors});
}

class NotFoundException implements Exception {
  final String? message;

  const NotFoundException([this.message]);
}

class PermissionException implements Exception {
  final String? message;

  const PermissionException([this.message]);
}

class StorageException implements Exception {
  final String? message;

  const StorageException([this.message]);
}
