import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'dart:io';

import '../../constants/storage_keys.dart';
import '../../logger/app_logger.dart';
import '../../services/session_manager.dart';
import '../../storage/storage_contracts.dart';
import '../network_constants.dart';
import '../network_info.dart';

/// Injects JWT access token into outgoing requests.
class AuthenticationInterceptor extends Interceptor {
  AuthenticationInterceptor({
    required SecureStorageService secureStorage,
    required AppLogger logger,
  })  : _secureStorage = secureStorage,
        _logger = logger;

  final SecureStorageService _secureStorage;
  final AppLogger _logger;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _secureStorage.read(StorageKeys.accessToken);
    if (token != null && token.isNotEmpty) {
      options.headers[NetworkConstants.headerAuthorization] =
          '${NetworkConstants.bearerPrefix}$token';
    }
    handler.next(options);
  }
}

/// Handles 401 responses with automatic token refresh and retry.
class TokenRefreshInterceptor extends Interceptor {
  TokenRefreshInterceptor({
    required SecureStorageService secureStorage,
    required SessionManager sessionManager,
    required AppLogger logger,
    required Dio dio,
  })  : _secureStorage = secureStorage,
        _sessionManager = sessionManager,
        _logger = logger,
        _dio = dio;

  final SecureStorageService _secureStorage;
  final SessionManager _sessionManager;
  final AppLogger _logger;
  final Dio _dio;
  bool _isRefreshing = false;

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode != 401) {
      return handler.next(err);
    }

    if (_isRefreshing) {
      return handler.next(err);
    }

    _isRefreshing = true;
    try {
      final refreshed = await _sessionManager.refreshToken();
      if (refreshed) {
        final token = await _secureStorage.read(StorageKeys.accessToken);
        err.requestOptions.headers[NetworkConstants.headerAuthorization] =
            '${NetworkConstants.bearerPrefix}$token';
        final response = await _dio.fetch<dynamic>(err.requestOptions);
        return handler.resolve(response);
      }
      await _sessionManager.logout();
    } catch (e) {
      _logger.error('Token refresh failed', e);
      await _sessionManager.logout();
    } finally {
      _isRefreshing = false;
    }
    handler.next(err);
  }
}

/// Retries failed requests with exponential backoff.
class RetryInterceptor extends Interceptor {
  RetryInterceptor({required AppLogger logger, required Dio dio})
      : _logger = logger,
        _dio = dio;

  final AppLogger _logger;
  final Dio _dio;

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final retryCount = err.requestOptions.extra['retryCount'] as int? ?? 0;
    final shouldRetry = _shouldRetry(err) &&
        retryCount < NetworkConstants.maxRetries;

    if (!shouldRetry) return handler.next(err);

    await Future<void>.delayed(
      NetworkConstants.retryDelay * (retryCount + 1),
    );

    err.requestOptions.extra['retryCount'] = retryCount + 1;
    _logger.warning('Retrying request (${retryCount + 1})');

    try {
      final response = await _dio.fetch<dynamic>(err.requestOptions);
      return handler.resolve(response);
    } catch (e) {
      _logger.error('Retry failed', e);
    }
    handler.next(err);
  }

  bool _shouldRetry(DioException err) {
    return err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.connectionError;
  }
}

/// Logs HTTP requests and responses in debug mode.
class LoggingInterceptor extends Interceptor {
  LoggingInterceptor({required AppLogger logger}) : _logger = logger;

  final AppLogger _logger;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    _logger.api(
      options.method,
      options.uri.toString(),
      body: options.data,
    );
    handler.next(options);
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    _logger.api(
      response.requestOptions.method,
      response.requestOptions.uri.toString(),
      response: response.data,
    );
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    _logger.error(
      'API Error: ${err.requestOptions.uri}',
      err.message,
    );
    handler.next(err);
  }
}

/// Blocks requests when offline and attaches connectivity metadata.
class ConnectivityInterceptor extends Interceptor {
  ConnectivityInterceptor({required NetworkInfo networkInfo})
      : _networkInfo = networkInfo;

  final NetworkInfo _networkInfo;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final connected = await _networkInfo.isConnected;
    options.extra['isConnected'] = connected;
    if (!connected && options.extra['requiresConnection'] == true) {
      return handler.reject(
        DioException(
          requestOptions: options,
          type: DioExceptionType.connectionError,
          message: 'No internet connection',
        ),
      );
    }
    handler.next(options);
  }
}

/// SSL pinning ready — override [badCertificateCallback] for production certs.
class SslPinningConfig {
  static void configure(Dio dio, {bool enabled = false}) {
    final adapter = dio.httpClientAdapter;
    if (adapter is IOHttpClientAdapter) {
      adapter.createHttpClient = () {
        final client = HttpClient();
        if (!enabled) {
          client.badCertificateCallback = (_, __, ___) => false;
        }
        // Production: validate certificate fingerprint here.
        return client;
      };
    }
  }
}
