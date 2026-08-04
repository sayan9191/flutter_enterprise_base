import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/base/bloc/base_state.dart';
import '../../../../core/base/bloc/pagination_bloc.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_error_view.dart';
import '../../../../core/widgets/app_loading_indicator.dart';
import '../../../../core/widgets/app_refresh_indicator.dart';
import '../bloc/home_bloc.dart';
import '../bloc/home_state.dart';
import '../widgets/user_list_tile.dart';

/// Starter home screen — sample API list demonstrating pagination pattern.
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    context.read<HomeBloc>().add(const LoadInitialPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.home)),
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          if (state.isLoading && state.items.isEmpty) {
            return const Center(child: AppLoadingIndicator());
          }
          if (state.isFailure && state.items.isEmpty) {
            return AppErrorView(
              message: state.failure?.message ?? context.l10n.errorUnknown,
              onRetry: () =>
                  context.read<HomeBloc>().add(const LoadInitialPage()),
            );
          }
          if (state.isEmpty) {
            return AppEmptyState(message: context.l10n.noData);
          }

          return AppRefreshIndicator(
            onRefresh: () async =>
                context.read<HomeBloc>().add(const RefreshPage()),
            child: ListView(
              padding: const EdgeInsets.only(bottom: AppSpacing.lg),
              children: [
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            context.l10n.welcomeBack,
                            style: context.textTheme.titleLarge,
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          Text(
                            'Enterprise Flutter starter — Clean Architecture, BLoC, offline-ready networking.',
                            style: context.textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                  child: Text(
                    context.l10n.recentItems,
                    style: context.textTheme.titleMedium,
                  ),
                ),
                ...state.items.map(
                  (user) => UserListTile(user: user),
                ),
                if (state.isLoadingMore)
                  const Padding(
                    padding: EdgeInsets.all(AppSpacing.md),
                    child: Center(child: AppLoadingIndicator()),
                  )
                else if (state.hasMore)
                  Padding(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: AppButton(
                      expand: true,
                      label: 'Load more',
                      variant: AppButtonVariant.outline,
                      onPressed: () =>
                          context.read<HomeBloc>().add(const LoadNextPage()),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
