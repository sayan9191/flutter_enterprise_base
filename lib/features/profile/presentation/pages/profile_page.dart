import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/router/route_constants.dart';
import '../../../../core/base/bloc/base_state.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/widgets/app_avatar.dart';
import '../../../../features/authentication/presentation/bloc/auth_bloc.dart';
import '../../../../features/authentication/presentation/bloc/auth_event.dart';
import '../bloc/profile_bloc.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    context.read<ProfileBloc>().add(const ProfileLoadRequested());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.profile)),
      body: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return ListView(
            children: [
              const SizedBox(height: 24),
              Center(
                child: AppAvatar(name: state.email, radius: 40),
              ),
              const SizedBox(height: 16),
              Center(
                child: Text(
                  state.email ?? '',
                  style: context.textTheme.titleLarge,
                ),
              ),
              const SizedBox(height: 24),
              ListTile(
                leading: const Icon(Icons.settings_outlined),
                title: Text(context.l10n.settings),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.push(RouteConstants.settings),
              ),
              ListTile(
                leading: const Icon(Icons.logout),
                title: Text(context.l10n.logout),
                onTap: () {
                  context.read<AuthBloc>().add(const AuthLogoutRequested());
                  context.go(RouteConstants.login);
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
