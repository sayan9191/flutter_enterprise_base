import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/base/bloc/base_state.dart';
import '../../../../core/base/bloc/search_bloc.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_search_bar.dart';
import '../../../home/presentation/widgets/user_list_tile.dart';
import '../bloc/search_users_bloc.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});
  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _ctrl = TextEditingController();
  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.search)),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: AppSearchBar(
              controller: _ctrl,
              hint: context.l10n.search,
              onChanged: (q) => context.read<SearchUsersBloc>().add(SearchQueryChanged(q)),
              onClear: () { _ctrl.clear(); context.read<SearchUsersBloc>().add(const SearchCleared()); },
            ),
          ),
          Expanded(
            child: BlocBuilder<SearchUsersBloc, SearchUsersState>(
              builder: (context, state) {
                if (state.isEmpty) return AppEmptyState(message: context.l10n.noData);
                if (state.isLoading) return const Center(child: CircularProgressIndicator());
                return ListView.builder(
                  itemCount: state.results.length,
                  itemBuilder: (_, i) => UserListTile(user: state.results[i]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
