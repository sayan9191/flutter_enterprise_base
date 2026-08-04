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
  Future<AuthResponseModel> login({required String email, required String password}) =>
      _api.post('/login', data: {'email': email, 'password': password},
          parser: (j) => AuthResponseModel.fromJson(j as Map<String, dynamic>));

  @override
  Future<AuthResponseModel> register({required String email, required String password}) =>
      _api.post('/register', data: {'email': email, 'password': password},
          parser: (j) => AuthResponseModel.fromJson(j as Map<String, dynamic>));

  @override
  Future<UserModel> getCurrentUser({required String userId}) => _api.get('/users/$userId',
      parser: (j) => UserModel.fromJson((j as Map<String, dynamic>)['data'] as Map<String, dynamic>));
}
