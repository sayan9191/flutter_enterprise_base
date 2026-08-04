/// Network layer constants and configuration defaults.
abstract final class NetworkConstants {
  static const connectTimeout = Duration(seconds: 30);
  static const receiveTimeout = Duration(seconds: 30);
  static const sendTimeout = Duration(seconds: 30);
  static const retryDelay = Duration(seconds: 2);
  static const maxRetries = 3;

  static const headerContentType = 'Content-Type';
  static const headerAccept = 'Accept';
  static const headerAuthorization = 'Authorization';
  static const headerApiKey = 'x-api-key';
  static const contentTypeJson = 'application/json';
  static const bearerPrefix = 'Bearer ';
}

/// Centralized API endpoint paths (relative to base URL).
abstract final class ApiEndpoints {
  static const login = '/login';
  static const register = '/register';
  static const users = '/users';
  static const userById = '/users/{id}';
  static const refreshToken = '/refresh-token';
}
