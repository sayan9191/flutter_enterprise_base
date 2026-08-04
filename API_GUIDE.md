# API Guide

## Base URL

```
https://reqres.in/api
```

Configured per environment in `.env.*` files as `BASE_URL`.

## Authentication

### Login

```http
POST /login
Content-Type: application/json

{
  "email": "eve.holt@reqres.in",
  "password": "cityslicka"
}
```

**Response (200):**

```json
{
  "token": "QpwL5tke4Pnpja7X4"
}
```

**Response (400):**

```json
{
  "error": "Missing password"
}
```

### Register

```http
POST /register
Content-Type: application/json

{
  "email": "peter@klaven.fi",
  "password": "pizza"
}
```

**Response (200):**

```json
{
  "id": 4,
  "token": "QpwL5tke4Pnpja7X4"
}
```

Note: ReqRes register always returns 200 with mock data regardless of input.

## Users (Pagination)

### List Users

```http
GET /users?page=1
```

**Response (200):**

```json
{
  "page": 1,
  "per_page": 6,
  "total": 12,
  "total_pages": 2,
  "data": [
    {
      "id": 1,
      "email": "george.bluth@reqres.in",
      "first_name": "George",
      "last_name": "Bluth",
      "avatar": "https://reqres.in/img/faces/1-image.jpg"
    }
  ]
}
```

### Get User

```http
GET /users/1
```

### Create User

```http
POST /users
Content-Type: application/json

{
  "name": "morpheus",
  "job": "leader"
}
```

### Update User

```http
PUT /users/1
Content-Type: application/json

{
  "name": "morpheus",
  "job": "zion resident"
}
```

### Delete User

```http
DELETE /users/1
```

## Implementation Map

| API      | Data Source            | Repository           | Use Case          | BLoC       |
|----------|------------------------|----------------------|-------------------|------------|
| Login    | `AuthRemoteDataSource` | `AuthRepositoryImpl` | `LoginUseCase`    | `AuthBloc` |
| Register | `AuthRemoteDataSource` | `AuthRepositoryImpl` | `RegisterUseCase` | `AuthBloc` |
| Users    | `HomeRemoteDataSource` | `HomeRepositoryImpl` | `GetUsersUseCase` | `HomeBloc` |

## Model Mapping

```dart
// DTO
class UserItemModel {
  factory UserItemModel.fromJson(Map<String, dynamic> json) =>
      UserItemModel(
        id: json['id'] as int,
        email: json['email'] as String,
        firstName: json['first_name'] as String,
        lastName: json['last_name'] as String,
        avatar: json['avatar'] as String?,
      );

  UserItem toEntity() =>
      UserItem(
        id: id,
        email: email,
        fullName: '$firstName $lastName',
        avatarUrl: avatar,
      );
}
```

## Error Handling

ReqRes returns standard HTTP status codes:

| Code | Meaning      | Mapped Failure      |
|------|--------------|---------------------|
| 400  | Bad request  | ValidationFailure   |
| 401  | Unauthorized | UnauthorizedFailure |
| 404  | Not found    | ClientFailure       |
| 500  | Server error | ServerFailure       |

## Adding a New API

1. Add endpoint to `ApiEndpoints`
2. Create/update model in `data/models/`
3. Add method to remote data source
4. Update repository implementation
5. Create/update use case
6. Wire in BLoC

See [DEVELOPER_GUIDE.md](DEVELOPER_GUIDE.md) for detailed steps.

## Test Credentials

| Email              | Password   | Notes       |
|--------------------|------------|-------------|
| eve.holt@reqres.in | cityslicka | Valid login |
| Anything else      | —          | Returns 400 |

## Rate Limits

ReqRes is a free mock API — no authentication required for user endpoints. Suitable for development
and demo only. Replace with production API before release.
