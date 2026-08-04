/// Base exception thrown in data layer, mapped to [Failure] before domain.
sealed class AppException implements Exception {
  const AppException({required this.message, this.code});
  final String message;
  final String? code;

  @override
  String toString() => 'AppException: $message';
}

final class NetworkException extends AppException {
  const NetworkException({super.message = 'Network error', super.code});
}

final class ServerException extends AppException {
  const ServerException({super.message = 'Server error', super.code, this.statusCode});
  final int? statusCode;
}

final class UnauthorizedException extends AppException {
  const UnauthorizedException({super.message = 'Unauthorized', super.code});
}

final class CacheException extends AppException {
  const CacheException({super.message = 'Cache error', super.code});
}

final class ValidationException extends AppException {
  const ValidationException({required super.message, super.code});
}

final class ParseException extends AppException {
  const ParseException({super.message = 'Failed to parse response', super.code});
}

final class TimeoutException extends AppException {
  const TimeoutException({super.message = 'Request timed out', super.code});
}

final class CancelException extends AppException {
  const CancelException({super.message = 'Request cancelled', super.code});
}
