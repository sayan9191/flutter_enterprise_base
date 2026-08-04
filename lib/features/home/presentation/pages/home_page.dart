import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/base/bloc/base_state.dart';
import '../../../../core/base/bloc/pagination_bloc.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_error_view.dart';
import '../../../../core/widgets/app_loading_indicator.dart';
import '../../../../core/widgets/app_refresh_indicator.dart';
import '../bloc/home_bloc.dart';
import '../bloc/home_state.dart';
import '../widgets/user_list_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _scrollCtrl = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<HomeBloc>().add(const LoadInitialPage());
    _scrollCtrl.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollCtrl.position.pixels >= _scrollCtrl.position.maxScrollExtent - 200) {
      context.read<HomeBloc>().add(const LoadNextPage());
    }
  }

  @override
  void dispose() { _scrollCtrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.home)),
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          if (state.isLoading && state.items.isEmpty) return const Center(child: AppLoadingIndicator());
          if (state.isFailure && state.items.isEmpty) {
            return AppErrorView(message: state.failure?.message ?? context.l10n.errorUnknown,
                onRetry: () => context.read<HomeBloc>().add(const LoadInitialPage()));
          }
          if (state.isEmpty) return AppEmptyState(message: context.l10n.noData);
          return AppRefreshIndicator(
            onRefresh: () async => context.read<HomeBloc>().add(const RefreshPage()),
            child: ListView.builder(
              controller: _scrollCtrl,
              itemCount: state.items.length + (state.hasMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index >= state.items.length) return const Padding(padding: EdgeInsets.all(16), child: Center(child: AppLoadingIndicator()));
                return UserListTile(user: state.items[index]);
              },
            ),
          );
        },
      ),
    );
  }
}
