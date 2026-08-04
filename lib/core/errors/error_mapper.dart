import '../exceptions/app_exception.dart';
import '../failure/failure.dart';

/// Maps data-layer [AppException] to domain [Failure] with user-friendly messages.
class ErrorMapper {
  const ErrorMapper();

  Failure mapException(Object error) {
    if (error is Failure) return error;
    if (error is AppException) return _mapAppException(error);
    return UnknownFailure(message: error.toString());
  }

  Failure _mapAppException(AppException exception) {
    return switch (exception) {
      NetworkException() => NetworkFailure(message: exception.message),
      UnauthorizedException() => UnauthorizedFailure(message: exception.message),
      ServerException(:final statusCode) => ServerFailure(
          message: exception.message,
        ),
      CacheException() => CacheFailure(message: exception.message),
      ValidationException() => ValidationFailure(message: exception.message),
      TimeoutException() => NetworkFailure(message: 'Connection timed out'),
      CancelException() => UnknownFailure(message: 'Request cancelled'),
      ParseException() => ServerFailure(message: 'Invalid server response'),
      _ => UnknownFailure(message: exception.message),
    };
  }

  String friendlyMessage(Failure failure) {
    return switch (failure) {
      NetworkFailure() => 'Please check your internet connection and try again.',
      UnauthorizedFailure() => 'Your session has expired. Please sign in again.',
      ServerFailure() => 'We are experiencing issues. Please try again later.',
      CacheFailure() => 'Unable to load saved data.',
      ValidationFailure() => failure.message,
      PermissionFailure() => failure.message,
      ClientFailure() => failure.message,
      UnknownFailure() => 'Something went wrong. Please try again.',
    };
  }
}
