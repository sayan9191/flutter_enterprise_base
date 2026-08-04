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

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController(text: 'eve.holt@reqres.in');
  final _passwordCtrl = TextEditingController(text: 'cityslicka');

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.login)),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state.isSuccess && state.user != null) {
            context.go(RouteConstants.home);
          } else if (state.isFailure && state.failure != null) {
            SnackbarService.showError(context, state.failure!.message);
          }
        },
        builder: (context, state) => SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(context.l10n.welcomeBack, style: context.textTheme.headlineSmall),
                const SizedBox(height: 24),
                AppTextField(controller: _emailCtrl, label: context.l10n.email, keyboardType: TextInputType.emailAddress, validator: Validators.email),
                const SizedBox(height: 16),
                AppTextField(controller: _passwordCtrl, label: context.l10n.password, obscureText: true, validator: Validators.password),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(onPressed: () => context.push(RouteConstants.forgotPassword), child: Text(context.l10n.forgotPassword)),
                ),
                const SizedBox(height: 8),
                AppButton(
                  expand: true,
                  label: context.l10n.login,
                  isLoading: state.isLoading,
                  onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    context.read<AuthBloc>().add(AuthLoginRequested(email: _emailCtrl.text.trim(), password: _passwordCtrl.text));
                  }
                }),
                TextButton(onPressed: () => context.push(RouteConstants.register), child: Text(context.l10n.register)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
