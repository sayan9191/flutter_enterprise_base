import '../../../../core/resources/result.dart';
import '../entities/user.dart';

abstract class AuthRepository {
  Future<Result<User>> login({required String email, required String password});
  Future<Result<User>> register({required String email, required String password});
  Future<Result<void>> forgotPassword({required String email});
  Future<Result<void>> verifyOtp({required String email, required String otp});
  Future<Result<void>> resetPassword({required String email, required String password});
  Future<Result<void>> logout();
  Future<bool> isLoggedIn();
}
