import '../../../../core/base/domain/usecase.dart';
import '../../../../core/resources/result.dart';
import '../repositories/auth_repository.dart';

class VerifyOtpUseCase extends UseCase<void, VerifyOtpParams> {
  VerifyOtpUseCase(this._repository);
  final AuthRepository _repository;
  @override
  Future<Result<void>> call(VerifyOtpParams params) =>
      _repository.verifyOtp(email: params.email, otp: params.otp);
}

class VerifyOtpParams {
  const VerifyOtpParams({required this.email, required this.otp});
  final String email;
  final String otp;
}
