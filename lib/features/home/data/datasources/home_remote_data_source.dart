import '../../../../core/constants/app_constants.dart';
import '../../../../core/network/models/api_response.dart';
import '../../../../core/network/network.dart';
import '../models/user_item_model.dart';

abstract class HomeRemoteDataSource {
  Future<PaginationResponse<UserItemModel>> getUsers({required int page});
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  HomeRemoteDataSourceImpl({required ApiService apiService}) : _api = apiService;
  final ApiService _api;

  @override
  Future<PaginationResponse<UserItemModel>> getUsers({required int page}) async {
    return _api.get('/users',
        queryParameters: {'page': page, 'per_page': AppConstants.defaultPageSize},
        parser: (json) => PaginationResponse.fromJson(json as Map<String, dynamic>, UserItemModel.fromJson));
  }
}
