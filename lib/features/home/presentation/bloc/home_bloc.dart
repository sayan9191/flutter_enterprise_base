import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/base/bloc/base_state.dart';
import '../../../../core/base/bloc/pagination_bloc.dart';
import '../../../../core/logger/app_logger.dart';
import '../../domain/entities/user_item.dart';
import '../../domain/usecases/get_users_usecase.dart';
import 'home_state.dart';

class HomeBloc extends PaginationBloc<UserItem, HomeState> {
  HomeBloc({required GetUsersUseCase getUsersUseCase, required AppLogger logger})
      : _getUsers = getUsersUseCase,
        super(const HomeState(), logger: logger) {
    on<LoadInitialPage>(_onInitial);
    on<LoadNextPage>(_onNext);
    on<RefreshPage>(_onRefresh);
  }

  final GetUsersUseCase _getUsers;

  Future<void> _onInitial(LoadInitialPage event, Emitter<HomeState> emit) async {
    emit(state.copyWithPagination(status: ViewStatus.loading, items: [], page: 1));
    await _fetch(emit, 1, append: false);
  }

  Future<void> _onNext(LoadNextPage event, Emitter<HomeState> emit) async {
    if (!state.hasMore || state.isLoadingMore) return;
    emit(state.copyWithPagination(status: ViewStatus.loadingMore));
    await _fetch(emit, state.page + 1, append: true);
  }

  Future<void> _onRefresh(RefreshPage event, Emitter<HomeState> emit) async {
    emit(state.copyWithPagination(status: ViewStatus.refreshing));
    await _fetch(emit, 1, append: false);
  }

  Future<void> _fetch(Emitter<HomeState> emit, int page, {required bool append}) async {
    final result = await _getUsers(GetUsersParams(page: page));
    result.when(
      success: (data) {
        final items = append ? [...state.items, ...data.users] : data.users;
        emit(state.copyWithPagination(
          status: items.isEmpty ? ViewStatus.empty : ViewStatus.success,
          items: items,
          page: data.page,
          hasMore: data.hasMore,
        ));
      },
      orElse: (f) => emit(state.copyWithPagination(status: ViewStatus.failure, failure: f)),
    );
  }
}
