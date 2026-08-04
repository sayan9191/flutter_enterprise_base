# Networking

## Architecture

```
ApiClient (Dio) → Interceptors → ApiService → RemoteDataSource → Repository
```

## Components

| Component | File | Purpose |
|-----------|------|---------|
| `ApiClient` | `core/network/network.dart` | Low-level Dio wrapper |
| `ApiService` | `core/network/network.dart` | Exception mapping |
| `ApiEndpoints` | `core/network/network_constants.dart` | Path constants |
| `NetworkInfo` | `core/network/network_info.dart` | Connectivity check |
| `ApiResponse<T>` | `core/network/models/api_response.dart` | Generic envelope |
| `PaginationResponse<T>` | Same | Paginated responses |
| `ApiErrorModel` | Same | Server error parsing |

## Interceptors

| Interceptor | Purpose |
|-------------|---------|
| `ConnectivityInterceptor` | Block requests when offline |
| `AuthenticationInterceptor` | Inject JWT Bearer token |
| `LoggingInterceptor` | Log requests/responses (debug) |
| `RetryInterceptor` | Exponential backoff retry |
| `TokenRefreshInterceptor` | Auto refresh on 401 |

### Interceptor Order

```
Connectivity → Auth → Logging → Retry → TokenRefresh
```

## JWT Token Flow

1. Login → Store access + refresh tokens in SecureStorage
2. `AuthenticationInterceptor` attaches Bearer token
3. On 401 → `TokenRefreshInterceptor` calls `SessionManager.refreshToken()`
4. Success → Retry original request with new token
5. Failure → `SessionManager.logout()` → Redirect to login

## SSL Pinning

`SslPinningConfig` in interceptors provides a hook:

```dart
SslPinningConfig.configure(dio, enabled: environment.sslPinningEnabled);
```

Production: validate certificate fingerprint in `badCertificateCallback`.

## Usage

```dart
// Remote data source
class HomeRemoteDataSource extends BaseRemoteDataSource {
  HomeRemoteDataSource({required ApiService apiService}) : _api = apiService;
  final ApiService _api;

  Future<PaginationResponse<UserItemModel>> fetchUsers({required int page}) {
    return _api.get(
      ApiEndpoints.users,
      queryParameters: {'page': page},
      parser: (json) => PaginationResponse.fromJson(
        json as Map<String, dynamic>,
        UserItemModel.fromJson,
      ),
    );
  }
}
```

## Multipart Upload

```dart
final formData = FormData.fromMap({
  'file': await MultipartFile.fromFile(path),
});
await apiClient.upload('/upload', formData: formData);
```

## Download

```dart
await apiClient.download(url, savePath, onReceiveProgress: (c, t) {});
```

## Cancel Token

```dart
final cancelToken = CancelToken();
await apiClient.get('/users', cancelToken: cancelToken);
// Later: cancelToken.cancel('User navigated away');
```

## Error Mapping

```
DioException → AppException (data layer) → Failure (domain layer)
```

| DioException Type | AppException |
|-------------------|--------------|
| connectionError | NetworkException |
| connectionTimeout | TimeoutException |
| receiveTimeout | TimeoutException |
| cancel | CancelException |
| 401 response | UnauthorizedException |
| 5xx response | ServerException |

## ReqRes API

Base URL: `https://reqres.in/api`

| Endpoint | Method | Purpose |
|----------|--------|---------|
| `/login` | POST | Authentication |
| `/register` | POST | Registration |
| `/users?page=N` | GET | Paginated user list |
| `/users/{id}` | GET/PUT/DELETE | CRUD operations |

See [API_GUIDE.md](API_GUIDE.md) for request/response formats.
