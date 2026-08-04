import '../../errors/error_mapper.dart';
import '../../failure/failure.dart';
import '../../resources/result.dart';

/// Base repository with standardized exception-to-failure mapping.
abstract class BaseRepository {
  BaseRepository({ErrorMapper? errorMapper})
      : _errorMapper = errorMapper ?? const ErrorMapper();

  final ErrorMapper _errorMapper;

  Future<Result<T>> execute<T>(Future<T> Function() operation) async {
    try {
      final result = await operation();
      return Success(result);
    } catch (e) {
      return FailureResult(_errorMapper.mapException(e));
    }
  }
}
