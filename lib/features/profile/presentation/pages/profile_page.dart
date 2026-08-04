import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/base/bloc/base_state.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/widgets/app_avatar.dart';
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
          if (state.isLoading) return const Center(child: CircularProgressIndicator());
          return Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                AppAvatar(name: state.email, radius: 40),
                const SizedBox(height: 16),
                Text(state.email ?? '', style: context.textTheme.titleLarge),
                const SizedBox(height: 8),
                Text(context.l10n.editProfile, style: context.textTheme.bodyMedium),
              ],
            ),
          );
        },
      ),
    );
  }
}
