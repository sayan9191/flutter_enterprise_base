import 'base_bloc.dart';
import 'base_event.dart';
import 'base_state.dart';

abstract class SearchEvent extends BaseEvent {
  const SearchEvent();
}

class SearchQueryChanged extends SearchEvent {
  const SearchQueryChanged(this.query);
  final String query;
  @override
  List<Object?> get props => [query];
}

class SearchCleared extends SearchEvent {
  const SearchCleared();
}

abstract class SearchState<T> extends BaseState {
  const SearchState({
    super.status,
    super.failure,
    this.query = '',
    this.results = const [],
  });

  final String query;
  final List<T> results;

  @override
  List<Object?> get props => [...super.props, query, results];
}

abstract class SearchBloc<T, S extends SearchState<T>>
    extends BaseBloc<SearchEvent, S> {
  SearchBloc(super.initialState, {required super.logger});
}
