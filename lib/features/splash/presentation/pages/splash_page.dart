import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/router/route_constants.dart';
import '../../../../core/base/bloc/base_state.dart';
import '../../../../core/constants/app_constants.dart';
import '../bloc/splash_bloc.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});
  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    context.read<SplashBloc>().add(const SplashStarted());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SplashBloc, SplashState>(
      listener: (context, state) {
        if (!state.isSuccess) return;
        Future.delayed(const Duration(milliseconds: AppConstants.animationDurationMs), () {
          if (!context.mounted) return;
          if (!state.onboardingComplete) {
            context.go(RouteConstants.onboarding);
          } else if (state.isLoggedIn) {
            context.go(RouteConstants.dashboard);
          } else {
            context.go(RouteConstants.login);
          }
        });
      },
      child: const Scaffold(body: Center(child: CircularProgressIndicator())),
    );
  }
}
