import 'package:equatable/equatable.dart';

/// Domain-level failure hierarchy. Never throw these — return via [Result].
sealed class Failure extends Equatable {
  const Failure({this.message = 'An unexpected error occurred'});

  final String message;

  @override
  List<Object?> get props => [message];
}

/// No network connectivity.
final class NetworkFailure extends Failure {
  const NetworkFailure({super.message = 'No internet connection'});
}

/// HTTP 401 / session expired.
final class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure({super.message = 'Session expired. Please login again.'});
}

/// HTTP 5xx errors.
final class ServerFailure extends Failure {
  const ServerFailure({super.message = 'Server error. Please try again later.'});
}

/// HTTP 4xx (non-auth) errors.
final class ClientFailure extends Failure {
  const ClientFailure({super.message = 'Invalid request', this.statusCode});
  final int? statusCode;

  @override
  List<Object?> get props => [message, statusCode];
}

/// Local cache / storage errors.
final class CacheFailure extends Failure {
  const CacheFailure({super.message = 'Failed to read cached data'});
}

/// Validation errors from domain rules.
final class ValidationFailure extends Failure {
  const ValidationFailure({required super.message});
}

/// Catch-all for unmapped errors.
final class UnknownFailure extends Failure {
  const UnknownFailure({super.message = 'Something went wrong'});
}

/// Permission denied by user or OS.
final class PermissionFailure extends Failure {
  const PermissionFailure({super.message = 'Permission denied'});
}
