import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/router/route_constants.dart';
import '../../../../core/base/bloc/base_state.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/widgets/app_button.dart';
import '../bloc/onboarding_bloc.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});
  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final _controller = PageController();
  int _index = 0;

  @override
  void dispose() { _controller.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final pages = [
      _Page(title: context.l10n.onboardingTitle1, desc: context.l10n.onboardingDesc1),
      _Page(title: context.l10n.onboardingTitle2, desc: context.l10n.onboardingDesc2),
      _Page(title: context.l10n.onboardingTitle3, desc: context.l10n.onboardingDesc3),
    ];
    return BlocListener<OnboardingBloc, BaseState>(
      listener: (context, state) {
        if (state.isSuccess) context.go(RouteConstants.login);
      },
      child: Scaffold(
        body: PageView(controller: _controller, onPageChanged: (i) => setState(() => _index = i), children: pages),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(24),
          child: Row(
            children: [
              if (_index < pages.length - 1)
                TextButton(onPressed: () => context.read<OnboardingBloc>().add(const OnboardingCompleteRequested()), child: Text(context.l10n.skip))
              else
                const Spacer(),
              AppButton(
                label: _index < pages.length - 1 ? context.l10n.next : context.l10n.getStarted,
                onPressed: () {
                  if (_index < pages.length - 1) {
                    _controller.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
                  } else {
                    context.read<OnboardingBloc>().add(const OnboardingCompleteRequested());
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Page extends StatelessWidget {
  const _Page({required this.title, required this.desc});
  final String title;
  final String desc;
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(32),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(title, style: context.textTheme.headlineMedium, textAlign: TextAlign.center),
          const SizedBox(height: 16),
          Text(desc, textAlign: TextAlign.center),
        ]),
      );
}
