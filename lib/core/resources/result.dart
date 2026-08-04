import '../failure/failure.dart';

/// Functional result type for success/failure without exceptions in domain layer.
sealed class Result<T> {
  const Result();

  bool get isSuccess => this is Success<T>;
  bool get isFailure => this is FailureResult<T>;

  R when<R>({
    required R Function(T data) success,
    required R Function(Failure failure) orElse,
  }) {
    return switch (this) {
      Success<T>(:final data) => success(data),
      FailureResult<T>(:final failure) => orElse(failure),
    };
  }

  Result<R> map<R>(R Function(T data) transform) {
    return switch (this) {
      Success<T>(:final data) => Success(transform(data)),
      FailureResult<T>(:final failure) => FailureResult(failure),
    };
  }
}

/// Successful operation carrying [data].
final class Success<T> extends Result<T> {
  const Success(this.data);
  final T data;
}

/// Failed operation carrying domain [failure].
final class FailureResult<T> extends Result<T> {
  const FailureResult(this.failure);
  final Failure failure;
}
