import '../../../../core/base/bloc/base_state.dart';
import '../../../../core/base/bloc/pagination_bloc.dart';
import '../../../../core/failure/failure.dart';
import '../../domain/entities/user_item.dart';

class HomeState extends PaginationState<UserItem> {
  const HomeState({super.status, super.failure, super.items, super.page, super.hasMore});

  @override
  HomeState copyWithPagination({ViewStatus? status, List<UserItem>? items, int? page, bool? hasMore, Failure? failure}) =>
      HomeState(status: status ?? this.status, items: items ?? this.items, page: page ?? this.page, hasMore: hasMore ?? this.hasMore, failure: failure ?? this.failure);
}
