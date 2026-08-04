import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/base/bloc/base_state.dart';
import '../../../../core/base/bloc/search_bloc.dart';
import '../../../../core/helpers/debouncer.dart';
import '../../../../core/logger/app_logger.dart';
import '../../../home/domain/entities/user_item.dart';
import '../../../../core/failure/failure.dart';
import '../../../home/domain/usecases/get_users_usecase.dart';

class SearchUsersState extends SearchState<UserItem> {
  const SearchUsersState({super.status, super.failure, super.query, super.results});

  SearchUsersState copyWith({
    ViewStatus? status,
    String? query,
    List<UserItem>? results,
    Failure? failure,
  }) =>
      SearchUsersState(status: status ?? this.status, query: query ?? this.query, results: results ?? this.results, failure: failure ?? this.failure);
}

class SearchUsersBloc extends SearchBloc<UserItem, SearchUsersState> {
  SearchUsersBloc({required GetUsersUseCase getUsersUseCase, required AppLogger logger})
      : _getUsers = getUsersUseCase, _debouncer = Debouncer(), super(const SearchUsersState(), logger: logger) {
    on<SearchQueryChanged>(_onQuery);
    on<SearchCleared>(_onClear);
  }
  final GetUsersUseCase _getUsers;
  final Debouncer _debouncer;

  Future<void> _onQuery(SearchQueryChanged e, Emitter<SearchUsersState> emit) async {
    emit(SearchUsersState(status: ViewStatus.loading, query: e.query, results: state.results));
    _debouncer.run(() async {
      if (e.query.isEmpty) {
        emit(const SearchUsersState(status: ViewStatus.empty, results: []));
        return;
      }
      final result = await _getUsers(const GetUsersParams(page: 1));
      result.when(
        success: (page) {
          final filtered = page.users.where((u) =>
              u.email.toLowerCase().contains(e.query.toLowerCase()) ||
              u.displayName.toLowerCase().contains(e.query.toLowerCase())).toList();
          emit(SearchUsersState(status: filtered.isEmpty ? ViewStatus.empty : ViewStatus.success, query: e.query, results: filtered));
        },
        orElse: (f) => emit(SearchUsersState(status: ViewStatus.failure, query: e.query, failure: f)),
      );
    });
  }

  void _onClear(SearchCleared e, Emitter<SearchUsersState> emit) {
    emit(const SearchUsersState());
  }

  @override
  Future<void> close() { _debouncer.dispose(); return super.close(); }
}
