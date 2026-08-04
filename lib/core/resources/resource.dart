import '../failure/failure.dart';

/// UI/API resource wrapper combining data with loading and error states.
sealed class Resource<T> {
  const Resource();
}

final class ResourceInitial<T> extends Resource<T> {
  const ResourceInitial();
}

final class ResourceLoading<T> extends Resource<T> {
  const ResourceLoading({this.isRefresh = false});
  final bool isRefresh;
}

final class ResourceSuccess<T> extends Resource<T> {
  const ResourceSuccess(this.data);
  final T data;
}

final class ResourceEmpty<T> extends Resource<T> {
  const ResourceEmpty();
}

final class ResourceFailure<T> extends Resource<T> {
  const ResourceFailure(this.failure);
  final Failure failure;
}
