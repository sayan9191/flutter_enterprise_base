#!/usr/bin/env python3
"""Generates features, app, config, DI, main entry points, and tests."""
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent / "lib"
TEST = Path(__file__).resolve().parent.parent / "test"

def w(rel, content, base=ROOT):
    p = base / rel
    p.parent.mkdir(parents=True, exist_ok=True)
    p.write_text(content.strip() + "\n", encoding="utf-8")
    print(f"  {rel}")

# ========== AUTH FEATURE ==========
AUTH = {
"features/authentication/domain/entities/user.dart": '''
import 'package:equatable/equatable.dart';

class User extends Equatable {
  const User({
    required this.id,
    required this.email,
    this.firstName,
    this.lastName,
    this.avatarUrl,
  });

  final String id;
  final String email;
  final String? firstName;
  final String? lastName;
  final String? avatarUrl;

  String get displayName {
    if (firstName != null && lastName != null) {
      return '$firstName $lastName';
    }
    return email;
  }

  @override
  List<Object?> get props => [id, email, firstName, lastName, avatarUrl];
}
''',
"features/authentication/data/models/user_model.dart": '''
import '../../domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.email,
    super.firstName,
    super.lastName,
    super.avatarUrl,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: (json['id'] ?? '').toString(),
      email: json['email'] as String? ?? '',
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      avatarUrl: json['avatar'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        'first_name': firstName,
        'last_name': lastName,
        'avatar': avatarUrl,
      };
}
''',
"features/authentication/data/models/auth_response_model.dart": '''
class AuthResponseModel {
  const AuthResponseModel({required this.token});

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    return AuthResponseModel(token: json['token'] as String? ?? '');
  }

  final String token;
}
''',
"features/authentication/data/datasources/auth_remote_data_source.dart": '''
import '../../../../core/exceptions/app_exception.dart';
import '../../../../core/network/network.dart';
import '../models/auth_response_model.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<AuthResponseModel> login({required String email, required String password});
  Future<AuthResponseModel> register({required String email, required String password});
  Future<UserModel> getCurrentUser({required String userId});
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  AuthRemoteDataSourceImpl({required ApiService apiService}) : _api = apiService;

  final ApiService _api;

  @override
  Future<AuthResponseModel> login({required String email, required String password}) {
    return _api.post(
      '/login',
      data: {'email': email, 'password': password},
      parser: (json) => AuthResponseModel.fromJson(json as Map<String, dynamic>),
    );
  }

  @override
  Future<AuthResponseModel> register({required String email, required String password}) {
    return _api.post(
      '/register',
      data: {'email': email, 'password': password},
      parser: (json) => AuthResponseModel.fromJson(json as Map<String, dynamic>),
    );
  }

  @override
  Future<UserModel> getCurrentUser({required String userId}) {
    return _api.get(
      '/users/$userId',
      parser: (json) {
        final data = json as Map<String, dynamic>;
        return UserModel.fromJson(data['data'] as Map<String, dynamic>);
      },
    );
  }
}
''',
"features/authentication/data/datasources/auth_local_data_source.dart": '''
import '../../../../core/constants/storage_keys.dart';
import '../../../../core/storage/preferences_service.dart';
import '../../../../core/storage/secure_storage_service.dart';
import '../models/user_model.dart';

abstract class AuthLocalDataSource {
  Future<void> cacheUser(UserModel user);
  UserModel? getCachedUser();
  Future<void> clearCache();
  Future<void> setRememberMe(bool value);
  bool getRememberMe();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  AuthLocalDataSourceImpl({
    required SecureStorageService secureStorage,
    required PreferencesService preferences,
  })  : _secureStorage = secureStorage,
        _preferences = preferences;

  final SecureStorageService _secureStorage;
  final PreferencesService _preferences;

  @override
  Future<void> cacheUser(UserModel user) async {
    await _secureStorage.write(StorageKeys.userId, user.id);
    await _secureStorage.write(StorageKeys.userEmail, user.email);
  }

  @override
  UserModel? getCachedUser() {
    return null;
  }

  @override
  Future<void> clearCache() async {
    await _secureStorage.delete(StorageKeys.userId);
    await _secureStorage.delete(StorageKeys.userEmail);
  }

  @override
  Future<void> setRememberMe(bool value) =>
      _preferences.setBool(StorageKeys.rememberMe, value);

  @override
  bool getRememberMe() => _preferences.getBool(StorageKeys.rememberMe) ?? false;
}
''',
"features/authentication/domain/repositories/auth_repository.dart": '''
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
''',
"features/authentication/data/repositories/auth_repository_impl.dart": '''
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
  AuthRepositoryImpl({
    required AuthRemoteDataSource remote,
    required AuthLocalDataSource local,
    required SessionManager sessionManager,
  })  : _remote = remote,
        _local = local,
        _sessionManager = sessionManager;

  final AuthRemoteDataSource _remote;
  final AuthLocalDataSource _local;
  final SessionManager _sessionManager;

  @override
  Future<Result<User>> login({required String email, required String password}) {
    return execute(() async {
      final response = await _remote.login(email: email, password: password);
      if (response.token.isEmpty) {
        throw const ValidationException(message: 'Invalid credentials');
      }
      final user = UserModel(
        id: '1',
        email: email,
        firstName: email.split('@').first,
      );
      await _sessionManager.saveSession(
        accessToken: response.token,
        refreshToken: response.token,
        userId: user.id,
        email: user.email,
      );
      await _local.cacheUser(user);
      return user;
    });
  }

  @override
  Future<Result<User>> register({required String email, required String password}) {
    return execute(() async {
      final response = await _remote.register(email: email, password: password);
      if (response.token.isEmpty) {
        throw const ValidationException(message: 'Registration failed');
      }
      final user = UserModel(id: '2', email: email);
      await _sessionManager.saveSession(
        accessToken: response.token,
        refreshToken: response.token,
        userId: user.id,
        email: user.email,
      );
      await _local.cacheUser(user);
      return user;
    });
  }

  @override
  Future<Result<void>> forgotPassword({required String email}) async {
    if (email.isEmpty) {
      return const FailureResult(ValidationFailure(message: 'Email is required'));
    }
    return const Success(null);
  }

  @override
  Future<Result<void>> verifyOtp({required String email, required String otp}) async {
    if (otp.length != 6) {
      return const FailureResult(ValidationFailure(message: 'Invalid OTP'));
    }
    return const Success(null);
  }

  @override
  Future<Result<void>> resetPassword({required String email, required String password}) async {
    if (password.length < 6) {
      return const FailureResult(ValidationFailure(message: 'Password too short'));
    }
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
''',
}

# Use cases
usecases = [
("login_usecase.dart", "LoginParams", "{required this.email, required this.password}", "final String email;\\n  final String password;", "login"),
("register_usecase.dart", "RegisterParams", "{required this.email, required this.password}", "final String email;\\n  final String password;", "register"),
("forgot_password_usecase.dart", "ForgotPasswordParams", "{required this.email}", "final String email;", "forgotPassword"),
("verify_otp_usecase.dart", "VerifyOtpParams", "{required this.email, required this.otp}", "final String email;\\n  final String otp;", "verifyOtp"),
("reset_password_usecase.dart", "ResetPasswordParams", "{required this.email, required this.password}", "final String email;\\n  final String password;", "resetPassword"),
("logout_usecase.dart", "NoParams", "", "", "logout"),
]

for fname, params, ctor, fields, method in usecases:
    ret = "User" if method in ("login", "register") else "void"
    repo_call = f"_repository.{method}("
    if method == "logout":
        repo_call = "_repository.logout("
        call_args = ""
    elif method == "login":
        call_args = "email: params.email, password: params.password"
    elif method == "register":
        call_args = "email: params.email, password: params.password"
    elif method == "forgotPassword":
        call_args = "email: params.email"
    elif method == "verifyOtp":
        call_args = "email: params.email, otp: params.otp"
    elif method == "resetPassword":
        call_args = "email: params.email, password: params.password"
    else:
        call_args = ""

    import_user = "import '../entities/user.dart';\n" if ret == "User" else ""
    AUTH[f"features/authentication/domain/usecases/{fname}"] = f'''
import '../../../../core/base/domain/usecase.dart';
import '../../../../core/resources/result.dart';
{import_user}import '../repositories/auth_repository.dart';

class {fname.replace('.dart','').replace('_u','U').replace('usecase','UseCase').title().replace('_','')} extends UseCase<{ret}, {params}> {{
  {fname.replace('.dart','').replace('_u','U').replace('usecase','UseCase').title().replace('_','')}(this._repository);
  final AuthRepository _repository;

  @override
  Future<Result<{ret}>> call({params} params) {{
    return _repository.{method}({call_args});
  }}
}}

class {params} {{
  const {params}({ctor});
  {fields}
}}
'''

# Fix use case names manually - the auto naming is messy. Let me write them properly in the script output instead.

print("Script placeholder - will write full files next")
