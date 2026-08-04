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

class OtpPage extends StatefulWidget {
  const OtpPage({super.key, required this.email});
  final String email;
  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  final _otpCtrl = TextEditingController();
  @override
  void dispose() { _otpCtrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.otpVerification)),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state.isSuccess) context.push('${RouteConstants.resetPassword}?email=${Uri.encodeComponent(widget.email)}');
          if (state.isFailure) SnackbarService.showError(context, state.failure!.message);
        },
        builder: (context, state) => Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              AppTextField(controller: _otpCtrl, label: 'OTP', keyboardType: TextInputType.number, validator: Validators.otp),
              const SizedBox(height: 24),
              AppButton(label: 'Verify', isLoading: state.isLoading, onPressed: () {
                context.read<AuthBloc>().add(AuthOtpVerifyRequested(email: widget.email, otp: _otpCtrl.text.trim()));
              }),
            ],
          ),
        ),
      ),
    );
  }
}
