# Offline Support

## Strategy

This project implements **offline-first architecture** where repositories decide the data source based on connectivity and cache validity.

## Decision Tree

```
Request
  ├── Online?
  │   ├── Yes → Fetch Remote → Cache → Return Fresh
  │   └── No  → Check Cache
  │       ├── Valid Cache → Return Cached
  │       └── No Cache → NetworkFailure
  └── Mutation (POST/PUT/DELETE)
      ├── Online → Execute → Update Cache
      └── Offline → Queue in SyncQueue → Return Optimistic/Failure
```

## Storage Layers

| Layer | Technology | Purpose |
|-------|-----------|---------|
| Secure | FlutterSecureStorage | Tokens, sensitive data |
| Preferences | SharedPreferences | Settings, flags |
| Local | Hive | API cache, user data, sync queue |

## CacheManager

Located in `core/storage/hive_storage_service.dart`:

```dart
// Cache API response
await cacheManager.cacheData('users_page_1', responseJson);

// Read with expiration check
final cached = cacheManager.getCachedData('users_page_1');
```

Default expiration: 24 hours (`AppConstants.cacheExpirationHours`).

## Hive Boxes

| Box | Purpose |
|-----|---------|
| `user_box` | User profile data |
| `settings_box` | App settings |
| `cache_box` | API response cache |
| `sync_queue_box` | Pending offline mutations |
| `search_box` | Recent searches |

## ConnectivityManager

Listens for connectivity changes and triggers sync:

```dart
connectivityManager.onConnectivityRestored.listen((_) {
  syncQueue.processPending();
});
```

## Offline Banner

`ConnectivityManager` exposes stream for UI:

```dart
StreamBuilder<bool>(
  stream: connectivityManager.isConnectedStream,
  builder: (context, snapshot) {
    if (snapshot.data == false) return const OfflineBanner();
    return const SizedBox.shrink();
  },
)
```

## Sync Queue

Pending mutations stored in Hive:

```dart
{
  'id': 'uuid',
  'method': 'POST',
  'endpoint': '/users',
  'body': {...},
  'timestamp': 1234567890,
  'retryCount': 0,
}
```

Process on connectivity restore (background sync ready).

## Repository Pattern

```dart
@override
Future<Result<List<User>>> getUsers({required int page}) async {
  if (await _networkInfo.isConnected) {
    return execute(() async {
      final response = await _remote.fetchUsers(page: page);
      await _local.cacheUsers(page, response);
      return response.items.map((m) => m.toEntity()).toList();
    });
  }
  final cached = _local.getCachedUsers(page);
  if (cached != null) return Success(cached);
  return const FailureResult(NetworkFailure());
}
```

## Background Sync

The sync queue architecture supports background processing via:
- WorkManager (Android)
- Background Fetch (iOS)

Integration hooks are in `StartupService` — add platform-specific packages as needed.

## Best Practices

1. Always cache successful API responses
2. Set appropriate TTL per endpoint
3. Show offline banner, not blocking dialogs
4. Provide retry buttons on cached-fallback views
5. Queue write operations when offline
6. Invalidate cache on logout
