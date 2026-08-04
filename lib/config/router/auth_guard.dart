import '../../features/authentication/domain/repositories/auth_repository.dart';

/// Redirect guard for protected routes.
class AuthGuard {
  AuthGuard({required AuthRepository authRepository}) : _auth = authRepository;
  final AuthRepository _auth;

  Future<bool> isAuthenticated() => _auth.isLoggedIn();
}
