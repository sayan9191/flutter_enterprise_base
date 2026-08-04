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

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});
  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _emailCtrl = TextEditingController();
  @override
  void dispose() { _emailCtrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.forgotPassword)),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state.isSuccess && state.emailForReset != null) {
            context.push('${RouteConstants.otp}?email=${Uri.encodeComponent(state.emailForReset!)}');
          }
          if (state.isFailure) SnackbarService.showError(context, state.failure!.message);
        },
        builder: (context, state) => Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              AppTextField(controller: _emailCtrl, label: context.l10n.email, validator: Validators.email),
              const SizedBox(height: 24),
              AppButton(label: 'Send OTP', isLoading: state.isLoading, onPressed: () {
                context.read<AuthBloc>().add(AuthForgotPasswordRequested(email: _emailCtrl.text.trim()));
              }),
            ],
          ),
        ),
      ),
    );
  }
}
