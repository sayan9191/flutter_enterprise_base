import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/router/route_constants.dart';
import '../../../../core/base/bloc/base_state.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/services/snackbar_service.dart';
import '../../../../core/validators/validators.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key, required this.email});
  final String email;
  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final _passwordCtrl = TextEditingController();
  @override
  void dispose() { _passwordCtrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.resetPassword)),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state.isSuccess) {
            SnackbarService.showSuccess(context, 'Password reset successfully');
            context.go(RouteConstants.login);
          }
          if (state.isFailure) SnackbarService.showError(context, state.failure!.message);
        },
        builder: (context, state) => Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              AppTextField(controller: _passwordCtrl, label: context.l10n.password, obscureText: true, validator: Validators.password),
              const SizedBox(height: 24),
              AppButton(
                expand: true,
                label: context.l10n.resetPassword,
                isLoading: state.isLoading,
                onPressed: () {
                context.read<AuthBloc>().add(AuthResetPasswordRequested(email: widget.email, password: _passwordCtrl.text));
              }),
            ],
          ),
        ),
      ),
    );
  }
}
