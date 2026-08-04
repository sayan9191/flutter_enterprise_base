import '../../../../core/base/data/base_repository.dart';
import '../../../../core/exceptions/app_exception.dart';
import '../../../../core/failure/failure.dart';
import '../../../../core/resources/result.dart';
import '../../../../core/services/session_manager.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_data_source.dart';
import '../datasources/auth_remote_data_source.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl extends BaseRepository implements AuthRepository {
  AuthRepositoryImpl({required AuthRemoteDataSource remote, required AuthLocalDataSource local, required SessionManager sessionManager})
      : _remote = remote, _local = local, _sessionManager = sessionManager;
  final AuthRemoteDataSource _remote;
  final AuthLocalDataSource _local;
  final SessionManager _sessionManager;

  @override
  Future<Result<User>> login({required String email, required String password}) => execute(() async {
        final response = await _remote.login(email: email, password: password);
        if (response.token.isEmpty) throw const ValidationException(message: 'Invalid credentials');
        final user = UserModel(id: '1', email: email, firstName: email.split('@').first);
        await _sessionManager.saveSession(accessToken: response.token, refreshToken: response.token, userId: user.id, email: user.email);
        await _local.cacheUser(user);
        return user;
      });

  @override
  Future<Result<User>> register({required String email, required String password}) => execute(() async {
        final response = await _remote.register(email: email, password: password);
        if (response.token.isEmpty) throw const ValidationException(message: 'Registration failed');
        final user = UserModel(id: '2', email: email);
        await _sessionManager.saveSession(accessToken: response.token, refreshToken: response.token, userId: user.id, email: user.email);
        await _local.cacheUser(user);
        return user;
      });

  @override
  Future<Result<void>> forgotPassword({required String email}) async {
    if (email.isEmpty) return const FailureResult(ValidationFailure(message: 'Email is required'));
    return const Success(null);
  }

  @override
  Future<Result<void>> verifyOtp({required String email, required String otp}) async {
    if (otp.length != 6) return const FailureResult(ValidationFailure(message: 'Invalid OTP'));
    return const Success(null);
  }

  @override
  Future<Result<void>> resetPassword({required String email, required String password}) async {
    if (password.length < 6) return const FailureResult(ValidationFailure(message: 'Password too short'));
    return const Success(null);
  }

  @override
  Future<Result<void>> logout() async {
    await _sessionManager.logout();
    await _local.clearCache();
    return const Success(null);
  }

  @override
  Future<bool> isLoggedIn() => _sessionManager.isLoggedIn;
}
