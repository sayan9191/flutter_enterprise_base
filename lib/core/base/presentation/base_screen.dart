import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../failure/failure.dart';
import '../../services/snackbar_service.dart';
import '../../widgets/app_error_view.dart';
import '../../widgets/app_loading_indicator.dart';
import '../bloc/base_bloc.dart';
import '../bloc/base_state.dart';

/// Base screen with loading overlay, error handling, and BLoC listener hooks.
abstract class BaseScreen<B extends BaseBloc<dynamic, S>, S extends BaseState>
    extends StatelessWidget {
  const BaseScreen({super.key});

  B createBloc(BuildContext context);

  Widget buildContent(BuildContext context, S state);

  void onStateChanged(BuildContext context, S state) {}

  bool get showLoadingOverlay => true;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: createBloc,
      child: BlocConsumer<B, S>(
        listener: (context, state) {
          onStateChanged(context, state);
          if (state.isFailure && state.failure != null) {
            SnackbarService.showError(
              context,
              _failureMessage(state.failure!),
            );
          }
        },
        builder: (context, state) {
          return Stack(
            children: [
              buildContent(context, state),
              if (showLoadingOverlay && state.isLoading)
                const ColoredBox(
                  color: Colors.black26,
                  child: Center(child: AppLoadingIndicator()),
                ),
            ],
          );
        },
      ),
    );
  }

  String _failureMessage(Failure failure) => failure.message;
}

/// Simpler base for screens without BLoC.
abstract class BaseStatelessScreen extends StatelessWidget {
  const BaseStatelessScreen({super.key});

  PreferredSizeWidget? buildAppBar(BuildContext context) => null;

  Widget buildBody(BuildContext context);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: buildBody(context),
    );
  }
}

/// Base for stateful screens with shared error/loading helpers.
abstract class BaseStatefulScreen extends StatefulWidget {
  const BaseStatefulScreen({super.key});
}

abstract class BaseStatefulScreenState<T extends BaseStatefulScreen>
    extends State<T> {
  void showLoading() {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: AppLoadingIndicator()),
    );
  }

  void hideLoading() {
    Navigator.of(context, rootNavigator: true).pop();
  }

  void showError(Failure failure) {
    showDialog<void>(
      context: context,
      builder: (_) => AppErrorView(
        message: failure.message,
        onRetry: () => Navigator.of(context).pop(),
      ),
    );
  }
}
