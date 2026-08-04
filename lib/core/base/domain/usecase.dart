import '../../resources/result.dart';

/// Base use case enforcing single-responsibility domain operations.
abstract class UseCase<Type, Params> {
  Future<Result<Type>> call(Params params);
}

class NoParams {
  const NoParams();
}
