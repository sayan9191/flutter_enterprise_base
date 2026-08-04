/// Generic API response envelope matching ReqRes and common REST patterns.
class ApiResponse<T> {
  const ApiResponse({
    this.data,
    this.message,
    this.success = true,
    this.statusCode,
    this.meta,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT, {
    String dataKey = 'data',
  }) {
    return ApiResponse(
      data: json[dataKey] != null ? fromJsonT(json[dataKey]) : null,
      message: json['message'] as String?,
      success: json['success'] as bool? ?? true,
      statusCode: json['statusCode'] as int?,
      meta: json['meta'] as Map<String, dynamic>?,
    );
  }

  final T? data;
  final String? message;
  final bool success;
  final int? statusCode;
  final Map<String, dynamic>? meta;
}

/// Paginated API response wrapper.
class PaginationResponse<T> {
  const PaginationResponse({
    required this.items,
    required this.page,
    required this.totalPages,
    required this.totalItems,
    this.perPage = 6,
  });

  factory PaginationResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic> json) fromJsonT, {
    String itemsKey = 'data',
    String pageKey = 'page',
    String totalKey = 'total',
    String perPageKey = 'per_page',
    String totalPagesKey = 'total_pages',
  }) {
    final itemsJson = json[itemsKey] as List<dynamic>? ?? [];
    return PaginationResponse(
      items: itemsJson
          .map((e) => fromJsonT(e as Map<String, dynamic>))
          .toList(),
      page: json[pageKey] as int? ?? 1,
      totalPages: json[totalPagesKey] as int? ??
          ((json[totalKey] as int? ?? 0) /
                  (json[perPageKey] as int? ?? 6))
              .ceil(),
      totalItems: json[totalKey] as int? ?? itemsJson.length,
      perPage: json[perPageKey] as int? ?? 6,
    );
  }

  final List<T> items;
  final int page;
  final int totalPages;
  final int totalItems;
  final int perPage;

  bool get hasMore => page < totalPages;
}

/// Standard API error model from server responses.
class ApiErrorModel {
  const ApiErrorModel({this.error, this.message});

  factory ApiErrorModel.fromJson(Map<String, dynamic> json) {
    return ApiErrorModel(
      error: json['error'] as String?,
      message: json['message'] as String? ?? json['error'] as String?,
    );
  }

  final String? error;
  final String? message;
}
