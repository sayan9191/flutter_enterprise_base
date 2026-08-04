import 'package:equatable/equatable.dart';

import '../../failure/failure.dart';

/// Generic loading states shared across all features.
enum ViewStatus {
  initial,
  loading,
  refreshing,
  loadingMore,
  success,
  failure,
  empty,
  noInternet,
  unauthorized,
  serverError,
  unknownError,
}

/// Base state with [ViewStatus] and optional [Failure].
abstract class BaseState extends Equatable {
  const BaseState({this.status = ViewStatus.initial, this.failure});

  final ViewStatus status;
  final Failure? failure;

  bool get isLoading => status == ViewStatus.loading;
  bool get isRefreshing => status == ViewStatus.refreshing;
  bool get isLoadingMore => status == ViewStatus.loadingMore;
  bool get isSuccess => status == ViewStatus.success;
  bool get isFailure => status == ViewStatus.failure;
  bool get isEmpty => status == ViewStatus.empty;
  bool get isNoInternet => status == ViewStatus.noInternet;

  @override
  List<Object?> get props => [status, failure];
}
