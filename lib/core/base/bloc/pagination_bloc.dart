import 'base_bloc.dart';
import '../../failure/failure.dart';
import 'base_event.dart';
import 'base_state.dart';

abstract class PaginationEvent extends BaseEvent {
  const PaginationEvent();
}

class LoadInitialPage extends PaginationEvent {
  const LoadInitialPage();
}

class LoadNextPage extends PaginationEvent {
  const LoadNextPage();
}

class RefreshPage extends PaginationEvent {
  const RefreshPage();
}

abstract class PaginationState<T> extends BaseState {
  const PaginationState({
    super.status,
    super.failure,
    this.items = const [],
    this.page = 1,
    this.hasMore = true,
  });

  final List<T> items;
  final int page;
  final bool hasMore;

  @override
  List<Object?> get props => [...super.props, items, page, hasMore];

  PaginationState<T> copyWithPagination({
    ViewStatus? status,
    List<T>? items,
    int? page,
    bool? hasMore,
    Failure? failure,
  });
}

abstract class PaginationBloc<T, S extends PaginationState<T>>
    extends BaseBloc<PaginationEvent, S> {
  PaginationBloc(super.initialState, {required super.logger});
}
