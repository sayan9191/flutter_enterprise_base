import 'package:dio/dio.dart';

import '../../config/env/environment.dart';
import '../exceptions/app_exception.dart';
import '../logger/app_logger.dart';
import '../services/session_manager.dart';
import '../storage/storage_contracts.dart';
import 'interceptors/network_interceptors.dart';
import 'models/api_response.dart';
import 'network_constants.dart';
import 'network_info.dart';

export 'interceptors/network_interceptors.dart';
export 'models/api_response.dart';
export 'network_constants.dart';
export 'network_info.dart';

/// Low-level Dio wrapper providing typed HTTP methods.
class ApiClient {
  ApiClient({
    required Environment environment,
    required SecureStorageService secureStorage,
    required SessionManager sessionManager,
    required NetworkInfo networkInfo,
    required AppLogger logger,
  }) : _dio = Dio(
          BaseOptions(
            baseUrl: environment.baseUrl,
            connectTimeout: NetworkConstants.connectTimeout,
            receiveTimeout: NetworkConstants.receiveTimeout,
            sendTimeout: NetworkConstants.sendTimeout,
            headers: {
              NetworkConstants.headerContentType:
                  NetworkConstants.contentTypeJson,
              NetworkConstants.headerAccept: NetworkConstants.contentTypeJson,
            },
          ),
        ) {
    _dio.interceptors.addAll([
      ConnectivityInterceptor(networkInfo: networkInfo),
      AuthenticationInterceptor(
        secureStorage: secureStorage,
        logger: logger,
      ),
      LoggingInterceptor(logger: logger),
      RetryInterceptor(logger: logger, dio: _dio),
      TokenRefreshInterceptor(
        secureStorage: secureStorage,
        sessionManager: sessionManager,
        logger: logger,
        dio: _dio,
      ),
    ]);
    SslPinningConfig.configure(_dio, enabled: environment.sslPinningEnabled);
  }

  final Dio _dio;

  Dio get dio => _dio;

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    bool requiresConnection = true,
  }) {
    return _dio.get<T>(
      path,
      queryParameters: queryParameters,
      cancelToken: cancelToken,
      options: Options(extra: {'requiresConnection': requiresConnection}),
    );
  }

  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
  }) {
    return _dio.post<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      cancelToken: cancelToken,
    );
  }

  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    CancelToken? cancelToken,
  }) {
    return _dio.put<T>(path, data: data, cancelToken: cancelToken);
  }

  Future<Response<T>> delete<T>(
    String path, {
    CancelToken? cancelToken,
  }) {
    return _dio.delete<T>(path, cancelToken: cancelToken);
  }

  Future<Response<T>> upload<T>(
    String path, {
    required FormData formData,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
  }) {
    return _dio.post<T>(
      path,
      data: formData,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
    );
  }

  Future<Response<dynamic>> download(
    String url,
    String savePath, {
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) {
    return _dio.download(
      url,
      savePath,
      cancelToken: cancelToken,
      onReceiveProgress: onReceiveProgress,
    );
  }
}

/// High-level API service with exception mapping.
class ApiService {
  ApiService({required ApiClient apiClient, required AppLogger logger})
      : _client = apiClient,
        _logger = logger;

  final ApiClient _client;
  final AppLogger _logger;

  Future<T> get<T>(
    String path, {
    required T Function(dynamic json) parser,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _client.get<dynamic>(
        path,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
      );
      return parser(response.data);
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  Future<T> post<T>(
    String path, {
    required T Function(dynamic json) parser,
    dynamic data,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _client.post<dynamic>(
        path,
        data: data,
        cancelToken: cancelToken,
      );
      return parser(response.data);
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  AppException _mapDioException(DioException e) {
    _logger.error('DioException', e.message);
    if (e.type == DioExceptionType.connectionError ||
        e.type == DioExceptionType.connectionTimeout) {
      return NetworkException(message: e.message ?? 'Network error');
    }
    if (e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout) {
      return TimeoutException(message: e.message ?? 'Timeout');
    }
    if (e.type == DioExceptionType.cancel) {
      return CancelException();
    }
    final statusCode = e.response?.statusCode;
    if (statusCode == 401) {
      return UnauthorizedException();
    }
    if (statusCode != null && statusCode >= 500) {
      return ServerException(
        message: e.response?.data?.toString() ?? 'Server error',
        statusCode: statusCode,
      );
    }
    final errorModel = e.response?.data is Map<String, dynamic>
        ? ApiErrorModel.fromJson(e.response!.data as Map<String, dynamic>)
        : null;
    return ServerException(
      message: errorModel?.message ?? e.message ?? 'Request failed',
      statusCode: statusCode,
    );
  }
}
