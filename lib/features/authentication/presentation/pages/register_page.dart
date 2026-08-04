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

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();

  @override
  void dispose() {
    _emailCtrl.dispose(); _passwordCtrl.dispose(); _confirmCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.register)),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state.isSuccess && state.user != null) context.go(RouteConstants.home);
          if (state.isFailure) SnackbarService.showError(context, state.failure!.message);
        },
        builder: (context, state) => Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                AppTextField(controller: _emailCtrl, label: context.l10n.email, validator: Validators.email),
                const SizedBox(height: 16),
                AppTextField(controller: _passwordCtrl, label: context.l10n.password, obscureText: true, validator: Validators.password),
                const SizedBox(height: 16),
                AppTextField(controller: _confirmCtrl, label: context.l10n.confirmPassword, obscureText: true,
                    validator: (v) => Validators.confirmPassword(v, _passwordCtrl.text)),
                const SizedBox(height: 24),
                AppButton(
                  expand: true,
                  label: context.l10n.register,
                  isLoading: state.isLoading,
                  onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    context.read<AuthBloc>().add(AuthRegisterRequested(email: _emailCtrl.text.trim(), password: _passwordCtrl.text));
                  }
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
